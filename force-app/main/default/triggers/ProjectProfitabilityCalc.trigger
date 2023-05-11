trigger ProjectProfitabilityCalc on Chikpea_Project__c(After update){
    
    try{
        if(checkRecursive.runOnce()){
            
            If(Trigger.Isupdate){
                // Estimated profitability calculation
                List<ChikPeaO2B__Quote_Line__c> ql = new list<ChikPeaO2B__Quote_Line__c>();
                
                List<Chikpea_Project__c> Prj = [Select id,Total_Estimated_hours__c,Estimated_Profit__c from Chikpea_Project__c where id = :Trigger.new];
                List<Chikpea_Project__c> Prjupd = new List<Chikpea_Project__c>();
                
                
                ql = [Select id,ChikPeaO2B__Item__c,Estimated_Hours__c,Estimated_Amount__c,ChikPeaO2B__Rate_Plan__r.Cost_Plan__c from ChikPeaO2B__Quote_Line__c where Project_Name__c = :Trigger.new and ChikPeaO2B__Item_Type__c = 'Post-Paid Usage'];
                
                
                Double TotalAmt = 0;
                Double CpAmt = 0;
                Double Totalhrs = 0;
                
                If(ql.size() > 0){
                    for(ChikPeaO2B__Quote_Line__c ql1 : ql){
                        TotalAmt = TotalAmt + ql1.Estimated_Amount__c;
                        Totalhrs = Totalhrs + ql1.Estimated_Hours__c;
                        For(Cost_Plan__c cp : [Select id,Item__c,Usage_Cost__c from Cost_Plan__c where id = :ql1.ChikPeaO2B__Rate_Plan__r.Cost_Plan__c]){
                            CpAmt = CpAmt + (cp.Usage_Cost__c * ql1.Estimated_Hours__c);
                        }
                    }
                      system.debug('TotalAmt = '+TotalAmt);
                      system.debug('CpAmt = '+CpAmt);
                    
                    Prj[0].Estimated_Profit__c = TotalAmt - CpAmt;
                    Prj[0].Total_Estimated_hours__c = Totalhrs;
                    Prjupd.add(Prj[0]);
                    
                    
                    Update Prjupd;
                }
                
                system.debug('Prj[0].Estimated_Profit__c = '+Prj[0].Estimated_Profit__c);
                
            }
        }
    }Catch(Exception e)
    {
        system.debug('---Exception--'+e.getMessage());
    }
}