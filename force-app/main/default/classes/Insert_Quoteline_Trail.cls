public class Insert_Quoteline_Trail {
    
    public static void Quoteline(){
        
        List<ChikPeaO2B__Quote__c> q1 = new list<ChikPeaO2B__Quote__c>();
        List<ChikPeaO2B__Quote_Line__c> ql1 = new list<ChikPeaO2B__Quote_Line__c>();
        
        q1=[Select id,name from ChikPeaO2B__Quote__c where id = 'a0T7F00000R9kjY'];
        
       
        If(q1.size()>0)
        {
            ChikPeaO2B__Quote_Line__c ql = new ChikPeaO2B__Quote_Line__c(ChikPeaO2B__Item__c = 'a0J7F00000PBPIb',ChikPeaO2B__Rate_Plan__c = 'a0U7F00000FVZAL',
                                                                        ChikPeaO2B__Quote__c = 'a0T7F00000R9kjY');
         ql1.add(ql);
        }
        insert ql1;  
    }  
}