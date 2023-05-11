public class PhaseCmpCls {
    
     @AuraEnabled
    public static list<ChikPeaSSB__Chikpea_Project__c> getPhase(String recordId){
        
        string Model; 
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select Id,ChikPeaSSB__Project__r.ChikPeaSSB__Project_Model__c,ChikPeaSSB__Project__c from ChikPeaSSB__Project_Phase__c where id =: recordId];
        
        id Prjid = Phase[0].ChikPeaSSB__Project__c;
        
        system.debug('Prjid ='+Prjid);
        List<ChikPeaSSB__Chikpea_Project__c> Prj = [Select Id,ChikPeaSSB__Project_Model__c from ChikPeaSSB__Chikpea_Project__c where id =: Prjid];
        
        //Model = Phase[0].Project__r.Project_Model__c;
        
          //system.debug('Prj model ='+Prj);
        
        return Prj;
    } 

    
}