global with sharing class TotalusagetoSub{
    
    //for schedule from UI
    @AuraEnabled
  Webservice static String totalusage(){
   
        String error; 
        String sch;        
        Scheduledtotalusagetosub BCBS = new Scheduledtotalusagetosub();
        list<ChikPeaO2B__O2B_Setting__c>O2BsetList=[SELECT id,ChikPeaO2B__Billing_Type__c,ChikPeaO2B__Billing_Day__c,ChikPeaO2B__Schedule_Time__c from ChikPeaO2B__O2B_Setting__c limit 1];
        if(O2BsetList!=null && O2BsetList.size()>0)
        {
            if(O2BsetList[0].ChikPeaO2B__Schedule_Time__c!=null && O2BsetList[0].ChikPeaO2B__Schedule_Time__c!='')
            {
                List<String> ScheduleTime=O2BsetList[0].ChikPeaO2B__Schedule_Time__c.split(':');
                
                system.debug('ScheduleTime' + ScheduleTime);
                //system.debug('integer.valueof(scheduletime[1])-2' + (integer.valueof(scheduletime[1])-2));
                
               // logic to -1 the time before the invoice batch is scheduled
                if(O2BsetList[0].ChikPeaO2B__Billing_Type__c=='Anniversary Subscription')
                    {
                if(scheduletime[1] == '00'){
                    
                    scheduletime[1] = '60';
                    string s1 = String.valueof(integer.valueof(scheduletime[1])-1);
                    
                    If(integer.valueof(scheduletime[0]) == 00){
                        
                       scheduletime[0] = '24';
                    string s2 = String.valueof(integer.valueof(scheduletime[0])-1);//1-24 but 00
                        sch='0 '+s1.trim()+' '+s2.trim()+' * * ?'; 
                        
                    }else{
                        
                         string s2 = String.valueof(integer.valueof(scheduletime[0])-1);
                        sch='0 '+s1.trim()+' '+s2.trim()+' * * ?';  
                        
                    } 
                }
                        else
                {
               string s1 = String.valueof(integer.valueof(scheduletime[1])-1);
                system.debug('s1' + s1);  
                                         
                        sch='0 '+s1.trim()+' '+ScheduleTime[0].trim()+' * * ?';
                }
            }
                
                    
            }   
            try{
                //sch='0 69 06 * * ?';
               system.schedule('Batch for Usage',sch, BCBS);
                error='success';
            }
            catch(Exception e)
            {
                error=e.getMessage();
                system.debug('error = '+error);
            ErrorLogger.log(e, 'TotalusagetoSub');            
            //throw new BatchException('Some error occured in BatchCreateBillRunScheduler Class.',e);
            }
        }
        return error;    
    }
    
    
    //logic to get the Usage ID related to services billing
   Public static void usgid(){
        
       try{
           List<Account> Acc = New List<Account>();
           List<id> usgidlist = New List<id>();
           List<id> qtidlist = New List<id>();
           List<id> olidList = New List<id>();
           List<ChikPeaO2B__Quote_Line__c> qtl = New List<ChikPeaO2B__Quote_Line__c>();
            List<ChikPeaO2B__Order_Line__c> ordln = New List<ChikPeaO2B__Order_Line__c>();
           List<ChikPeaO2B__Usage__c> usgid = New List<ChikPeaO2B__Usage__c>();

            Date todaydate = System.Today();
            
            system.debug('----todaydate ='+todaydate);
               
            usgid = [Select id from ChikPeaO2B__Usage__c where ChikPeaO2B__Subscription__r.ChikPeaO2B__Next_Bill_Date__c = today and 
                     ChikPeaO2B__Subscription__r.ChikPeaSSB__Project__c != null and ChikPeaO2B__Subscription__r.ChikPeaSSB__Phase__c != null];
            
            system.debug('----usgid ='+usgid);
                        system.debug('----usgid size ='+usgid.size());
            for(ChikPeaO2B__Usage__c u1 : usgid){
            usgidlist.add(u1.Id);
            }          

        system.debug('----usgidlist ='+usgidlist);
           
           UsagetoSub(usgidlist);
     
       }catch(exception e ){
        ErrorLogger.log(e, 'TotalusagetoSub');            
    } 
    }
    //Code logic to populate the Total usage value into the subscbtion Reccuring charge
   public static void UsagetoSub(list<id> usgid){
       try{
        If(usgid != null){
           
            list<ChikPeaO2B__Usage__c> usglst = new list<ChikPeaO2B__Usage__c>();
            list<ChikPeaO2B__Usage_Staging__c> stgngslstupdate = new list<ChikPeaO2B__Usage_Staging__c>();
            list<ChikPeaO2B__Subscription__c> Sublst = new list<ChikPeaO2B__Subscription__c>();
            list<ChikPeaO2B__Usage_History__c> usghstlst = new list<ChikPeaO2B__Usage_History__c>();
            list<ChikPeaO2B__Usage_Staging__c> stgngslstupdate1 = new list<ChikPeaO2B__Usage_Staging__c>();
        
    
            For(ChikPeaO2B__Usage_Staging__c usg : [Select id,Usage_ID__c,ChikPeaO2B__Usage__c,ChikPeaO2B__Status__c 
                   from ChikPeaO2B__Usage_Staging__c where ChikPeaO2B__Status__c ='New' and ChikPeaO2B__Usage__c =: usgid]){
               
                    usg.ChikPeaO2B__Status__c= 'Processed';
                    stgngslstupdate.add(usg);
                            }
               update stgngslstupdate;
        
        For(ChikPeaO2B__Usage__c usg :   [select id, ChikPeaO2B__Account__c,ChikPeaO2B__Rate__c,ChikPeaO2B__Remaining_Usage__c,
                  ChikPeaO2B__Free_Usage__c,ChikPeaO2B__Usage_Value__c,ChikPeaO2B__Total_Usage__c from ChikPeaO2B__Usage__c where id =: usgid AND ChikPeaO2B__Usage_Value__c > 0]){
       
                      ChikPeaO2B__Usage_History__c usghst = new ChikPeaO2B__Usage_History__c();
                                                               usghst.ChikPeaO2B__Account__c = usg.ChikPeaO2B__Account__c;
                                                               usghst.ChikPeaO2B__Bill_Date__c = date.today();
                                                               usghst.ChikPeaO2B__Usage__c = usg.Id;
                                                               usghst.ChikPeaO2B__Rate__c = usg.ChikPeaO2B__Rate__c;
                                                               usghst.ChikPeaO2B__Total_Usage__c = usg.ChikPeaO2B__Total_Usage__c;
                                                               usghstlst.add(usghst);
                                                           }
                                     insert usghstlst;        
        
               
            
        
            
            For(ChikPeaO2B__Usage__c usg :   [select id,ChikPeaO2B__Usage_Value__c,ChikPeaO2B__Subscription__c from ChikPeaO2B__Usage__c where id =: usgid]){
                
                    system.debug('-----ChikPeaO2B__Usage_Value__c----'+usg.ChikPeaO2B__Usage_Value__c);
                 for(ChikPeaO2B__Subscription__c sub : 
                    [select id,ChikPeaO2B__Recurring_Charge__c from ChikPeaO2B__Subscription__c 
                     where id =: usg.ChikPeaO2B__Subscription__c]){
                         
                         double finalval = sub.ChikPeaO2B__Recurring_Charge__c+usg.ChikPeaO2B__Usage_Value__c;
                         
                         sub.ChikPeaO2B__Recurring_Charge__c = finalval;
                         
                         Sublst.add(sub);
                     }
            }
         Update Sublst;
       
            
        For(ChikPeaO2B__Usage_Staging__c usg : [Select id,Usage_ID__c,ChikPeaO2B__Usage__c,ChikPeaO2B__Status__c 
                   from ChikPeaO2B__Usage_Staging__c where ChikPeaO2B__Status__c ='Processed' and ChikPeaO2B__Usage__c =: usgid]){
               
                    usg.ChikPeaO2B__Status__c= 'Invoiced';
                    stgngslstupdate1.add(usg);
                   }
            Database.update(stgngslstupdate1,false);
        }
          
       }catch(exception e ){
           system.debug('exception = '+e);
           ErrorLogger.log(e, 'TotalusagetoSub');            
        }
        
    }
   
}