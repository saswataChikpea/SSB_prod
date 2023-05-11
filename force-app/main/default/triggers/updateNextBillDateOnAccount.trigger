trigger updateNextBillDateOnAccount on ChikPeaO2B__Subscription__c (before insert,after insert,before update,after delete) {
    if(Trigger.isInsert){
        try {
            Set<Id> ParentIds = New Set<Id>();
            List<ChikPeaO2B__Subscription__c> cc = New List<ChikPeaO2B__Subscription__c>([select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1]);
            System.debug('number of items in ID set ' + cc);
            for (ChikPeaO2B__Subscription__c co : [select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1])
            { 
                ParentIds.add(co.id);
            }  
            List<Account> accVal = [Select Id,ChikPeaO2B__Next_Bill_Date__c from Account where id IN:ParentIds];
            
            for(account acc:accVal)
            {
                for(ChikPeaO2B__Subscription__c am_co : cc)
                {
                    IF(acc.ChikPeaO2B__Next_Bill_Date__c == null)
                    {
                        acc.ChikPeaO2B__Next_Bill_Date__c = am_co.ChikPeaO2B__Billing_Start_Date__c;  
                        
                    }
                }
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
    if(Trigger.isBefore) {
        if(Trigger.isUpdate){
            try {
                Set<Id> ParentIds = New Set<Id>();
                List<ChikPeaO2B__Subscription__c> cc = New List<ChikPeaO2B__Subscription__c>([select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1]);
                System.debug('number of items in ID set ' + cc);
                for (ChikPeaO2B__Subscription__c co : [select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1])
                { 
                    ParentIds.add(co.id);
                }  
                List<Account> accVal = [Select Id,ChikPeaO2B__Next_Bill_Date__c from Account where id IN:ParentIds];
                
                for(account acc:accVal)
                {
                    for(ChikPeaO2B__Subscription__c am_co : cc)
                    {
                        IF(acc.ChikPeaO2B__Next_Bill_Date__c == null)
                        {
                            acc.ChikPeaO2B__Next_Bill_Date__c = am_co.ChikPeaO2B__Billing_Start_Date__c;  
                            
                        }
                    }
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
        if(Trigger.isDelete){
            try {
                Set<Id> ParentIds = New Set<Id>();
                List<ChikPeaO2B__Subscription__c> cc = New List<ChikPeaO2B__Subscription__c>([select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1]);
                System.debug('number of items in ID set ' + cc);
                for (ChikPeaO2B__Subscription__c co : [select id,ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Start_Date__c from ChikPeaO2B__Subscription__c ORDER BY ChikPeaO2B__Billing_Start_Date__c asc limit 1])
                { 
                    ParentIds.add(co.id);
                }  
                List<Account> accVal = [Select Id,ChikPeaO2B__Next_Bill_Date__c from Account where id IN:ParentIds];
                
                for(account acc:accVal)
                {
                    for(ChikPeaO2B__Subscription__c am_co : cc)
                    {
                        IF(acc.ChikPeaO2B__Next_Bill_Date__c == null)
                        {
                            acc.ChikPeaO2B__Next_Bill_Date__c = am_co.ChikPeaO2B__Billing_Start_Date__c;  
                            
                        }
                    }
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
}