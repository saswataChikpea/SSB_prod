public with sharing class ErrorLogger {
    public static String log(Exception e, String tag){
        String errorMsg = 'Exception ==> '+e.getMessage();
        errorMsg += ' ==> line number ==> '+String.valueOf(e.getLineNumber());
        errorMsg += ' ==> stack trace ==> '+String.valueOf(e.getStackTraceString());
        errorMsg += ' ==> type name ==> '+String.valueOf(e.getTypeName());
        errorMsg += ' ==> cause ==> '+String.valueOf(e.getCause());
        ChikPeaO2B__BatchLog__c el = new ChikPeaO2B__BatchLog__c();
        el.ChikPeaO2B__Error_Log__c = errorMsg;
        el.Name = tag;
        insert el;
        return 'success';
    }
}