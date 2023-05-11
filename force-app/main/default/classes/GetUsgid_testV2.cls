@isTest

public class GetUsgid_testV2 {
    
    static testmethod void getusageidv1(){
        Datetime now = Datetime.now();

        Account acc = new Account();
        acc.name='new'+now;
        
        insert acc;
        
        ChikPeaO2B__Item__c Itm = new ChikPeaO2B__Item__c();
        Itm.Name = 'new item'+now;
        Itm.ChikPeaO2B__Item_Type__c = 'Recurring';
        Itm.ChikpeaO2b__active__c =True;
        insert Itm;
        
        ChikPeaO2B__Price_Book__c PB = new ChikPeaO2B__Price_Book__c();
        PB.Name = 'new book'+now;
        insert PB;
        
        ChikPeaO2B__Rate_Plan__c Rp= new ChikPeaO2B__Rate_Plan__c();
        Rp.ChikPeaO2B__Item__c = Itm.id;
        Rp.ChikPeaO2B__Price_Book__c = PB.Id;
        Rp.ChikPeaO2B__Bill_Cycle__c = 'Monthly';
        Rp.ChikPeaO2B__Pricing_Type__c = 'Flat';
        insert Rp;
        
        Chikpea_Project__c prj = new Chikpea_Project__c();
        prj.Name = 'Project1'+now;
        insert prj;
        
         ChikPeaO2B__Quote__c qq = new ChikPeaO2B__Quote__c();
        qq.ChikPeaO2B__Account__c = acc.Id;
        qq.ChikPeaO2B__Price_Book__c= PB.Id;
        qq.ChikPeaO2B__Status__c = 'Open';
        qq.ChikPeaO2B__Contract_Term_Months__c = '12';
        insert qq;
        
        ChikPeaO2B__Quote_Line__c ql = new ChikPeaO2B__Quote_Line__c();
        ql.ChikPeaO2B__Item__c = Itm.id;
        ql.ChikPeaO2B__Rate_Plan__c = Rp.id;
        ql.ChikPeaO2B__Quote__c = qq.Id;
        ql.Project_Name__c =  prj.Id;
        ql.ChikPeaO2B__Usage_Rate__c = Rp.ChikPeaO2B__Usage_Rate__c;
        ql.Tracking_Hours__c = True;
        ql.ChikPeaO2B__Subscription_Term_Months__c = '12' ;
        ql.ChikPeaO2B__Subscription_Start_Date__c = Date.newInstance(2019, 11 , 22);
        ql.Estimated_Hours__c = 10;
        insert ql;
        
        
       
      ChikpeaO2B__Order__c O = new ChikpeaO2B__Order__c();
        O.ChikPeaO2B__Price_Book__c = PB.Id;
        O.ChikPeaO2B__Account__c = acc.Id;
        O.ChikPeaO2B__Status__c ='Open';
        
        insert O;
        
      
        
        ChikpeaO2B__Order_line__c Ol = new ChikpeaO2B__Order_line__c();
        Ol.ChikpeaO2B__Order__c = O.Id;
        Ol.ChikPeaO2B__Item__c = Itm.Id;
        Ol.ChikPeaO2B__Rate_Plan__c = RP.Id;
        ol.ChikPeaO2B__Status__c = 'Open';
        Ol.ChikPeaO2B__Description__c = 'This is the test item';
        
        insert Ol;
        
        
        O.ChikPeaO2B__Status__c = 'In Process';
        Update O ;
        
          Ol.ChikPeaO2B__Status__c = 'In Process';
        Update Ol ;
        
        ChikPeaO2B__Usage__c usg = new ChikPeaO2B__Usage__c();
        usg.ChikPeaO2B__Account__c = acc.id;
        usg.ChikPeaO2B__Item__c = Itm.id;
        usg.ChikPeaO2B__Rate_Plan__c = Rp.id;
        usg.ChikPeaO2B__Order_Line__c = Ol.Id;
        
        insert usg;
        
        ChikPeaO2B__Usage__c usgg = new ChikPeaO2B__Usage__c();
        usgg.ChikPeaO2B__Account__c = acc.id;
        usgg.ChikPeaO2B__Item__c = Itm.id;
        usgg.ChikPeaO2B__Rate_Plan__c = Rp.id;
        usgg.ChikPeaO2B__Order_Line__c = Ol.Id;
        insert usgg;
        
        
        ChikPeaO2B__Usage_History__c UH = New ChikPeaO2B__Usage_History__c();
        UH.ChikPeaO2B__Total_Usage__c = 1;
        UH.ChikPeaO2B__Usage__c = usg.Id;
        insert UH;
        ChikPeaO2B__Usage_Staging__c ust = new ChikPeaO2B__Usage_Staging__c();
        ust.ChikPeaO2B__Usage__c = usg.id;
        ust.Billable__c = True;
        ust.ChikPeaO2B__Usage_unit__c = 0;
        ust.ChikPeaO2B__Status__c = 'Processed';
        ust.Usage_ID__c = 'STARTNOW';
        insert ust;
        ChikPeaO2B__Usage_Staging__c ust1 = new ChikPeaO2B__Usage_Staging__c();
        ust1.ChikPeaO2B__Usage__c = usg.id;
        ust1.Billable__c = FALSE;
        ust1.ChikPeaO2B__Usage_unit__c = 0;
        ust1.ChikPeaO2B__Status__c = 'Processed';
        ust1.Usage_ID__c = 'STARTNOW';
        insert ust1;
        
         ChikPeaO2B__Usage_Staging__c ust5 = new ChikPeaO2B__Usage_Staging__c();
        ust5.ChikPeaO2B__Usage__c = usg.id;
        ust5.Billable__c = false;
        ust5.ChikPeaO2B__Usage_unit__c = 0;
        ust5.ChikPeaO2B__Status__c = 'Processed';
        ust5.Usage_ID__c = 'STARTNOW';
        insert ust5;
        
         
        JsonWrapper_Pms wrap = new JsonWrapper_Pms();
        wrap.usageid = usg.Id;
        
        
       //wrap1 =  CreateProjectInPms_Callouts.createProject(usgg.id);        
       // CreateProjectInPms_Callouts.CreateProjectUsageInPms(wrap);
        //CreateProjectInPms_Callouts.ApiProcesstoPMS(usgg.id);

        
        //BatchLog.Name='Exception Account';
        
        //insert BatchLog;
        
    }

}