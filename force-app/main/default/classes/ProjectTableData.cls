public class ProjectTableData {
    @AuraEnabled
    public static List<ChikPeaSSB__Project_Phase__c> ShowPhase(String recordId){
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select  Name,(select Name From ChikPeaSSB__Resources__r) 
                                                    from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: recordId];
        return Phase;
    } 
        
    @AuraEnabled
    public static list<ChikPeaSSB__Resource__c> getResc(String recordId){ 
        
        List<ChikPeaSSB__Resource__c> Res = [Select id,Name,ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c,ChikPeaSSB__Res_Num__c,ChikPeaSSB__Item__r.Name from ChikPeaSSB__Resource__c
                                 where ChikPeaSSB__Phase__c =: recordId Order by CreatedDate];
        
        return Res;
    }
    
    //For staffing
   @AuraEnabled
    public static list<ChikPeaSSB__Resource__c> ToSendInvite(String Resid){ 
        
        List<ChikPeaSSB__Resource__c> Res = [Select id,Name,ChikPeaSSB__Invite_Sent__c,ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c,ChikPeaSSB__Res_Num__c,ChikPeaSSB__Item__r.Name from ChikPeaSSB__Resource__c
                                 where id =: Resid];
        Res[0].ChikPeaSSB__Invite_Sent__c = True;
        
        ////Update Res;
        return Res;
    }
    
     @AuraEnabled
    public static list<ChikPeaSSB__Resource__c> OnChangeStaff(String recordId,string Seltdstaff){ 
       system.debug('Seltdstaff'+Seltdstaff);
        
        List<ChikPeaSSB__Resource__c> Res = [Select id,Name,ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c,ChikPeaSSB__Staff__c,ChikPeaSSB__Res_Num__c,ChikPeaSSB__Item__r.Name from ChikPeaSSB__Resource__c
                                 where id =: recordId];
        
         if(Seltdstaff != Null && Seltdstaff != 'None'){
              system.debug('comes in if');
        List<ChikPeaSSB__Staffing__c> Stafflist = [Select id,Name from ChikPeaSSB__Staffing__c
                                 where Name =: Seltdstaff];
             Id OldStafId;
             Id NewStafId;
             if(!String.isBlank(Res[0].ChikPeaSSB__Staff__c)){
                OldStafId = Res[0].ChikPeaSSB__Staff__c;
                 if(Seltdstaff != null && Seltdstaff !='None'){
                     NewStafId = Stafflist[0].id;
                 }
                 else{
                    NewStafId = null; 
                 }
             	
             }
             else{
                OldStafId = null;
                 if(Seltdstaff != null && Seltdstaff !='None'){
                     NewStafId = Stafflist[0].id;
                 }
                 else{
                    NewStafId = null; 
                 }
                 
             }
      			
             
             ResourceInStaff.ResourceStaffMapping(OldStafId, NewStafId);
             
            Res[0].ChikPeaSSB__Staff__c = Stafflist[0].id;
         }
        else if(Seltdstaff == 'None'){
            system.debug('comes in else');
            ID Emptystaffid = Null;
          
           Res[0].ChikPeaSSB__Staff__c = Emptystaffid; 
        }
        
         Update Res;
        return Res;
    }
    
      
   @AuraEnabled
    public static list<ChikPeaSSB__Staffing__c> getRescStaffing(){ 
        
        List<ChikPeaSSB__Staffing__c> Res = [ select id,Name,ChikPeaSSB__Staff_Roles__c from ChikPeaSSB__Staffing__c];
        
        return Res;
    }
   
    
    @AuraEnabled
    public static list<ChikPeaSSB__Resource__c> UpdateResc(String recordId, Double EstEfforts, Double EstHrs){ 
        
        List<Resource__c> Res = [Select id,Name,ChikPeaSSB__Estimated_Hours__c,ChikPeaSSB__Estimated_Efforts__c,ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c
                                 from ChikPeaSSB__Resource__c where id =: recordId];
        
       // System.debug('EstEfforts ='+EstEfforts);
        //System.debug('EstHrs ='+EstHrs);
        if(Res.size() > 0 ){
            
            if(EstEfforts == Null){
                
                Res[0].ChikPeaSSB__Estimated_Hours__c = EstHrs;
                update Res;
            }else if(EstHrs == Null){
                
                if(EstEfforts != null){
                
                double Estcalc = ((Res[0].ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c * 40 ) * EstEfforts )/100 ;
                  Res[0].ChikPeaSSB__Estimated_Efforts__c = Estcalc; 
                }
                update Res;
            } 
            
        }
        return Res;
    }
    
    @AuraEnabled
    public static List<ChikPeaSSB__Resource__c> DeleteRes(ID Phaseid){ 
        
        List<ChikPeaSSB__Resource__c> Res = [Select id,Name,ChikPeaSSB__Phase__c,ChikPeaSSB__Actual_Cost__c,ChikPeaSSB__Res_Num__c 
                                             from ChikPeaSSB__Resource__c where id =: Phaseid];
        
        Double num = Res[0].ChikPeaSSB__Res_Num__c;
        
       // system.debug('Res = '+Res);
    		
        if(Res.size() > 0){
            IF(num != NULL){
           ArrngResNum(Res[0].ChikPeaSSB__Phase__c,num);
            }
            delete Res;
        }
           return Res; 
    }
    
     public static void ArrngResNum(ID Phaseid,Double ResNum){ 
    
        List<ChikPeaSSB__Resource__c> Reslist = [Select id,ChikPeaSSB__Res_Num__c 
                                                 from ChikPeaSSB__Resource__c where ChikPeaSSB__Phase__c =: Phaseid and ChikPeaSSB__Res_Num__c > :ResNum 
                                                 order by ChikPeaSSB__Res_Num__c];
        List<ChikPeaSSB__Resource__c> Reslistupd = New List<ChikPeaSSB__Resource__c>();
        if(Reslist.size() > 0){
        for(ChikPeaSSB__Resource__c  res : Reslist){
            // system.debug('Res Bfr= '+res.Res_Num__c);
            res.ChikPeaSSB__Res_Num__c = res.ChikPeaSSB__Res_Num__c - 1;
            system.debug('Res Af= '+res.ChikPeaSSB__Res_Num__c);
            Reslistupd.add(res);
        }
    Update Reslistupd;
    }
    }
    
     @AuraEnabled
    public static Boolean DeleteResValdiation(ID Phaseid){ 
        system.debug('Phaseid'+Phaseid);
        Boolean Valcheck;
        
        List<ChikPeaSSB__Resource__c> Res = [Select id,ChikPeaSSB__Actual_Cost__c from ChikPeaSSB__Resource__c where id =: Phaseid];
        system.debug('Res = '+Res);
        
        if(Res[0].ChikPeaSSB__Actual_Cost__c == 0 || Res[0].ChikPeaSSB__Actual_Cost__c == null){
            Valcheck = true;
            return Valcheck; 
             // Resource will be deleted.
        }else{
            Valcheck = false;
            return  Valcheck;
             
        }
        
    }
    
    @AuraEnabled
    public static List<Resource_Staging__c> getStagings (String recordId) {  
        
        List<Resource_Staging__c> Prj = [SELECT Id,Name,ChikPeaSSB__Actual_Hours__c,ChikPeaSSB__Billable_Hours__c,ChikPeaSSB__Post__c,ChikPeaSSB__Date__c,ChikPeaSSB__Resource__r.Name
                                         FROM ChikPeaSSB__Resource_Staging__c WHERE ChikPeaSSB__Resource__c=: recordId];
        update prj;
        return Prj;
    }
      
     @AuraEnabled
    public static List<ChikPeaSSB__Resource_Staging__c> updateStagingsApx (List<ChikPeaSSB__Resource_Staging__c> updatedSatgings) {  
        
        
          system.debug('updatedSatgings = ' +updatedSatgings);
            update updatedSatgings;  
             return updatedSatgings;  
              
         
            
    }    
    
       @AuraEnabled
    public static List<ChikPeaSSB__Chikpea_Project__c> IsAuditDisableBillable (String recordId) {
        
         system.debug('recordId = '+recordId);
       /*  list<Resource__c> phid = [Select id,Phase__c from Resource__c where id =: recordId];
        
         system.debug('phid = '+phid);*/
        list<ChikPeaSSB__Project_Phase__c> Prjid = [Select id,ChikPeaSSB__Project__c from ChikPeaSSB__Project_Phase__c where id =: recordId];
        
        system.debug('Prjid = '+Prjid);
        
        id prj = Prjid[0].ChikPeaSSB__Project__c;
        
        //System.debug('Prjid[0].Project__c = '+prj);        
        list<ChikPeaSSB__Chikpea_Project__c> Isaudit = [Select id,ChikPeaSSB__Is_Audit__c from ChikPeaSSB__Chikpea_Project__c where id =: prj];
        
        return Isaudit;
        
    }
    //*************************************************************************************************************************************
    //This method is used on phase detail page to display the list of staff  matches the resource role //
  
     @AuraEnabled
    public static list<ChikPeaSSB__Staffing__c> getStaffRole(String recordId , String ResId){ 
        
        List<ChikPeaSSB__Resource__c> Resource = [Select id, Name,ChikPeaSSB__Item__c,ChikPeaSSB__Item__r.Name
                                        from ChikPeaSSB__Resource__c where id =: ResId];
        String ResourceRoleName = Resource[0].ChikPeaSSB__Item__r.Name;
        system.debug('ResourceRoleName---'+ResourceRoleName);
        List<ChikPeaSSB__Staffing__c> Staff = [Select id,Name,ChikPeaSSB__Staff_Roles__c from ChikPeaSSB__Staffing__c where ChikPeaSSB__Current_Status__c != 'Working'];
        List<ChikPeaSSB__Staffing__c> stafffnlist = New List<ChikPeaSSB__Staffing__c>();
       for(ChikPeaSSB__Staffing__c stafflst : Staff){
            if(stafflst.ChikPeaSSB__Staff_Roles__c.contains(ResourceRoleName)){
                stafffnlist.add(stafflst);
            }
        }
       // Phase.add('Null');
        system.debug('Matached list'+stafffnlist);
        return stafffnlist;
    }
    //***************************************************************************************************************************************
 }