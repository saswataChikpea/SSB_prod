/*Class Name: projectInPmsCls
 *Purpose:future callout and mapping the o2b fields with PMS fields
 *created on and By:  14th Jun2019,Sridevi
 * Last modified on and By: 20th Jun2019,Sridevi
 * last Modifcation
 */
global with sharing class projectInPmsCls {
	 @future(callout=True)
    public static void createProject(Id usageId){
        Http http = new Http();//Responce for callouts
        HttpRequest req = new HttpRequest();//callout
        list<ChikpeaO2B__Usage__c> usg = [SELECT Name, ChikPeaO2B__Account__c, Description__c, ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c,
                                          ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c, ChikpeaO2B__Order_line__r.Is_Chikpea_Sow__c
                                          FROM ChikpeaO2B__Usage__c WHERE Id=:usageId];
        if(usg != null && usg.size() > 0){
           // account acc = [SELECT Name, Phone, BillingCity FROM account WHERE id=:usg[0].ChikPeaO2B__Account__c];
           list<account> acc = [SELECT Name, Phone, BillingCity,(select id,Name,email from Contacts limit 1) FROM account WHERE id=:usg[0].ChikPeaO2B__Account__c];
            //contact con = [SELECT email FROM contact WHERE account.id=:usg[0].ChikPeaO2B__Account__c LIMIT 1];
            if(acc != null && acc.size() > 0){
            jsonClass jwrap = new jsonClass();
            jwrap.UsageRateCode = usg[0].Name;    // USageID in PMS
            jwrap.ClientName = acc[0].Name;
            jwrap.ProjectName = acc[0].Name + ' - ' +Usg[0].Description__c;
            jwrap.Description = usg[0].Description__c;
            jwrap.StartDate = usg[0].ChikPeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c;
            jwrap.EndDate = usg[0].ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c;
            jwrap.IsChickpeaSOW = usg[0].ChikpeaO2B__Order_line__r.Is_Chikpea_Sow__c;
            jwrap.AccName = acc[0].Name;
            jwrap.EmailID = acc[0].Contacts[0].Email;
            jwrap.ClientLocation = acc[0].BillingCity;
             string PhoneNumber =acc[0].Phone.ReplaceAll('\\D','');//phone number should not contain any strings
            jwrap.ContactPerson = acc[0].Contacts[0].Name;
            String endpoint = 'http://103.16.202.117:8005/AddProjectDetailsSF';//Callouts end point
            //String endpoint = 'https://httpbin.org/post';        
            String body = json.serialize(jwrap); 
			// Blob headerValue = Blob.valueOf('admin@yourdomain.com' + ':' + 'welcome');
            // String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            //req.setHeader('Authorization', authorizationHeader);
           
          	req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setTimeout(119990);
            req.setEndpoint(endpoint);
            req.setBody(body);  
                
            HttpResponse resp = http.send(req);//sending req into the method send of http obj and storing in 'resp'
                
            System.debug('request body======>'+body);
            System.debug('response status====>'+ resp.getBody());//getting the status of the response by using the getbody
          }
    	}  	
	}
}