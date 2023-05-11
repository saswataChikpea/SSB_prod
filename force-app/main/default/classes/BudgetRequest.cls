public with sharing class BudgetRequest {
    public BudgetRequest() {

    }

    @AuraEnabled
    public static List<ChikPeaSSB__Resource__c>  getResc(String recordId){
        List<ChikPeaSSB__Resource__c> Res = [Select id,Name,
        ChikPeaSSB__Res_Num__c, ChikPeaSSB__Estimated_Efforts__c, ChikPeaSSB__Estimated_Hours__c, ChikPeaSSB__Staff_Rate__c,
        ChikPeaSSB__Profit__c, ChikPeaSSB__Rate__c, ChikPeaSSB__Cost__c, ChikPeaSSB__Actual_Accrued__c,
        ChikPeaSSB__Billable_Accrued__c, ChikPeaSSB__Remaining_Hours__c, ChikPeaSSB__Res_Profit__c, 
        ChikPeaSSB__Billed__c, ChikPeaSSB__Actual_Cost__c, 
        ChikPeaSSB__Item__c,
        ChikPeaSSB__Cost_Plan__c,
        ChikPeaSSB__Rate_Plan__c,
        ChikPeaSSB__Item__r.Name,
        ChikPeaSSB__Phase__r.Name, 
        ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Hours__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Rate__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Estimated_Cost__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Phase_Profit__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Act_hours__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Profit__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Rate__c,
        ChikPeaSSB__Phase__r.ChikPeaSSB__Actual_Cost__c

        from ChikPeaSSB__Resource__c
                                 where ChikPeaSSB__Phase__c =: recordId Order by CreatedDate];
        
        return Res;
    }

    @AuraEnabled(cacheable = true)
    public static List<ResourceCustomWrapper> getAllResources(String recordId){
        system.debug('recordId = '+recordId);

        List<ChikPeaO2B__Rate_Plan__c> Rp = new List<ChikPeaO2B__Rate_Plan__c>();
        list<id> PbList = new list<id>(); 
        
        List<Project_Phase__c> Pricebook = new List<Project_Phase__c>();
        List<ChikPeaO2B__Rate_Plan__c> rateplanid = new List<ChikPeaO2B__Rate_Plan__c>();
        Set<id> itemId = new set<id>();

        List<ResourceCustomWrapper> ItemList = new List<ResourceCustomWrapper>();

        Pricebook =  [select id,Project__c,Project__r.Price_Book__c,Project__r.Billing_Frequency__c,Project__r.Project_Model__c from Project_Phase__c 
                      WHERE Id = :recordId];
        
        String bilFreq = Pricebook[0].Project__r.Billing_Frequency__c;
        
        
        String ProjectModel = Pricebook[0].Project__r.Project_Model__c;
        
        
        // if(ProjectModel == 'Waterfall'){
        //     EstCloumnname = 'Estimated Units';
            
        // }else if(ProjectModel == 'Agile'){
        //      EstCloumnname = 'Estimated Efforts';
        // } 
        // system.debug('EstCloumnname = '+EstCloumnname);
        
        if(bilFreq == 'Milestone'){
            bilFreq = 'Annual';
        }
        
        System.debug('Pricebook = '+Pricebook);
        for(Project_Phase__c pb : Pricebook){    
            PbList.add(pb.Project__r.Price_Book__c);
        }
        
        rateplanid = [select id,ChikPeaO2B__Item__c from ChikPeaO2B__Rate_Plan__c
                      where  ChikPeaO2B__Price_Book__c = :PbList[0] and ChikPeaO2B__Bill_Cycle__c =: bilFreq ];
        //
        
        system.debug('rateplanid = '+rateplanid);
        
        
        for(ChikPeaO2B__Rate_Plan__c rpln : rateplanid){
            
            itemId.add(rpln.ChikPeaO2B__Item__c);
            
        }
        system.debug('itemId = '+itemId);



        for(ChikPeaO2B__Item__c a : [select id, Name,(Select id,Name,ChikPeaO2B__Usage_Rate__c,ChikPeaO2B__Bill_Cycle__c,ChikPeaO2B__Pricing_Type__c
                                                      ,ChikPeaO2B__UOM__c,Profit__c,Cost_Plan__c,Cost_Plan__r.Usage_Cost__c,Cost_Book__c from 
                                                      ChikPeaO2B__Rate_Plans__r where ChikPeaO2B__Bill_Cycle__c =: bilFreq) from ChikPeaO2B__Item__c where id =:itemId 
                                     				and ChikPeaO2B__Item_Type__c = 'Post-Paid Usage' and ChikPeaO2B__Active__c = true and ChikPeaO2B__Category__c = 'Resource'])
        {
            system.debug('a = '+a);
            ResourceCustomWrapper vb = new ResourceCustomWrapper();
            vb.selected = false;
            vb.Resource =a.Name;
            vb.itmid = a.id;
            vb.EstHrs = 00;  
            vb.EstPerc = 00;
            vb.ProjectModel = ProjectModel;
            //commented by Ari
            // vb.bdLine = new Budget_Line__c(Status__c = 'Open', Request_Type__c = 'Original',
            //     Effective_Date__c = Date.today()
            // );
            //

            //vb.EstCloumnname = EstCloumnname;
            vb.rtplans = new list<RateplanCustomWrapper>();
            for(ChikPeaO2B__Rate_Plan__c rpl : a.ChikPeaO2B__Rate_Plans__r ){
                RateplanCustomWrapper vb1 = new RateplanCustomWrapper();
                vb1.rateplanselected = false;
                vb1.Name =rpl.Name;
                
                vb1.rplid = rpl.id;
                vb1.cplid = rpl.Cost_Plan__c;
                vb1.Rate =rpl.ChikPeaO2B__Usage_Rate__c == null ? 0 : rpl.ChikPeaO2B__Usage_Rate__c;
                vb1.Billcycle= rpl.ChikPeaO2B__Bill_Cycle__c;
                vb1.Pricingtype = rpl.ChikPeaO2B__Pricing_Type__c;
                vb1.UOM= rpl.ChikPeaO2B__UOM__c;
                vb1.Profit = rpl.Profit__c;
                vb1.costBk = rpl.Cost_Book__c;
                vb1.Cost =rpl.Cost_Plan__r.Usage_Cost__c == null ? 0 : rpl.Cost_Plan__r.Usage_Cost__c;
                vb.rtplans.add(vb1);            
            }
            ItemList.add(vb);  
            
        }
        System.debug('ItemList::'+JSON.Serialize(ItemList));
        return ItemList;
    }

    @AuraEnabled
    public static Boolean saveNewBudget(List<Map<String,String>> resourceList, String reasonForIncrement, Id PhaseId){
        System.debug('PhaseId==>'+PhaseId);
        System.debug('resourceList==>'+JSON.serialize(resourceList));
        try {
                list<Project_Phase__c>  Prjtype =  [select id,Project__c,Project__r.Project_Model__c,Weeks__c,Is_Blended_Rate__c, Reason_for_Increment__C
                from Project_Phase__c 
                WHERE Id = :PhaseId];

                ID PrjId = Prjtype[0].Project__c;
                Project_Phase__c projectPhase= Prjtype[0];

                system.debug('Prjtype ' +Prjtype[0].Project__r.Project_Model__c);
                list<Resource__c> reos = new list<Resource__c>();
                list<ChikPeaSSB__Budget_Line__c> bdLines = new list<ChikPeaSSB__Budget_Line__c>();
                
                for(Map<String,String> resource : resourceList)
                {                  
                    ChikPeaSSB__Budget_Line__c bdline= new ChikPeaSSB__Budget_Line__c();
                    Resource__c res = new Resource__c();
                    res.Phase__c = resource.get('Phase__c');

                    if(Prjtype[0].Project__r.Project_Model__c =='Waterfall'){
                        
                        res.Estimated_Hours__c = Decimal.valueOf(resource.get('ChikPeaSSB__Est_Hours__c'));
                        bdLine.ChikPeaSSB__Est_Hours__c = Decimal.valueOf(resource.get('ChikPeaSSB__Est_Hours__c'));
                        
                    }
                    // else if(Prjtype[0].Project__r.Project_Model__c =='Agile'){
                        //need to check #Arindam
                        // double week =  Prjtype[0].Weeks__c;
                        // double perc = resource.get('EstPerc');
                        
                        // res.Estimated_Efforts__c  = perc;
                        
                        // double Estcalc = ((week * 40 ) * perc )/100 ;
                        
                        // //res.Estimated_Hours__c = Estcalc; 
                        // bdLine.ChikPeaSSB__Est_Hours__c = Estcalc;
                    // }
                    
                    res.Item__c = resource.get('Item__c');
                    res.Rate_Plan__c = resource.get('Rate_Plan__c');
                    res.Cost_Plan__c = resource.get('Cost_Plan__c');
                    res.Project__c = PrjId;
                    if(Prjtype[0].Is_Blended_Rate__c){
                        res.Staff_Rate__c = false;
                    }else{
                        res.Staff_Rate__c = true;
                    }

                    // budget approval in required
                    res.Pending_For_Approval__c = true;

                    reos.add(res);
                    break;                        
                    }
    
                
            if(reos.size()>0){
                insert reos;
                projectPhase.Reason_for_Increment__C = reasonForIncrement;
                update projectPhase;
            }
                
            if (bdLines.size()>0) {
                insert bdLines;
            }
            return true;
        } 
        catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
    }    

    @AuraEnabled
    public static Boolean updateHours(String hoursToUpdate,ID dataid){
      
    try{
        System.debug('dataid'+dataid);
       System.debug('hoursToUpdate'+hoursToUpdate);
       Decimal intVal = Decimal.ValueOf(hoursToUpdate);

       ChikPeaSSB__Resource__c hours=[Select ChikPeaSSB__Estimated_Hours__c from ChikPeaSSB__Resource__c Where Id = :dataid ];
       System.debug('hoursToUpdate'+hours);

       Decimal prevHour=hours.ChikPeaSSB__Estimated_Hours__c;
       Decimal totalHour=intVal+prevHour;
       System.debug( 'intVal value is ' + totalHour);

       hours.ChikPeaSSB__Estimated_Hours__c=totalHour;

       update hours;

    }

    catch (Exception e){
        String errmsg = e.getMessage();
       System.debug('errmsg'+errmsg);
    }
    
    
    //    System.debug('dataid'+hours);
       return true;
    }



    public class ResourceCustomWrapper
    {
        //public ChikPeaO2B__Item__c acc{get; set;}
        @AuraEnabled public Boolean selected {get; set;}
        @AuraEnabled public String Resource {get; set;}
        @AuraEnabled public Integer EstHrs {get; set;}
        @AuraEnabled public Integer EstPerc {get; set;}
        @AuraEnabled public String ProjectModel {get; set;}
        // @AuraEnabled //public String EstCloumnname {get; set;}
        @AuraEnabled public Double Cost {get; set;}   
        @AuraEnabled public id  itmid {get; set;}   
        @AuraEnabled public list<RateplanCustomWrapper> rtplans {get; set;}
        @AuraEnabled public Budget_Line__c bdLine{get;set;}
        @AuraEnabled public Resource__c rs{get;set;}
    }
    public class RateplanCustomWrapper
    {
        @AuraEnabled public Boolean rateplanselected {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Double Rate {get; set;}  
        @AuraEnabled public String Billcycle {get; set;}  
        @AuraEnabled public String Pricingtype {get; set;}  
        @AuraEnabled public String UOM {get; set;}  
        @AuraEnabled public Double Profit {get; set;}  
        @AuraEnabled public Double Cost {get; set;} 
        @AuraEnabled public String costBk {get; set;}
        @AuraEnabled public id  rplid {get; set;}  
        @AuraEnabled public id  cplid {get; set;}  
    }
}