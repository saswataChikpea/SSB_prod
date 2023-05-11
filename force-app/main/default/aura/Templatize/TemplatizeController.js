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
            if(data[0].ChikPeaSSB__Project_Model__c === 'Agile'){
                component.set('v.hide' , "true");
           }
        });
        $A.enqueueAction(action);   
    },
    allowToEdit : function(component, event, helper){
        //this.editVisible = !this.editVisible;
        component.set("v.editVisible",true);
        component.set("v.hide",false);
    },
    UpdateProject : function(component, event, helper){
        console.log('OUTPUT : onsuccess');
        var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
            	'title' : 'Success',
                'type': 'success',
                'message' : 'Project Templatize Successfully.' 
            }); 
            showToast.fire(); 
        component.set("v.editVisible",false);
        component.set("v.hide",true);
        component.set("v.isLoading",false);
    },
    handleSubmit : function(component, event, helper){
        component.set("v.isLoading",true);
    }
})