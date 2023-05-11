trigger Get_Usageid on ChikPeaO2B__Order__c (after update) {
    List<ChikPeaO2B__Order_Line__c> ord = new list<ChikPeaO2B__Order_Line__c>();
    List<JsonWrapper_Pms> ApiOrderMaster = new list<JsonWrapper_Pms>();
    set<id> TempChikpeaorderID = new set<id>();
    // try{ 
    for(ChikPeaO2B__Order__c ordd: Trigger.new){
        if(Trigger.oldMap.get(ordd.Id).ChikPeaO2B__Status__c =='Open' && ordd.ChikPeaO2B__Status__c =='In Process'){
            TempChikpeaorderID.add(ordd.Id);
        }
    }
    if(TempChikpeaorderID.size() > 0){         
        system.debug('**********TempChikpeaorderID**************'+TempChikpeaorderID);   
      
        ord = [SELECT Tracking_Hours__c,(select id from ChikPeaO2B__Usages__r order by CreatedDate desc limit 1) FROM ChikPeaO2B__Order_Line__c 
               where ChikPeaO2B__Order__c =: TempChikpeaorderID and  ChikPeaO2B__Status__c = 'In Process'];             
       
        //or ChikPeaO2B__Status__c = 'In Process' 
        //and Tracking_Hours__c = True
        system.debug('**********ord**************'+ord);
        
    }
    if(ord.size() > 0){
        //CreateProjectInPms.createProject(usg.Id);//Apex Class
        //set<id> lstusage = new set<id>();        
        for(ChikPeaO2B__Order_Line__c usg : ord ){                   
            for(ChikPeaO2B__Usage__c usg1 : usg.ChikPeaO2B__Usages__r ){       
                JsonWrapper_Pms wrap1 = new JsonWrapper_Pms();
              
                   // wrap1 = CreateProjectInPms_Callouts.createProject(usg1.id);
                    if(wrap1 != null){
                        ApiOrderMaster.add(wrap1);    
                    }  
                 
                
            }            
        }
        if(ApiOrderMaster.size() > 0){
            system.debug('ApiOrderMaster ' +ApiOrderMaster);
          //  CreateProjectInPms_Callouts.CreateProjectUsageInPms(ApiOrderMaster);       
        }        
    } 
    //}
    /*catch(Exception e){
system.debug('===Exception===='+e);
}*/
}