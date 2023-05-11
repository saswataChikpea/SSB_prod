@isTest
public class generateXmlTest {
    static testmethod void testgenerateXml(){
        Project p= new Project();
        //p.name='TEST';
        //p.startDate= System.today();
        //p.finishDate= System.today();
        //p.currentDate= System.today();
        //insert p;
        Test.startTest();
        GenerateXml.generateXml(p);
        
        Test.stopTest();
        
    }
}