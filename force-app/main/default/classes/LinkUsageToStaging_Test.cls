@isTest
global class LinkUsageToStaging_Test  {
    
    @isTest static void testBatchClass() {
        
        DateTime now = DateTime.now();
        // Implement test code
        Contact con = new Contact(); 
        con.Email = 'Chikpea@gamil.com';
        con.LastName = 'Contact 010'+now;
        insert con;
        
        Account acc = New Account();
        acc.Name ='Account 001'+now;
        acc.BillingCity = 'USA';
        acc.Phone ='1234567890';
        insert acc;
        
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Item name';
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Monthly';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        insert Rp;
        
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
        insert quote;
        
        ChikPeaO2B__Quote_Line__c quoteline = new ChikPeaO2B__Quote_Line__c();
        quoteline.ChikPeaO2B__Quote__c = quote.Id;
        quoteline.ChikPeaO2B__Item__c = Item.Id;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.Project_Name__c =  cpr.Id;
        quoteline.ChikPeaO2B__Usage_Rate__c = Rp.ChikPeaO2B__Usage_Rate__c;
        quoteline.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        quoteline.Tracking_Hours__c=True;
        quoteline.ChikPeaO2B__Subscription_Term_Months__c = '12' ;
        quoteline.ChikPeaO2B__Subscription_Start_Date__c = Date.newInstance(2019, 11 , 22);
        quoteline.Estimated_Hours__c = 10;
        insert quoteline;
        
        Integer myInt = Integer.valueOf(quoteline.ChikPeaO2B__Subscription_Term_Months__c);
        date myDate = quoteline.ChikPeaO2B__Subscription_Start_Date__c;
        date newDate = myDate.addMonths(myInt);
        
        
        ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = pricebk.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        insert O;
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        Ol.ChikPeaO2B__Item__c = Item.Id;
        Ol.ChikPeaO2B__Rate_Plan__c = RP.Id;
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        //Ol.Estimated_Hours__c = quoteline.Estimated_Hours__c;
        insert Ol;        
        
        ChikPeaO2B__Usage__c usg = new ChikPeaO2B__Usage__c();
        usg.ChikPeaO2B__Account__c = acc.id;
        usg.ChikPeaO2B__Item__c = Item.id;
        usg.ChikPeaO2B__Rate_Plan__c = Rp.id;
        usg.ChikPeaO2B__Order_Line__c = Ol.Id;
        //usg.Projected_Hours__c = Ol.Estimated_Hours__c;
        insert usg;
        
        
       
        ChikPeaO2B__Usage_Staging__c usgstg = new ChikPeaO2B__Usage_Staging__c();
        usgstg.Usage_ID__c = usg.Id;
        usgstg.ChikPeaO2B__Rate__c = 22;
        usgstg.ChikPeaO2B__Status__c = 'New'; 
      usgstg.Comment__c='Usage Unit Cannot be Negative0';
        usgstg.ChikPeaO2B__Usage_unit__c = 00.0;
        String s = usg.id;
        String s2 = s.abbreviate(14);
        usgstg.Usage_ID__c = s2;
        insert usgstg; 
       
        
        usgstg.ChikPeaO2B__Usage_unit__c = -1;
        Update usgstg;
  
        
        list<ChikPeaO2B__Usage_Staging__c> l1 = new list<ChikPeaO2B__Usage_Staging__c>();
        
        String querys = 'Select id,name,Usage_ID__c,chikpeao2b__rate__c,chikpeao2b__status__c,chikpeao2b__uom__c,chikpeao2b__usage_identifier__c,chikpeao2b__usage_rate_code__c,'+
            'chikpeao2b__usage__c,chikpeao2b__usage_unit__c,cost_total__c,billable__c,project_name__c,task__c,task_description__c '
            +'From ChikPeaO2B__Usage_Staging__c'; 
        
        
        System.debug('************querys'+querys);
        
        
        l1 = [Select id,name,Usage_ID__c,chikpeao2b__rate__c,chikpeao2b__status__c,chikpeao2b__uom__c,chikpeao2b__usage_identifier__c,chikpeao2b__usage_rate_code__c,
              chikpeao2b__usage__c,chikpeao2b__usage_unit__c,cost_total__c,billable__c,project_name__c,task__c,task_description__c
              From ChikPeaO2B__Usage_Staging__c limit 10];
        
        LinkUsageToStagingv1 sf = new LinkUsageToStagingv1(); 
        
        // sf = new LinkUsageToStaging();
        //Database.executeBatch(sf);
       
        LinkUsageToStagingv1 LUS = new LinkUsageToStagingv1();
        Database.executeBatch(new LinkUsageToStagingv1());
        database.executeBatch(LUS,200);
        
        Database.QueryLocator ql = LUS.start(null);
        LUS.execute(null,l1); 
        LUS.Finish(null);
        
    
        ChikPeaO2B__BatchLog__c cl = new ChikPeaO2B__BatchLog__c();
        cl.ChikPeaO2B__DML_Exception__c = True;
        cl.ChikPeaO2B__Error_Log__c = 'test';
        cl.Name = 'tests';
        insert cl;
        
        ChikPeaO2B__BatchLog__c cll = new ChikPeaO2B__BatchLog__c();
        cll.ChikPeaO2B__DML_Exception__c = True;
        cll.ChikPeaO2B__Error_Log__c = 'test';
        cll.Name = 'tests';
        insert cll;                  
    }
    
   
}