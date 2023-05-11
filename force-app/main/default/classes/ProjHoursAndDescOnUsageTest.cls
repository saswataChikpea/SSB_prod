@isTest
public class ProjHoursAndDescOnUsageTest {
    static testmethod void Projecthrsmethod(){
        Account acc = new Account();
        acc.name='Test';
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
    }
}