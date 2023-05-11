trigger Resourceprofitcalc on Resource__c (before insert,before update,after update,after insert) {
   
  List<Resource__c> NReslist = New List<Resource__c>();
  List<Resource__c> OReslist = New List<Resource__c>();
  List<ChikPeaSSB__Staffing__c> staffupdateoldlist2 = New List<ChikPeaSSB__Staffing__c>();
  
  
  for(Resource__c res : trigger.new){
      
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
          
          if( res.Estimated_Hours__c != null && res.Rate__c != null && res.Cost__c!=null){
              
              res.Estimated_Rate__c = res.Estimated_Hours__c * res.Rate__c;
              res.Estimated_Cost__c = res.Estimated_Hours__c * res.Cost__c;
              res.Estimated_Profit__c = res.Estimated_Rate__c -  res.Estimated_Cost__c;
             //res.Estimated_Profit__c = (res.Estimated_Hours__c * res.Rate__c) - (res.Estimated_Hours__c * res.Cost__c);
          }
      }
      
      
          /*    if(trigger.isbefore && trigger.isupdate){
                   System.debug('Before Trigger');
                 if(!ResourceInStaff.firstcall) {
           System.debug('firstcall');
             ResourceInStaff.firstcall = true;
              Id oldres = Trigger.oldmap.get(res.id).ChikPeaSSB__Staff__c;
              System.debug('oldres ='+oldres);
              
              //ResourceInStaff.ResourceStaffMapping(res,oldres);
                
          }
         }*/
      }
  
  

      
      
  }