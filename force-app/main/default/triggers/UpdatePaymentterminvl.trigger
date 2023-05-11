trigger UpdatePaymentterminvl on ChikPeaO2B__Invoice_Line__c (After insert,after update) {
    
    /*for(ChikPeaO2B__Invoice_Line__c invl : Trigger.new){

//Oldmap.get(Acc.Id).name

if(System.isFuture()) {
System.debug('isFuture--------');
}
if(System.isBatch()) {
System.debug('isBatch--------');
}

if(!System.isFuture() ){
system.debug('Am in ===');
Paymenttermclass.payment(invl.id);


}  

}//
    
    
    list<ChikPeaO2B__Invoice__c> updinvlp = new list<ChikPeaO2B__Invoice__c>();
    try{
        for(ChikPeaO2B__Invoice_Line__c invl : [select id, ChikPeaO2B__Invoice__c,ChikPeaO2B__Subscription__c from
                                                ChikPeaO2B__Invoice_Line__c where id = :trigger.new])
        {
            for(ChikPeaO2B__Invoice__c inv :[select id,ChikPeaO2B__Payment_Term__c from ChikPeaO2B__Invoice__c where id = :invl.ChikPeaO2B__Invoice__c]){
                
                For(ChikPeaO2B__Subscription__c sub : [select id,ChikPeaO2B__Order_Line__c from ChikPeaO2B__Subscription__c where id = :invl.ChikPeaO2B__Subscription__c]){
                    for(ChikPeaO2B__Order_Line__c ordl : [select id,ChikPeaO2B__Order__c,ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Bill_Cycle__c from ChikPeaO2B__Order_Line__c where id = :sub.ChikPeaO2B__Order_Line__c and Project__c <> null]){
                        for(ChikPeaO2B__Order__c ord : [Select id,ChikPeaO2B__Quote__c from ChikPeaO2B__Order__c where id = :ordl.ChikPeaO2B__Order__c]){
                            for(ChikPeaO2B__Quote__c qt : [select id,New_Payment_Term__c from ChikPeaO2B__Quote__c where id = :ord.ChikPeaO2B__Quote__c]){
                                
                                If(ordl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Bill_Cycle__c == 'Weekly'){
                                    inv.ChikPeaO2B__Payment_Term__c = 'COD';
                                }else{
                                inv.ChikPeaO2B__Payment_Term__c = qt.New_Payment_Term__c;
                                }
                                
                                updinvlp.add(inv);
                            }
                            
                        }
                        
                    }  
                    
                }
                
            }      
            
        }
        update updinvlp;
         
    }catch(Exception e){
        system.debug('Exception=='+e);
    }
    */
}