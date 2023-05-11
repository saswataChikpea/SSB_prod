@isTest
public class Paymentmethod_AdvancePayment_test {
   
    static testmethod void usgtosub(){
        
   
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
        
        
         
        ChikPeaO2B__Purchase__c pur = new ChikPeaO2B__Purchase__c();
        pur.ChikPeaO2B__Account__c = Oup.ChikPeaO2B__Account__c;
        pur.ChikPeaO2B__Item__c = Olup.ChikPeaO2B__Item__c;
        pur.ChikPeaO2B__Rate_Plan__c = Olup.ChikPeaO2B__Rate_Plan__c;
        insert pur;
        
        
        ChikPeaO2B__Invoice__c invup = new ChikPeaO2B__Invoice__c();
        invup.ChikPeaO2B__Account__c =   pur.ChikPeaO2B__Account__c;
        invup.ChikPeaO2B__Payment_Term__c = 'NET10';
        invup.ChikPeaO2B__Other_Charges__c = 100;
        insert invup;
        
        ChikPeaO2B__Invoice_Line__c invlup = new ChikPeaO2B__Invoice_Line__c();
        invlup.ChikPeaO2B__Invoice__c = invup.id;
        invlup.ChikPeaO2B__Purchase__c = pur.id;
        invlup.ChikPeaO2B__Item__c = pur.ChikPeaO2B__Item__c;
        invlup.ChikPeaO2B__Unit_Rate__c = 10;
        insert invlup;
        
        pur.ChikPeaO2B__Invoice__c = invup.id;
        update pur;
        
        ChikPeaO2B__Payment__c pay = new ChikPeaO2B__Payment__c();
        pay.ChikPeaO2B__Invoice__c = invup.id;
        pay.ChikPeaO2B__Account__c =  invup.ChikPeaO2B__Account__c;
        pay.ChikPeaO2B__Invoice_Line__c = invlup.id;
        pay.ChikPeaO2B__Payment_Amount__c = 10;
        pay.ChikPeaO2B__Payment_Method__c = 'Check';
        insert pay;
         
        invup.ChikPeaO2B__Payment_Term__c = 'NET30';
        update invup;
        
        list<id> invid = new list<id>();
        
        invid.add(invup.id);
                
        
                     Paymentmethod_AdvancePayment.Call_processorder(invid);

        
      

    
        ChikPeaO2B__Advance_payment__c Ad = new ChikPeaO2B__Advance_payment__c();
        Ad.ChikPeaO2B__Account__c = invup.ChikPeaO2B__Account__c;
        Ad.Advancepmt_Quote__c = quote.id;
        Ad.Invoice__c = invup.id;
        Ad.ChikPeaO2B__Payment_Method__c = '';
        insert Ad;
        
       // Ad.ChikPeaO2B__Payment_Method__c  =  pay.ChikPeaO2B__Payment_Method__c;
        
        //update Ad;
       
      // Paymentmethod_AdvancePayment.Call_processorder(invid);

 }
}