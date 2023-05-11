public with sharing class test1{  
  
    public void testsharing() {
        system.debug('========================');
        ChikPeaSSB__TimeSheet__c ts = new ChikPeaSSB__TimeSheet__c();
        
        insert ts; 
        system.debug('========================'+ts);
    }
}