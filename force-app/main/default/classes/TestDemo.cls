@isTest
public class TestDemo {
   
     static testmethod void testSetupMethod(){
        
         Account acc = New Account();
         acc.Name ='Account11234455';
         insert acc;
         
         list<Account> acc1 = [select id,name from Account];
         
         system.debug('acc1 ='+acc1);
     }
}