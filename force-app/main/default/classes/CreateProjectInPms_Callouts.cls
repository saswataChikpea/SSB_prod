public class CreateProjectInPms_Callouts{
   public id ApiUsageid;    
    public static boolean firstRun = true;
    
    public static JsonWrapper_Pms createProject(Id usageId){       
        JsonWrapper_Pms wrap = new JsonWrapper_Pms();
        list<ChikpeaO2B__Usage__c> usg = new  list<ChikpeaO2B__Usage__c>();
        if(Test.isRunningTest()){
            usg = [SELECT id,Name, ChikPeaO2B__Account__c, Description__c,Projected_Hours__c,ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c,
                   ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c,ChikPeaO2B__Item__r.Name,ChikPeaO2B__Order_Line__r.Project__r.Name,ChikpeaO2B__Order_line__r.Tracking_Hours__c
                   FROM ChikpeaO2B__Usage__c order by Name desc limit 1 ]; 
        }else{
            usg = [SELECT id,Name, ChikPeaO2B__Account__c, Description__c,Projected_Hours__c,ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c,
                   ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c,ChikPeaO2B__Item__r.Name,ChikPeaO2B__Order_Line__r.Project__r.Name,ChikpeaO2B__Order_line__r.Tracking_Hours__c
                   FROM ChikpeaO2B__Usage__c WHERE Id=:usageId]; 
        }
        
        if(usg != null && usg.size() > 0){
            // account acc = [SELECT Name, Phone, BillingCity FROM account WHERE id=:usg[0].ChikPeaO2B__Account__c];
            list<account> acc = [SELECT Name, Phone, BillingCity,(select id,Name,email from Contacts limit 1) FROM account WHERE id=:usg[0].ChikPeaO2B__Account__c];
            //contact con = [SELECT email FROM contact WHERE account.id=:usg[0].ChikPeaO2B__Account__c LIMIT 1];
            if(acc != null && acc.size() > 0){
                wrap.usageid = usageId;
                wrap.UsageRateCode = usg[0].Name;// USageID in PMS
                wrap.ClientName = acc[0].Name;
                wrap.ProjectName = usg[0].ChikPeaO2B__Order_Line__r.Project__r.Name;//acc[0].Name ;
                wrap.Description = usg[0].ChikPeaO2B__Order_Line__r.Project__r.Name;//usg[0].Description__c;
                //wrap.StartDate = usg[0].ChikPeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c;
                //wrap.EndDate = usg[0].ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c;                
                Date PjStartDate = usg[0].ChikPeaO2B__Subscription__r.ChikpeaO2B__Billing_Start_Date__c;              
                if(PjStartDate == null){wrap.StartDate ='';}else{wrap.StartDate = DateTime.newInstance(PjStartDate.year(),PjStartDate.month(),PjStartDate.day()).format('dd-MM-YYYY');}               
                Date PjEndDate = usg[0].ChikpeaO2B__Subscription__r.ChikpeaO2B__Billing_Stop_Date__c;
                if(PjEndDate == null)  { wrap.EndDate = '';}else{wrap.EndDate = DateTime.newInstance(PjEndDate.year(),PjEndDate.month(),PjEndDate.day()).format('dd-MM-YYYY'); }
                wrap.IsChickpeaSOW = usg[0].ChikpeaO2B__Order_line__r.Tracking_Hours__c;
                wrap.AccName = acc[0].Name;
                if(wrap.EmailID == null){wrap.EmailID = '';}else{wrap.EmailID = acc[0].Contacts[0].Email;}
                wrap.ClientLocation = acc[0].BillingCity;
                String PhoneNumber = acc[0].Phone;
                if(wrap.PhoneNumber ==null){wrap.PhoneNumber ='';}else{wrap.PhoneNumber = PhoneNumber.replaceAll('[^0-9]',''); }//acc[0].Phone; 
                if(acc[0].Contacts.size() > 0) { wrap.ContactPerson = acc[0].Contacts[0].Name;}               
                if(wrap.EstimatedHrs == null){wrap.EstimatedHrs = 0;}else{wrap.EstimatedHrs=usg[0].Projected_Hours__c;}
                wrap.BillingType ='2';
                wrap.ProjectPhase = usg[0].ChikPeaO2B__Item__r.Name;
                system.debug(' wrap.ProjectPhase '+ wrap.ProjectPhase);
                return wrap;        
            }
        }
        return wrap;
    }
    
    /*List<JsonWrapper_Pms> ApiOrderMaster = new list<JsonWrapper_Pms>();
public static  PassingPMSApi(list<JsonWrapper_Pms> JsonWrapperPms){
ApiOrderMaster.add(JsonWrapperPms);
ApiProcesstoPMS();
}*/
    
  public static  List<JsonWrapper_Pms> ApiOrderMaster {get;set;}
    public static void CreateProjectUsageInPms(list<JsonWrapper_Pms>  UsageProcessingList){
        
        system.debug('UsageProcessingList =============' +UsageProcessingList);      
        ApiOrderMaster = new  List<JsonWrapper_Pms>();
        String UsgID = '';
        if(UsageProcessingList.size() > 0){
            for(JsonWrapper_Pms xc : UsageProcessingList){            
                UsgID = UsgID + 'PMS' + xc.usageid;
            }
            system.debug('UID==========' +UsgID);           
            ApiProcesstoPMS(UsgID);  
            
        }  
    }
    
    @future(callout=true)
    public static void ApiProcesstoPMS(string Usageids){
        
        if(Usageids != null){
            List<JsonWrapper_Pms> ApiOrderMaster = new  List<JsonWrapper_Pms>();
            String[] SplitUsageid = new String[]{};
                SplitUsageid = Usageids.split('PMS');
            system.debug('SplitUsageid ' +SplitUsageid);            
            for(integer i=0;i < SplitUsageid.size();i++){
                JsonWrapper_Pms wrap1 = new JsonWrapper_Pms();
                if(SplitUsageid[i] != null && SplitUsageid[i] != ''){
                    wrap1 = CreateProjectInPms_Callouts.createProject(SplitUsageid[i]);
                    ApiOrderMaster.add(wrap1);
                    system.debug('ApiOrderMaster============'+ApiOrderMaster);
                }
            }            
            if(ApiOrderMaster.size() > 0){
                Http http = new Http();
                HttpRequest req = new HttpRequest();  
                String endpoint = '';
                endpoint = 'http://103.16.202.57:8081/AddProjectDetailsSF';
                
                //String endpoint = 'https://httpbin.org/post';   
                system.debug('ApiOrderMasterJSONFormat ' +ApiOrderMaster);   
                String body = Json.serialize(ApiOrderMaster);  
                system.debug('ApiOrderMasterAPi JSON ' +body);
                req.setHeader('Content-Type', 'application/json');
                req.setMethod('POST');
                req.setTimeout(119990);
                req.setEndpoint(endpoint);
                req.setBody(body);
                system.debug('ApiOrderMaster body ' +body);
                if(!Test.isRunningTest()){
                    HttpResponse resp = http.send(req);       
                }
                
            }                        
        }   
        
    }   
}