@isTest 
private  class CreateProjectInPmscallouts_test {
    @isTest static  void testCallout() {
        
        
        List<JsonWrapper_Pms> jsonlst = new list<JsonWrapper_Pms>();
        //SingleRequestMock smk = new SingleRequestMock();
        List<Account> accnt = new list<Account>();
        
        
        Contact con = new Contact();
        con.Email = 'Chikpea@gamil.com';
        con.LastName = 'Contact';
        insert con;
        
        
        
        Account acc = New Account();
        acc.Name ='Account' + system.now();
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
        
        insert Ol;        
        
        ChikPeaO2B__Usage__c usg = new ChikPeaO2B__Usage__c();
        usg.ChikPeaO2B__Account__c = acc.id;
        usg.ChikPeaO2B__Item__c = Item.id;
        usg.ChikPeaO2B__Rate_Plan__c = Rp.id;
        usg.ChikPeaO2B__Order_Line__c = Ol.Id;
        //usg.Projected_Hours__c = Ol.Estimated_Hours__c;
        insert usg;
        
        ChikPeaO2B__Subscription__c	 sub = new ChikPeaO2B__Subscription__c();
        sub.ChikPeaO2B__Account__c = acc.Id;
        sub.ChikPeaO2B__Item__c = Item.Id;
        sub.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        // Date.newInstance(2019, 11 , 02);
        DateTime dT = System.now();
        Date myDates = date.newinstance(dT.year(), dT.month(), dT.day());
        sub.ChikPeaO2B__Billing_Start_Date__c = myDates;
        sub.ChikPeaO2B__Billing_Stop_Date__c = newDate;
        insert sub;
        
        Datetime d = Date.Valueof(myDates);   
        String dateStr = d.formatGMT('dd/MM/yyyy');
        
        JsonWrapper_Pms wrap = new JsonWrapper_Pms();
        wrap.usageid = usg.id;
        
        
        jsonlst.add(wrap);
      //  CreateProjectInPms_Callouts.createProject(usg.id);
       // CreateProjectInPms_Callouts.CreateProjectUsageInPms(jsonlst);
        
        //CreateProjectInPms_Callouts.createProject(usg.Id);        
        // CreateProjectInPms_Callouts.CreateProjectUsageInPms(jsonlst);
        
        
        // Set mock callout class 
        //   Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        
    }
    
    @isTest static void testCallout1() {
        
        Contact con = new Contact();
        con.Email ='vhkkj@gmail.com';
        con.LastName = 'Contact';
        
        insert con;
        
        Account acc = New Account();
        acc.Name ='Account';
        acc.BillingCity = 'USA';
        acc.Phone ='';
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
        quoteline.Estimated_Hours__c = null;
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
        
        ChikPeaO2B__Subscription__c	 sub = new ChikPeaO2B__Subscription__c();
        sub.ChikPeaO2B__Account__c = acc.Id;
        sub.ChikPeaO2B__Item__c = Item.Id;
        sub.ChikPeaO2B__Rate_Plan__c = Rp.Id;
        sub.ChikPeaO2B__Billing_Start_Date__c = system.today();
        sub.ChikPeaO2B__Billing_Stop_Date__c = system.today();
        insert sub;
        
       // CreateProjectInPms_Callouts.createProject(usg.Id);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());       
    } 
}