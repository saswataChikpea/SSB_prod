trigger AgileWeeksUpdate on Project_Phase__c (Before Update, After Update, Before Insert, After Insert){
             
    list<ChikPeaSSB__Resource__c> UpdateRes =New List<ChikPeaSSB__Resource__c>();
    list<ChikPeaO2B__Subscription__c> subdate = New List<ChikPeaO2B__Subscription__c>();
    List<ChikPeaSSB__Project_Phase__c> phselst = new List<ChikPeaSSB__Project_Phase__c>();
    List<ChikPeaSSB__Project_Phase__c> phselst1 = new List<ChikPeaSSB__Project_Phase__c>();
    
 
    for (Project_Phase__c Phase : trigger.new)
    { 
        //Commented on 1-Apr-22 as Estimated_Hours__c is a Roll-Up Summary field 
        // if(Trigger.isAfter && Trigger.isUpdate && Phase.Weeks__c != null && Phase.Weeks__c != trigger.oldMap.get(Phase.Id).Weeks__c){
       
        //     for(Resource__c Res : [Select id,Name,Estimated_Efforts__c,Estimated_Hours__c from Resource__c where Phase__c =: Phase.Id]){
                
        //       double Estcalc  = ((Phase.Weeks__c * 40 ) * Res.Estimated_Efforts__c )/100 ;
                
        //         Res.Estimated_Hours__c = Estcalc;
        //         UpdateRes.add(Res);
        //     }
        //     update UpdateRes;
        // }
        
        //Phase name Duplicate 
        if(Trigger.isbefore && Trigger.isUpdate && Phase.Name != trigger.oldMap.get(Phase.Id).Name){
          
                Boolean checkPhName = false;
                list<Project_Phase__c> phaselist = [select id,Name from Project_Phase__c where Project__c =: Phase.Project__c];
                for(Project_Phase__c Phnames : phaselist){
                    If(Phase.Name ==  Phnames.Name){
                        checkPhName = true;
                    }
                }
                if(checkPhName){
                    Phase.addError( 'Phase name already exist');
                } 
        }
        
     
        //To Update the date in subscbtion for Milestone billing 
        if(Trigger.isbefore && Trigger.isUpdate && Phase.Billing_Frequency__c == 'Milestone'
           && Phase.Status__c != trigger.oldMap.get(Phase.Id).Status__c && Phase.Status__c == 'Closed'){
               
               for(Resource__c ResName : [Select id,Name from Resource__c where Phase__c =: Phase.id]){
                   //system.debug('ResName = '+ResName.Name);
                   for(ChikPeaO2B__Subscription__c sub : [Select id,ChikPeaO2B__Next_Bill_Date__c from ChikPeaO2B__Subscription__c where Resource__c =: ResName.Name]){
                       
                       sub.ChikPeaO2B__Next_Bill_Date__c = system.today();
                       subdate.add(sub);
                   }
               }
               update subdate;
               
           }
        
       //SSB Est End date calculation
       
       If(Trigger.IsInsert && Trigger.isbefore || Trigger.IsUpdate && Trigger.isbefore){
            
           try{
               
            if(Phase.ChikPeaSSB__Est_Start_date__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Est_Start_date__c ||
                Phase.ChikPeaSSB__Est_time_of_Completion__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Est_time_of_Completion__c 
               || Phase.ChikPeaSSB__Dependencies__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Dependencies__c){
                   
                   Date stdate = Phase.ChikPeaSSB__Est_Start_date__c;
                   
                   Integer hrs = 0;
                   if(Phase.ChikPeaSSB__Est_time_of_Completion__c.intValue() > 0){
                        hrs = Phase.ChikPeaSSB__Est_time_of_Completion__c.intValue(); 
                   }
                  //Businesshours Bhrs = [select id,name from Businesshours];
                   
                    System.debug('hrs : ' + hrs);
                   if(hrs > 0){
                       
                       Integer Noofday = hrs/8 ;
                       Integer Remindr = math.mod(hrs,8); 
                       system.debug('Remindr ='+Remindr);
                       
                       //Working day calculation
                       integer i = 0;
                       Integer weekdays = 0;
                       while (weekdays < Noofday) {
                           Date dt = stdate + i;  
                           DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                           String todayDay = currDate.format('EEEE');  
                           if(todayDay != 'Saturday' && todayDay !='Sunday')  
                           {  
                               weekdays = weekdays + 1;
                           }     
                           i++;
                       }
                       system.debug('i = '+i);
                       system.debug('weekdays ='+weekdays);
                       system.debug('Noofday ='+Noofday);
                       
                       if(Remindr == 0){
                           Noofday = i - 1;
                           //Noofday =   Noofday;
                           Phase.ChikPeaSSB__Est_End_Date__c = stdate.addDays(Noofday);
                       }else{
                           //need to check this
                           Noofday = i;
                          
                           Phase.ChikPeaSSB__Est_End_Date__c = stdate.addDays(Noofday);
                           date tocheck = Phase.ChikPeaSSB__Est_End_Date__c;
                       }  
                   }
                   Datetime dt = DateTime.newInstance(stdate, Time.newInstance(0, 0, 0, 0));
                   String dayOfWeek=dt.format('EEEE');
                   
                   Integer pnum = Phase.ChikPeaSSB__Phase_Num__c.intValue() + 1;
                   
                   phselst = [Select id,Name,ChikPeaSSB__Dependencies__c,ChikPeaSSB__Est_Start_date__c,ChikPeaSSB__Est_End_Date__c,ChikPeaSSB__Phase_Num__c,
                              ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c,ChikPeaSSB__Project__r.ChikPeaSSB__Sum_of_Phase__c 
                                  from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Phase_Num__c =: pnum and ChikPeaSSB__Project__c =: Phase.ChikPeaSSB__Project__c];
                 
                    if(phselst.size() > 0){
                        
                        Integer Noofphase = phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__Sum_of_Phase__c.intValue();
                        for(ChikPeaSSB__Project_Phase__c phs : phselst){
                        if(Noofphase == phs.ChikPeaSSB__Phase_Num__c){
                        //system.debug('before = '+ phs.Project__r.End_Date__c );
                            phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c = Phase.ChikPeaSSB__Est_End_Date__c;
                           
                            DateTime dat = phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c;
                            String dayOfWeek1 = dat.format('EEEE');
                            system.debug('dayOfWeek1 ='+dayOfWeek1);
                             //system.debug('After = '+ phselst[0].Project__r.End_Date__c);
                       }
                    }
                        Integer hrs1 = Phase.ChikPeaSSB__Est_time_of_Completion__c.intValue();
                        Integer Noofday = hrs1/8 ;
                        Integer Remindr = math.mod(hrs1,8); 
                        system.debug('Remindr ='+Remindr);
                        if(Remindr == 0){
                        phselst[0].ChikPeaSSB__Est_Start_date__c = Phase.ChikPeaSSB__Est_End_Date__c + 1;

                        }else{
                            phselst[0].ChikPeaSSB__Est_Start_date__c = Phase.ChikPeaSSB__Est_End_Date__c;
                        }
                    }
            }
             update phselst;
           }catch(Exception e ){
              System.debug('Exception = '+e);
          }
              
        } 
     
        
         //Virtuzzo Est End date calculation
     /*  If(Trigger.IsInsert && Trigger.isbefore || Trigger.IsUpdate && Trigger.isbefore){
            
           try{
               
            if(Phase.ChikPeaSSB__Est_Start_date__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Est_Start_date__c ||
                Phase.ChikPeaSSB__Contract_Month__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Contract_Month__c 
               || Phase.ChikPeaSSB__Dependencies__c != trigger.oldMap.get(Phase.Id).ChikPeaSSB__Dependencies__c){
                   
                   Date stdate = Phase.ChikPeaSSB__Est_Start_date__c;
                   
                   Integer Months = 0;
                   if(integer.valueof(Phase.ChikPeaSSB__Contract_Month__c) > 0){
                        Months = integer.valueof(Phase.ChikPeaSSB__Contract_Month__c); 
                       
                   }
                 system.debug('Phase.ChikPeaSSB__Est_End_Date__c old= '+Phase.ChikPeaSSB__Est_End_Date__c);

                   if(Months > 0){
                        Phase.ChikPeaSSB__Est_End_Date__c = stdate.addMonths(Months);
                       system.debug('Phase.ChikPeaSSB__Est_End_Date__c new= '+Phase.ChikPeaSSB__Est_End_Date__c);
                      
                   }
                   Datetime dt = DateTime.newInstance(stdate, Time.newInstance(0, 0, 0, 0));
                   String dayOfWeek=dt.format('EEEE');
                   
                   
                   Integer pnum = Phase.ChikPeaSSB__Phase_Num__c.intValue() + 1;
                   
                   
                   phselst = [Select id,Name,ChikPeaSSB__Dependencies__c,ChikPeaSSB__Est_Start_date__c,ChikPeaSSB__Est_End_Date__c,ChikPeaSSB__Phase_Num__c,
                              ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c,ChikPeaSSB__Project__r.ChikPeaSSB__Sum_of_Phase__c 
                                  from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Phase_Num__c =: pnum and ChikPeaSSB__Project__c =: Phase.ChikPeaSSB__Project__c];
                  
                    if(phselst.size() > 0){
                        
                        Integer Noofphase = phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__Sum_of_Phase__c.intValue();
                        for(ChikPeaSSB__Project_Phase__c phs : phselst){
                        if(Noofphase == phs.ChikPeaSSB__Phase_Num__c){
                        //system.debug('before = '+ phs.Project__r.End_Date__c );
                            phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c = Phase.ChikPeaSSB__Est_End_Date__c;
                           
                            DateTime dat = phselst[0].ChikPeaSSB__Project__r.ChikPeaSSB__End_Date__c;
                            String dayOfWeek1 = dat.format('EEEE');
                            system.debug('dayOfWeek1 ='+dayOfWeek1);
                             //system.debug('After = '+ phselst[0].Project__r.End_Date__c);
                       }
                    } 
                    }
              
            }
             update phselst;
           }catch(Exception e ){
              System.debug('Exception = '+e);
          }
              
        } */
    }
}