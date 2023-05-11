public class UploadUsagesStagingsfromcsv{
    @AuraEnabled
    public static string insertData(String strfromlex)
    {
        String returnresponse = 'ERROR';
        List<ChikPeaO2B__Usage_Staging__c> csvtoupdatestagings = new List<ChikPeaO2B__Usage_Staging__c>();
        system.debug('@@@ strfromlex = ' + strfromlex);
        List<fieldWrapper> datalist = (List<fieldWrapper>) JSON.deserialize(strfromlex, List<fieldWrapper>.class);
        system.debug('@@@ datalist = ' + datalist);
        system.debug('@@@ datalistSize = ' + datalist.size());
        for(fieldWrapper wrapper: datalist)
        {
            ChikPeaO2B__Usage_Staging__c uss = new ChikPeaO2B__Usage_Staging__c();
            
            uss.Project_Name__c= wrapper.ProjectName;
            uss.Usage_ID__c = wrapper.UsageID;
            uss.Task__c = wrapper.Task;
            // uss.ChikPeaO2B__UsageDate__c = wrapper.TaskDate;11/13/2019
            if(wrapper.TaskDate != null && wrapper.TaskDate != ''){
                string[] UsageSplitDate = wrapper.TaskDate.split('-');
                integer UsageYear =  Integer.valueOf(UsageSplitDate[2]);
                integer UsageMonth  =  Integer.valueOf(UsageSplitDate[0]);
                integer UsageDate =  Integer.valueOf(UsageSplitDate[1]);
                uss.ChikPeaO2B__UsageDate__c = Date.newInstance(UsageYear, UsageMonth, UsageDate);
            }
            uss.Task_Description__c = wrapper.TaskDescription;
            uss.ChikPeaO2B__Usage_Identifier__c = wrapper.Resource;
            uss.ChikPeaO2B__Usage_Rate_Code__c = wrapper.UsageRateCode;
            uss.ChikPeaO2B__UoM__c = wrapper.UOM;
            uss.ChikPeaO2B__Usage_unit__c = wrapper.Usageunit;
            wrapper.Status = 'New';
            uss.ChikPeaO2B__Status__c = wrapper.Status;                
            uss.Comment__c = wrapper.Comments;         
            uss.Billable__c = wrapper.Billable;
            uss.Project_Phase__c = wrapper.ProjectPhase;
            uss.ChikPeaO2B__UoM__c ='Hour';
            
            
            csvtoupdatestagings.add(uss);                        
            system.debug('Is that is iserted'+ uss);
            
        }
        if(csvtoupdatestagings.size() > 0)
        {
            try {
                ChikPeaO2B__Usage_Staging__c uss = new ChikPeaO2B__Usage_Staging__c();
                
                
                uss.Usage_ID__c = 'STARTNOW';
                uss.ChikPeaO2B__Status__c ='Processed';
                csvtoupdatestagings.add(uss);  
                insert csvtoupdatestagings;                
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
        public String UsageID;
        public String ProjectName;
        public String ProjectPhase;
        public String Task;
        public String TaskDescription; 
        public String Resource;
        public String UsageRateCode;
        public String UOM;
        public Integer Usageunit;
        public Boolean Billable;
        public string TaskDate;
        public String Status;
       public String Comments;
        
        
    } 
}