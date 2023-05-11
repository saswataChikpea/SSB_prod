@isTest
public class Resourceprofitcalc_Test {

    static testmethod void testSetupMethod1(){
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Developer';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item;
        
       /* ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item1;*/
        
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
        decimal targetprice;
        
        Chikpea_Project__c prj = new Chikpea_Project__c();
        prj.Account__c = acc.id;
        prj.Price_Book__c = pricebk.id;
        prj.Billing_Frequency__c = 'Weekly';
        prj.Project_Model__c = 'Waterfall';
        prj.Target_Price__c = 10.0;
        prj.ChikPeaSSB__Est_Start_Date__c = system.today() + 1;
        insert prj;
        
        Integer val = 12;
        prj.Target_Price__c = val;
        update prj; 
        
        Integer week ;
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = prj.Id;
        phs.Weeks__c = week;
        insert phs;
        
        
        Double est = 20;
        Double EsEfforts;
        
        Resource__c res = new Resource__c();
        res.Phase__c = phs.id;
        res.Staff_Rate__c = true;
        insert res;
        res.Estimated_Hours__c = est;
        
        update res;  
            
        
    }
    static testmethod void testSetupMethod2(){
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Upfront Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item;
        
       /* ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item1;*/
        
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
        decimal targetprice;
        
        Chikpea_Project__c prj = new Chikpea_Project__c();
        prj.Name = 'Testprj';
        prj.Account__c = acc.id;
        prj.Price_Book__c = pricebk.id;
        prj.Billing_Frequency__c = 'Weekly';
        prj.Project_Model__c = 'Agile';
        prj.Target_Price__c = 10.0;
        prj.ChikPeaSSB__Est_Start_Date__c = system.today() + 1;

        insert prj;
        
        Integer val = 12;
        prj.Target_Price__c = val;
        update prj; 
        
        Integer week =10;
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = prj.Id;
        phs.Weeks__c = week;
        insert phs;
        
        
        Double est = 20;
        Double EsEfforts = 10.00;
        
        Resource__c res = new Resource__c();
        res.Phase__c = phs.id;
        res.Staff_Rate__c = true;
        res.Estimated_Efforts__c = EsEfforts;
        insert res;
        EsEfforts= 20;
        res.Estimated_Efforts__c = EsEfforts;
            update res;
        
        
            
        
    }
}