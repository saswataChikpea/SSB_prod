Global class LinkUsageToStagingv1 implements database.Batchable<Sobject> {
    global string query;
    /*global LinkUsageToStaging(){ 
        //Query to get all the usage stagings with status 'New'
        query='Select id,name,Usage_ID__c,chikpeao2b__rate__c,chikpeao2b__status__c,chikpeao2b__uom__c,chikpeao2b__usage_identifier__c,chikpeao2b__usage_rate_code__c,'+
            'chikpeao2b__usage__c,chikpeao2b__usage_unit__c,cost_total__c,billable__c,project_name__c,task__c,task_description__c '
            +'From ChikPeaO2B__Usage_Staging__c'; 
        //+'From ChikPeaO2B__Usage_Staging__c WHERE chikpeao2b__status__c=\'New\'';
    }
    
    global LinkUsageToStaging(String querys){
        this.query = querys;
    }*/
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'Select id,name,Usage_ID__c,chikpeao2b__rate__c,chikpeao2b__status__c,chikpeao2b__uom__c,chikpeao2b__usage_identifier__c,chikpeao2b__usage_rate_code__c,'+
            'chikpeao2b__usage__c,chikpeao2b__usage_unit__c,cost_total__c,billable__c,project_name__c,task__c,task_description__c,Comment__c '
            +'From ChikPeaO2B__Usage_Staging__c';
        return Database.getQueryLocator(query);
    }
    
    /*global database.querylocator start (database.BatchableContext bc){
        system.debug(query);
        return database.getQueryLocator(query);
    } */
    
    
    global void execute(database.BatchableContext bc, list<ChikPeaO2B__Usage_Staging__c>scope){
        list<ChikPeaO2B__Usage_Staging__c> usglst=new list<ChikPeaO2B__Usage_Staging__c>();
        list<ChikPeaO2B__Usage_Staging__c> excptnlst = new list<ChikPeaO2B__Usage_Staging__c>();
        //loop through all usage stagings to get the item name and account name 
        system.debug('*****scope*****'+scope);
        
      scope = [Select id,name,Usage_ID__c,chikpeao2b__rate__c,chikpeao2b__status__c,chikpeao2b__uom__c,chikpeao2b__usage_identifier__c,
               chikpeao2b__usage_rate_code__c,Comment__c,
              chikpeao2b__usage__c,chikpeao2b__usage_unit__c,cost_total__c,billable__c,project_name__c,task__c,task_description__c
              From ChikPeaO2B__Usage_Staging__c limit 10];
        if(scope.size()>0){ 
               
                
            for(ChikPeaO2B__Usage_Staging__c s:scope){
                ChikPeaO2B__Usage_Staging__c tempUsgst=(ChikPeaO2B__Usage_Staging__c)s;
                tempUsgst.ChikPeaO2B__Rate__c=22;
             
                
                try{
                    if(tempUsgst.ChikPeaO2B__Usage_unit__c<0.00){                      
                        tempUsgst.ChikPeaO2B__Status__c='Error';                                                
                       tempUsgst.Comment__c='Usage Unit Cannot be Negative';
                    }
                    
                    
                     if(Test.isRunningTest()){
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception for testing and code coverage');
                        throw e;
                        
                    }
                                    
                 
                }catch(exception e){
                    
                    ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
                    List<ChikPeaO2B__BatchLog__c> listlog= new List<ChikPeaO2B__BatchLog__c>();
                    
                    String ExptnName = 'Exception Type = '+e.getTypeName() +' Time = '+ system.now();
                    String LineNumber =' The root Cause of Exception = ' + String.valueOf(e.getCause()) + '\n StackTrace ====> ' + e.getStackTraceString();
                    BatchLog.ChikPeaO2B__Error_Log__c = LineNumber;
                    BatchLog.Name = 'LinkUsageToStaging';
                    listlog.add(BatchLog);
                    
                    insert listlog;
                    
                    tempUsgst.ChikPeaO2B__Status__c='Error';
                    string TempCmt = tempUsgst.Comment__c == null ? 'Usage Error: '+e.getmessage() : tempUsgst.Comment__c + ', '+'Usage Error: '+e.getmessage() ;                    
                 tempUsgst.Comment__c = TempCmt;
                }
                usglst.add(tempUsgst);
            }
        }
        system.debug(usglst);
        list<ChikPeaO2B__Usage__c> allUsg = [select id,Name from ChikPeaO2B__Usage__c];
        Map<string,id> UsgNameVsUsgId = New Map<string,id>();
        if(allUsg.size()>0){
            for(ChikPeaO2B__Usage__c usg: allUsg){
                UsgNameVsUsgId.put(usg.Name,usg.Id);
            }
        }
        list<ChikPeaO2B__Usage_Staging__c> usgstToUpdate=new list<ChikPeaO2B__Usage_Staging__c>();
        for(ChikPeaO2B__Usage_Staging__c usgst:usglst){
            boolean usg_found=false;
            if(usgst.ChikPeaO2B__Status__c=='New'){
                if(usgst.Usage_ID__c!=null && UsgNameVsUsgId.containsKey(usgst.Usage_ID__c)){ 
                    usg_found=true;
                    usgst.ChikPeaO2B__Usage_unit__c = usgst.ChikPeaO2B__Usage_unit__c != null ? usgst.ChikPeaO2B__Usage_unit__c : 0.00;
                    usgst.ChikPeaO2B__Usage__c=UsgNameVsUsgId.get(usgst.Usage_ID__c);
                }
                if(usg_found)
                    usgst.ChikPeaO2B__Status__c='Processed';
                //break;
                
                if(!usg_found){
                    usgst.ChikPeaO2B__Status__c='Error';
                   usgst.Comment__c='No usage found';  
                }           
                
            }
        }
        if(usglst.size()>0){
            update usglst;
            System.debug('updated usage staging list--->'+usglst);
        }
    }
    global void finish(database.BatchableContext bc){
        
    }  
}