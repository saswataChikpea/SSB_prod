({
    myAction : function(component, event, helper) {
        
        
        var msg ='Are you sure you want to generate Quote ?';
        if (confirm(msg)) {
           // console.log('No');
            //return false;
        
            var prjId = component.get('v.recordId');
            
            var action = component.get('c.CheckPrjStatus');
            action.setParams({
                "Recid":prjId
            });
        action.setCallback(this, function(response){
            
            var state = response.getState();
                if (state == "SUCCESS") {
                    
                var data = response.getReturnValue();
                var pjStatus = data[0].ChikPeaSSB__Status__c;
                var PrjRate  = data[0].ChikPeaSSB__Estimated_Rate__c;
                   //alert(pjStatus);
     
             //Creating new Quote
                    if(pjStatus == "New"){
                        if(PrjRate > 0 ){
                    var prjId = component.get('v.recordId');
        var PrjList = [];
        PrjList.push(prjId);
        
        var action = component.get('c.GetQuote');
        action.setParams({
            
            "prjid" : PrjList
            
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                 var data = response.getReturnValue();
                var Phaseidx = data.Qtlist[0].Id;
                if(data.Error){
                    if(Phaseidx){
                        alert('Quote created with error\n'+ data.ErrorMsg);
                    }else{
                        alert(data.ErrorMsg);
                    }
                    
                }
                //alert(Phaseidx);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    
                    "recordId": Phaseidx,
                    "slideDevName": "detail"
                    
                });
                navEvt.fire();
            }
            else if (state === "ERROR") {
              var errors = response.getError();
                
                alert(errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Something went wrong!',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
                    }else{
                         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please make sure to add resources to the phases',
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
                    }else{
                         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Something went wrong! The Quote is already Generated for this project.',
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