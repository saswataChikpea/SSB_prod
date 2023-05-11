({
	doInit : function(component, event, helper){
        var recID = component.get("v.recordId");
        var action = component.get("c.getStaff");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.Stafflist", data);
             

        });
        $A.enqueueAction(action);   
    },
    handleDel : function(component, event, helper){
        var recID = component.get("v.recordId");
        alert(recID);
        var action = component.get("c.DelStaff");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var deleteResult = response.getReturnValue();
           
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Deleted succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
               
                $A.get('e.force:refreshView').fire();  
                location.reload();
                
            } else if (deleteResult.state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Something went wrong.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();  
                location.reload();
            } 
      
             

        });
         $A.get('e.force:refreshView').fire();
        $A.enqueueAction(action);   
    },
    sendMail : function(component, event, helper) {
        var action = component.get("c.sendMailWithPDF");
        action.setParams({
            'recordId' : component.get('v.recordId'),
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert('Email Sent Successfully');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
    
    
})