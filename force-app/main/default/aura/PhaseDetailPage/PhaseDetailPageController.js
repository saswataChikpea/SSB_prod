({
    
     ResCard : function(component, event, helper) {
       
        var recID = component.get("v.recordId");
         //alert(recID);
        var action = component.get('c.getPhase');
         debugger
        action.setParams({
            recordId : recID             
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var resp= response.getReturnValue();    
              
            component.set('v.Phaselist',resp);
            
            var Prjid = resp[0].Id;
           // alert(Prjid);
            
            var Model = resp[0].Project_Model__c;
            //alert(Model);
            if(Model == 'Agile'){
                
                 component.set('v.hide',true);
            }   
        });
       $A.enqueueAction(action,false);        
        
    },
    
    ERecord : function (component, event, helper){
        
        component.set('v.editVisible',true);
        component.set('v.hide1',false);
        
    },
	  UpdatePhase : function(component, event, helper)
    {
        var Phaseidx = component.get("v.recordId");
       // alert(Phaseidx);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "detail"
        });
        navEvt.fire();
        
     var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: 'Phase Updated succesfully',
            messageTemplate: 'Record {0} created! See it {1}!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
       toastEvent.fire();
        
         $A.get('e.force:refreshView').fire();  
            location.reload();
                     
    },
    Redirect : function(component, event, helper) { 
        var recID = component.get("v.recordId");
        //alert(recID);
        var action = component.get('c.getPhase');
        debugger
        action.setParams({
            recordId : recID             
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var resp= response.getReturnValue();    
            
            component.set('v.Phaselist',resp);
            
            var Prjid = resp[0].Id;
            // alert(Prjid);
            
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": Prjid,
                "slideDevName": "detail"
            });
            navEvt.fire();
                    });
       $A.enqueueAction(action,false);        
        
    },
     cancelPhase : function(component, event, helper)
    {
        component.set('v.editVisible',false);
        component.set('v.hide1',true);
    }
    
})