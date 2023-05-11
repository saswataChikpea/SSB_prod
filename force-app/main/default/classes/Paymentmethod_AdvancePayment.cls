public class Paymentmethod_AdvancePayment {
    @InvocableMethod
    public static void Call_processorder(list<id> inv)//list<id> inv
    {
          
        list<ChikPeaO2B__Advance_payment__c> AdvPay = new list<ChikPeaO2B__Advance_payment__c>();
         list<ChikPeaO2B__Invoice_Line__c> Invln = new list<ChikPeaO2B__Invoice_Line__c>();
         list<ChikPeaO2B__Payment__c> Paymt = new list<ChikPeaO2B__Payment__c>();
        
        Invln  = [Select id from ChikPeaO2B__Invoice_Line__c where ChikPeaO2B__Invoice__c = :inv and ChikPeaO2B__Invoice__r.ChikPeaO2B__Invoice_Status__c = 'Paid' and ChikPeaO2B__Item__r.name ='Upfront Payment'];
       system.debug('Invln ='+Invln);
        
        AdvPay = [Select id,ChikPeaO2B__Payment_Method__c from ChikPeaO2B__Advance_payment__c where Invoice__c =: inv];
        system.debug('AdvPay ='+AdvPay);
        
        Paymt = [select id,ChikPeaO2B__Payment_Method__c from ChikPeaO2B__Payment__c where ChikPeaO2B__Invoice_Line__c = :Invln];
        system.debug('Paymt ='+Paymt);
       
        //system.debug('AdvPay[0].ChikPeaO2B__Payment_Method__c 1 ='+AdvPay[0].ChikPeaO2B__Payment_Method__c);
        if(AdvPay.size() > 0){
            
        
        AdvPay[0].ChikPeaO2B__Payment_Method__c = Paymt[0].ChikPeaO2B__Payment_Method__c;
        
        system.debug('AdvPay[0].ChikPeaO2B__Payment_Method__c 2 ='+AdvPay[0].ChikPeaO2B__Payment_Method__c);
        }
        
        update AdvPay;
        
    }

}