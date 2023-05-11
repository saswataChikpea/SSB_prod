@isTest
public class TestAttachPdf {
    static testmethod void test1(){

        Account acc = New Account();
        acc.Name ='Account1';
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
        
        
        
        
        
        ChikPeaO2B__Quote__c quote = new ChikPeaO2B__Quote__c();
        quote.ChikPeaO2B__Account__c = acc.Id;
        quote.ChikPeaO2B__Price_Book__c = pricebk.Id;
        quote.ChikPeaO2B__Status__c = 'Open1';
        quote.ChikPeaO2B__Contract_Term_Months__c = '12';
         quote.ChikPeaO2B__Payment_Term__c = 'Pay on Receipt';
        quote.New_Payment_Term__c = 'Pay on Receipt';
        insert quote;

        Chikpea_Project__c cpr = new Chikpea_Project__c();
        cpr.Name = 'Services1';
        cpr.Template_Description__c = 'Project to define billing';
        cpr.Template_Name__c = 'Billing1';
        cpr.Category__c = 'Software development';
        cpr.Billing_Frequency__c = 'Weekly';
        cpr.Account__c = acc.id;
        cpr.ChikPeaSSB__Quote__c = quote.Id;
        cpr.Price_Book__c = pricebk.id;
        cpr.Templatize__c = True;
        cpr.Status__c = 'New';
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today();
        insert cpr;
        
        ChikPeaO2B__Quote_Line__c quoteline = new ChikPeaO2B__Quote_Line__c();
        quoteline.ChikPeaO2B__Quote__c = quote.Id;
        quoteline.ChikPeaO2B__Item__c = Item.Id;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.Project_Name__c =  cpr.Id;
        quoteline.ChikPeaO2B__Usage_Rate__c = Rp.ChikPeaO2B__Usage_Rate__c;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        
        insert quoteline;
        
        ChikPeaO2B__Quote_Line__c quoteline1 = new ChikPeaO2B__Quote_Line__c();
        quoteline1.ChikPeaO2B__Quote__c = quote.Id;
        quoteline1.ChikPeaO2B__Item__c = Item.Id;
        quoteline1.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline1.Project_Name__c =  cpr.Id;
        quoteline1.ChikPeaO2B__Usage_Rate__c = Rp.ChikPeaO2B__Usage_Rate__c;
        quoteline1.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline1.ChikPeaO2B__Item_Type__c = 'Upfront Payment';
        quoteline1.ChikPeaO2B__Unit_Price__c = quote.Upfront_Amount__c;
        
        
        insert quoteline1;

        Test.startTest();
        AttachPdf.attachQuotePDF(new List<Id>{quote.Id});
        Test.stopTest();
    }
}