@isTest(SeeAllData=true)
public class convertToMultiple_Test {
    static testmethod void MultipleOrder(){
        
        
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
         ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Upfront Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'One-Off';
        insert Item;
        
        ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item1;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book123';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        insert Rp;
        
         
        ChikPeaO2B__Rate_Plan__c Rp1 = new ChikPeaO2B__Rate_Plan__c();
        Rp1.ChikPeaO2B__Item__c = Item1.Id;
        Rp1.ChikPeaO2B__Bill_Cycle__c='Monthly';
        Rp1.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp1.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp1.ChikPeaO2B__Usage_Rate__c = 7.00;
        insert Rp1;
        
        
       Chikpea_Project__c cpr = new Chikpea_Project__c();
        cpr.Name = 'Services1';
        cpr.Template_Description__c = 'Project to define billing';
        cpr.Template_Name__c = 'Billing1';
        cpr.Category__c = 'Software development';
        cpr.Billing_Frequency__c = 'Weekly';
        cpr.Account__c = acc.id;
        cpr.Price_Book__c = pricebk.id;
        cpr.Templatize__c = True;
        cpr.Status__c = 'New';
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        insert cpr;
        
        
        ChikPeaO2B__Quote__c quote = new ChikPeaO2B__Quote__c();
        quote.ChikPeaO2B__Account__c = acc.Id;
        quote.ChikPeaO2B__Price_Book__c = pricebk.Id;
        quote.ChikPeaO2B__Status__c = 'Open';
        quote.ChikPeaO2B__Contract_Term_Months__c = '12';
        quote.ChikPeaO2B__Payment_Term__c = 'Pay on Receipt';
        quote.New_Payment_Term__c = 'Pay on Receipt';
        quote.Upfront__c = true;
        quote.Upfront_Percent__c = 10;
        quote.Billing_Type__c = 'Monthly';
        insert quote;
        
        ChikPeaO2B__Quote_Line__c quoteline = new ChikPeaO2B__Quote_Line__c();
        quoteline.ChikPeaO2B__Quote__c = quote.Id;
        quoteline.ChikPeaO2B__Item__c = Item.Id;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.Project_Name__c =  null;
        quoteline.ChikPeaO2B__Usage_Rate__c = Rp.ChikPeaO2B__Usage_Rate__c;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.ChikPeaO2B__Item_Type__c = 'One-Off';
        
        insert quoteline;
        
        ChikPeaO2B__Quote_Line__c quoteline1 = new ChikPeaO2B__Quote_Line__c();
        quoteline1.ChikPeaO2B__Quote__c = quote.Id;
        quoteline1.ChikPeaO2B__Item__c = Item1.Id;
        quoteline1.ChikPeaO2B__Rate_Plan__c = Rp1.Id;
        quoteline1.Project_Name__c =  cpr.Id;
        quoteline1.ChikPeaO2B__Usage_Rate__c = Rp1.ChikPeaO2B__Usage_Rate__c;
        quoteline1.ChikPeaO2B__Rate_Plan__c = Rp1.Id;
        quoteline1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        quoteline1.ChikPeaO2B__Unit_Price__c = 50;
        
        
        insert quoteline1;
        
        List<id> tes= new List<id>{quote.Id};
            convertToMultipleOrderBasedOnProjects.quoteToOrder(tes);
        
        //delete quote;
        //delete quoteline;
        
        
        ChikPeaO2B__BatchLog__c Blog = new ChikPeaO2B__BatchLog__c();
        Blog.ChikPeaO2B__Error_Log__c = 'Error';
        Blog.Name = 'Exception';
        insert Blog;  
        
    } 
}