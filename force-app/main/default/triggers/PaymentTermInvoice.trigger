trigger PaymentTermInvoice on ChikPeaO2B__Invoice__c (before insert,before update,after insert, after update) {
    /*
    list<id> invid = new list<id>();
    
    System.debug('Trigger is working');
    
    For(ChikPeaO2B__Invoice__c inv : Trigger.new){
        invid.add(inv.id);
    }
    
    list<ChikPeaO2B__Invoice__c> updinvlp = new list<ChikPeaO2B__Invoice__c>();
    
    try{
        
        for(ChikPeaO2B__Invoice__c inv :[select id,ChikPeaO2B__Payment_Term__c,ChikPeaO2B__Billing_Country__c,(Select id,ChikPeaO2B__Subscription__c from ChikPeaO2B__Invoice_Lines__r) from ChikPeaO2B__Invoice__c where id = :invid]){
            For(ChikPeaO2B__Invoice_Line__c invlne : inv.ChikPeaO2B__Invoice_Lines__r){
                for(ChikPeaO2B__Invoice_Line__c invl : [select id,ChikPeaO2B__Subscription__c from ChikPeaO2B__Invoice_Line__c where id = :invlne.id]){
                
                    For(ChikPeaO2B__Subscription__c sub : [select id,ChikPeaO2B__Order_Line__c from ChikPeaO2B__Subscription__c where id = :invl.ChikPeaO2B__Subscription__c]){
                        for(ChikPeaO2B__Order_Line__c ordl : [select id,ChikPeaO2B__Order__c,ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Bill_Cycle__c from ChikPeaO2B__Order_Line__c where id = :sub.ChikPeaO2B__Order_Line__c and Project__c <> null]){
                            for(ChikPeaO2B__Order__c ord : [Select id,ChikPeaO2B__Quote__c from ChikPeaO2B__Order__c where id = :ordl.ChikPeaO2B__Order__c]){
                                for(ChikPeaO2B__Quote__c qt : [select id,New_Payment_Term__c from ChikPeaO2B__Quote__c where id = :ord.ChikPeaO2B__Quote__c]){
                                    
                                    
                                    inv.ChikPeaO2B__Billing_Country__c = 'Dhanush';
                                        System.debug('Bill scyce ===='+ordl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Bill_Cycle__c);

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
        }
        update updinvlp;
    }catch(Exception e){
        system.debug('Exception=='+e);
    }
    
    */
}