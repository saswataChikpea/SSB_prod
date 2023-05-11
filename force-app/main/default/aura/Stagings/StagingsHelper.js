({
    getAccounts : function(component, event, helper) {
        
        // var ShowRecid = event.getParam("ResrecordId");
       // alert(ShowRecid);
       var action = component.get("c.getStagings");
        
     /*     action.setParams({
            'recordId' : ShowRecid
        });
        */
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
        getStagings : function(component, event, helper,ShowRecid) {
         var action = component.get("c.getStagings");
            action.setParams({
            "recordId" : ShowRecid
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                for (var i = 0; i < data.length; i++) {
                    data[i].ResName = data[i].Resource__c !=null ? data[i].Resource__r.Name : ''; 
                }
                component.set('v.Data', data);
                var evt = $A.get("e.c:cardValUpdate");
                evt.fire();  
            }
            });
            $A.enqueueAction(action);
          
    },

    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("StagingsTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateStagingsApx");
        action.setParams({
            'updatedSatgings' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === true){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Account Records Updated"
                    });
                    helper.reloadDataTable();
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": "Error in update"
                    });
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },

    /*
     * reload data table
     * */
    reloadDataTable : function(){
    var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    
});