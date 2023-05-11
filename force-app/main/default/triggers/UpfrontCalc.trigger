/*This trigger is to sums all the values from "Estimated Amount" field in the Quote lines and 
Polulates it in the "Estimated Budget" field in the Quote Object*/


 trigger UpfrontCalc on ChikPeaO2B__Quote__c (after update) {
 
/*
List<ChikPeaO2B__Quote__c> ql = new List<ChikPeaO2B__Quote__c>();
    List<ChikPeaO2B__Quote__c> qlf = new List<ChikPeaO2B__Quote__c>();
    List<ChikPeaO2B__Quote__c> qlfq = new List<ChikPeaO2B__Quote__c>();
    List<ChikPeaO2B__Quote_Line__c> qut = new List<ChikPeaO2B__Quote_Line__c>();
    //set allist = new set();
    ql = [SELECT id, Estimated_Budget__c,Upfront__c,Upfront_Percent__c,Upfront_Amount__c, 
          (SELECT id,Estimated_Amount__c,ChikPeaO2B__Item_Type__c,ChikPeaO2B__Item__r.Name from ChikPeaO2B__Quote_Lines__r 
           where Estimated_Amount__c <> null order by Estimated_Amount__c desc ) 
          FROM ChikPeaO2B__Quote__c where id =: trigger.new];
    
    double Estamt = 0;
    double int1 = 0;
    try{
    if(checkRecursive.runOnce())//EsrBudgetCls.avoidUpdate == true
    {
     
        ChikPeaO2B__Quote__c q1 = new ChikPeaO2B__Quote__c();
        if(ql.size()>0){
            for(ChikPeaO2B__Quote__c ql1 : ql){ 
                if( ql1.ChikPeaO2B__Quote_Lines__r.size() > 0){
                    for(ChikPeaO2B__Quote_Line__c ql2 : ql1.ChikPeaO2B__Quote_Lines__r){                
                           string itemtpe;
                        itemtpe = ql2.ChikPeaO2B__Item_Type__c;
                        
                        system.debug('*******itemtpe****1****'+itemtpe);
                        
                        if(itemtpe == 'Post-Paid Usage'){
                            double amt = ql2.Estimated_Amount__c;
                            Estamt = Estamt + amt; 
                        }
                        q1 = new ChikPeaO2B__Quote__c();
                        q1.Id = ql1.Id;
                        q1.Estimated_Budget__c = Estamt;
                        
                        If(Estamt >=0){
                            //integer Upfrntperc = integer.valueof(ql1.Upfront_Percent__c);
                            double Upfrntperc = ql1.Upfront_Percent__c;
                            ql1.Upfront_Amount__c = (q1.Estimated_Budget__c * Upfrntperc)/100;//update not done
                            
                            system.debug('******* ql1.Upfront_Amount__c ********'+ ql1.Upfront_Amount__c +q1.Estimated_Budget__c+Upfrntperc);
                            
                           system.debug('******* itemtpe ********'+ itemtpe +ql2.ChikPeaO2B__Item__r.Name);
                            if(itemtpe == 'One-Off' && ql2.ChikPeaO2B__Item__r.Name == 'Upfront Payment'){
                                   system.debug('******* ql1.Upfront_Amount__c ********'+ ql1.Upfront_Amount__c);
                                ChikPeaO2B__Quote_Line__c qql = new ChikPeaO2B__Quote_Line__c();
                                qql.Id = ql2.Id;
                                qql.ChikPeaO2B__Unit_Price__c = ql1.Upfront_Amount__c;
                                qut.add(qql);
                                system.debug('*******qut********'+qut);
                            }                 
                        } 
                       
                    }
                     qlf.add(q1);
                    qlfq.add(ql1);
                }      
            } 
            if(qlf.size() > 0){ 
               // EsrBudgetCls.avoidUpdate = false;
               update qlfq;
               update qut;
               update qlf; 
            }
        }  
    }
    }Catch(Exception e)
   {
       system.debug('---Exception--'+e.getMessage());
    } */
     
     
     
     
     
}