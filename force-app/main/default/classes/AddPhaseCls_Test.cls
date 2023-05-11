@isTest
public class AddPhaseCls_Test {
    
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
         Integer week ;
        boolean ABlendedcheckbox = true;
        Integer ABRate = 10;
        double rate = 10;
        
        Project_Phase__c phs = new Project_Phase__c();
        phs.Name = 'Project Phase';
        phs.Project__c = cpr.Id;
        phs.Weeks__c = week;
        phs.Is_Blended_Rate__c = ABlendedcheckbox;
        phs.Blended_Rate__c = ABRate;
        phs.ChikPeaSSB__Dependencies__c ='Test';
        insert phs;
       
        Project_Phase__c phs1 = new Project_Phase__c();
        phs1.Name = 'Project Phase1';
        phs1.Project__c = cpr.Id;
        phs1.Weeks__c = week;
        phs1.Is_Blended_Rate__c = ABlendedcheckbox;
        phs1.Blended_Rate__c = ABRate;
        phs1.ChikPeaSSB__Est_Start_date__c = Date.today();
         
        insert phs1;
        string selectdpn = 'Services1';
         
         Project_Phase__c phs2 = new Project_Phase__c();
        phs2.Name = 'Project Phase1';
        phs2.Project__c = cpr.Id;
        phs2.Weeks__c = week;
        phs2.Is_Blended_Rate__c = ABlendedcheckbox;
        phs2.Blended_Rate__c = ABRate;
        phs2.ChikPeaSSB__Est_Start_date__c = Date.today();
        phs2.ChikPeaSSB__Dependencies__c = selectdpn;
        insert phs2;
        Project_Phase__c phs3 = new Project_Phase__c();
        phs3.Name = phs2.ChikPeaSSB__Dependencies__c;
        phs3.Project__c = cpr.Id;
        phs3.Weeks__c = week;
        phs3.Is_Blended_Rate__c = ABlendedcheckbox;
        phs3.Blended_Rate__c = ABRate;
        phs3.ChikPeaSSB__Est_Start_date__c = Date.today();
        //phs3.ChikPeaSSB__Dependencies__c = selectdpn;
        insert phs3;
        
        // update phs1;
       // phs2.ChikPeaSSB__Est_Start_date__c = phs.ChikPeaSSB__Est_Start_date__c;
         //update phs;
     
       
         string AName = 'Testing';
         string ADescription = 'This is test';
         String pName = 'Test project';
         
         //delete phs;
         
         AddPhaseCls.getPrjdetails(cpr.id);
         AddPhaseCls.getPhaseDepVal(cpr.id,phs.id);
         AddPhaseCls.getPhaselist(cpr.id);
         AddPhaseCls.DeletephaseValidation(phs.id);
         AddPhaseCls.Deletephase(phs.id);
         AddPhaseCls.PhaseNameValidation(cpr.id,pName);
         AddPhaseCls.InsertPhaseFn(cpr.id,AName,ADescription,week,ABlendedcheckbox,rate);
         try{
               AddPhaseCls.OnChangePhaseDepent(phs2.id,selectdpn);
         }catch(Exception e){

         }
         
         
         
     }

     // @TestSetup
     // static void makeData(){
     //      Account acc = New Account();
     //      acc.Name = 'Account1';
     //      insert acc;

     //      ChikPeaO2B__Item__c Item1 = new ChikPeaO2B__Item__c();
     //      Item1.Name = 'Upfront Payment1';
     //      Item1.ChikPeaO2B__Item_Type__c = 'Post-Paid Usage1';
     //      insert Item1;

     //      ChikPeaO2B__Item__c Item = new ChikPeaO2B__Item__c();
     //      Item.Name = 'Item name1';
     //      Item.ChikPeaO2B__Item_Type__c = 'One-Off1';
     //      insert Item;

     //      ChikPeaO2B__Price_Book__c pricebk = new ChikPeaO2B__Price_Book__c();
     //      pricebk.Name = 'Price book1';
     //      pricebk.ChikPeaO2B__Active__c = true;
     //      insert pricebk;

     //      ChikPeaO2B__Rate_Plan__c Rp = new ChikPeaO2B__Rate_Plan__c();
     //      Rp.ChikPeaO2B__Item__c = Item.Id;
     //      Rp.ChikPeaO2B__Bill_Cycle__c = 'Monthly1';
     //      Rp.ChikPeaO2B__Price_Book__c = pricebk.Id;
     //      Rp.ChikPeaO2B__Pricing_Type__c = 'Flat1';
     //      Rp.ChikPeaO2B__Usage_Rate__c = 7.00;
     //      insert Rp;



     //      Chikpea_Project__c cpr = new Chikpea_Project__c();
     //      cpr.Name = 'Services1';
     //      cpr.Template_Description__c = 'Project to define billing';
     //      cpr.Template_Name__c = 'Billing1';
     //      cpr.Category__c = 'Software development';
     //      cpr.Billing_Frequency__c = 'Weekly';
     //      cpr.Account__c = acc.id;
     //      cpr.Price_Book__c = pricebk.id;
     //      cpr.Templatize__c = True;
     //      cpr.Status__c = 'New';
     //      cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1;
     //      insert cpr;
     //      Integer week;
     //      boolean ABlendedcheckbox = true;
     //      Integer ABRate = 10;
     //      double rate = 10;

     //      Project_Phase__c phs = new Project_Phase__c();
     //      phs.Name = 'Project Phase';
     //      phs.Project__c = cpr.Id;
     //      phs.Weeks__c = week;
     //      phs.Is_Blended_Rate__c = ABlendedcheckbox;
     //      phs.Blended_Rate__c = ABRate;
     //      phs.ChikPeaSSB__Dependencies__c = 'Test';
     //      insert phs;

     //      Project_Phase__c phs1 = new Project_Phase__c();
     //      phs1.Name = 'Project Phase1';
     //      phs1.Project__c = cpr.Id;
     //      phs1.Weeks__c = week;
     //      phs1.Is_Blended_Rate__c = ABlendedcheckbox;
     //      phs1.Blended_Rate__c = ABRate;
     //      phs1.ChikPeaSSB__Est_Start_date__c = Date.today();

     //      insert phs1;
     //      string selectdpn = 'Services1';

     //      Project_Phase__c phs2 = new Project_Phase__c();
     //      phs2.Name = 'Project Phase1';
     //      phs2.Project__c = cpr.Id;
     //      phs2.Weeks__c = week;
     //      phs2.Is_Blended_Rate__c = ABlendedcheckbox;
     //      phs2.Blended_Rate__c = ABRate;
     //      phs2.ChikPeaSSB__Est_Start_date__c = Date.today();
     //      phs2.ChikPeaSSB__Dependencies__c = selectdpn;
     //      insert phs2;
     //      Project_Phase__c phs3 = new Project_Phase__c();
     //      phs3.Name = phs2.ChikPeaSSB__Dependencies__c;
     //      phs3.Project__c = cpr.Id;
     //      phs3.Weeks__c = week;
     //      phs3.Is_Blended_Rate__c = ABlendedcheckbox;
     //      phs3.Blended_Rate__c = ABRate;
     //      phs3.ChikPeaSSB__Est_Start_date__c = Date.today();
     //      //phs3.ChikPeaSSB__Dependencies__c = selectdpn;
     //      insert phs3;

     //      // update phs1;
     //      // phs2.ChikPeaSSB__Est_Start_date__c = phs.ChikPeaSSB__Est_Start_date__c;
     //      //update phs;


     //      string AName = 'Testing';
     //      string ADescription = 'This is test';
     //      String pName = 'Test project';
     // }

}