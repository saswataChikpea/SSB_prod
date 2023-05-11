public class AddPhasePrjId {
    
@AuraEnabled
    public static List<Chikpea_Project__c> getPrjid(String PrjId) {
        return [SELECT id FROM Chikpea_Project__c WHERE Id =: PrjId];
    }
}