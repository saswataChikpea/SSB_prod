public class AddResouurceClsHtml {
    
    public List<ResourceCustomWrapper> ItemList {get;set;}
    
    List<ResourceCustomWrapper> selectedItems = new List<ResourceCustomWrapper>();
    List<ChikPeaO2B__Rate_Plan__c> Rp = new List<ChikPeaO2B__Rate_Plan__c>();
    list<id> PbList = new list<id>(); 
    
    List<Project_Phase__c> Pricebook = new List<Project_Phase__c>();
    List<ChikPeaO2B__Rate_Plan__c> rateplanid = new List<ChikPeaO2B__Rate_Plan__c>();
    Set<id> itemid = new set<id>();
    
    id phaseid = ApexPages.currentPage().getParameters().get('id');
    
    Public AddResouurceClsHtml(ApexPages.StandardController controller)
    {
        Pricebook =  [select id,Project__r.Price_Book__c from Project_Phase__c 
                      WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        System.debug('Pricebook = '+Pricebook);
        for(Project_Phase__c pb : Pricebook){    
            PbList.add(pb.Project__r.Price_Book__c);
        }
        
        rateplanid = [select id,ChikPeaO2B__Item__c from ChikPeaO2B__Rate_Plan__c where  ChikPeaO2B__Price_Book__c = :PbList[0]];
        
        system.debug('rateplanid = '+rateplanid);
        
        for(ChikPeaO2B__Rate_Plan__c rpln : rateplanid){
            
            itemid.add(rpln.ChikPeaO2B__Item__c);
            
        }
        system.debug('itemid = '+itemid);
        
        
        ItemList = new List<ResourceCustomWrapper>();
        for(ChikPeaO2B__Item__c a : [select id, Name,(Select 
id,Name,ChikPeaO2B__Usage_Rate__c,ChikPeaO2B__Bill_Cycle__c,ChikPeaO2B__Pricing_Type__c
                                          ,ChikPeaO2B__UOM__c,Profit__c,Cost_Plan__c,Cost_Plan__r.Usage_Cost__c from 
ChikPeaO2B__Rate_Plans__r ) from ChikPeaO2B__Item__c where id =:itemid])
        {
            system.debug('a = '+a);
            ResourceCustomWrapper vb = new ResourceCustomWrapper();
            vb.selected = false;
            vb.Resource =a.Name;
            vb.itmid = a.id;
            vb.EstHrs = 00;  
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
                selectedItems.add(accwrapper);  
                system.debug('selectedItems ' + selectedItems);
            }
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
        public ChikPeaO2B__Item__c acc{get; set;}
        public Boolean selected {get; set;}
        public String Resource {get; set;}
        public Integer EstHrs {get; set;}
        public Double Cost {get; set;}   
        public id  itmid {get; set;}   
        public list<RateplanCustomWrapper> rtplans {get; set;}
        
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
        public id  rplid {get; set;}  
        public id  cplid {get; set;}  
    }
    
    //save method
    public PageReference save(){
        list<Resource__c> reos = new list<Resource__c>();
        
        for(ResourceCustomWrapper itm : selectedItems)
        {
            If(itm.rtplans.size() == 1){
                for(RateplanCustomWrapper rpl : itm.rtplans){
                    If(rpl.rateplanselected){
                        if (Schema.sObjectType.Resource__c.fields.Phase__c.isCreateable() &&
                        Schema.sObjectType.Resource__c.fields.Estimated_Hours__c.isCreateable() &&
                        Schema.sObjectType.Resource__c.fields.Item__c.isCreateable() &&
                        Schema.sObjectType.Resource__c.fields.Rate_Plan__c.isCreateable() &&
                        Schema.sObjectType.Resource__c.fields.Cost_Plan__c.isCreateable() ){
                            Resource__c res = new Resource__c();
                            res.Phase__c = phaseid;
                            res.Estimated_Hours__c = itm.EstHrs;
                            res.Item__c = itm.itmid;
                            res.Rate_Plan__c = rpl.rplid;
                            res.Cost_Plan__c = rpl.cplid;
                            reos.add(res);
                        }
                    }
                }
            }
        }
        
        system.debug('reos.size()'+reos.size());
        system.debug('reos = '+reos);
        
        if(reos.size()>0)
            insert reos;
        
        
        
        // Page redirect to the record page
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        PageReference pg = new PageReference('/'+phaseid);
        pg.setRedirect(true);
        return pg;  
        
    }
    

}