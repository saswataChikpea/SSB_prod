@isTest
public class InvoiceLineSplit_test {
  
    static testmethod void Invsplt(){
        
         test.starttest();
         Scheduledtotalusagetosub myClass = new Scheduledtotalusagetosub ();   
         String chron = '0 0 23 * * ?';        //23
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
        
        
      //ChikPeaO2B__O2B_Setting__c O2bset = new ChikPeaO2B__O2B_Setting__c();
      
       List<ChikPeaO2B__O2B_Setting__c> O2bset1 = new List<ChikPeaO2B__O2B_Setting__c>();
        
        
       /*O2bset = [Select ChikPeaO2B__Schedule_Time__c,ChikPeaO2B__Billing_Type__c from ChikPeaO2B__O2B_Setting__c];
        
        For(ChikPeaO2B__O2B_Setting__c O2bset : [Select ChikPeaO2B__Schedule_Time__c,ChikPeaO2B__Billing_Type__c from ChikPeaO2B__O2B_Setting__c]){
        
        O2bset.ChikPeaO2B__Schedule_Time__c = '00:00';
        O2bset.ChikPeaO2B__Billing_Type__c = 'Anniversary Subscription';
       O2bset1.add(O2bset);
        }
       //  update O2bset1;*/
       
        ChikPeaO2B__O2B_Setting__c o2b = new ChikPeaO2B__O2B_Setting__c();
        o2b.ChikPeaO2B__Schedule_Time__c = '23:59';
        o2b.ChikPeaO2B__Billing_Type__c = 'Anniversary Subscription';
        insert o2b;
        
          InvoiceLineSplit.Invoicesplitschdle();      
       
        
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
        
         ChikPeaO2B__Quote_Line__c quoteline2 = new ChikPeaO2B__Quote_Line__c();
        quoteline2.ChikPeaO2B__Quote__c = quote.Id;
        quoteline2.ChikPeaO2B__Item__c = Item1.Id;
        quoteline2.ChikPeaO2B__Rate_Plan__c = Rp1.Id;
        quoteline2.Project_Name__c =  cpr.Id;
        quoteline2.ChikPeaO2B__Usage_Rate__c = Rp1.ChikPeaO2B__Usage_Rate__c;
        quoteline2.ChikPeaO2B__Rate_Plan__c = Rp1.Id;
        quoteline2.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        quoteline2.ChikPeaO2B__Unit_Price__c = 50;
        
        insert quoteline2;
        
        
       
        
        quote.ChikPeaO2B__Status__c = 'Accepted';
        update quote;
        
        //upfront Item Order
         ChikpeaO2B__Order__c Oup = new ChikpeaO2B__Order__c();
        Oup.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Oup.ChikPeaO2B__Account__c = acc.Id;
        Oup.ChikPeaO2B__Quote__c = quote.id;
        Oup.Upfront__c = true;
        Oup.ChikPeaO2B__Status__c = 'Open';
        
        insert Oup;
        
        Oup.ChikPeaO2B__Status__c = 'In Process';
        update Oup;
        
        
        ChikpeaO2B__Order_line__c Olup = new ChikpeaO2B__Order_line__c();
        Olup.ChikpeaO2B__Order__c = Oup.Id;
        Olup.ChikPeaO2B__Quote_Line__c = quoteline.id;
        Olup.ChikPeaO2B__Item__c =  quoteline.ChikPeaO2B__Item__c;
        Olup.ChikPeaO2B__Rate_Plan__c = quoteline.ChikPeaO2B__Rate_Plan__c;
        Olup.ChikPeaO2B__Description__c = 'This is the test item';
        insert Olup;
        
        Olup.ChikPeaO2B__Status__c = 'In Process';
         update Olup;
        
        
        // post paid order
        ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = pricebk.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        O.ChikPeaO2B__Quote__c = quote.id;
        o.ChikPeaO2B__Status__c = 'Open';
        insert O;
        
        O.ChikPeaO2B__Status__c = 'In Process';
        update O;
        
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        ol.Project__c = cpr.id;
        ol.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        ol.ChikPeaO2B__Quote_Line__c = quoteline1.id;
        Ol.ChikPeaO2B__Item__c =  quoteline1.ChikPeaO2B__Item__c;
        Ol.ChikPeaO2B__Rate_Plan__c = quoteline1.ChikPeaO2B__Rate_Plan__c;
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        insert Ol;
        
         
        ChikpeaO2B__Order_line__c Ol1 = new ChikpeaO2B__Order_line__c();
        Ol1.ChikpeaO2B__Order__c = O.Id;
        Ol1.Project__c = cpr.id;
        Ol1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        Ol1.ChikPeaO2B__Quote_Line__c = quoteline2.id;
        Ol1.ChikPeaO2B__Item__c =  quoteline2.ChikPeaO2B__Item__c;
        Ol1.ChikPeaO2B__Rate_Plan__c = quoteline2.ChikPeaO2B__Rate_Plan__c;
        Ol1.ChikPeaO2B__Description__c = 'This is the test item';
        insert Ol1;
        
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
        
        ChikPeaO2B__Subscription__c sub1 = new ChikPeaO2B__Subscription__c();
        sub1.ChikPeaO2B__Account__c = acc.id;
        sub1.ChikPeaO2B__Item__c = Ol1.ChikPeaO2B__Item__c;
        sub1.ChikPeaO2B__Rate_Plan__c = Ol1.ChikPeaO2B__Rate_Plan__c;
        sub1.ChikPeaO2B__Order_Line__c = Ol1.id;
        sub1.ChikPeaO2B__Billing_Start_Date__c = system.today();
        sub1.ChikPeaO2B__Recurring_Charge__c = 100;
        sub1.ChikPeaO2B__Next_Bill_Date__c = system.today();
        insert sub1;
        
        ChikPeaO2B__Purchase__c pur = new ChikPeaO2B__Purchase__c();
        pur.ChikPeaO2B__Account__c = Oup.ChikPeaO2B__Account__c;
        pur.ChikPeaO2B__Item__c = Olup.ChikPeaO2B__Item__c;
        pur.ChikPeaO2B__Rate_Plan__c = Olup.ChikPeaO2B__Rate_Plan__c;
        insert pur;
        
        
         ChikPeaO2B__Invoice__c invup = new ChikPeaO2B__Invoice__c();
        invup.ChikPeaO2B__Account__c =  sub.ChikPeaO2B__Account__c;
        invup.ChikPeaO2B__Payment_Term__c = 'NET10';
        insert invup;
        
        ChikPeaO2B__Invoice_Line__c invlup = new ChikPeaO2B__Invoice_Line__c();
        invlup.ChikPeaO2B__Invoice__c = invup.id;
        invlup.ChikPeaO2B__Purchase__c = pur.id;
        invlup.ChikPeaO2B__Item__c = pur.ChikPeaO2B__Item__c;
        invlup.ChikPeaO2B__Unit_Rate__c = 10;
        insert invlup;
        
        ChikPeaO2B__Payment__c pay = new ChikPeaO2B__Payment__c();
        pay.ChikPeaO2B__Invoice__c = invup.id;
        pay.ChikPeaO2B__Account__c =  invup.ChikPeaO2B__Account__c;
        pay.ChikPeaO2B__Invoice_Line__c = invlup.id;
        pay.ChikPeaO2B__Payment_Amount__c = 10;
        insert pay;
         
        invup.ChikPeaO2B__Payment_Term__c = 'NET30';
        update invup;
        
        
        ChikPeaO2B__Invoice__c inv = new ChikPeaO2B__Invoice__c();
        inv.ChikPeaO2B__Account__c =  sub.ChikPeaO2B__Account__c;
        inv.ChikPeaO2B__Payment_Term__c = 'NET10';
        inv.ChikPeaO2B__Other_Charges__c = 100;
        insert inv;
        
        ChikPeaO2B__Invoice_Line__c invl = new ChikPeaO2B__Invoice_Line__c();
        invl.ChikPeaO2B__Invoice__c = inv.id;
        invl.ChikPeaO2B__Subscription__c = sub.id;
        invl.ChikPeaO2B__Item__c = Ol.ChikPeaO2B__Item__c;
        invl.ChikPeaO2B__Unit_Rate__c = 10;
        insert invl;
        
        
        ChikPeaO2B__Invoice_Line__c invl1 = new ChikPeaO2B__Invoice_Line__c();
        invl1.ChikPeaO2B__Invoice__c = inv.id;
        invl1.ChikPeaO2B__Subscription__c = sub1.id;
        invl1.ChikPeaO2B__Item__c = Ol1.ChikPeaO2B__Item__c;
        invl1.ChikPeaO2B__Unit_Rate__c = 10;
        insert invl1;
        
        sub.ChikPeaO2B__Invoice__c = inv.id;
        update sub;
          
        InvoiceLineSplit.InvoiceId();
        
        PaymentTerm.Subscrption(inv.id);
       
        
        
        //TotalusagetoSub.usgid();
    }

}