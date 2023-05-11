@isTest
private class TestCall_processOrd_aftter_upfront {
    private static testMethod void doTest(){
                

      Account acc = New Account();
        acc.Name ='Account2';
        insert acc;
        
        ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage1';
        insert Item1;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Item name1';
        Item.ChikPeaO2B__Item_Type__c = 'One-Off1';
        insert Item;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book1';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Monthly1';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat1';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        insert Rp;
        
        
        ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = pricebk.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        insert O;
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        Ol.ChikPeaO2B__Item__c = Item.Id;
        Ol.ChikPeaO2B__Rate_Plan__c = RP.Id;
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        insert Ol;
        
        ChikPeaO2B__Invoice__c v1 = new ChikPeaO2B__Invoice__c();
        v1.ChikPeaO2B__Order__c = O.Id;
        v1.ChikPeaO2B__Account__c =acc.id;
        insert v1;
        
     List<id> invlst = New List<id>(); 
        invlst.add(v1.id);
       
        
        Call_processOrd_aftter_upfront.Call_processorder(invlst);
        
        
        

}
}