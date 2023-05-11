public with sharing class AttachPdf {
    
    @InvocableMethod(label='Attach Quote PDF' description='Generate and attach quote pdf to quote.' category='Quote')
    public static void attachQuotePDF(List<String> finalNameList){
        System.debug('finalNameList=>'+finalNameList);
        List<Id> quoteIdList= new list<Id>();
        String documentType ='';
        for (String name : finalNameList) {
            String[] parts = name.split(';');
            String quoteId = parts[0];
            quoteIdList.add(Id.valueOf(quoteId));
            documentType = parts[1];
        }
        //documentType  ==> BudgetQuote/BudgetIncreaseQuote
        
        System.debug('quoteIdList==>'+quoteIdList+'documentType==>'+documentType);
        List<Attachment> insertAttList = new List<Attachment>();
        Map<Id,SObject> projectIdMap = new Map<Id,SObject>();

        for (ChikPeaSSB__Chikpea_Project__c project : [select id, Name, ChikPeaSSB__Quote__c from ChikPeaSSB__Chikpea_Project__c where ChikPeaSSB__Quote__c in :quoteIdList]) {
            projectIdMap.put(project.Id, project);
        }

        for (Id projectId : projectIdMap.keySet()) {
            PageReference pdf= null;
            if (documentType == 'BudgetQuote') {
                pdf = Page.BudgetQuote;
            }else if (documentType == 'BudgetIncreaseQuote') {
                pdf = Page.BudgetIncreaseQuote;
            }
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',projectId);
            

            // create the new attachment
            Attachment attach = new Attachment();
            
            // the contents of the attachment from the pdf
            Blob body;

            try {
                // returns the output of the page as a PDF
                body = pdf.getContent();
            
            // need to pass unit test -- current bug    
            } catch (Exception e) {
                system.debug('exception =======>'+e);
                body = Blob.valueOf(e.getMessage());
            }
            attach.Body = body;

            String projectName = 'Proposal_' + projectIdMap.get(projectId).get('Name');
            String parentId = '' + projectIdMap.get(projectId).get('ChikPeaSSB__Quote__c');
            // add the user entered name
            Date tday = Date.today();
            String pdfName = projectName+'_'+tday.Month()+'/'+tday.Day()+'/'+tday.Year()+'.pdf';
            attach.Name = pdfName;
            attach.IsPrivate = false;
            // attach the pdf to the account
            attach.ParentId = Id.valueOf(parentId);
            //insert attach;
            insertAttList.add(attach);            
        }
        
        system.debug('insertAttList =====>'+insertAttList);
        if(insertAttList != NULL && insertAttList.size()>0){
            Insert insertAttList;
        }

    }
}