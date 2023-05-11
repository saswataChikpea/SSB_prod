trigger createProjectInPms on ChikPeaO2B__Usage__c (after insert) 
{ //after insert,
   /* for (ChikpeaO2B__Usage__c usg: Trigger.new)
    {
       ChikpeaO2B__Order_line__c ord = [SELECT Tracking_Hours__c  FROM ChikpeaO2B__Order_line__c WHERE id=:usg.ChikPeaO2B__Order_Line__c];
        if (ord.Tracking_Hours__c)//Is_chikpea_Sow__c check box
        { 
           system.debug('usg.Id ===>' + usg.Id);
              system.debug('****** Current Date timein Usage after insert$$$$ ****** ' + System.Datetime.now());
            //CreateProjectInPms.createProject(usg.Id);//Apex Class
            
            
        }
    }*/
}