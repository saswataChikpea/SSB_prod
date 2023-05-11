public with sharing class GenerateXml {
    
    public static String generateXml(Project proj){
        String xmlstring; 
        /*try {
            DOM.Document doc = new DOM.Document();
 
            dom.XmlNode project = doc.createRootElement('Project', null, null);
            project.setAttribute('xmlns', 'http://schemas.microsoft.com/project');
            project.addChildElement('Name', null, null).addTextNode(proj.name);
            project.addChildElement('StartDate', null, null).addTextNode(proj.startDate);
            project.addChildElement('FinishDate', null, null).addTextNode(proj.finishDate);
            project.addChildElement('CurrentDate', null, null).addTextNode(proj.currentDate);
            
            /*dom.XmlNode extendedAttributes= project.addChildElement('ExtendedAttributes', null, null);
    
            //body1.addChildElement('Name', null, null).addTextNode('Xbox One');
            //body1.addChildElement('Code', null, null).addTextNode('XBO');
    
            dom.XmlNode calendars= project.addChildElement('Calendars', null, null);
    
            //body2.addChildElement('Name', null, null).addTextNode('PlayStation 4');
            //body2.addChildElement('Code', null, null).addTextNode('PS4');
    
            dom.XmlNode tasks= project.addChildElement('Tasks', null, null);
    
            tasks.addChildElement('Name', null, null).addTextNode('WII');
            //body3.addChildElement('Code', null, null).addTextNode('Wii');
            dom.XmlNode resources= project.addChildElement('Resources', null, null);
            dom.XmlNode assignments= project.addChildElement('Assignments', null, null);*//*
            xmlstring = doc.toXmlString();
            System.debug('xmlstring : '+xmlstring);
        } catch (Exception e) {
            System.debug('Exception occur at : '+e.getMessage()+' Stack :'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }*/
        return xmlstring; 
    }
}