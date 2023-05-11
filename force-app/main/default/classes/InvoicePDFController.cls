public class InvoicePDFController {
    
    Public String recordID {get;set;}
    public ChikPeaO2B__Invoice__c invoiceDetails{get;set;}
    Public String contactName {get;set;}
    Public String contactPhone {get;set;}
    Public String accountName {get;set;}
    
    /*public Account wonAccList {get;set;}
    
    public Contact wonConList {get;set;}
    
    public ChikPeaO2B__Invoice_Line__c invLine{get;set;}
    
    public ChikPeaO2B__Invoice_Line__c invRe{get;set;}
    
    
    public ChikPeaSSB__Resource__c  tableDataR1{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD1{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR2{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD2{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR3{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD3{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR4{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD4{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR5{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD5{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR6{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD6{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR7{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD7{get;set;}
    
    public ChikPeaSSB__Resource__c  tableDataR8{get;set;}
    public List<ChikPeaSSB__Resource__c>  tableDataRD8{get;set;}
    
    public Double rateTotalR1 {get;set;}
    public Double hr1 {get;set;}
    
    public Double rateTotalR2 {get;set;}
    public Double hr2 {get;set;}
    
    public Double rateTotalR3 {get;set;}
    public Double hr3 {get;set;}
    
    public Double sumR1 {get;set;}
    
    public Double rateTotalR4 {get;set;}
    public Double hr4 {get;set;}
    
    public Double rateTotalR5 {get;set;}
    public Double hr5 {get;set;}
    
    public Double rateTotalR6 {get;set;}
    public Double hr6 {get;set;}
    
    public Double rateTotalR7 {get;set;}
    public Double hr7 {get;set;}
    
    public Double rateTotalR8 {get;set;}
    public Double hr8 {get;set;}
    
    public Double sumR2 {get;set;}
    public Double sumR3 {get;set;}
    
    public Double sumTotal {get;set;}
    
    public ChikPeaSSB__Resource__c  resData{get;set;}*/
    
    
    
    public InvoicePDFController(Apexpages.StandardController controller){
        recordID = controller.getid();
        /*String accountId = ApexPages.currentPage().getParameters().get('accountId');*/
        invoiceDetails = [SELECT Id, name, ChikPeaO2B__Billing_Contact__r.name, ChikPeaO2B__Account__r.name,ChikPeaO2B__Billing_Contact__r.phone  FROM ChikPeaO2B__Invoice__c WHERE Id =:recordID];
        contactName = invoiceDetails.ChikPeaO2B__Billing_Contact__r.name;
        accountName = invoiceDetails.ChikPeaO2B__Account__r.name;
        contactPhone = invoiceDetails.ChikPeaO2B__Billing_Contact__r.phone;
        /*wonAccList = [SELECT Id, BillingStreet,Phone FROM Account WHERE Id = '0017F00000bS2h5QAC'];
        
        wonConList = [SELECT Id, Email FROM Contact WHERE Id = '0037F00001y1wqPQAQ'];
        
        invLine = [SELECT Id, name, ChikPeaO2B__Subscription__r.name, ChikPeaSSB__Phase__c, ChikPeaSSB__Resource__c 
                        FROM ChikPeaO2B__Invoice_Line__c 
                        WHERE Id = 'a0H7F00000udXccUAE'];
        
        invRe = [SELECT Id,ChikPeaSSB__Resource__c 
                        FROM ChikPeaO2B__Invoice_Line__c 
                        WHERE Id = 'a0H7F00000ucdPFUAY'];
        
        
        resData = [SELECT Id, name,ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Estimated_Rate__c FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HOGO4UAP'];
        
        
        tableDataR1 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f6UAD'];
        tableDataRD1 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f6UAD'];
        
        tableDataR2 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f7UAD'];
        tableDataRD2 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f7UAD'];
        
        tableDataR3 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f8UAD'];
        tableDataRD3 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HO2f8UAD'];
        
        tableDataR4 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEEUA3'];
        tableDataRD4 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEEUA3'];
        
        tableDataR5 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEFUA3'];
        tableDataRD5 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEFUA3'];
        
        tableDataR6 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEGUA3'];
        tableDataRD6 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000FrIEGUA3'];
        
        tableDataR7 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HKjfFUAT'];
        tableDataRD7 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HKjfFUAT'];
        
        tableDataR8 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HKjfGUAT'];
        tableDataRD8 = [SELECT Id, name, ChikPeaSSB__Item__r.name, ChikPeaSSB__Phase__r.name, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Rate__c 
                          FROM ChikPeaSSB__Resource__c WHERE Id = 'a1E7F00000HKjfGUAT'];
        
        
        
        hr1 =1;
        hr2 =1;
        hr3 =1;
        hr4 =1;
        hr5 =1;
        hr6 =1;
        hr7 =1;
        hr8 =1;
        
        rateTotalR1 = 1;
        rateTotalR2 = 1;
        rateTotalR3 = 1;
        rateTotalR4 = 1;
        rateTotalR5 = 1;
        rateTotalR6 = 1;
        rateTotalR7 = 1;
        rateTotalR8 = 1;
        
        for (ChikPeaSSB__Resource__c tData : tableDataRD1 )
        {
            rateTotalR1 = rateTotalR1*tData.ChikPeaSSB__Rate__c;
            hr1 = hr1*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        for (ChikPeaSSB__Resource__c tData : tableDataRD2 )
        {
            rateTotalR2 = rateTotalR2*tData.ChikPeaSSB__Rate__c;
            hr2 = hr2*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        for (ChikPeaSSB__Resource__c tData : tableDataRD3 )
        {
            rateTotalR3 = rateTotalR3*tData.ChikPeaSSB__Rate__c;
            hr3 = hr3*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        sumR1 = rateTotalR1*hr1+rateTotalR2*hr2+rateTotalR3*hr3 ;
        
        for (ChikPeaSSB__Resource__c tData : tableDataRD4 )
        {
            rateTotalR4 = rateTotalR4*tData.ChikPeaSSB__Rate__c;
            hr4 = hr4*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        for (ChikPeaSSB__Resource__c tData : tableDataRD5 )
        {
            rateTotalR5 = rateTotalR5*tData.ChikPeaSSB__Rate__c;
            hr5 = hr5*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        for (ChikPeaSSB__Resource__c tData : tableDataRD6 )
        {
            rateTotalR6 = rateTotalR6*tData.ChikPeaSSB__Rate__c;
            hr6 = hr6*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        sumR2 = rateTotalR4*hr4+rateTotalR5*hr5+rateTotalR6*hr6;
        
        for (ChikPeaSSB__Resource__c tData : tableDataRD7 )
        {
            rateTotalR7 = rateTotalR7*tData.ChikPeaSSB__Rate__c;
            hr7 = hr7*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        for (ChikPeaSSB__Resource__c tData : tableDataRD8 )
        {
            rateTotalR8 = rateTotalR8*tData.ChikPeaSSB__Rate__c;
            hr8 = hr8*tData.ChikPeaSSB__Estimated_Hours__c;
        }
        sumR3 = rateTotalR7*hr7+rateTotalR8*hr8;
        
        sumTotal = sumR1 + sumR2 + sumR3;*/
    }
}