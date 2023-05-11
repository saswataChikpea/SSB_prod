public class PostToUsgStagings{
    
    @AuraEnabled
    public static string ResStaging(Id Recid){
        
        String Error;
          system.debug('Inside the method');
        List<Resource_Staging__c> Resstagings = new List<Resource_Staging__c>();
        List<id> ResQl = new List<id>();
        
         List<ChikPeaO2B__Usage_Staging__c> UploadStg = new List<ChikPeaO2B__Usage_Staging__c>();
        List<Resource_Staging__c> updateRestg = new List<Resource_Staging__c>();
        
        Map<id,List<Resource_Staging__c>> Resourcemap = new Map<id,List<Resource_Staging__c>>();
        
        try{
        for(Resource__c res : [SELECT id from Resource__c where Phase__c =: Recid]){
            for(Resource_Staging__c resstg : [SELECT id,Resource__c,Billable_Hours__c,Date__c,Post__c,Resource__r.Phase__r.Name from Resource_Staging__c where Resource__c =: res.Id and Post__c = false]){
                
                Resstagings.add(resstg); 
                system.debug('Resstagings ='+Resstagings);
            }
            
            If(Resstagings.size() > 0){
                
                Resourcemap.put(res.id,Resstagings);
            }
            
            Resstagings = new List<Resource_Staging__c>();
            ResQl.add(res.id);
            
        }
       system.debug('Resourcemap ='+Resourcemap);
            if(Resourcemap.isEmpty())
            {
                          
                Error = 'Please make sure that the Phase has unposted Resource stagings.';
                system.debug('Error ='+Error);

            }
        
        for(ChikPeaO2B__Quote_Line__c ql : [Select id,Resource__c from ChikPeaO2B__Quote_Line__c where Resource__c =: ResQl 
                                            and ChikPeaO2B__Quote__r.ChikPeaO2B__Status__c = 'Accepted']){
                                                
                                                if (Resourcemap.containsKey(ql.Resource__c)){
                                                    
                                                   system.debug('If ' +ql.Resource__c);         
         for(ChikPeaO2B__Order_Line__c ol : [Select id,(Select id from ChikPeaO2B__Usages__r) from ChikPeaO2B__Order_Line__c where ChikPeaO2B__Quote_Line__c =: ql.id 
                                                                                        and ChikPeaO2B__Order__r.ChikPeaO2B__Status__c = 'In Process']){
                                                                                            
          for(ChikPeaO2B__Usage__c usg : ol.ChikPeaO2B__Usages__r){    
                                                                                                
                                                                                                system.debug('ol.ChikPeaO2B__Usages__r.id =  '+usg.id );    
                                                                                                
                                                                                                for (id Mapid : Resourcemap.keySet()){
                                                                                               for (Resource_Staging__c collection : Resourcemap.get(Mapid)){
                                                                                                
                                                                                                   if(Mapid == ql.Resource__c){
                                                                                                  system.debug('collection =  '+collection );
                                                                                                      
                                                                                                       ChikPeaO2B__Usage_Staging__c Stagings = new ChikPeaO2B__Usage_Staging__c();
                                                                                                       Stagings.Billable__c = true;
                                                                                                       Stagings.ChikPeaO2B__Status__c = 'New';
                                                                                                       Stagings.ChikPeaO2B__Usage_unit__c = collection.Billable_Hours__c;
                                                                                                       Stagings.ChikPeaO2B__UsageDate__c = collection.Date__c;
                                                                                                       Stagings.ChikPeaO2B__Usage__c = usg.id;
                                                                                                       //Stagings.Project_Name__c = Resource__r.Project__c;
                                                                                                       //Stagings.Project_Phase__c = Resource__r.Phase__r.Name;
                                                                                                       UploadStg.add(Stagings);
                                                                                                       
                                                                                                       collection.Post__c = true;
                                                                                                       
                                                                                                       updateRestg.add(collection);
                                                                                                       
                                                                                                   }
                                                                                                    //Database.Insert(listname,false); 
                                                                                                }
                                                                                                }
                                                                                            }             
                                                                                        }
                                                }       
                                            }
        Database.Insert(UploadStg,false);
        Database.Update(updateRestg,false);
            return Error;
    }
    catch(Exception e){
        system.debug('Exception = '+e);
    }
        return Error;
}
}