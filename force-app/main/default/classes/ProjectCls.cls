public class ProjectCls {
    
    
    @AuraEnabled
     public static List<ChikPeaSSB__Chikpea_Project__c> getPrjdetails (Id recordId) {  
        
        List<Chikpea_Project__c> Prj = [SELECT ChikPeaSSB__Target_Price__c,ChikPeaSSB__Target_Profit__c, ChikPeaSSB__Potential_Project_Delay__c,
        ChikPeaSSB__Estimated_Cost__c,ChikPeaSSB__Estimated_Rate__c,ChikPeaSSB__Project_Model__c,ChikPeaSSB__Quote__c 
                                        FROM ChikPeaSSB__Chikpea_Project__c WHERE id=:recordId];
        
        return Prj; 
    } 
    
     @AuraEnabled
    public static List<ChikPeaSSB__Chikpea_Project__c> getPrjdetails1 (Id recordId, integer val) {  
        
        List<ChikPeaSSB__Chikpea_Project__c> Prj = [SELECT ChikPeaSSB__Target_Price__c FROM ChikPeaSSB__Chikpea_Project__c WHERE id=:recordId];
        
        Prj[0].ChikPeaSSB__Target_Price__c = val;
        
        update prj;
        
        return Prj;
    }
    
     @AuraEnabled
    public static list<Project_Phase__c> getAcclist(String recordId){ 
        
        List<Project_Phase__c> Phase = [Select id, Name,Project__r.Project_Model__c,Status__c,Estimated_Cost__c,Estimated_Rate__c,Estimated_Hours__c,Phase_Profit__c,Descriptions__c from Project_Phase__c where Project__c =: recordId];
        
        
        return Phase;
    }

    
    

}