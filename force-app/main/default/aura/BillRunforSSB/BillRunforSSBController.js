({
    myAction : function(component, event, helper) {
        
        
        var msg ='Are you sure you want to generate Quote ?';
        if (confirm(msg)) {
           // console.log('No');
            //return false;
        
            var prjId = component.get('v.recordId');
            
            var action = component.get('c.totalusage');
            action.setParams({
            });
            
            action.setCallback(this, function(response){
            
                var state = response.getState();
                var data = response.getReturnValue();
                //alert(data);
                if (state == "SUCCESS" && data == "success") {
                    
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Billing batch scheduled succesfully',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
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
                    
                }else if(data != "success"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'The Apex job is already scheduled for execution',
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
                });
         $A.enqueueAction(action); 
            
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Something went wrong! Quote Generation is canceled',
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