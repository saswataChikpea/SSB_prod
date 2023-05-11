({
    myAction : function(component, event, helper){
        
        var PhId = component.get('v.recordId');
        //  alert(PhId);
        
        var action = component.get('c.ResStaging');
        action.setParams({
            "Recid":PhId
        });
        
         action.setCallback(this, function(response){
            
            var state = response.getState();
             var data = response.getReturnValue();
            // alert(data);
                if (state == "SUCCESS" && data == null) {
                
                  
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Resource Stagings moved to usage succesfully',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                    
                } else if(data != null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: data,
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                } 
             var navEvt = $A.get("e.force:navigateToSObject");
             navEvt.setParams({
                 
                 "recordId": PhId,
                 "slideDevName": "detail"
                 
             });
             navEvt.fire();

                     });
         $A.enqueueAction(action);
        
         
    }
})