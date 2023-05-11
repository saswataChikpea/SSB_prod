public class ConvertToOrderlightning {
@AuraEnabled 
    public static String quoteToOrder(List<ID> qidList){
        List<ID> QuoteId = new List<ID>();
        List<ChikPeaO2B__Quote__c> QuoteList = [Select ID,ChikPeaO2B__Status__c From ChikPeaO2B__Quote__c where ID =:qidList];
        System.debug('The QuoteList is '+QuoteList);
        if(QuoteList[0].ChikPeaO2B__Status__c == 'Open'){
            QuoteId.add(QuoteList[0].ID);
    		Id OrderId = convertToMultipleOrderBasedOnProjects.quoteToOrder(QuoteId);
        	return OrderId;
        }
        else{
            return 'Cannot convert to Order. Quote\'s Status is not Open';
        }
    }
}