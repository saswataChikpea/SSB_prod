@isTest
public class ProjectTableData_Test {
    
    static testmethod void testSetupMethod1(){
        //Test.startTest();
        
        Account acc = New Account();
        acc.Name ='Account1';
        insert acc;
        
        ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
        Item.Name = 'Upfront Payment';
        Item.ChikPeaO2B__Active__c = true;
        Item.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        //Item.Role__c = true;
        insert Item;
        
       /* ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
        Item1.Name = 'Upfront Payment1';
        Item1.ChikPeaO2B__Active__c = true;
        Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage';
        insert Item1;*/
        
        ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
        pricebk.Name = 'Price book1';
        pricebk.ChikPeaO2B__Active__c = true;
        insert pricebk; 
        
         Cost_Book__c cb = New Cost_Book__c();
        cb.Name = 'Testbook';
        cb.Active__c = true;
        insert cb;
        
        Cost_Plan__c cp = new Cost_Plan__c();
         cp.Cost_Book__c = cb.id;
        cp.Item__c = Item.id;
        cp.Usage_Cost__c = 3;
        insert cp;
        
        ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Item.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c='Weekly';
        Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
        Rp.Cost_Plan__c = cp.id;
        insert Rp;
        
        decimal targetprice;
        boolean ismatched = false;
        Chikpea_Project__c prj = new Chikpea_Project__c();
        prj.Account__c = acc.id;
        prj.Price_Book__c = pricebk.id;
        prj.Billing_Frequency__c = 'Weekly';
        prj.Project_Model__c = 'Waterfall';
        prj.Target_Price__c = 10.0;
        prj.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
        insert prj;
        
        Integer val = 12;
        prj.Target_Price__c = val;
        update prj; 
        
        Integer week ;
        boolean ABlendedcheckbox = true;
        Integer ABRate = 10;
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = prj.Id;
        phs.Weeks__c = week;
        phs.Is_Blended_Rate__c = ABlendedcheckbox;
        phs.Blended_Rate__c = ABRate;
        insert phs;
        
         Project_Phase__c phs1 = new Project_Phase__c();
        phs1.Name = 'Project Phase';
        phs1.Project__c = prj.Id;
        phs1.Weeks__c = week;
        phs1.Is_Blended_Rate__c = ABlendedcheckbox;
        phs1.Blended_Rate__c = ABRate;
        insert phs1;
        
        Project_Phase__c phs2 = new Project_Phase__c();
        phs2.Name = 'Project Phase';
        phs2.Project__c = prj.Id;
        phs2.Weeks__c = week;
        phs2.Is_Blended_Rate__c = ABlendedcheckbox;
        phs2.Blended_Rate__c = ABRate;
        insert phs2;
        
        Project_Phase__c phs3 = new Project_Phase__c();
        phs3.Name = 'Project Phase';
        phs3.Project__c = prj.Id;
        phs3.Weeks__c = week;
        phs3.Is_Blended_Rate__c = ABlendedcheckbox;
        phs3.Blended_Rate__c = ABRate;
        insert phs3;
        delete phs3;
        
       Double est = 20;
        Double EsEfforts;
        Double resnum = 10;
        Resource__c res = new Resource__c();
        res.Phase__c = phs.id;
        res.Staff_Rate__c = true;
        res.Rate_Plan__c = Rp.Id ;
        res.Cost_Plan__c = cp.Id;
        res.Staff_Rate__c = true;
        res.Actual_Cost__c = 0;
        insert res;
        
        res.Estimated_Hours__c = est;
        update res;  
        
        Resource__c res1 = new Resource__c();
        res1.Phase__c = phs.id;
        res1.Rate_Plan__c = Rp.Id ;
        res1.Cost_Plan__c = cp.Id;
        res1.Staff_Rate__c = true;
        res1.Actual_Cost__c = 0;
        insert res1;
        
        /*Resource__c res1 = new Resource__c();
        res1.Phase__c = phs.id;
        res1.Estimated_Hours__c = est;
         insert res1;*/
        
         List<Resource_Staging__c> lss = new list<Resource_Staging__c>();
        Resource_Staging__c resstage = new Resource_Staging__c();
        resstage.Resource__c =res.id;
        resstage.Actual_Hours__c = 10;
        insert resstage; 
        
        resstage.Actual_Hours__c = 20;
        update resstage;
        
        lss.add(resstage);
         List<Resource_Staging__c> lss1 = new list<Resource_Staging__c>();
        Resource_Staging__c resstage1 = new Resource_Staging__c();
        resstage1.Resource__c =res.id;
        resstage1.Actual_Hours__c = 10;
        insert resstage1; 
        
        resstage1.Actual_Hours__c = 20;
        update resstage1;
        
        lss.add(resstage1);
        
         
        
       ProjectTableData.ShowPhase(prj.id);
        ProjectTableData.getResc(phs.id);
       ProjectTableData.UpdateResc(res.id, EsEfforts, est);
       ProjectTableData.DeleteRes(res.id);
        ProjectTableData.ArrngResNum(res.id,resnum);
        ProjectTableData.getStagings(lss[0].id);
        ProjectTableData.updateStagingsApx(lss1);
        ProjectTableData.IsAuditDisableBillable(phs.id);
        ProjectTableData.DeleteResValdiation(res1.id);
        /*ProjectTableData.getPrjdetails(phs.Id);
        ProjectTableData.getPhase(phs.Id);
        ProjectTableData.getPrjdetails1(prj.Id, val);
        ProjectTableData.ShowPhase(phs.id);
        ProjectTableData.getAcclist(phs.id);
        ProjectTableData.Deletephase(phs.id);
        ProjectTableData.InsertPhaseFn(phs.Project__c, phs.Name, phs.Descriptions__c, week,ABlendedcheckbox,ABRate);
        ProjectTableData.getResc(res.id);
        ProjectTableData.DeleteRes(res.id);
        
        ProjectTableData.getStagings(resstage.id);
        ProjectTableData.PhaseNameValidation(prj.Id,phs.Name);
        ProjectTableData.DeletephaseValidation(phs1.id);
        ProjectTableData.IsAuditDisableBillable(phs2.id);*/
       //   ProjectTableData.DeleteResValdiation(res.Id);

      //  ProjectTableData.updateStagingsApx(lss);
      // ProjectTableData.updateStagingsApx(lss);
    }

    
}