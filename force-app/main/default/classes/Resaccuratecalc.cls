public class Resaccuratecalc {
    
    @Future
    
        public static void accuratecalc(List<Id> resid ) {
           
            
           Map<Id,Resource__c>  resourcemap = New Map<Id,Resource__c>([Select id,
                                         Actual_Cost__c,Billed__c,Res_Profit__c,Cost__c,Rate__c,Actual_Accrued__c,Billable_Accrued__c from Resource__c]);
           
             
          
                        List<Resource__c> resourcevalues = New List<Resource__c>();
                        List<Resource__c> Updatelist = New List<Resource__c>();
            
            for(Id resstagmap2 : resid){
                if(resourcemap.containsKey(resstagmap2)){
                    system.debug('Matching resource');
                  
                            resourcevalues.add(resourcemap.get(resstagmap2));
                            for(Resource__c resval : resourcevalues){
                                resval.Actual_Cost__c = resval.Actual_Accrued__c * resval.Cost__c;
                                resval.Billed__c = resval.Billable_Accrued__c * resval.Rate__c;
                                resval.Res_Profit__c = resval.Billed__c - resval.Actual_Cost__c;
                                Updatelist.add(resval);
                            }
                        
                    
                }
                resourcevalues.clear();
            }
            system.debug('Updatelist---------'+Updatelist);
     if(Updatelist.size() > 0)  
     {
       Update Updatelist ;        
     }
}
    @Future
    public static void accuratecalcold(List<Id> residold) {
        
        Map<Id,Resource__c>  resourcemapold = New Map<Id,Resource__c>([Select id,
                                         Actual_Cost__c,Billed__c,Res_Profit__c,Cost__c,Rate__c,Actual_Accrued__c,Billable_Accrued__c from Resource__c]);
            
            
        List<Resource_Staging__c> Matchingresstageidold = New List<Resource_Staging__c>();
                        List<Resource__c> resourcevaluesold = New List<Resource__c>();
                    String Resourceidold;
  List<Resource__c> Updatelistold = New List<Resource__c>();

        for(Id resstageoldid :residold){
            
            system.debug('comes in 1st loop');
            
                   if(resourcemapold.containsKey(resstageoldid)){
                       system.debug('resource matching');
                       resourcevaluesold.add(resourcemapold.get(resstageoldid));
                       for(Resource__c rsvalold : resourcevaluesold){
                          system.debug('rsvalold actual accured'+rsvalold.Actual_Accrued__c);
                                                     system.debug('rsvalold Billable_Accrued__c'+rsvalold.Billable_Accrued__c);

                           rsvalold.Actual_Cost__c = rsvalold.Actual_Accrued__c * rsvalold.Cost__c;
                             rsvalold.Billed__c = rsvalold.Billable_Accrued__c * rsvalold.Rate__c;
                              rsvalold.Res_Profit__c = rsvalold.Billed__c - rsvalold.Actual_Cost__c;
                           Updatelistold.add(rsvalold);
                       }
                   }

                resourcevaluesold.clear();
            
            
        }
        if(Updatelistold.size() > 0){
            Update Updatelistold;
        }
        
        
    }
    
}