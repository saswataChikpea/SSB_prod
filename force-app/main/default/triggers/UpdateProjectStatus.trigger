trigger UpdateProjectStatus on ChikPeaO2B__Quote__c (after insert, after update) {
    
    Set<Id> projId = new Set<Id>();
    
    for(ChikPeaO2B__Quote__c qt : Trigger.new){
        if(qt.ChikPeaO2B__Status__c == 'Accepted'){
            projId.add(qt.ChikPeaSSB__Project__c);
            
            //qt.ChikPeaSSB__Project__r.ChikPeaSSB__Status__c = 'Quote Accepted';
        }
        
        List<ChikPeaSSB__Chikpea_Project__c> projs = [Select Id,ChikPeaSSB__Status__c from ChikPeaSSB__Chikpea_Project__c where Id IN :projId];
        
        for(ChikPeaSSB__Chikpea_Project__c p : projs){
            p.ChikPeaSSB__Status__c = 'Quote Accepted';
          
        }
        update projs;
    }

}