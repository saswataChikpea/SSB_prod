public class Call_processOrd_aftter_upfront {
    @InvocableMethod
    public static void Call_processorder(list<id> inv)
    {
        List<ChikPeaO2B__Invoice__c> invlst =New List<ChikPeaO2B__Invoice__c>(); 
        List<id>   ordid = New List<id>();
        list<ChikPeaO2B__Order__c> Olist = New list<ChikPeaO2B__Order__c>();
        list<id> Qlist = New list<id>();
        list<ChikPeaO2B__Quote__c> OpenOrd = New list<ChikPeaO2B__Quote__c>();
        list<id> ordids = New list<id>();
        
        
        invlst = [select id,name,ChikPeaO2B__Order__r.id from ChikPeaO2B__Invoice__c where id =: inv ];
        
        for(ChikPeaO2B__Invoice__c invc : invlst){
            id sid = invc.ChikPeaO2B__Order__r.id;
            ordid.add(sid);
        }
        
        Olist = [select id,ChikPeaO2B__Quote__c from ChikPeaO2B__Order__c where id =: ordid[0]];
        
        for(ChikPeaO2B__Order__c Qid : Olist){
            id Qtid = Qid.ChikPeaO2B__Quote__c;
            Qlist.add(Qtid);
        }
        if(Qlist.size()>0 && Qlist != Null){
            OpenOrd = [select id,(select id from ChikPeaO2B__Orders__r where ChikPeaO2B__Status__c = 'Open') from ChikPeaO2B__Quote__c 
                       where id =: Qlist and ChikPeaO2B__Status__c = 'Accepted'];
            
            system.debug('*******OpenOrd*****'+ OpenOrd);
            for(ChikPeaO2B__Quote__c oid : OpenOrd){
                for(ChikPeaO2B__Order__c oid1 : oid.ChikPeaO2B__Orders__r){
                    id tempoid = oid1.id;
                    
                    ordids.add(tempoid);
                }
                system.debug('*******ordids***1**'+ ordids);
            }
            system.debug('*******ordids**2***'+ ordids);
            if(ordids.size()>0 && ordids != null){
                 system.debug('*******ordids**3***'+ ordids);
               ChikPeaO2B.ProcessOrder.OrderProcessorButton(ordids);
            }  
        }
        
    } 
}