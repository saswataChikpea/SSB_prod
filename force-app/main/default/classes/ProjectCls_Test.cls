/*********************************************
 Apex class : It covers the Minimum code coverage for ProjectCls and PhaseCmpCls

**********************************************/

@isTest
public class ProjectCls_Test {
    
    static testmethod void Testmethod1(){
        
        
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage1';
        insert Item1;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Item name1';
        Item.ChikPeaO2B__Item_Type__c = 'One-Off1';
        insert Item;
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book1';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Monthly1';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat1';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        insert Rp;
        
        
        
        Chikpea_Project__c cpr = new Chikpea_Project__c();
        cpr.Name = 'Services1';
        cpr.Template_Description__c = 'Project to define billing';
        cpr.Template_Name__c = 'Billing1';
        cpr.Category__c = 'Software development';
        cpr.Billing_Frequency__c = 'Weekly';
        cpr.Account__c = acc.id;
        cpr.Price_Book__c = pricebk.id;
        cpr.Templatize__c = True;
        cpr.Status__c = 'New';
        cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        insert cpr;
        
        Integer val = 10;
       /*Project_Phase__c phs3 = new Project_Phase__c();
        phs3.Name = 'Project Phase';
        phs3.Project__c = cpr.Id;
        phs3.Weeks__c = week;
        phs3.Is_Blended_Rate__c = ABlendedcheckbox;
        phs3.Blended_Rate__c = ABRate;
        insert phs3;*/
         Integer week ;
        boolean ABlendedcheckbox = true;
        Integer ABRate = 10;
        Project_Phase__c phs3 = new Project_Phase__c();
        phs3.Name = 'Project Phase';
        phs3.Project__c = cpr.Id;
        phs3.Weeks__c = week;
        phs3.Is_Blended_Rate__c = ABlendedcheckbox;
        phs3.Blended_Rate__c = ABRate;
        insert phs3;
        
        PhaseCmpCls.getPhase(phs3.id);
        
         ProjectCls.getPrjdetails(cpr.id);
        ProjectCls.getPrjdetails1(cpr.id, val);
        ProjectCls.getAcclist(cpr.id);
        
        
    }
   

}