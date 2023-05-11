public class Uploadresourcestaggingfromcsv {
    
    @AuraEnabled
    public static string insertData(String strfromlex)
    {
        
        String returnresponse = 'ERROR';
        List<ChikPeaSSB__Resource_Staging__c> csvtoupdatestagings = new List<ChikPeaSSB__Resource_Staging__c>();
        system.debug('@@@ strfromlex = ' + strfromlex);
        //fieldWrapper datalist = (fieldWrapper)JSON.deserializeStrict(strfromlex, fieldWrapper.class);
        List<fieldWrapper> datalist = (List<fieldWrapper>)system.JSON.deserialize(strfromlex, List<fieldWrapper>.class);
        system.debug('@@@ datalist = ' + datalist);
        system.debug('@@@ datalistSize = ' + datalist.size());
        for(fieldWrapper wrapper: datalist)
        {
            list<ChikPeaSSB__Resource__c> Resid = [Select id from ChikPeaSSB__Resource__c where Name =:wrapper.Resource];
            string actualhrsstring = string.valueOf(wrapper.ActualHours);
            string datestring = string.valueOf(wrapper.UploadDate);
            system.debug('wrapper.ActualHours---'+wrapper.ActualHours);
                        system.debug('wrapper.ActualHours---'+wrapper.UploadDate);

            if(wrapper.ActualHours > 0 &&  string.isNotBlank(actualhrsstring) && string.isNotBlank(datestring)){
                
                ChikPeaSSB__Resource_Staging__c uss = new ChikPeaSSB__Resource_Staging__c();
                uss.ChikPeaSSB__Resource__c = Resid[0].id;
                uss.ChikPeaSSB__Actual_Hours__c = wrapper.ActualHours;
                uss.ChikPeaSSB__Billable_Hours__c = wrapper.ActualHours;
                //uss.Resource__r.Phase_Name__c = wrapper.ProjectPhase;
                
                //uss.Usage_ID__c = wrapper.UsageID;
                //uss.Task__c = wrapper.Task;
                // uss.ChikPeaO2B__UsageDate__c = wrapper.TaskDate;11/13/2019
                if(wrapper.UploadDate != null && wrapper.UploadDate != ''){
                    
                    if(wrapper.UploadDate.contains('/')){
                        
                        string[] UsageSplitDate = wrapper.UploadDate.split('/');
                        integer UsageYear =  Integer.valueOf(UsageSplitDate[2]);
                        integer UsageMonth  =  Integer.valueOf(UsageSplitDate[0]);
                        integer UsageDate =  Integer.valueOf(UsageSplitDate[1]);
                        uss.ChikPeaSSB__Date__c = Date.newInstance(UsageYear, UsageMonth, UsageDate);
                    }else if(wrapper.UploadDate.contains('-')){
                        string[] UsageSplitDate = wrapper.UploadDate.split('-');
                        integer UsageYear =  Integer.valueOf(UsageSplitDate[2]);
                        integer UsageMonth  =  Integer.valueOf(UsageSplitDate[0]);
                        integer UsageDate =  Integer.valueOf(UsageSplitDate[1]);
                        uss.ChikPeaSSB__Date__c = Date.newInstance(UsageYear, UsageMonth, UsageDate);
                    }
                }
                
                //uss.Project_Phase__c = wrapper.ProjectPhase;
                //uss.ChikPeaO2B__UoM__c ='Hour';
                
                
                csvtoupdatestagings.add(uss);   
                
                system.debug('Is that is iserted'+ uss);
                Resid.clear();
            }
        }
        if(csvtoupdatestagings.size() > 0)
        {
            try {
                ChikPeaSSB__Resource_Staging__c uss = new ChikPeaSSB__Resource_Staging__c();
                
                
                //uss.Usage_ID__c = 'STARTNOW';
                //uss.ChikPeaO2B__Status__c ='Processed';
                //csvtoupdatestagings.add(uss);  
                // upsert csvtoupdatestagings;
                Database.Insert(csvtoupdatestagings,false);                
                returnresponse = 'SUCCESS';
                return returnresponse;
            }
            catch(Exception ex)
            {
                system.debug('Exception ' +ex);
                returnresponse = 'ERROR';
                return returnresponse;
            }
        }
        return returnresponse;
    }
    public class fieldWrapper {
        //public String UsageID;
        public String Project;
        public String Phase; //resource name
        public String Resource;//project phase
        public String Role;
        public Integer Actualhours;//acutal hrs
        public String Task;
        public String UploadDate;
    }
    
    
    @AuraEnabled
    public static list <ChikPeaSSB__Chikpea_Project__c> PrjStatus(Id recoId){
        
        List <ChikPeaSSB__Chikpea_Project__c> Prjname = [SELECT ChikPeaSSB__Status__c from ChikPeaSSB__Chikpea_Project__c where id =: recoId];
        
        return Prjname;
        
    }
    
}