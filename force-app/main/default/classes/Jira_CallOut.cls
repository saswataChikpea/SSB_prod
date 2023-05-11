public class Jira_CallOut {
    
    public static JsonWrapper_Jira createProject(Id PrjId){ 
    
    JsonWrapper_Jira wrap = new JsonWrapper_Jira();
        
         list<ChikPeaSSB__Chikpea_Project__c> Project = [Select id,Name from ChikPeaSSB__Chikpea_Project__c where id =: PrjId];
        
        if(Project != null && Project.size() > 0){
            wrap.ProjectName = 'Dhanush123';
                   system.debug('Step 2');
        }
        return wrap;
    }
    
    public static  List<JsonWrapper_Jira> ApiOrderMaster {get;set;}
    //Step - 1
   public static void CreateProjectUsageInPms(String  PrjList){
        
 /*       system.debug('PrjList =============' +PrjList);      
        ApiOrderMaster = new  List<JsonWrapper_Jira>();
        String PrjID = '';
        if(PrjList.size() > 0){
            for(JsonWrapper_Jira xc : PrjList){            
                PrjID = PrjID + 'PMS' + xc.ProjectID;
            }
            system.debug('PrjID==========' +PrjID);           
            ApiProcesstoJira(PrjID);  
            
        }  */
       system.debug('Step 1');
           ApiProcesstoJira(PrjList);
    }
      @future(callout=true)
    public static void ApiProcesstoJira(string PrjID){
        
        if(PrjID != null){
            List<JsonWrapper_Jira> ApiOrderMaster = new  List<JsonWrapper_Jira>();
           // String[] SplitUsageid = new String[]{};
            //    SplitUsageid = Usageids.split('PMS');
            //system.debug('SplitUsageid ' +SplitUsageid);            
           // for(integer i=0;i < SplitUsageid.size();i++){
                JsonWrapper_Jira wrap1 = new JsonWrapper_Jira();
               // if(SplitUsageid[i] != null && SplitUsageid[i] != ''){
                    wrap1 = Jira_CallOut.createProject(PrjID);
                    ApiOrderMaster.add(wrap1);
                    system.debug('ApiOrderMaster============'+ApiOrderMaster);
              //  }
            }            
            if(ApiOrderMaster.size() > 0){
                Http http = new Http();
                HttpRequest req = new HttpRequest();  
                String endpoint = '';
                endpoint = 'https://dhanush24.atlassian.net';
                
                system.debug('ApiOrderMasterJSONFormat ' +ApiOrderMaster);   
                String body = Json.serialize(ApiOrderMaster);  
                system.debug('ApiOrderMasterAPi JSON ' +body);
                req.setHeader('Content-Type', 'application/json');
                req.setMethod('POST');
                req.setEndpoint(endpoint);
                req.setBody(body);
                
                HttpResponse resp = http.send(req);   
                  
                
            }                        
        }   
        
    }