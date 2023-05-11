public class ProjectHomePage {
    
    @AuraEnabled
    public static List<Chikpea_Project__c> getProjects () {  
        
        List<Chikpea_Project__c> Prj = [SELECT Id,Name,Status__c,Account__c,Account__r.Name,Project_Contact__c,Project_Contact__r.Name,Price_Book__c,Price_Book__r.Name,
                                        Templatize__c,Template_Name__c,Category__c FROM Chikpea_Project__c ];
        
        return Prj;
    }

}