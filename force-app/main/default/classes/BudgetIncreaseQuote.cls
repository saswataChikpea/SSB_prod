public with sharing class BudgetIncreaseQuote {
    Public String recordID {get;set;}
    Public ChikPeaSSB__Chikpea_Project__c projectDetails {get;set;}
    Public Contact projectContact {get;set;}
    Public Account accountDetails {get;set;}
    Public List<Project_Phase__c> phaseDetails {get;set;}
    Public List<Project_Phase__c> incresedPhaseDetails {get;set;}
    Public List<ChikPeaSSB__Resource__c> resourceDetails {get;set;}
    public Double subTotal {get;set;}
    public Double grandTotal {get;set;}

    public Double upfront {get;set;}
    public Double subTotalIncrement {get;set;}
    public Double taxPercent {get;set;}
    public Double taxAmount {get;set;}
    public Double taxAmountIncrement {get;set;}
    public Double totalAmount {get;set;}
    public Double totalAmountIncrement {get;set;}

    public BudgetIncreaseQuote(Apexpages.StandardController controller) {
        recordID = controller.getid();
        system.debug('constructor project recordID===>'+recordID);
        
        projectDetails= [select Id, Name, ChikPeaSSB__Project_Description__c, ChikPeaSSB__Project_Specifications__c, ChikPeaSSB__Project_Goals__c,
         ChikPeaSSB__Account__r.Name,ChikPeaSSB__Account__r.BillingState,ChikPeaSSB__Account__r.BillingCity,ChikPeaSSB__Account__r.BillingPostalCode,ChikPeaSSB__Account__r.ChikPeaSSB__State_Code__c,ChikPeaSSB__Account__r.BillingCountry,ChikPeaSSB__Account__r.BillingStreet, 
         ChikPeaSSB__Account__r.Website,ChikPeaSSB__Project_Contact__r.Name, ChikPeaSSB__Project_Contact__r.Phone,
        ChikPeaSSB__Project_Contact__r.Email, ChikPeaSSB__Project_Contact__r.MobilePhone, ChikPeaSSB__Project_Contact__r.MailingAddress,
        ChikPeaSSB__Upfront_Amount__c,ChikPeaSSB__Upfront_Payment_Percentage__c
        from ChikPeaSSB__Chikpea_Project__c WHERE  id =:recordID
            ];
        projectContact= projectDetails.ChikPeaSSB__Project_Contact__r;
        System.debug('projectDetails==>'+JSON.serialize(projectDetails));
      
        
        accountDetails= projectDetails.ChikPeaSSB__Account__r;
        
            
        upfront=projectDetails.ChikPeaSSB__Upfront_Amount__c;
            
           
        

        phaseDetails = [select id, name, ChikPeaSSB__Descriptions__c, ChikPeaSSB__Est_Start_date__c, ChikPeaSSB__Est_End_Date__c,
        ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Estimated_Rate__c, ChikPeaSSB__Estimated_Cost__c,
        ChikPeaSSB__Phase_Profit__c, ChikPeaSSB__Act_hours__c, ChikPeaSSB__Actual_Profit__c, 
        ChikPeaSSB__Actual_Rate__c, ChikPeaSSB__Actual_Cost__c, ChikPeaSSB__Increased_Hours__c, ChikPeaSSB__Increased_Rate__c,
        ChikPeaSSB__Reason_for_Increment__C
        from  ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c=:recordID];
        System.debug('phaseDetails==>'+JSON.serialize(phaseDetails));
    
        incresedPhaseDetails =new List<Project_Phase__c>();
        List<Id> phaseIds = new List<Id>();
        subTotal=0;
        subTotalIncrement=0;
        taxPercent=5;//hardcoded
        if (phaseDetails.size()>0) {
            for (ChikPeaSSB__Project_Phase__c phase : phaseDetails ) {
                phaseIds.add(phase.id);
                
                subTotal= subTotal + phase.ChikPeaSSB__Estimated_Rate__c;
                if (phase.ChikPeaSSB__Increased_Hours__c != null) {
                    incresedPhaseDetails.add(phase);
                    subTotalIncrement= subTotalIncrement + phase.ChikPeaSSB__Increased_Rate__c;
                }
            }
           
        }


        grandTotal = subTotal - upfront ;
        
        System.debug('incresedPhaseDetails==>'+JSON.serialize(incresedPhaseDetails));
        taxAmount= subTotal * taxPercent / 100;
        totalAmount = subTotal + taxAmount;
        taxAmountIncrement = subTotalIncrement * taxPercent/100;
        totalAmountIncrement = subTotalIncrement + taxAmountIncrement;
        System.debug('phaseIds==>'+phaseIds);

        resourceDetails = [Select id,Name,
            ChikPeaSSB__Res_Num__c, ChikPeaSSB__Estimated_Efforts__c, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Staff_Rate__c,
            ChikPeaSSB__Profit__c, ChikPeaSSB__Rate__c, ChikPeaSSB__Cost__c, ChikPeaSSB__Actual_Accrued__c,
            ChikPeaSSB__Billable_Accrued__c, ChikPeaSSB__Remaining_Hours__c, ChikPeaSSB__Res_Profit__c, 
            ChikPeaSSB__Billed__c, ChikPeaSSB__Actual_Cost__c, 
            ChikPeaSSB__Item__r.Name,
            ChikPeaSSB__Phase__r.Name, 
            ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Hours__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Rate__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Cost__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Phase_Profit__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Act_hours__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Profit__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Rate__c,
            ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Cost__c
            from ChikPeaSSB__Resource__c
                                    where ChikPeaSSB__Phase__c in :phaseIds and Pending_For_Approval__c=true
                                    Order by CreatedDate];   
        System.debug('resourceDetails==>'+JSON.serialize(resourceDetails));

        
        
    }
}