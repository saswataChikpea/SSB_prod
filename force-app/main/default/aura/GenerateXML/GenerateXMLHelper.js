({
	onLoad: function(component, event) {
        //call apex class method
        var recID = component.get("v.recordId");
        //alert(recID);
        var action = component.get("c.fetchContact");
        
        action.setParams({
            recoId   : recID
        });
        //var action = component.get('c.fetchContact');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.ListOfprojects', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
    }
})