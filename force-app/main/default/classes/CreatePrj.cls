public with sharing class CreatePrj {
    
    
    @AuraEnabled
    public static Boolean CheckPrjOpp(Id recordId){
        
        List<Opportunity> opp = [select id,name from Opportunity where id = :recordId ];
        
        List<ChikPeaSSB__Chikpea_Project__c> Prj = [SELECT ChikPeaSSB__Target_Price__c,ChikPeaSSB__Target_Profit__c,ChikPeaSSB__Estimated_Cost__c,ChikPeaSSB__Estimated_Rate__c,ChikPeaSSB__Project_Model__c,ChikPeaSSB__Quote__c 
                                        FROM ChikPeaSSB__Chikpea_Project__c WHERE Opportunity__c =:recordId Or Name =: opp[0].Name];
        
        Boolean Check;
        system.debug('Prj.size() = '+Prj.size());
        if(Prj.size() > 0){
            Check = false;
             return Check;
        }else{
            Check = true;
             return Check;
        }
       
    }
    
    @AuraEnabled
    public static String newContract(String opp_id){
        System.debug('opp_id -->'+opp_id);
        String contractID; 
        try {
            if(opp_id != null){
                Opportunity opp = [select id,name,Account.id,Account.name,Pricebook2.O2B_Price_Book__c from Opportunity where id = :opp_id ];
                
                if(opp != null){
                    if(Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.Name.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Account__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.Opportunity__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Price_Book__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Billing_Frequency__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Est_Start_Date__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Project_Model__c.isCreateable()
                    ){
                        ChikPeaSSB__Chikpea_Project__c contractProj = new ChikPeaSSB__Chikpea_Project__c();
                        contractProj.Name = opp.name;
                        contractProj.ChikPeaSSB__Account__c = opp.Account.id;
                        contractProj.Opportunity__c = opp_id;
                        //ChikPeaSSB__Price_Book__c
                        contractProj.ChikPeaSSB__Price_Book__c = opp.Pricebook2.O2B_Price_Book__c;
                        contractProj.ChikPeaSSB__Billing_Frequency__c = 'Monthly';
                        contractProj.ChikPeaSSB__Est_Start_Date__c = Date.today();
                        contractProj.ChikPeaSSB__Project_Model__c = 'Waterfall';
                        insert contractProj;
                        System.debug('contractProj.id '+contractProj.id);
                        //contractID = 'a0s5e000000XBbkAAG';//contractProj.id;
                        contractID = contractProj.id;
                    }else{
                        return null;
                    }
    
                }
            }
        } catch (Exception e) {
            System.debug('Exception at Create Contract : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            ErrorLogger.log(e, 'CreateProj');            
        }
        return contractID;
    }
     @AuraEnabled
    public static String CheckConctract(String opp_id){
        System.debug('opp_id -->'+opp_id);
        String contractID;
        try {
            if(opp_id != null){
                Opportunity opp = [select id,name,Account.id,Account.name,Pricebook2.O2B_Price_Book__c from Opportunity where id = :opp_id ];
                
                if(opp != null){
                    if(Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.Name.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Account__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.Opportunity__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Price_Book__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Billing_Frequency__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Est_Start_Date__c.isCreateable() &&
                    Schema.sObjectType.ChikPeaSSB__Chikpea_Project__c.fields.ChikPeaSSB__Project_Model__c.isCreateable()
                    ){
                        ChikPeaSSB__Chikpea_Project__c contractProj = new ChikPeaSSB__Chikpea_Project__c();
                        contractProj.Name = opp.name;
                        contractProj.ChikPeaSSB__Account__c = opp.Account.id;
                        contractProj.Opportunity__c = opp_id;
                        //ChikPeaSSB__Price_Book__c
                        contractProj.ChikPeaSSB__Price_Book__c = opp.Pricebook2.O2B_Price_Book__c;
                        contractProj.ChikPeaSSB__Billing_Frequency__c = 'Monthly';
                        contractProj.ChikPeaSSB__Est_Start_Date__c = Date.today();
                        contractProj.ChikPeaSSB__Project_Model__c = 'Waterfall';
                        insert contractProj;
                        System.debug('contractProj.id '+contractProj.id);
                        //contractID = 'a0s5e000000XBbkAAG';//contractProj.id;
                        contractID = contractProj.id;
                    }else{
                        return null;
                    }
    
                }
            }
        } catch (Exception e) {
            System.debug('Exception at Create Contract : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            ErrorLogger.log(e, 'CreateProj');
        }
        return contractID;
    }
}