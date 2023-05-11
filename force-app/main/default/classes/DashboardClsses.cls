public with sharing class DashboardClsses {
    public DashboardClsses() {

    }
    @AuraEnabled(Cacheable = true)
    
    public static list<ChikPeaSSB__TimeSheet__c> getTimeDetails(String UserId){
        
        //list<TimeSheet> tList = new list<TimeSheet>();
        list<ChikPeaSSB__TimeSheet__c> tList = new list<ChikPeaSSB__TimeSheet__c>();
        system.debug('====');
        for(User u : [Select id, ContactId from User where id =: UserId limit 1])
        {
            for(contact c : [select id, AccountId from contact where Id= : u.ContactId])
            {
                //tList = [select Id, Status, StartDate, EndDate, ChikPeaSSB__Service_Resource_Account__r.name from timesheet where ChikPeaSSB__Service_Resource_Account__c=:c.AccountId];
                tList = [Select Id, ChikPeaSSB__Start_date__c, ChikPeaSSB__End_Date__c, ChikPeaSSB__Resource_Name__r.name, 
                            ChikPeaSSB__Project__r.Name, ChikPeaSSB__Phase__r.Name from ChikPeaSSB__TimeSheet__c ];
                            
            }
        } 
        system.debug('=============================='+tList[0].ChikPeaSSB__Resource_Name__r.name );       
        return tList; 
    }

    @AuraEnabled(Cacheable = true)
    
    public static list<case> getcomHistory(String UserId){        
       
        list<case> caseList = new list<case>();
        system.debug('====getcomHistory====');
        for(User u : [Select id, ContactId from User where id =: UserId limit 1])
        {
            for(contact c : [select id, AccountId from contact where Id= : u.ContactId])
            {
                caseList = [Select Id, AccountId, Comments, CaseNumber, Description, 
                            Reason, status, subject, Type, IsClosed from case WHERE AccountId =: c.AccountId ];
            }
        }        
        return caseList; 
    }

    @AuraEnabled(Cacheable = true)
    
    public static list<ChikPeaSSB__Chikpea_Project__c> getSuggestedProj(String UserId){        
       
        list<ChikPeaSSB__Chikpea_Project__c> projList = new list<ChikPeaSSB__Chikpea_Project__c>();
        system.debug('====getcomHistory====');
        for(User u : [Select id, ContactId from User where id =: UserId limit 1])
        {
            for(contact c : [select id, AccountId from contact where Id= : u.ContactId])
            {
                projList = [Select Id, Name, ChikPeaSSB__Status__c from ChikPeaSSB__Chikpea_Project__c ];
            }
        }        
        return projList; 
    }
}