/*This trigger is a support trigger for the EstmBudget.apxt as 
that is a after update trigger with a field which updates the last edit time */

trigger UpfrontCalcSupprt on ChikPeaO2B__Quote_Line__c (After insert,After update) {
    
    List<ChikPeaO2B__Quote__c> qlf = new List<ChikPeaO2B__Quote__c>();
    
    List<ChikPeaO2B__Quote_Line__c> ql = new List<ChikPeaO2B__Quote_Line__c>();
    List<ChikPeaO2B__Quote_Line__c> qlinfo = new List<ChikPeaO2B__Quote_Line__c>();
    
    List<id> qlid = new List<id>();
    
     List<Chikpea_Project__c> prj = new List<Chikpea_Project__c>();  
          List<Chikpea_Project__c> prjupd = new List<Chikpea_Project__c>();     


    set<Id> ParentQuoteId = new set<Id>();
       

  //if(checkRecursive.runOnce2()){
    for(ChikPeaO2B__Quote_Line__c QuoteLine : trigger.new){
        
        ParentQuoteId.add(QuoteLine.ChikPeaO2B__Quote__c);
        qlid.add(QuoteLine.id);
        
    }
    
    system.debug('qlid ='+qlid);
    If(Trigger.isUpdate){
      qlinfo = [Select id,Project_Name__c from ChikPeaO2B__Quote_Line__c where id = :qlid];
    
    system.debug('qlinfo = '+qlinfo);
   
     If(qlinfo.size() > 0){
        for(ChikPeaO2B__Quote_Line__c ql1 : qlinfo){  //10 5 5 - 2       
            Chikpea_Project__c q1 = new Chikpea_Project__c();  
            q1.Id = qlinfo[0].Project_Name__c;
            q1.To_update_Project__c = date.today();
            prjupd.add(q1);
        }
    }
     if(prjupd.size() > 0){         
    update prjupd;    
    }
    
    }
   
    System.debug('ParentQuoteId = '+ParentQuoteId);
    
    If(ParentQuoteId.size() > 0){
        for(string ql1 : ParentQuoteId){  //10 5 5 - 2       
            ChikPeaO2B__Quote__c q1 = new ChikPeaO2B__Quote__c();  
            q1.Id = ql1;
            q1.To_update_Quote__c = date.today();
            qlf.add(q1);
        }
    }
     
    
    if(qlf.size() > 0){         
    update qlf;    
    }
    
    //}
    
    
}