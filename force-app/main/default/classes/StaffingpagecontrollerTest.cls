@isTest
public with sharing class StaffingpagecontrollerTest {
    
    @TestSetup
     static void makeData(){
        ChikPeaSSB__Staffing__c ssbStaf = new ChikPeaSSB__Staffing__c(ChikPeaSSB__Last_Name__c = 'Doe');
        insert ssbStaf;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId='test01';
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ssbStaf.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
    }
    static testmethod void testMtd(){
        String staffId = [Select Id from ChikPeaSSB__Staffing__c].Id;
        Staffingpagecontroller.getStaffimg(staffId);
        Staffingpagecontroller.onloadgetStaffimg(staffId);
        Staffingpagecontroller.RoleNameList('');
        Staffingpagecontroller.staffroleuppend(staffId, new List<String>{'a', 'b'});
        Staffingpagecontroller.StaffrelatedRec(staffId);
        Staffingpagecontroller.StaffPrjCmplt(staffId);
        Staffingpagecontroller.delstaff(staffId);
    }
}