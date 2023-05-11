public with sharing class Project {
   /* public String name {get;set;}
    public String title {get;set;}
    public String manager {get;set;}
    public String startDate {get;set;}
    public String finishDate {get;set;}
    public String defaultStartDate {get;set;}
    public String defaultFinishDate {get;set;}
    public String currentDate {get;set;}

    @AuraEnabled
    public static String getTheProjectStatus(String project_id){
        String projectStatus;
        try {
            Chikpea_Project__c project = [select name,Status__c
            from Chikpea_Project__c where id = :project_id];
            projectStatus = project.Status__c;
            
        } catch (Exception e) {
            System.debug('Exception at getTheProjectStatus : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
        System.debug('projectStatus :'+projectStatus);
        return projectStatus;
    }

    @AuraEnabled
    public static String generateXmlForThirdParty(String project_id){
        String xmlContent;
        //project_id = 'a0y7F000004QtKqQAK';
        List<Project_Phase__c> projPhaseList = new List<Project_Phase__c>();
        try {
            Chikpea_Project__c project = [select name,Est_Est_Start_Date__c,Billing_Frequency__c,
            End_Date__c,Project_Description__c 
            from Chikpea_Project__c where id = :project_id];

            if(project != null){
                /*Project proj = new Project();
                proj.name =  project.name;
                proj.startDate = (project.Est_Start_Date__c != null ?  String.valueOf(project.Est_Start_Date__c) : '');
                proj.finishDate = (project.Est_Start_Date__c != null ? String.valueOf(project.End_Date__c) : '');
                proj.currentDate = System.now().format('yyyy-mm-dd\'T\'HH:mm:ss');//
                //***** 
             /*   DOM.Document doc = new DOM.Document();
 
                dom.XmlNode projectDom = doc.createRootElement('Project', null, null);
                projectDom.setAttribute('xmlns', 'http://schemas.microsoft.com/project');
                projectDom.addChildElement('Name', null, null).addTextNode(project.name);
                projectDom.addChildElement('StartDate', null, null).addTextNode((project.Est_Start_Date__c != null ?  String.valueOf(project.Est_Start_Date__c) : ''));
                projectDom.addChildElement('FinishDate', null, null).addTextNode((project.Est_Start_Date__c != null ? String.valueOf(project.End_Date__c) : ''));
                projectDom.addChildElement('CurrentDate', null, null).addTextNode(System.now().format('yyyy-mm-dd\'T\'HH:mm:ss'));
                //**** 
                projPhaseList = [select id,name,createdDate,Status__c from Project_Phase__c where Project__c = :project_id ];
                if(projPhaseList != null){
                    dom.XmlNode tasks= projectDom.addChildElement('Tasks', null, null);
                    Integer task_counter = 0;
                    for(Project_Phase__c phase : projPhaseList){
                        task_counter = task_counter +1;
                        dom.XmlNode child_task= tasks.addChildElement('Task', null, null);
                        child_task.addChildElement('UID ', null, null).addTextNode(String.valueOf(task_counter));
                        child_task.addChildElement('ID', null, null).addTextNode(String.valueOf(task_counter));
                        child_task.addChildElement('Name', null, null).addTextNode(phase.name);
                        child_task.addChildElement('CreateDate', null, null).addTextNode(phase.createdDate.format('yyyy-mm-dd\'T\'HH:mm:ss'));
                        child_task.addChildElement('OutlineNumber', null, null).addTextNode(String.valueOf(task_counter));

                        child_task.addChildElement('OutlineLevel', null, null).addTextNode(String.valueOf(1));
                        child_task.addChildElement('Priority', null, null).addTextNode(String.valueOf(500));
                        child_task.addChildElement('FixedCostAccrual', null, null).addTextNode(String.valueOf(2));
                    }
                }
                xmlContent = doc.toXmlString(); //GenerateXml.generateXml(proj);
                System.debug('xmlContent : '+xmlContent);
            }  
        } catch (Exception e) {
            System.debug('Exception at generateXmlForThirdParty : '+e.getMessage()+' Stack : '+e.getStackTraceString());
        } 
        return xmlContent;
    }*/
}