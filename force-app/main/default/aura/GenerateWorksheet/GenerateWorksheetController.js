({
    
    loadContactList: function(component, event, helper){
       helper.onLoad(component, event);
    },
    
    downloadCsv : function(component,event,helper){
        
        var msg ='Are you sure you want to Generate Worksheet ?';
        if (confirm(msg)) {
        
        var recID = component.get("v.recordId");
     //   alert(recID);
     
             var action = component.get('c.fetchprjname');
            action.setParams({
                "recoId":recID
            });
        action.setCallback(this, function(response){
            
            var state = response.getState();
                if (state == "SUCCESS") {
                    
                var data = response.getReturnValue();
                var pjStatus = data[0].ChikPeaSSB__Status__c;
                   //alert(pjStatus);
     
                    if(pjStatus == "In Process"){
        
          action.setCallback(this, function(response) {
              
                var status = response.getState();
               var value = response.getReturnValue();
              var model = value[0].Name;
              //alert(model);
               
        // get the Records [contact] list from 'ListOfContact' attribute 
        var stockData = component.get("v.ListOfprojects");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData); 
        if (csv == null){return;} 
        var testname = model;
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = testname+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
              
               var prjId = component.get("v.recordId");
               var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    
                    "recordId": prjId,
                    "slideDevName": "detail"
                    
                }); 
                navEvt.fire();
                
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Worksheet Generated Succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                var prjId = component.get('v.recordId');
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    
                    "recordId": prjId,
                    "slideDevName": "detail"
                    
                });
                navEvt.fire();
              
         });
                 $A.enqueueAction(action);
                        
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'Please make sure the project Status is In Process',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        
                        var prjId = component.get('v.recordId');
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            
                            "recordId": prjId,
                            "slideDevName": "detail"
                            
                        });
                        navEvt.fire();
                    }
                    
                }
        });
         $A.enqueueAction(action); 
        
        }
     else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Something went wrong! Generate Worksheet process canceled',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                var prjId = component.get('v.recordId');
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    
                    "recordId": prjId,
                    "slideDevName": "detail"
                    
                });
                navEvt.fire();
        }
         
    }
   
 })