@isTest
public class AgileWeeksUpdate_Test { 
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
    cpr.Billing_Frequency__c = 'Milestone';
    cpr.Account__c = acc.id;
    cpr.Price_Book__c = prcebk.id;
    cpr.Templatize__c = True;
    cpr.Project_Model__c = 'Agile';
    cpr.Status__c ='In Process';
    cpr.ChikPeaSSB__Est_Start_Date__c = system.today() + 1 ;
    //cpr.ChikPeaSSB__Sum_of_Phase__c = 15;
   
    insert cpr;
        

    Integer pnum = 1;
    Project_Phase__c ppr = new Project_Phase__c();
    ppr.Name = 'Test Requirements';
    ppr.Status__c = 'In Process';
    ppr.ChikPeaSSB__Contract_Month__c ='1';
    ppr.Project__c = cpr.Id;
    ppr.Weeks__c = 10;
    ppr.ChikPeaSSB__Est_Start_date__c = system.today();
    ppr.ChikPeaSSB__Phase_Num__c = 10;
    ppr.ChikPeaSSB__Project__c = cpr.id;
    //
    insert ppr;
      ppr.Name = 'Requirements';
    ppr.ChikPeaSSB__Contract_Month__c ='6';
    //ppr.ChikPeaSSB__Phase_Num__c = 1;
    update ppr;
    
    Project_Phase__c ppr1 = new Project_Phase__c();
    ppr1.Name = 'testing';
    ppr1.Status__c = 'In Process';
    ppr1.ChikPeaSSB__Contract_Month__c ='1';
    ppr1.Project__c = cpr.Id;
    ppr1.Weeks__c = 10;
    ppr1.ChikPeaSSB__Est_Start_date__c = system.today();
    ppr1.ChikPeaSSB__Phase_Num__c = 15;
    ppr1.Project__c = cpr.Id;
    insert ppr1;
      ppr1.Name = 'Requirements test';
    ppr1.ChikPeaSSB__Contract_Month__c ='6';
    //ppr.ChikPeaSSB__Phase_Num__c = 1;
    update ppr1;
    
    Date stdate = ppr.ChikPeaSSB__Est_Start_date__c;
    Datetime dt = DateTime.newInstance(stdate, Time.newInstance(0, 0, 0, 0));
                   String dayOfWeek=dt.format('EEEE');
    
    Date stdate1 = ppr1.ChikPeaSSB__Est_Start_date__c;
    Datetime dt1 = DateTime.newInstance(stdate1, Time.newInstance(0, 0, 0, 0));
                   String dayOfWeek1=dt1.format('EEEE');
   
    Resource__c res = new Resource__c();
    res.Phase__c = ppr.Id;
    res.Staff_Rate__c = true;
    res.Estimated_Efforts__c = 10;
    Insert res;
    
    Resource__c res1 = new Resource__c();
    res1.Phase__c = ppr1.Id;
    res1.Staff_Rate__c = true;
    res1.Estimated_Efforts__c = 10;
    
    
    Insert res1;
    String Pname ='value';
    
    double escvalue;
    
    escvalue = ((ppr.Weeks__c*40) * res.Estimated_Efforts__c)/100;
    res.Estimated_Hours__c = escvalue;
    update res;
    ChikPeaO2B__Rate_Plan__c rp = New ChikPeaO2B__Rate_Plan__c();
    rp.ChikPeaO2B__Item__c = cpi.Id;
    rp.ChikPeaO2B__Bill_Cycle__c = 'Weekly';
    rp.ChikPeaO2B__Price_Book__c =prcebk.id;
    rp.ChikPeaO2B__Pricing_Type__c ='Flat';
    insert rp;
    
     ChikPeaO2B__Subscription__c cps = New ChikPeaO2B__Subscription__c();
    cps.ChikPeaO2B__Account__c = acc.id;
    cps.ChikPeaO2B__Item__c = cpi.Id;
    cps.ChikPeaO2B__Rate_Plan__c = rp.id;
    cps.ChikPeaO2B__Billing_Start_Date__c = system.today();    
    cps.ChikPeaO2B__Next_Bill_Date__c= system.today(); 
   
    insert cps;
    
      ppr.Weeks__c =15;
    ppr.Status__c ='Closed';
    ppr.Name = 'Testing';
    update ppr;
    
    Test.stopTest();
    }
}