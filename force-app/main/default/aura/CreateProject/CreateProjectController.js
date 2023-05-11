({
	doInit : function(component, event, helper) {
        
        //To check the Opp has a project
        var recID = component.get("v.recordId");
        var action = component.get("c.CheckPrjOpp");
        
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var data = response.getReturnValue();
            if (data) {
                console.log('openTemplate controller id : '+component.get("v.recordId"));
                //alert(component.get("v.recordId"));
                console.log('openTemplate controller Account : '+component.get("v.Account"));
                console.log('openTemplate controller Opportunity : '+component.get("v.Opportunity"));
                var pageReference = component.find("navigation");
                var pageReferenceNav = {
                    type: 'standard__component',
                    attributes: {
                        componentName: 'c__Templates'
                    },
                    state: {
                        c__id : component.get("v.recordId")
                    }
                };
                pageReference.navigate(pageReferenceNav);
                
                    }
                    else{
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'Project with same Name already exists',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'Error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
               // var action = component.get('c.PhaseCard');
            $A.enqueueAction(action);
                    }
        });
        $A.enqueueAction(action);
        
		
	}
})