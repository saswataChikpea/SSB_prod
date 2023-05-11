public class AddResourceCls
{
    public List<ResourceCustomWrapper> ItemList {get;set;}
    public String EstCloumnname {get; set;}
    
    public  List<ResourceCustomWrapper> selectedItems = new List<ResourceCustomWrapper>();
    List<ChikPeaO2B__Rate_Plan__c> Rp = new List<ChikPeaO2B__Rate_Plan__c>();
    list<id> PbList = new list<id>(); 
    
    List<Project_Phase__c> Pricebook = new List<Project_Phase__c>();
    List<ChikPeaO2B__Rate_Plan__c> rateplanid = new List<ChikPeaO2B__Rate_Plan__c>();
    Set<id> itemid = new set<id>();
    
    id phaseid = ApexPages.currentPage().getParameters().get('id');
    
    Public AddResourceCls(ApexPages.StandardController controller)
    {
        Pricebook =  [select id,Project__c,Project__r.Price_Book__c,Project__r.Billing_Frequency__c,Project__r.Project_Model__c from Project_Phase__c 
                      WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        String bilFreq = Pricebook[0].Project__r.Billing_Frequency__c;
        
        
        String ProjectModel = Pricebook[0].Project__r.Project_Model__c;
        
        
        if(ProjectModel == 'Waterfall'){
            EstCloumnname = 'Estimated Units';
            
        }else if(ProjectModel == 'Agile'){
             EstCloumnname = 'Estimated Efforts';
        } 
        system.debug('EstCloumnname = '+EstCloumnname);
        
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
            
            itemid.add(rpln.ChikPeaO2B__Item__c);
            
        }
        system.debug('itemid = '+itemid);
        
        
        ItemList = new List<ResourceCustomWrapper>();
        for(ChikPeaO2B__Item__c a : [select id, Name,(Select id,Name,ChikPeaO2B__Usage_Rate__c,ChikPeaO2B__Bill_Cycle__c,ChikPeaO2B__Pricing_Type__c
                                                      ,ChikPeaO2B__UOM__c,Profit__c,Cost_Plan__c,Cost_Plan__r.Usage_Cost__c,Cost_Book__c from 
                                                      ChikPeaO2B__Rate_Plans__r where ChikPeaO2B__Bill_Cycle__c =: bilFreq) from ChikPeaO2B__Item__c where id =:itemid 
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
            vb.bdLine = new Budget_Line__c(Status__c = 'Open', Request_Type__c = 'Original',
                Effective_Date__c = Date.today()
            );
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
    }
    public PageReference GetSelected()
    {
        selectedItems.clear();
        system.debug('accountList ' + ItemList);
        for(ResourceCustomWrapper accwrapper : ItemList){
            if(accwrapper.selected == true){
                if(accwrapper.rtplans.size() == 1){
                    for(RateplanCustomWrapper rpl : accwrapper.rtplans){                    
                        rpl.rateplanselected = true;
                    }   
                }              
                system.debug('selectedItems ' + selectedItems);
            }else{
                for(RateplanCustomWrapper rpl : accwrapper.rtplans){                    
                    rpl.rateplanselected = false;
                }                 
            }
            selectedItems.add(accwrapper);  
        }
        
        return null;
    }
    
    public List<ResourceCustomWrapper> GetSelectedAccounts()
    {
        if(selectedItems.size()>0)
            return selectedItems;
        else
            return null;
    }    
    
    public class ResourceCustomWrapper
    {
        //public ChikPeaO2B__Item__c acc{get; set;}
        public Boolean selected {get; set;}
        public String Resource {get; set;}
        public Integer EstHrs {get; set;}
        public Integer EstPerc {get; set;}
        public String ProjectModel {get; set;}
        //public String EstCloumnname {get; set;}
        public Double Cost {get; set;}   
        public id  itmid {get; set;}   
        public list<RateplanCustomWrapper> rtplans {get; set;}
        public Budget_Line__c bdLine{get;set;}
        public Resource__c rs{get;set;}
    }
    public class RateplanCustomWrapper
    {
        public Boolean rateplanselected {get; set;}
        public String Name {get; set;}
        public Double Rate {get; set;}  
        public String Billcycle {get; set;}  
        public String Pricingtype {get; set;}  
        public String UOM {get; set;}  
        public Double Profit {get; set;}  
        public Double Cost {get; set;} 
        public String costBk {get; set;}
        public id  rplid {get; set;}  
        public id  cplid {get; set;}  
    }
    
    //save method
    public PageReference save(){
        
       list<Project_Phase__c>  Prjtype =  [select id,Project__c,Project__r.Project_Model__c,Weeks__c,Is_Blended_Rate__c from Project_Phase__c 
                      WHERE Id = :ApexPages.currentPage().getParameters().get('id')];

        ID PrjId = Prjtype[0].Project__c;
        
        system.debug('Prjtype ' +Prjtype[0].Project__r.Project_Model__c);
        list<Resource__c> reos = new list<Resource__c>();
        list<ChikPeaSSB__Budget_Line__c> bdLines = new list<ChikPeaSSB__Budget_Line__c>();
        //system.debug('selectedItems ' +selectedItems);
        for(ResourceCustomWrapper itm : selectedItems)
        {      
            if(itm.selected){                                
                if ((Prjtype[0].Project__r.Project_Model__c =='Waterfall') && (itm.EstHrs == null || itm.EstHrs == 0))                
                {                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Estimated Hours greater than 0'));                
                    return null;                
                }else if ((Prjtype[0].Project__r.Project_Model__c =='Agile') && (itm.EstPerc == null || itm.EstPerc == 0 || itm.EstPerc > 100 ) )               
                {                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Estimated Efforts greater than zero and less than or equal to 100'));                
                    return null;                
                } 
                system.debug('itm.rtplans = '+itm.rtplans);
                system.debug('itm.rtplans = '+itm.rtplans);
                
                If(itm.rtplans.size() > 0)
                {
                    boolean isrpcheck = False;
                    for(RateplanCustomWrapper rpl : itm.rtplans){    
                        
                        System.debug('rpl.rateplanselected  = '+rpl.rateplanselected );
                        
                        
                        If(rpl.rateplanselected)
                        {
                            isrpcheck = true;
                            Resource__c res = new Resource__c();
                            itm.rs = res;
                            res.Phase__c = phaseid;
                            if(Prjtype[0].Project__r.Project_Model__c =='Waterfall'){
                                
                               //res.Estimated_Hours__c = itm.EstHrs;
                               itm.bdLine.ChikPeaSSB__Est_Hours__c = itm.EstHrs;
                                
                            }else if(Prjtype[0].Project__r.Project_Model__c =='Agile'){
                                
                                double week =  Prjtype[0].Weeks__c;
                                double perc = itm.EstPerc;
                                
                                res.Estimated_Efforts__c  = perc;
                                
                                double Estcalc = ((week * 40 ) * perc )/100 ;
                                
                                //res.Estimated_Hours__c = Estcalc; 
                                itm.bdLine.ChikPeaSSB__Est_Hours__c = Estcalc;
                            }
                            
                            res.Item__c = itm.itmid;
                            res.Rate_Plan__c = rpl.rplid;
                            res.Cost_Plan__c = rpl.cplid;
                            res.Project__c = PrjId;
                            if(Prjtype[0].Is_Blended_Rate__c){
                                res.Staff_Rate__c = false;
                            }else{
                                 res.Staff_Rate__c = true;
                            }
                            reos.add(res);
                            break;
                        }
                    }
                    if(isrpcheck == False){
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a Rate Plan'));                    
                        return null;                    
                        
                    }
                }
            }
        }
        
        //  system.debug('reos.size()'+reos.size());
        // system.debug('reos = '+reos);
        
        if(reos.size()>0)
            insert reos;
        
        for(ResourceCustomWrapper itm : selectedItems){
            if(itm.selected && itm.rs != null){
                itm.bdLine.Resource__c = itm.rs.Id;
                bdLines.add(itm.bdLine);
            }
        }
        insert bdLines;
        
        // Page redirect to the record page
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        PageReference pg = new PageReference('/'+phaseid);
        pg.setRedirect(true);
        return pg;  
        
        //rendered="{!if(a.ProjectModel =='Agile',false,true)}"
        //rendered="{!if(a.ProjectModel =='Waterfall',false,true)}"
    }
   
}