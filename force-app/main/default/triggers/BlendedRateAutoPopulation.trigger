trigger BlendedRateAutoPopulation on Project_Phase__c (Before insert,Before update) {
    
    system.debug('fire1' );
  
  /*    List<Project_Phase__c> OldPhase = [select Id,Is_Blended_Rate__c,Blended_Rate__c from Project_Phase__c where id =: Trigger.old];
    
    
    List<Project_Phase__c> Phase = [select Id,Name,Project__c,Status__c,Is_Blended_Rate__c,Blended_Rate__c,(Select id,Rate__c,Rate_Plan__r.ChikPeaO2B__Usage_Rate__c,Rate_Plan__r.Old_Usage_Rate__c from Resources__r) 
                                    from Project_Phase__c where id =: Trigger.new];
    
    List<ChikPeaO2B__Rate_Plan__c> UpdateOldRate = New List<ChikPeaO2B__Rate_Plan__c>();
    List<ChikPeaO2B__Rate_Plan__c> UpdateOldRate1 = New List<ChikPeaO2B__Rate_Plan__c>();
    List<ChikPeaO2B__Rate_Plan__c> UpdateOldRate2 = New List<ChikPeaO2B__Rate_Plan__c>();
    List<ChikPeaO2B__Rate_Plan__c> UpdateRatePln = New List<ChikPeaO2B__Rate_Plan__c>();
    List<Project_Phase__c> UpdateUnCheckZero = New List<Project_Phase__c>();
    
    try{
        BlendedRateCls.isBldrate = False;
        
        For(integer i = 0 ; i< Trigger.new.size() ;i++)
        {
            if(Trigger.old[i].Is_Blended_Rate__c == false && Trigger.New[i].Is_Blended_Rate__c == True){
                //() || (Trigger.isInsert == true && Phase[0].Is_Blended_Rate__c == True)
                System.debug('Logic 1 ');
                
                for(Project_Phase__c Phs : Phase){
                    For(Resource__c res :Phs.Resources__r ){
                        
                        res.Rate_Plan__r.ChikPeaO2B__Usage_Rate__c = Phs.Blended_Rate__c;
                        
                        UpdateOldRate2.add(res.Rate_Plan__r);
                        system.debug('res.id = '+res.id);
                    }
                }
                update UpdateOldRate2;
            }
            else if(Trigger.isupdate && Trigger.New[i].Is_Blended_Rate__c == False)
            {
                System.debug('Logic 2 ');
                //  for(Project_Phase__c Phs : Phase){
                For(Resource__c res :Phase[0].Resources__r ){
                    
                    System.debug('Rate value = '+res.Rate_Plan__r.ChikPeaO2B__Usage_Rate__c);
                    
                    res.Rate_Plan__r.ChikPeaO2B__Usage_Rate__c = res.Rate_Plan__r.Old_Usage_Rate__c ;
                    System.debug('Old Rate value = '+res.Rate_Plan__r.Old_Usage_Rate__c);
                    UpdateRatePln.add(res.Rate_Plan__r);
                }
                //}
                
                update UpdateRatePln;
                
             /*   for(Project_Phase__c Phs : Phase){
                    Phs.Blended_Rate__c = 0.0;
                    UpdateUnCheckZero.add(Phs);
                }
                update UpdateUnCheckZero;
*/

/*              }
            //If both Old and new value is true for Is Blended rate
          else if(Trigger.old[i].Is_Blended_Rate__c == true && Trigger.new[i].Is_Blended_Rate__c == True){
                system.debug('Both old and new value is true');
                
                for(Project_Phase__c Phs : Phase){
                    For(Resource__c res :Phs.Resources__r ){
                        
                        res.Rate_Plan__r.ChikPeaO2B__Usage_Rate__c = Phs.Blended_Rate__c;
                        
                        UpdateOldRate2.add(res.Rate_Plan__r);
                        system.debug('res.id = '+res.id);
                    }
                }
                update UpdateOldRate1;
            }
        }
        
    }Catch(Exception e){
        System.debug('Exception = '+e);
    }  */

}