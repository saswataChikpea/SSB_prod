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
        
    }
})