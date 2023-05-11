({
    CreateRecord: function (component, event, helper) {
        
        var msg ='Are you sure you want to Generate Worksheet ?';
        // if (confirm(msg)) {
        
        var recID = component.get("v.recordId");
        //   alert(recID);
        
        var action = component.get('c.PrjStatus');
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
                    
                    var fileInput = component.find("file").getElement();
                    var file = fileInput.files[0];
                    //alert(file);
                    if (file) {
                        console.log("File");
                        var reader = new FileReader();
                        reader.readAsText(file, "UTF-8");
                        
                        reader.onload = function (evt) {             
                            console.log("EVT FN");
                            var csv = evt.target.result;
                            //console.log('@@@ csv file contains'+ csv);
                            var result = helper.CSV2JSON(component,csv);
                            console.log('@@@ result = ' + result);
                            //console.log('@@@ Result = '+JSON.parse(result));
                            helper.CreateAccount(component,result);            
                            
                        }
                        
                        
                        reader.onerror = function (evt) {
                            console.log("error reading file");
                        }
                    }
                    component.set("v.Likedisable",true);
                    
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
    
    
})