/*
* Trigger name: projectInPms
* Purpose:creation of the project in PMS, with the creation of usage in O2b
* Created on and by: 16thJun 2019, Sridevi
* Last Modified on and By: 20th Jun 2019, Sridevi
*/
Trigger projectInPms on ChikPeaO2B__Usage__c (after insert) {
    if(trigger.isAfter && trigger.isInsert ){
        for (ChikpeaO2B__Usage__c usg: Trigger.new){
            ChikpeaO2B__Order_line__c ord = [SELECT Is_Chikpea_Sow__c  FROM ChikpeaO2B__Order_line__c WHERE id=:usg.ChikPeaO2B__Order_Line__c];
            try{
                if (ord.Is_Chikpea_Sow__c){//Is_chikpea_Sow__c){
                    system.debug('usg.Id ===>' + usg.Id);
                    projectInPmsCls.createProject(usg.Id);
                }
            }
            catch(Exception ex){
                system.debug('Its showing error');            
            }
        }
    }
}