@isTest
public class checkRecursiveTest {
    static testmethod void testMtd(){
        
        Test.startTest();
        checkRecursive.runOnce();
        checkRecursive.runOnce2();
        Test.stopTest();
       
    }
}