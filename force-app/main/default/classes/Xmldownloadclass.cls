public class Xmldownloadclass {

    @AuraEnabled
   public static list <Resource__c> fetchContact(Id recoId){
       
       List <Project_Phase__c> PhaseList = [SELECT Id From Project_Phase__c where Project__c =: recoId];
      
      List <Resource__c> returnConList = new List < Resource__c > ();
        //,Phase_Name_For_CSV__c,Project_Name_for_CSV__c
      for(Resource__c con: [Select Id,Name,Project_Name__c,Phase_Name__c,Role__c,Actual_Hours__c,Date__c from Resource__c where Phase__c =: PhaseList]) {
          //con.Actual_Hours__c = ' ';
           //con.Date__c = ' ';
             returnConList.add(con);
          
          }
       return returnConList;
   }       
    public String generateXML()
    { 
    DOM.Document doc = new DOM.Document();
 
        dom.XmlNode products = doc.createRootElement('Project', null, null);
        dom.XmlNode body1= products.addChildElement('Project Name', null, null);//project
 
        body1.addChildElement('Name', null, null).addTextNode('Abc corp');
       
         dom.XmlNode phase = body1.addChildElement('Project phase', null, null);
               phase.addChildElement('Name', null, null).addTextNode('Requirements');


        dom.XmlNode resource= body1.addChildElement('Resource', null, null);
 
        resource.addChildElement('Name', null, null).addTextNode('Developer');
 
        
         String xmlString = doc.toXmlString();
       system.debug('xmlString---'+xmlString);
        return xmlString;
   } 

}