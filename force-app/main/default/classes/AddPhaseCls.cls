public class AddPhaseCls {
    
     @AuraEnabled
     public static List<ChikPeaSSB__Chikpea_Project__c> getPrjdetails (Id recordId) {  
        
        List<Chikpea_Project__c> Prj = [SELECT ChikPeaSSB__Target_Price__c,ChikPeaSSB__Target_Profit__c,ChikPeaSSB__Estimated_Cost__c,ChikPeaSSB__Estimated_Rate__c,ChikPeaSSB__Project_Model__c,ChikPeaSSB__Quote__c 
                                        FROM ChikPeaSSB__Chikpea_Project__c WHERE id=:recordId];
        
        return Prj; 
    } 
    
     @AuraEnabled
    public static list<ChikPeaSSB__Project_Phase__c> getPhaseDepVal(String recordId , String phaseid){ 
        
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select id, Name
                                        from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: recordId and id != : phaseid 
                                        Order by CreatedDate];
       // Phase.add('Null');
        
        return Phase;
    }

    @AuraEnabled
    public static list<ChikPeaSSB__Project_Phase__c> getPhaselist(String recordId){ 
        
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select id, Name,ChikPeaSSB__Project__r.ChikPeaSSB__Project_Model__c,
                ChikPeaSSB__Status__c,ChikPeaSSB__Estimated_Cost__c, ChikPeaSSB__Dependencies__c,
                ChikPeaSSB__Estimated_Rate__c,ChikPeaSSB__Estimated_Hours__c,ChikPeaSSB__Phase_Profit__c,
                ChikPeaSSB__Descriptions__c,ChikPeaSSB__Phase_Num__c
                from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: recordId 
                Order by ChikPeaSSB__Phase_Num__c ];
                        // from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: recordId];

        return Phase;
    }
    
     @AuraEnabled
    public static Boolean DeletephaseValidation(ID Phaseid){ 
          Boolean Valcheck;
        
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select ChikPeaSSB__Estimated_Hours__c from ChikPeaSSB__Project_Phase__c where id =: Phaseid];
        system.debug('Phase = '+Phase);
        
        
        if(Phase[0].ChikPeaSSB__Estimated_Hours__c == 0 || Phase[0].ChikPeaSSB__Estimated_Hours__c == null){
            Valcheck = true;
            return Valcheck; 
             // Phase will be deleted.
        }else{
            Valcheck = false;
            return  Valcheck;
             
        }
    }
    
     @AuraEnabled
    public static list<ChikPeaSSB__Project_Phase__c> Deletephase(ID Phaseid){ 
        try{ 
            List<ChikPeaSSB__Project_Phase__c> Phase = [Select id, Name,ChikPeaSSB__Phase_Num__c,ChikPeaSSB__Project__c,ChikPeaSSB__Dependencies__c,
                                                        (Select id From ChikPeaSSB__Resources__r) from ChikPeaSSB__Project_Phase__c where id =: Phaseid];
            system.debug('Phase = '+Phase);
            
            if(Phase[0].ChikPeaSSB__Dependencies__c != Null || Phase[0].ChikPeaSSB__Dependencies__c != ''){
                changedependency(Phase[0].ChikPeaSSB__Project__c,Phase[0].Name,Phase[0].ChikPeaSSB__Dependencies__c);
            }
            List<ChikPeaSSB__Project_Phase__c> PhaseNumchange = [Select id, Name,ChikPeaSSB__Phase_Num__c 
                                                                 from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: Phase[0].ChikPeaSSB__Project__c and ChikPeaSSB__Phase_Num__c >: Phase[0].ChikPeaSSB__Phase_Num__c];
            
            List<ChikPeaSSB__Project_Phase__c> Pnumer = New list<ChikPeaSSB__Project_Phase__c>();
            
            for(ChikPeaSSB__Project_Phase__c pnum : PhaseNumchange){
                
                pnum.ChikPeaSSB__Phase_Num__c =   pnum.ChikPeaSSB__Phase_Num__c - 1;
                
                Pnumer.add(pnum);
            }
            
            update Pnumer;
            delete Phase;
            return Phase;
        }catch(Exception e){
            system.debug('Exception  = '+e);
            ErrorLogger.log(e, 'AddPhaseCls');            

        }
        return null;
        
    }
     public static void changedependency(ID PrjId, String PhName, String Depndency){
         
         List<ChikPeaSSB__Project_Phase__c> phseId = [Select Id,Name from ChikPeaSSB__Project_Phase__c 
                                                    where ChikPeaSSB__Project__c =: PrjId and ChikPeaSSB__Dependencies__c =: PhName];
         
         for(ChikPeaSSB__Project_Phase__c PhaseId : phseId){
             
             OnChangePhaseDepent(PhaseId.id,Depndency);
         }
     }
    
    
     @AuraEnabled
    public static Boolean PhaseNameValidation(String recoId, String AName){
            
        Boolean Valcheck;
        
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select  Name from ChikPeaSSB__Project_Phase__c 
                                                    where ChikPeaSSB__Project__c =: recoId and Name =: AName];
        
        system.debug('Phase'+Phase);
        if(Phase.size() > 0){
            Valcheck = true;
            return Valcheck; 
             // Resource will be deleted.
        }else{
            Valcheck = false;
            return  Valcheck;
             
        }
        
    }
    
     @AuraEnabled
    public static ChikPeaSSB__Project_Phase__c InsertPhaseFn(String recoId, String AName , 
                                                             String ADescription,Integer Aweek,boolean ABlendedcheckbox, Double ABRate) {  
       
         
        
        try{
           List<ChikPeaSSB__Chikpea_Project__c> Phasetotal = [Select id,Name,ChikPeaSSB__Sum_of_Phase__c,
           ChikPeaSSB__Est_Start_Date__c, (Select Id, Name from ChikPeaSSB__Project_Phases__r) 
           from ChikPeaSSB__Chikpea_Project__c where id=: recoId];
        
            ChikPeaSSB__Project_Phase__c phase = new ChikPeaSSB__Project_Phase__c();
            phase.ChikPeaSSB__Project__c = recoId;
            phase.Name = AName;
            if(Aweek == null){
                phase.ChikPeaSSB__Weeks__c = null;
            }else{
                phase.ChikPeaSSB__Weeks__c = Aweek;
            }
            phase.ChikPeaSSB__Descriptions__c = ADescription;
            phase.ChikPeaSSB__Is_Blended_Rate__c =  ABlendedcheckbox;
            phase.ChikPeaSSB__Blended_Rate__c =   ABRate;
            phase.ChikPeaSSB__Phase_Num__c = Phasetotal[0].ChikPeaSSB__Sum_of_Phase__c + 1;
            if(Phasetotal[0].ChikPeaSSB__Project_Phases__r.size() == 0){
                phase.ChikPeaSSB__Est_Start_Date__c = Phasetotal[0].ChikPeaSSB__Est_Start_Date__c;
            } 
            system.debug('phase==> '+phase);
            Insert phase;
            return phase;
            
        }catch(Exception e){
              system.debug('Exception  = '+e);
            ErrorLogger.log(e, 'AddPhaseCls');            

        }
         return null;
       
    }
    
     @AuraEnabled
    public static list<ChikPeaSSB__Project_Phase__c> OnChangePhaseDepent(String recordId,String SeltdPh){ 
        
        
       // system.debug('In APex class');
        List<ChikPeaSSB__Project_Phase__c> Phase = [Select id, Name,ChikPeaSSB__Project__c,ChikPeaSSB__Project__r.ChikPeaSSB__Est_Start_Date__c,ChikPeaSSB__Status__c,
                                                    ChikPeaSSB__Phase_Num__c,ChikPeaSSB__Dependencies__c,ChikPeaSSB__Est_Start_date__c
                                        from ChikPeaSSB__Project_Phase__c where id =: recordId ];
        
        System.debug('SeltdPh = '+SeltdPh);
        if(SeltdPh == Null || SeltdPh == '' || SeltdPh == 'Independent'){
            Phase[0].ChikPeaSSB__Dependencies__c = 'Independent';
            Phase[0].ChikPeaSSB__Est_Start_date__c = Phase[0].ChikPeaSSB__Project__r.ChikPeaSSB__Est_Start_Date__c;
        }else{
            Phase[0].ChikPeaSSB__Dependencies__c = SeltdPh;
            
            List<ChikPeaSSB__Project_Phase__c> Phase1 = [Select id, Name, ChikPeaSSB__Phase_Num__c,ChikPeaSSB__Dependencies__c,ChikPeaSSB__Est_End_Date__c
                                                         from ChikPeaSSB__Project_Phase__c where ChikPeaSSB__Project__c =: Phase[0].ChikPeaSSB__Project__c and Name =: SeltdPh];
            if(Phase1.size() > 0){                                                         
                if(Phase1[0].ChikPeaSSB__Est_End_Date__c != null){
                    Phase[0].ChikPeaSSB__Est_Start_date__c = Phase1[0].ChikPeaSSB__Est_End_Date__c;
                }else{
                    //Phase[0].ChikPeaSSB__Dependencies__c.addError(Phase1[0].Name +' needs to have a Est End Date');
                    throw new AuraHandledException(Phase1[0].Name +' phase needs to have an Est End Date');
                }
            }
        }
        
        
        
       if(Phase.size() > 0 )
       Update Phase;
        
        return Phase;
    }
    
}