({
    doInit : function(component, event, helper){
        var recID = component.get("v.recordId");
        var action = component.get("c.getPrjdetails");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.ProjectList", data);
             if(data[0].Project_Model__c === 'Agile')
           {
            component.set('v.hide' , "true");
           }

        });
        $A.enqueueAction(action);   
    }
})