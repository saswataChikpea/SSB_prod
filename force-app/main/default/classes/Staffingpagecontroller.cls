public with sharing class Staffingpagecontroller {
    
    @AuraEnabled
    public static Id getStaffimg (String Staffsid) { 
        system.Debug('staffid-----------'+ Staffsid);
            
        list<ContentDocumentLink> staffimgdetails = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
        ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
        FROM ContentDocumentLink 
        WHERE LinkedEntityId =: Staffsid  order by ContentDocument.createdDate desc limit 1];
       
        system.debug('image size-----------------------'+ staffimgdetails.size());
        if(staffimgdetails.size()>0){
            string currentimageid = staffimgdetails[0].ContentDocumentId;
            system.debug('currentimageid'+currentimageid);
            list<ContentDocumentLink> staffimgdel = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =: Staffsid and ContentDocumentId !=: currentimageid];
            system.debug('del image size-----------------------'+ staffimgdel.size());
            delete staffimgdel;

            return currentimageid;
        }else{
            return null;
        }
    
    }
    @AuraEnabled(cacheable=true)
    public static Id onloadgetStaffimg (String Staffsid) {
        system.Debug('staffid-----------'+ Staffsid);
            
        list<ContentDocumentLink> staffimgdetails = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
        ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
        FROM ContentDocumentLink 
        WHERE LinkedEntityId =: Staffsid order by ContentDocument.createdDate desc limit 1];
       
        system.debug('image size-----------------------'+ staffimgdetails.size());
        string currentimageid = staffimgdetails[0].ContentDocumentId;
        system.debug('currentimageid'+currentimageid);
		return currentimageid;
    
    }
    @AuraEnabled
    Public static string delstaff(string staffid){
        system.Debug('staffid-----------'+ staffid);

        List<ChikPeaSSB__Staffing__c> staffdetails = [select id from ChikPeaSSB__Staffing__c where id =: staffid];
        string delstaffid = staffdetails[0].id;
        if(staffdetails.size() > 0){
                delete staffdetails;
        }
        list<ContentDocumentLink> staffimgdetails = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
        ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
        FROM ContentDocumentLink 
        WHERE LinkedEntityId =: staffid];
        if(staffimgdetails.size() > 0){
            delete staffimgdetails;
        }
     string isdeleted = 'Isdeleted';
       return isdeleted;

    }
    @AuraEnabled
    Public static List<ChikPeaO2B__Item__c> RoleNameList(string staffid){
        List <ChikPeaO2B__Item__c> rolelst = New List<ChikPeaO2B__Item__c>();
        rolelst =[select id,Name,ChikPeaO2B__Active__c,ChikPeaO2B__Category__c from ChikPeaO2B__Item__c 
        where ChikPeaO2B__Active__c = True and ChikPeaO2B__Category__c ='Resource'];
        system.debug('rolelst---'+rolelst.size());
        return rolelst;

    }
    @AuraEnabled
    Public static List<ChikPeaSSB__Staffing__c> staffroleuppend(string staffid,string[] staffselectedroles){
        List <ChikPeaSSB__Staffing__c> stafflist = New List<ChikPeaSSB__Staffing__c>();
        stafflist =[select id,ChikPeaSSB__Staff_Roles__c from ChikPeaSSB__Staffing__c where id =: staffid];
        system.debug('staffid---'+staffid);
        system.debug('staffselectedroles---'+staffselectedroles);
        string allstring = string.join(staffselectedroles,',');
       // List<string> finalrole = allstring.split(',');
        stafflist[0].ChikPeaSSB__Staff_Roles__c = allstring;
        update stafflist;
        
        return stafflist;

    }
    @AuraEnabled(cacheable=true)
    Public static List<ChikPeaSSB__Resource__c> StaffrelatedRec(string Staffid){
        system.debug('staffidfor related list---'+Staffid);
        List<ChikPeaSSB__Resource__c> resourcelist = New List<ChikPeaSSB__Resource__c>();
        resourcelist = [select id,ChikPeaSSB__Project_Name__c,ChikPeaSSB__Phase__c,ChikPeaSSB__Project__c,ChikPeaSSB__Phase_Name__c,ChikPeaSSB__Role__c,ChikPeaSSB__Staff__c,
        ChikPeaSSB__Item__c, ChikPeaSSB__Project_Start_Date__c,ChikPeaSSB__Project_End_Date__c from ChikPeaSSB__Resource__c where ChikPeaSSB__Staff__c =:Staffid];
system.debug('staffrelated list'+resourcelist.size());
        return resourcelist;

    }

    @AuraEnabled(cacheable=true)
    Public static List<ChikPeaSSB__Resource__c> StaffPrjCmplt(string Staffid){
        system.debug('staffidfor related list---'+Staffid);
        List<ChikPeaSSB__Resource__c> resourcelist = New List<ChikPeaSSB__Resource__c>();
        resourcelist = [select id,ChikPeaSSB__Project_Name__c,ChikPeaSSB__Phase__c,ChikPeaSSB__Project__c,ChikPeaSSB__Phase_Name__c,ChikPeaSSB__Role__c,ChikPeaSSB__Staff__c,
        ChikPeaSSB__Item__c, ChikPeaSSB__Project_Start_Date__c,ChikPeaSSB__Project_End_Date__c from ChikPeaSSB__Resource__c where ChikPeaSSB__Staff__c =:Staffid and ChikPeaSSB__Project__r.ChikPeaSSB__Status__c = 'Completed'];
system.debug('staffrelated StaffPrjCmplt'+resourcelist.size());
        return resourcelist;

    }

}