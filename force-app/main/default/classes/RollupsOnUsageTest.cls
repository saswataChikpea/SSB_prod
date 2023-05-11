@isTest
public class RollupsOnUsageTest {
    static testmethod void usgRollup(){
         
        Contact con = new Contact();
        con.Email = 'Chikpea@gamil.com';
        con.LastName = 'Contact';
        insert con;
        
        
        Account acc = new Account();
        acc.name='Test it with test account' + system.now();
        acc.BillingCity = 'USA';
        acc.Phone ='1234567890';
        insert acc;
                
        ChikPeaO2B__Item__c Itm = new ChikPeaO2B__Item__c();
        Itm.Name = 'Test item';
        Itm.ChikPeaO2B__Item_Type__c = 'Recurring';
        Itm.ChikpeaO2b__active__c =True;
        insert Itm;
        ChikPeaO2B__Price_Book__c PB = new ChikPeaO2B__Price_Book__c();
        PB.Name = 'Test book';
        insert PB;
        ChikPeaO2B__Rate_Plan__c Rp= new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Itm.id;
        Rp.ChikPeaO2B__Price_Book__c = PB.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c = 'Monthly';
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        insert Rp;
        
        ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = PB.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        insert O;
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        Ol.ChikPeaO2B__Item__c = Itm.Id;
        Ol.ChikPeaO2B__Rate_Plan__c = RP.Id;
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        insert Ol;
        
        ChikPeaO2B__Usage__c usg = new ChikPeaO2B__Usage__c();
        usg.ChikPeaO2B__Account__c = acc.id;
        usg.ChikPeaO2B__Item__c = Itm.id;
        usg.ChikPeaO2B__Rate_Plan__c = Rp.id;
        usg.ChikPeaO2B__Order_Line__c = Ol.Id;
        insert usg;
        
        ChikPeaO2B__Usage_History__c UH = New ChikPeaO2B__Usage_History__c();
        UH.ChikPeaO2B__Total_Usage__c = 1;
        UH.ChikPeaO2B__Usage__c = usg.Id;
        insert UH;
        
        test.startTest();
        ChikPeaO2B__Usage_Staging__c ust = new ChikPeaO2B__Usage_Staging__c();
        ust.ChikPeaO2B__Usage__c = usg.id;
        ust.Billable__c = True;
        ust.ChikPeaO2B__Usage_unit__c = 0;
        ust.ChikPeaO2B__Status__c = 'Processed';
        ust.Usage_ID__c = 'STARTNOW';
        // ust.Comments__c = 'Comments';
        insert ust;
        test.stopTest();
        
        ChikPeaO2B__Usage_Staging__c ust1 = new ChikPeaO2B__Usage_Staging__c();
        ust1.ChikPeaO2B__Usage__c = usg.id;
        ust1.Billable__c = FALSE;
        ust1.ChikPeaO2B__Usage_unit__c = 0;
        ust1.ChikPeaO2B__Status__c = 'Processed';
        ust1.Usage_ID__c = 'STARTNOW';
        //ust1.Comments__c = 'Comments';
        insert ust1;
        /*
        ChikPeaO2B__Usage_Staging__c ust5 = new ChikPeaO2B__Usage_Staging__c();
        ust5.ChikPeaO2B__Usage__c = usg.id;
        ust5.Billable__c = false;
        ust5.ChikPeaO2B__Usage_unit__c = 0;
        ust5.ChikPeaO2B__Status__c = 'Processed';
        ust5.Usage_ID__c = 'STARTNOW';
       // ust5.Comments__c = 'Comments';
        insert ust5;*/
        
        ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
        BatchLog.ChikPeaO2B__Error_Log__c = 'error';
        BatchLog.Name = 'reson';
        
        insert BatchLog;
        
        delete ust1;
        
    }
}