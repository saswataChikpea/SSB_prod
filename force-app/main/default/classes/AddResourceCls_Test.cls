@isTest
public class AddResourceCls_Test {     
    
    static testmethod void testSetupMethod1(){
        Test.startTest();
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Upfront Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
         Item.ChikPeaO2B__Category__c = 'Resource';
        //Item.Role__c = true;
        insert Item;
        
        ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        Item1.ChikPeaO2B__Category__c = 'Resource';
        //Item1.Role__c = true;
        insert Item1;
        
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
        
        Chikpea_Project__c prj = new Chikpea_Project__c();
        prj.Account__c = acc.id;
        prj.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        prj.Price_Book__c = pricebk.id;
        prj.Billing_Frequency__c = 'Weekly';
        prj.Project_Model__c = 'Waterfall';
        insert prj;
        
        /*Chikpea_Project__c prjc = new Chikpea_Project__c();
        prjc.Account__c = acc.id;
        prjc.Price_Book__c = pricebk.id;
        prjc.Billing_Frequency__c = 'Weekly';
        prjc.Project_Model__c = 'Agile';
        insert prjc;*/
        
        /*Project_Phase__c phas = new Project_Phase__c();
        phas.Name = 'Project Phases';
        phas.Project__c = prjc.Id;
        insert phas;*/
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = prj.Id;
        insert phs;
        
       /* Resource__c ress = new Resource__c();
        ress.Phase__c = phas.id;
        ress.Estimated_Efforts__c = 50;
        ress.Item__c = Item.id;
        ress.Rate_Plan__c = Rp.id;
        ress.Cost_Plan__c = cp.id;
        insert ress;*/
        
        Resource__c res = new Resource__c();
        res.Phase__c = phs.id;
        res.Estimated_Hours__c = 123;
        res.Item__c = Item.id;
        res.Rate_Plan__c = Rp.id;
        res.Staff_Rate__c = true;
        
        res.Cost_Plan__c = cp.id; //cp.Usage_Cost__c//cp.id;
        insert res;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(phs);
        ApexPages.CurrentPage().getparameters().put('id', phs.id);        
        AddResourceCls obj = new AddResourceCls(sc);
      
        AddResourceCls.ResourceCustomWrapper ResWrap = new AddResourceCls.ResourceCustomWrapper();           
        ResWrap.Resource = Item.Name;
        //ResWrap.acc = Item.Id;
        ResWrap.itmid = Item.Id;
        ResWrap.EstHrs = 450;  //if(Resource__c.Cost_Plan__c != null)
        ResWrap.Cost = cp.Usage_Cost__c;
        ResWrap.rtplans = new list<AddResourceCls.RateplanCustomWrapper>();         
        ResWrap.selected = true;
        ResWrap.bdLine = new Budget_Line__c(Status__c = 'Open', Request_Type__c = 'Original',
            Effective_Date__c = Date.today()
        );
        
        
        
        AddResourceCls.RateplanCustomWrapper RpWrap = new AddResourceCls.RateplanCustomWrapper();         
        RpWrap.Name = Rp.Name;
        RpWrap.rplid = Rp.id;
        RpWrap.Rate = Rp.ChikPeaO2B__Usage_Rate__c;
        RpWrap.Billcycle = Rp.ChikPeaO2B__Bill_Cycle__c;                 
        RpWrap.rateplanselected = true;
        ResWrap.rtplans.add(RpWrap);
        
        obj.GetSelected();               
        obj.GetSelectedAccounts();                           
        obj.selectedItems.add(ResWrap); 
        obj.save();
        
        ResWrap = new AddResourceCls.ResourceCustomWrapper();           
        ResWrap.Resource = Item.Name;
        ResWrap.itmid = Item.Id;
        ResWrap.EstHrs = 0;
        ResWrap.Cost = cp.Usage_Cost__c;
        ResWrap.rtplans = new list<AddResourceCls.RateplanCustomWrapper>();         
        ResWrap.selected = true;
        ResWrap.bdLine = new Budget_Line__c(Status__c = 'Open', Request_Type__c = 'Original',
            Effective_Date__c = Date.today()
        );
        
        RpWrap = new AddResourceCls.RateplanCustomWrapper();         
        RpWrap.Name = Rp.Name;
        RpWrap.rplid = Rp.id;
        RpWrap.Rate = Rp.ChikPeaO2B__Usage_Rate__c;
        RpWrap.Billcycle = Rp.ChikPeaO2B__Bill_Cycle__c;                 
        RpWrap.rateplanselected = true;
        ResWrap.rtplans.add(RpWrap);
        
        obj.GetSelected();               
        obj.GetSelectedAccounts();                           
        obj.selectedItems.add(ResWrap);
        obj.save();
         
        ResWrap=new AddResourceCls.ResourceCustomWrapper();           
        ResWrap.Resource = Item.Name;
        //ResWrap.acc = Item.Id;
        ResWrap.itmid = Item.Id;
        ResWrap.EstHrs = 20;
        ResWrap.Cost = cp.Usage_Cost__c ;
        ResWrap.rtplans = new list<AddResourceCls.RateplanCustomWrapper>();         
        ResWrap.selected = true;
        ResWrap.bdLine = new Budget_Line__c(Status__c = 'Open', Request_Type__c = 'Original',
            Effective_Date__c = Date.today()
        );
          
        RpWrap = new AddResourceCls.RateplanCustomWrapper();         
        RpWrap.Name = Rp.Name;
        RpWrap.rplid = Rp.id;
        RpWrap.Rate = Rp.ChikPeaO2B__Usage_Rate__c;
        RpWrap.Billcycle = Rp.ChikPeaO2B__Bill_Cycle__c;                 
        RpWrap.rateplanselected = false;
        ResWrap.rtplans.add(RpWrap);
        
        obj.GetSelected();               
        obj.GetSelectedAccounts();                           
        obj.selectedItems.add(ResWrap);
        obj.save();
        Test.stopTest();
    }
    /*static testmethod void testSetupMethod2(){
        Test.startTest();
        
         Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Upfront Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item;
        
        ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item1;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book1';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
        Cost_Plan__c cp = new Cost_Plan__c();
        cp.Item__c = Item.id;
        cp.Usage_Cost__c = 100;
        insert cp;
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Weekly';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        Rp.Cost_Plan__c = cp.id;
        insert Rp;
        
        
        
        Chikpea_Project__c prjc = new Chikpea_Project__c();
        prjc.Account__c = acc.id;
        prjc.Price_Book__c = pricebk.id;
        prjc.Billing_Frequency__c = 'Weekly';
        prjc.Project_Model__c = 'Agile';
        insert prjc;
        
        Project_Phase__c phas = new Project_Phase__c();
        phas.Name = 'Project Phases';
        phas.Project__c = prjc.Id;
        insert phas;
        
        Resource__c ress = new Resource__c();
        ress.Phase__c = phas.id;
        ress.Estimated_Efforts__c = 50;
        ress.Item__c = Item.id;
        ress.Rate_Plan__c = Rp.id;
        ress.Cost_Plan__c = cp.id;
        insert ress;
        Test.stopTest();
    }*/
}