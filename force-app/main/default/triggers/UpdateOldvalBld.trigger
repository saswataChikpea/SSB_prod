trigger UpdateOldvalBld on ChikPeaO2B__Rate_Plan__c (before insert,before update) {

    System.debug('isBldrate' +  BlendedRateCls.isBldrate);
    
    if(BlendedRateCls.isBldrate){
        
        
        for(ChikPeaO2B__Rate_Plan__c Rpl : Trigger.new){
            
            if(Trigger.oldMap.get(Rpl.Id).ChikPeaO2B__Usage_Rate__c != Rpl.ChikPeaO2B__Usage_Rate__c){
                Rpl.Old_Usage_Rate__c = Rpl.ChikPeaO2B__Usage_Rate__c;
            }
        }
    }
    

}