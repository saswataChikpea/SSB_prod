trigger updateDateUsingTrigger on ChikPeaO2B__Subscription__c (before insert,after insert,after update) {

    if(Trigger.isInsert){
         
                 Set<Id> ParentIds = New Set<Id>();
                  Account po = [select Id,ChikPeaO2B__Next_Bill_Date__c from Account where Id ='0017F00001x3R55'];
                  system.debug('@#$%^^^'+po+' @@@@');
                 List<ChikPeaO2B__Subscription__c> l_co = [SELECT Id, ChikPeaO2B__Billing_Start_Date__c FROM ChikPeaO2B__Subscription__c WHERE id =: po.Id ORDER BY ChikPeaO2B__Billing_Start_Date__c asc LIMIT 1];
              
                for (ChikPeaO2B__Subscription__c co : Trigger.new)
                {
                    ParentIds.add(co.id);
                  
                   for(ChikPeaO2B__Subscription__c am_co : l_co) 
                   {
                        
                        co.ChikPeaO2B__Billing_Start_Date__c = am_co.ChikPeaO2B__Billing_Start_Date__c;  
                       IF(ParentIds.contains(co.id))
                       {
                            po.ChikPeaO2B__Next_Bill_Date__c = co.ChikPeaO2B__Billing_Start_Date__c;  

                       }
                   
                    update po;
                }
                }
            }
}