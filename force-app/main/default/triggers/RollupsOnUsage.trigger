/*** trigger Name : RollupOnUsage 
 * Created on : 22 Oct,2018 by Godson
 * Version : 1.0
 * Reason : Since the relationship between Usage and Usage_Staging is not master-detail,
 *          This trigger is needed to get the rollup summary of Usage_Staging in the Usage.
 * Pre-works : Created number and currency fields in usage.
 */

trigger RollupsOnUsage on ChikPeaO2B__Usage_Staging__c (after insert,after update,after delete) {
  //To get the rollup of billable, non-billable and billed hours
    if(trigger.isinsert || trigger.isupdate){
        for(ChikPeaO2B__Usage_Staging__c usgst: trigger.new){
            if(trigger.isinsert)
            if(usgst.Usage_ID__c!=null)
            if(usgst.Usage_ID__c=='STARTNOW' && system.isBatch() == false){
                   LinkUsageToStagingv1 LUS = new LinkUsageToStagingv1();
                If(!Test.isRunningTest()){
                    database.executeBatch(LUS,100);                                                   
                }
            }
        }
        list<id> usgid=new list<id>();
        list<ChikPeaO2B__Usage__c> usgListToUpdate=new list<ChikPeaO2B__Usage__c>();
        //loop through all incoming usage staging to get the usage id
        for(ChikPeaO2B__Usage_Staging__c usgst: trigger.new){
            if(usgst.ChikPeaO2B__Usage__c!=null ){
                usgid.add(usgst.ChikPeaO2B__Usage__c);
                system.debug('usage=====>'+usgst.ChikPeaO2B__Usage__c);
            }
        }
        if(usgid.size()>0){
            set<ChikPeaO2B__Usage__c> usgList=new set<ChikPeaO2B__Usage__c>([SELECT id,Total_Billable_Cost__c,Total_Billable_Hours__c,Projected_Hours__c,Total_Non_Billable_Cost__c,Total_Non_Billable_Hours__c,
                                                                             (SELECT id,Cost_Total__c,Billable__c,ChikPeaO2B__Status__c,ChikPeaO2B__Usage_unit__c,Comment__c FROM ChikPeaO2B__Usage_Stagings__r), 
                                                                             (SELECT id,ChikPeaO2B__Total_Usage__c FROM ChikPeaO2B__Usage_Histories__r)
                                                                             FROM ChikPeaO2B__Usage__c WHERE id IN:usgid]);
            
            system.debug('usglist size====>'+usgList.size());
            if(usgList.size()>0){
                decimal BilledHours=0;
                for(ChikPeaO2B__Usage__c usg:usgList){
                    for(ChikPeaO2B__Usage_History__c usghist:usg.ChikPeaO2B__Usage_Histories__r){
                        BilledHours+=usghist.ChikPeaO2B__Total_Usage__c;
                    }
                }
                //loop through usages and its stagings to populate the billable, non-billable and billed hours in the usage
                for(ChikPeaO2B__Usage__c usg:usgList){
                    decimal TotalBillableHours=0;
                    decimal TotalBillableCost=0;
                    decimal TotalNonBillableHours=0;
                    decimal TotalNonBillableCost=0; 
                    for(ChikPeaO2B__Usage_Staging__c usgst:usg.ChikPeaO2B__Usage_Stagings__r){
                        if(usgst.ChikPeaO2B__Usage_unit__c != null){
                            if(usgst.Billable__c==true && usgst.ChikPeaO2B__Status__c=='Processed' ){ 
                            TotalBillableHours+=usgst.ChikPeaO2B__Usage_unit__c;
                            TotalBillableCost+=usgst.Cost_Total__c;
                        }
                        if(usgst.Billable__c!=true ){
                            TotalNonBillableHours+=usgst.ChikPeaO2B__Usage_unit__c;
                            TotalNonBillableCost+=usgst.Cost_Total__c;
                        }
                        }
                    }
                    usg.Total_Billable_Hours__c=TotalBillableHours;
                    usg.Total_Non_Billable_Hours__c=TotalNonBillableHours;
                    usg.Total_Billable_Cost__c=TotalBillableCost;
                    usg.Total_Non_Billable_Cost__c=TotalNonBillableCost;
                    usg.ChikPeaO2B__Total_Usage__c=TotalBillableHours;
                    system.debug('Projected_Hours__c======>'+usg.Projected_Hours__c);
                    if(usg.Projected_Hours__c!=null)
                        usg.ChikPeaO2B__Remaining_Usage__c=usg.Projected_Hours__c-(TotalBillableHours+BilledHours);
                    usgListToUpdate.add(usg);
                }
                if(usgListToUpdate.size()>0){
                    try{
                        update usgListToUpdate;
                    }
                    
                    catch(dmlexception e){
                         /* ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
                BatchLog.ChikPeaO2B__Error_Log__c = 'Exception Type = '+e.getTypeName() +' Time = '+ system.now() + ' The Root Cause of Exception = ' + String.valueOf(e.getCause()) + '\n StackTrace ====> ' + e.getStackTraceString();
                BatchLog.Name = 'convertToMultipleOrderBasedOnProjects';
                insert BatchLog;*/
                        system.debug(e);
                    }
                }
            }
        }
    } 
    //To get the rollup of billable, non-billable and billed hours
    if(trigger.isDelete){
        list<id> usgid=new list<id>();
        list<ChikPeaO2B__Usage__c> usgListToUpdate=new list<ChikPeaO2B__Usage__c>();
        //loop through all incoming usage staging to get the usage id
        for(ChikPeaO2B__Usage_Staging__c usgst: trigger.old){
            if(usgst.ChikPeaO2B__Usage__c!=null ){
                usgid.add(usgst.ChikPeaO2B__Usage__c);
            }
        }
        if(usgid.size()>0){
            set<ChikPeaO2B__Usage__c> usgList=new set<ChikPeaO2B__Usage__c>([SELECT id,Total_Billable_Cost__c,Total_Billable_Hours__c,Projected_Hours__c,Total_Non_Billable_Cost__c,Total_Non_Billable_Hours__c,
                                                                             (SELECT id,Cost_Total__c,Billable__c,ChikPeaO2B__Status__c,ChikPeaO2B__Usage_unit__c,Comment__c FROM ChikPeaO2B__Usage_Stagings__r ), 
                                                                             (SELECT id,ChikPeaO2B__Total_Usage__c FROM ChikPeaO2B__Usage_Histories__r) 
                                                                             FROM ChikPeaO2B__Usage__c WHERE id IN:usgid]);
            if(usgList.size()>0){
                decimal BilledHours=0;
                for(ChikPeaO2B__Usage__c usg:usgList){
                    for(ChikPeaO2B__Usage_History__c usghist:usg.ChikPeaO2B__Usage_Histories__r){
                        BilledHours+=usghist.ChikPeaO2B__Total_Usage__c;
                    }
                }
                //loop through usages and its stagings to populate the billable, non-billable and billed hours in the usage
                for(ChikPeaO2B__Usage__c usg:usgList){
                    decimal TotalBillableHours=0;
                    decimal TotalBillableCost=0;
                    decimal TotalNonBillableHours=0;
                    decimal TotalNonBillableCost=0; 
                    for(ChikPeaO2B__Usage_Staging__c usgst:usg.ChikPeaO2B__Usage_Stagings__r){
                        if(usgst.Billable__c==true && usgst.ChikPeaO2B__Status__c=='Processed'){ 
                            TotalBillableHours+=usgst.ChikPeaO2B__Usage_unit__c;
                            TotalBillableCost+=usgst.Cost_Total__c;
                        }
                        if(usgst.Billable__c!=true ){
                            TotalNonBillableHours+=usgst.ChikPeaO2B__Usage_unit__c;
                            TotalNonBillableCost+=usgst.Cost_Total__c;
                        }
                    }
                    usg.Total_Billable_Hours__c=TotalBillableHours;
                    usg.Total_Non_Billable_Hours__c=TotalNonBillableHours;
                    usg.Total_Billable_Cost__c=TotalBillableCost;
                    usg.Total_Non_Billable_Cost__c=TotalNonBillableCost;
                    usg.ChikPeaO2B__Total_Usage__c=TotalBillableHours;
                   system.debug('Projected_Hours__c======>'+usg.Projected_Hours__c);
                    if(usg.Projected_Hours__c!=null)
                    usg.ChikPeaO2B__Remaining_Usage__c=usg.Projected_Hours__c-(TotalBillableHours+BilledHours);
                    usgListToUpdate.add(usg);
                }
                if(usgListToUpdate.size()>0){
                    try{
                        update usgListToUpdate;
                    }catch(dmlexception e){
                          ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
                BatchLog.ChikPeaO2B__Error_Log__c = 'Exception Type = '+e.getTypeName() +' Time = '+ system.now() + ' The Root Cause of Exception = ' + String.valueOf(e.getCause()) + '\n StackTrace ====> ' + e.getStackTraceString();
                BatchLog.Name = 'convertToMultipleOrderBasedOnProjects';
                insert BatchLog;
                        system.debug(e);
                    }
                }
            }
        }
    } 

}