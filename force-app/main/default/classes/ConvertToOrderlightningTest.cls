@isTest
public class ConvertToOrderlightningTest {
 static testmethod void testMtd(){
       Account acc=new Account(name='acc1');
        insert(acc);
     ChikPeaO2B__Price_Book__c pb=new ChikPeaO2B__Price_Book__c(Name='PB1',ChikPeaO2B__Active__c=true);
        insert(pb);
        ChikPeaO2B__quote__c q=new ChikPeaO2B__quote__c(ChikPeaO2B__Account__c=acc.id,ChikPeaO2B__Price_Book__c=pb.id);
        //insert(q);
     
     //ChikPeaO2B__Quote__c q= new ChikPeaO2B__Quote__c();
     q.ChikPeaO2B__Status__c='Open';
     q.ChikPeaO2B__Payment_Term__c='Pay on Receipt';
     q.ChikPeaSSB__New_Payment_Term__c= 'Pay on Receipt';
     insert q;
  ChikPeaO2B__quote__c q1=new ChikPeaO2B__quote__c(ChikPeaO2B__Account__c=acc.id,ChikPeaO2B__Price_Book__c=pb.id);
        //insert(q);
     
     //ChikPeaO2B__Quote__c q= new ChikPeaO2B__Quote__c();
     q1.ChikPeaO2B__Status__c='Net90';
     q1.ChikPeaO2B__Payment_Term__c='Pay on Receipt';
     q1.ChikPeaSSB__New_Payment_Term__c= 'Pay on Receipt';
     insert q1;     
     Test.startTest();
     
     ConvertToOrderlightning.quoteToOrder(new List<Id>{q.Id});
     ConvertToOrderlightning.quoteToOrder(new List<Id>{q1.Id});
        
     Test.stopTest();
        
    }
}