/*
 * Trigger Name : ProjHoursAndDescOnUsage
 * Created on : 22 Oct,2018 by Godson
 * Version : 1.0
 * Reason : This trigger is created to show the projected hours and usage description in the usage 
 * Pre-Works : Projected Hours field is created.
 */

trigger ProjHoursAndDescOnUsage on ChikPeaO2B__Usage__c (before insert, before update) {
    list<id> OlId=new list<id>();
    //loop through all the Incoming usages to get the order line of that usage
    for(ChikPeaO2B__Usage__c usg:trigger.new){
        if(usg.ChikPeaO2B__Order_Line__c!=null ){
            OlId.add(usg.ChikPeaO2B__Order_Line__c);
        }
    }
    if(OlId.size()>0){
        list<ChikPeaO2B__Order_Line__c> OlList =[SELECT id,ChikPeaO2B__Max_Usage__c,ChikPeaO2B__Description__c from ChikPeaO2B__Order_Line__c where id IN:olId];
        //loop through order lines to populate the projected hours and usage description with max usage value and description
        for(ChikPeaO2B__Order_Line__c Ol:OlList){
            for(ChikPeaO2B__Usage__c usg:trigger.new){
                if(Ol.Id==usg.ChikPeaO2B__Order_Line__c){
                   // usg.Projected_Hours__c=Ol.ChikPeaO2B__Max_Usage__c;
                    if(Ol.ChikPeaO2B__Description__c!=null)
                        usg.Description__c=Ol.ChikPeaO2B__Description__c;
                }
            }
        }
    }
}