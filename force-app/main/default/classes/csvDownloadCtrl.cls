public class csvDownloadCtrl {
@AuraEnabled
   public static list <ChikPeaSSB__Resource__c> fetchContact(Id recoId){
       
       List <ChikPeaSSB__Project_Phase__c> PhaseList = [SELECT Id From ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Phase_Status__c = 'In Process' AND ChikPeaSSB__Project__c =: recoId];
      
      List <ChikPeaSSB__Resource__c> returnConList = new List < ChikPeaSSB__Resource__c > ();
      for(ChikPeaSSB__Resource__c con: [Select Id,Name,ChikPeaSSB__Project_Name__c,ChikPeaSSB__Phase_Name__c,ChikPeaSSB__Role__c,ChikPeaSSB__Actual_Hours__c,Task__c, ChikPeaSSB__Date__c from 
                                        ChikPeaSSB__Resource__c where ChikPeaSSB__Phase__c =: PhaseList]) {
         
            con.ChikPeaSSB__Actual_Hours__c = 'HH';                                 
           con.ChikPeaSSB__Date__c = 'MM/DD/YYYY';
           con.Task__c = 'Arindam';
             returnConList.add(con);
          
          }
       system.debug('returnConList' + returnConList); 
         return returnConList;
   } 
 
    
 @AuraEnabled
   public static list <ChikPeaSSB__Chikpea_Project__c> fetchprjname(Id recoId){
      
      List <ChikPeaSSB__Chikpea_Project__c> Prjname = [SELECT Name,ChikPeaSSB__Status__c from ChikPeaSSB__Chikpea_Project__c where id =: recoId];
        
              return Prjname;
 
}
}