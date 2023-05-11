@isTest
public class csvDownloadCtrl_Test {
    
    static testmethod void testSetupMethod1(){
        Test.startTest();
        
        Account acc = New Account();
        acc.Name ='Account3';
        insert acc;  
        
        ChikPeaO2B__Item__c cpi = new ChikPeaO2B__Item__c();
        cpi.Name = 'Payment1';
        cpi.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        cpi.ChikPeaO2B__Active__c = true;
        insert cpi;
        
        ChikPeaO2B__Price_Book__c prcebk = new ChikPeaO2B__Price_Book__c();
        prcebk.Name = 'Price book3';
        prcebk.ChikPeaO2B__Active__c = true;
        insert prcebk;
        
        Chikpea_Project__c cpr = new Chikpea_Project__c();
        cpr.Name = 'Services1';
        cpr.Template_Description__c = 'Project to define billing';
        cpr.Template_Name__c = 'Billing1';
        cpr.Category__c = 'Software development';
        cpr.Billing_Frequency__c = 'Weekly';
        cpr.Account__c = acc.id;
        cpr.Price_Book__c = prcebk.id;
        cpr.Templatize__c = True;
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        insert cpr;
        
        Project_Phase__c ppr = new Project_Phase__c();
        ppr.Name = 'Requirements';
        ppr.Status__c = 'Open';
        ppr.Project__c = cpr.Id;
        insert ppr;
        
        Resource__c res = new Resource__c();
        res.Phase__c = ppr.Id;
        res.Staff_Rate__c = True;
        
        Insert res;
        String Pname ='value';
        
        TemplateCls.NewProjectApx(cpr.Id,pname,acc.Id,cpr.Price_Book__c);
        TemplateCls.getPhase(cpr.Id);
        TemplateCls.RemoveTemplate(cpr.Id);
        TemplateCls.getProjects();
        
        Test.stopTest();
        csvDownloadCtrl.fetchContact(cpr.id);
         csvDownloadCtrl.fetchprjname(cpr.id);
    }
}