global with sharing class UpfrontCalculationBasedOnProjects {
    
    //webservice static id quoteToOrder(List<id> qidList)
    //
    //UpfrontCalculationBasedOnProjects.UpfrontCalc('a0T7F00000R9kjY');
   /* webservice static Void UpfrontCalc(List<id> qidList)
    {
        List<ChikPeaO2B__Quote__c>qlList=new List<ChikPeaO2B__Quote__c>();
        Set<String> qlprj = new Set<String>();
        Map<id,set<String>> PrjMap = new Map<id,set<String>>();
        Map<id,String> PrjMap1 = new Map<id,String>();
        
        
        for(ChikPeaO2B__Quote__c qt:[SELECT id,name,ChikPeaO2B__Price_Book__c,ChikPeaO2B__Status__c,
                                     (SELECT id,name,ChikPeaO2B__Item__c,ChikPeaO2B__Quote__c,
                                      ChikPeaO2B__Rate_Plan__c,ChikPeaO2B__Non_recurring_Charge__c,ChikPeaO2B__Item_Type__c,
                                      Estimated_Hours__c,ChikPeaO2B__Unit_Price__c,ChikPeaO2B__Free_Usage__c,
                                      ChikPeaO2B__Usage_Rate__c,Project_Name__c,Project_Name__r.Name,ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Pricing_Type__c,
                                      ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c from 
                                      ChikPeaO2B__Quote_Lines__r) from ChikPeaO2B__Quote__c where id in:qidList])
        {
            
            qlList.add(qt);
            system.debug('*********qt***********'+qt);
        }
        
        If(qlList.size() > 0){
            for(ChikPeaO2B__Quote__c qt : qlList)
            {
                if(qt.ChikPeaO2B__Status__c=='Accepted')
                { 
                    if(qt.ChikPeaO2B__Quote_Lines__r!=null && qt.ChikPeaO2B__Quote_Lines__r.size()>0)
                    {
                        for(ChikPeaO2B__Quote_Line__c qtl:qt.ChikPeaO2B__Quote_Lines__r)
                        {
                            Id pid = qtl.Project_Name__c;
                            String s1 = qtl.Project_Name__r.Name; 
                            
                            PrjMap1.put(pid,s1);
                            
                        }
                        system.debug('**********PrjMap1************'+PrjMap1);    
                    }
                }
                
            }
            
            //return null;
        }
        
    }*/
}