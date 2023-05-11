trigger Resprofitcalconaccrude on Resource_Staging__c (after update,after insert,after delete) {
    
     if(trigger.isAfter){
         if(trigger.isinsert || trigger.isupdate){
             
         
         List<Id> reslist = New List<Id>();
         for(Resource_Staging__c res : Trigger.new){
             reslist.add(res.Resource__c);
                  }
         
        Resaccuratecalc.accuratecalc(reslist);
         }
    }
    if(trigger.isAfter){ 
        if(trigger.isdelete){
            
            List<Id> reslistold = New List<Id>();

         for(Resource_Staging__c resold : Trigger.old){
             reslistold.add(resold.Resource__c);
         
         }
        Resaccuratecalc.accuratecalcold(reslistold);

            
        }
         
    }
}