@isTest
public class PostToUsgStagings_Test {

    static testmethod void testSetupMethod1(){
     //   Test.startTest();
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        Contact conn = new Contact();
        conn.LastName = 'Mark1';
        insert Conn;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book1';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
         Cost_Book__c cb = New Cost_Book__c();
        cb.Name = 'Testbook';
        cb.Active__c = true;
        insert cb;
        
        Cost_Plan__c cp = new Cost_Plan__c();
         cp.Cost_Book__c = cb.id;
        cp.Item__c = Item.id;
        cp.Usage_Cost__c = 3;
        insert cp;
        
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Weekly';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        Rp.Cost_Plan__c = cp.id;
        insert Rp;
        
       Chikpea_Project__c cpr = new Chikpea_Project__c();
        cpr.Name = 'Services190';
        cpr.Template_Description__c = 'Project to define billing';
        cpr.Template_Name__c = 'Billing1';
        cpr.Category__c = 'Software development';
        cpr.Billing_Frequency__c = 'Weekly';
        cpr.Project_Model__c = 'Waterfall';
        cpr.Account__c = acc.id;
        cpr.Price_Book__c = pricebk.id;
        cpr.Templatize__c = True;
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        insert cpr;
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = cpr.Id;
        phs.Is_Blended_Rate__c = false;
        
        insert phs;
        
        Resource__c res = new Resource__c();
        res.Phase__c = phs.id;
        res.Estimated_Hours__c = 10;
        res.Rate_Plan__c = Rp.id;
        res.Cost_Plan__c = cp.id;
        res.Staff_Rate__c = true;
        
         insert res; 
        

        Resource_Staging__c resstage = new Resource_Staging__c();
        resstage.Resource__c = res.id;
        resstage.Actual_Hours__c = 20;
        resstage.Billable_Hours__c = 10;
        resstage.Date__c = system.today(); 
        resstage.Post__c = false;
        
        insert resstage;
        
        ChikPeaO2B__Quote__c quot = new ChikPeaO2B__Quote__c();
        quot.ChikPeaO2B__Account__c = acc.Id;
        quot.ChikPeaO2B__Contact__c = conn.Id;
        quot.ChikPeaO2B__Price_Book__c = pricebk.Id;
        quot.ChikPeaO2B__Payment_Term__c = 'NET10';
        quot.New_Payment_Term__c = 'Net10';
        quot.ChikPeaO2B__Status__c = 'Accepted';
        insert quot;
        
        ChikPeaO2B__Quote_Line__c qline = new ChikPeaO2B__Quote_Line__c();
        qline.ChikPeaO2B__Item__c = Item.Id;
        qline.ChikPeaO2B__Quote__c = quot.Id;
        qline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        qline.Resource__c = res.Id;
        insert qline;
        
          ChikPeaO2B__Order__c ordr = new ChikPeaO2B__Order__c();
        ordr.ChikPeaO2B__Account__c = acc.Id;
        ordr.ChikPeaO2B__Price_Book__c = pricebk.Id;
        ordr.ChikPeaO2B__Status__c = 'In Process';
        insert ordr;
        
           ChikPeaO2B__Order_Line__c ordrline = new ChikPeaO2B__Order_Line__c();
        ordrline.ChikPeaO2B__Order__c = ordr.Id;
        ordrline.ChikPeaO2B__Item__c = Item.Id;
        ordrline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        ordrline.ChikPeaO2B__Quote_Line__c = qline.Id;
        insert ordrline;
         
          ChikPeaO2B__Usage__c usgs = new ChikPeaO2B__Usage__c();
        usgs.ChikPeaO2B__Account__c = acc.Id;
        usgs.ChikPeaO2B__Order_Line__c = ordrline.id;
        usgs.ChikPeaO2B__Item__c = Item.Id;
        usgs.ChikPeaO2B__Type__c = 'Postpaid';
        usgs.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        usgs.ChikPeaO2B__Min_Usage__c =5000;
        insert usgs;
        
       
        ChikPeaO2B__Usage_Staging__c usgstgs = new ChikPeaO2B__Usage_Staging__c();
        usgstgs.Usage_ID__c = 'stages';
        usgstgs.ChikPeaO2B__Usage__c = usgs.Id;
        usgstgs.ChikPeaO2B__Usage_Identifier__c = 'usage';
        usgstgs.Project_Name__c = 'services';
        usgstgs.Billable__c = True;
        usgstgs.ChikPeaO2B__Status__c = 'Processed';
        insert usgstgs;
    
        
        ChikPeaO2B__Usage_Staging__c Stagings = new ChikPeaO2B__Usage_Staging__c();
        Stagings.Billable__c = true;
        Stagings.ChikPeaO2B__Status__c = 'New';
        Stagings.ChikPeaO2B__Usage_unit__c = 3;
        Stagings.ChikPeaO2B__UsageDate__c = system.today();
        Stagings.ChikPeaO2B__Usage__c = usgs.Id;
        Stagings.Usage_ID__c = 'stages1';
        Stagings.ChikPeaO2B__Usage_Identifier__c = 'usage1';
        usgstgs.Project_Name__c = 'services';
        insert Stagings;
        
        PostToUsgStagings.ResStaging( phs.id);
       //  Test.stopTest();

}
}