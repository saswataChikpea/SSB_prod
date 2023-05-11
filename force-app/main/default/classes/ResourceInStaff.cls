public class ResourceInStaff {

    Public static Boolean firstcall=false;
    
    public static void ResourceStaffMapping(Id Oresid, Id Nresid) {
        
                system.debug('Nresid ='+Nresid);
        system.debug('Oresid = '+Oresid);
        
        
        
       Map<Id,ChikPeaSSB__Staffing__c>  Staffmap = New Map<Id,ChikPeaSSB__Staffing__c>([Select id,ChikPeaSSB__Current_Status__c
                                                                                           from ChikPeaSSB__Staffing__c]);
        List<ChikPeaSSB__Staffing__c> oldstafflist = [select id from ChikPeaSSB__Staffing__c where id=:Oresid];
         List<ChikPeaSSB__Staffing__c> Newstafflist = [select id from ChikPeaSSB__Staffing__c where id=:Nresid];
         EmailTemplate templateId = [Select id from EmailTemplate where name = 'Invite Staff email template'];
         List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         List<string> toAddress = new List<string>();


          
         List<ChikPeaSSB__Staffing__c>  UpdateStafflist1 = New List<ChikPeaSSB__Staffing__c>();
          List<ChikPeaSSB__Staffing__c> UpdateStafflist2 = New List<ChikPeaSSB__Staffing__c>();
                                                                                         
        if(Newstafflist.size() > 0){
            Newstafflist[0].ChikPeaSSB__Current_Status__c = 'Working';
           // update Newstafflist;
        }
        if(oldstafflist.size() > 0){
            oldstafflist[0].ChikPeaSSB__Current_Status__c = 'Available';
          //  update oldstafflist;
        }
     
             
             /* if(!String.isBlank(Nresid.ChikPeaSSB__Staff__c)){
              ChikPeaSSB__Staffing__c staffval  = Staffmap.get(Nresid.ChikPeaSSB__Staff__c);
              staffval.ChikPeaSSB__Current_Status__c = 'Working';
              UpdateStafflist1.add(staffval);
                  
              if(!String.isBlank(Oresid.ChikPeaSSB__Staff__c)){
              system.debug('comes in line 48');
              ID OldStaffid = Oresid.ChikPeaSSB__Staff__c;
              system.debug('OldStaffid'+OldStaffid);
              ChikPeaSSB__Staffing__c staffvalue  = Staffmap.get(OldStaffid);
              staffvalue.ChikPeaSSB__Current_Status__c ='Available';
              UpdateStafflist2.add(staffvalue);
              }
              else
              {
              System.debug('previous staff is null');
              }
              }
              else if(String.isBlank(Nresid.ChikPeaSSB__Staff__c)){
                       
              system.debug('comes in line 59');
              if(Oresid.ChikPeaSSB__Staff__c != null && Oresid.ChikPeaSSB__Staff__c != '' && Oresid.ChikPeaSSB__Staff__c != 'None'){
              ID OldStaffidnull = Oresid.ChikPeaSSB__Staff__c; 
              system.debug('comes in line 62');
              ChikPeaSSB__Staffing__c staffvalue  = Staffmap.get(OldStaffidnull);
              staffvalue.ChikPeaSSB__Current_Status__c ='Available';
              UpdateStafflist2.add(staffvalue);
              }
              else
              {
              System.debug('current and previous staff is null');
              }
                        
              }  */
    //Send email for Invite sent button checked
        /* if(Nresid.ChikPeaSSB__Invite_Sent__c = true){
             if(!String.isBlank(Nresid.ChikPeaSSB__Staff__c)){
                  ChikPeaSSB__Staffing__c staffval1  = Staffmap.get(Nresid.ChikPeaSSB__Staff__c);
                 String emailadd = staffval1.ChikPeaSSB__Work_Contact__c;
                 toAddress.add(emailadd);

                 mail.setTemplateID(templateId.Id);
                 mail.setSaveAsActivity(false);
                 mail.setToAddresses(toAddress);
                 //mail.setOrgWideEmailAddressId(toAddress);
                 allmsg.add(mail);
                 Messaging.sendEmail(allmsg,false);
             }
         
             
         }*/
    
     }
         
         
    }