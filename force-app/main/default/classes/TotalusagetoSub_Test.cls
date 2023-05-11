//@isTest(SeeAllData=true)
@isTest
public class TotalusagetoSub_Test {
  
    static testmethod void usgtosub(){
        
         test.starttest();
         Scheduledtotalusagetosub myClass = new Scheduledtotalusagetosub ();   
         String chron = '0 0 23 * * ?';        //23
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
        
        
      //ChikPeaO2B__O2B_Setting__c O2bset = new ChikPeaO2B__O2B_Setting__c();
      
        List<ChikPeaO2B__O2B_Setting__c> O2bset1 = new List<ChikPeaO2B__O2B_Setting__c>();
        List<ID> usidlist = New List<ID>();

        
       /*O2bset = [Select ChikPeaO2B__Schedule_Time__c,ChikPeaO2B__Billing_Type__c from ChikPeaO2B__O2B_Setting__c];
        
        For(ChikPeaO2B__O2B_Setting__c O2bset : [Select ChikPeaO2B__Schedule_Time__c,ChikPeaO2B__Billing_Type__c from ChikPeaO2B__O2B_Setting__c]){
        
        O2bset.ChikPeaO2B__Schedule_Time__c = '00:00';
        O2bset.ChikPeaO2B__Billing_Type__c = 'Anniversary Subscription';
       O2bset1.add(O2bset);
        }
       //  update O2bset1;*/
       
        ChikPeaO2B__O2B_Setting__c o2b = new ChikPeaO2B__O2B_Setting__c();
        o2b.ChikPeaO2B__Schedule_Time__c = '00:00';
        o2b.ChikPeaO2B__Billing_Type__c = 'Anniversary Subscription';
        insert o2b;
        
          TotalusagetoSub.totalusage();      
       
        
        //Method 2 
        
        
        Account acc = New Account();
        acc.Name ='Account1';
        acc.ChikPeaO2B__Active__c = 'Yes';
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
        pricebk.Name = 'Price book1';
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
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1;
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
        quote.Services_Billing__c = True;
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
        
        quote.ChikPeaO2B__Status__c = 'Accepted';
        update quote;
        
        
        ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = pricebk.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        O.ChikPeaO2B__Quote__c = quote.id;
        insert O;
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        ol.Project__c = cpr.id;
        ol.ChikPeaO2B__Quote_Line__c = quoteline1.id;
        Ol.ChikPeaO2B__Item__c = Item.Id;
        Ol.ChikPeaO2B__Rate_Plan__c = RP.Id;
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        insert Ol;
        
        ol.ChikPeaO2B__Status__c = 'In Process';
         update Ol;
        
    
         ChikPeaO2B__Subscription__c sub = new ChikPeaO2B__Subscription__c();
        sub.ChikPeaO2B__Account__c = acc.id;
        sub.ChikPeaO2B__Item__c = ol.ChikPeaO2B__Item__c;
        sub.ChikPeaO2B__Rate_Plan__c = Ol.ChikPeaO2B__Rate_Plan__c;
        sub.ChikPeaO2B__Order_Line__c = ol.id;
        sub.ChikPeaO2B__Billing_Start_Date__c = system.today();
        sub.ChikPeaO2B__Recurring_Charge__c = 100;
        sub.ChikPeaO2B__Next_Bill_Date__c = system.today();
        insert sub;   
        
        ChikPeaO2B__Usage__c usg = new ChikPeaO2B__Usage__c();
        usg.ChikPeaO2B__Account__c = acc.Id;
        usg.ChikPeaO2B__Item__c = Item1.id;
        usg.ChikPeaO2B__Rate_Plan__c = Rp1.id;
        usg.ChikPeaO2B__Order_Line__c = ol.id;
        usg.ChikPeaO2B__Subscription__c =sub.id;
        usg.ChikPeaO2B__Rate__c = 10;
        usg.ChikPeaO2B__Total_Usage__c = 10;
        insert usg;
        
        usidlist.add(usg.id);
        
         ChikPeaO2B__Usage__c usg1 = new ChikPeaO2B__Usage__c();
        usg1.ChikPeaO2B__Account__c = acc.Id;
        usg1.ChikPeaO2B__Item__c = Item1.id;
        usg1.ChikPeaO2B__Rate_Plan__c = Rp1.id;
        usg1.ChikPeaO2B__Order_Line__c = ol.id;
        //usg1.ChikPeaO2B__Subscription__c =sub.id;
        usg1.ChikPeaO2B__Rate__c = 10;
        usg1.ChikPeaO2B__Total_Usage__c = 10;
        insert usg1;
        
        usidlist.add(usg1.Id);
        
        ChikPeaO2B__Usage_Staging__c usgst = new ChikPeaO2B__Usage_Staging__c();
        usgst.ChikPeaO2B__Status__c = 'New';
        usgst.ChikPeaO2B__Usage__c = usg.id;
        usgst.Usage_ID__c = 'xyz';
        usgst.Billable__c = true;
        Insert usgst;
        
         ChikPeaO2B__Usage_Staging__c usgst1 = new ChikPeaO2B__Usage_Staging__c();
        usgst1.ChikPeaO2B__Status__c = 'Processed';
        usgst1.ChikPeaO2B__Usage__c = usg.id;
        usgst1.Usage_ID__c = 'xyz';
        usgst1.Billable__c = true;
        Insert usgst1;
        
         ChikPeaO2B__Usage_Staging__c usgst2 = new ChikPeaO2B__Usage_Staging__c();
        usgst2.ChikPeaO2B__Status__c = 'Invoiced';
        usgst2.ChikPeaO2B__Usage__c = usg.id;
        usgst2.Usage_ID__c = 'xyz';
        usgst2.Billable__c = true;
        Insert usgst2;
        
        TotalusagetoSub.usgid();
            TotalusagetoSub.UsagetoSub(usidlist);
        
    }

}