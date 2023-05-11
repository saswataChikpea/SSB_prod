({

    doInit: function (component, event, helper) {
        var recID = component.get("v.recordId");
        var action = component.get("c.getPrjdetails");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function (response) {
            var data = response.getReturnValue();
        });
        $A.enqueueAction(action);

    },
    
    
    EditPhaseCard: function (component, event, helper) {

        component.set('v.Buttonshelp', 'Divert');
        var Phaseidx = event.target.id;

        component.set('v.PhaseIddep', Phaseidx);

        var loadvalues = component.get('v.Phaselist');
        var loadvalues = component.get('v.Phaselist1');
        var index = loadvalues.findIndex(x => x.Id === Phaseidx);
        // alert(loadvalues[index].HideEdit);
        if (loadvalues[index].HideEdit == true) {
            loadvalues[index].HideEdit = false;
        }

        component.set('v.Phaselist1', loadvalues);

        var recID = component.get("v.recordId");
        var action = component.get("c.getPhaseDepVal");

        action.setParams({
            recordId: recID,
            phaseid: Phaseidx
        });
        action.setCallback(this, function (response) {
            var response = response.getReturnValue();
            var Nnull = "Null";
            var Nval = '';

            var items = [];
            for (var i = 0; i < response.length; i++) {

                var item = {

                    "label": response[i].Name,
                    "value": response[i].Name
                };
                items.push(item);
            }
            var item = {
                "label": 'Independent',
                "value": 'Independent'
            };
            items.push(item);

            component.set("v.PhaseOptions", items);


        });
        $A.enqueueAction(action);



    },
    cancelcard: function (component, event, helper) {
        /*    var Phaseidx = component.get("v.recordId");
            // alert(Phaseidx);
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": Phaseidx,
                "slideDevName": "detail"
            });
            navEvt.fire();*/
        var action = component.get('c.PhaseCard');
        $A.enqueueAction(action);

    },
    PhaseCard: function (component, event, helper) {
        var recID = component.get("v.recordId");
        var action = component.get("c.getPhaselist");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function (response) {
            var response = response.getReturnValue();
            if (response.length > 0) {
                for (var i = 0; response.length > i; i++) {
                    response[i].HideEdit = true;
                }
                component.set("v.ProjectList", response);
            }
            component.set("v.Phaselist", response);
            component.set("v.Phaselist1", response);
            //component.set("v.ProjectList", data);
        });
        $A.enqueueAction(action);
        var action = component.get("c.getPrjdetails");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function (response) {
            var response = response.getReturnValue();
            //debugger
            if (response.length > 0) {

                component.set("v.ProjectList", response);

                if (response[0].ChikPeaSSB__Project_Model__c === 'Agile') {
                    component.set('v.Hideweek', "true");
                }
            }
            component.set("v.ProjectList", response);

        });

        $A.enqueueAction(action);
    },
    AddRes: function (component, event, helper) {

        component.set('v.Buttonshelp', 'Divert');
        var Phaseidx = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "Related"
        });
        navEvt.fire();
    },
    AddBud: function (component, event, helper) {
        component.set('v.Buttonshelp', 'Divert');
        var Phaseid = event.target.id;
        console.log('add budget::',Phaseid);
        component.find('addbudgetlwc').showDialog(Phaseid);
        return false;
    },
    handleBudgetChange: function (component, event, helper) {
        console.log('handleBudgetChange');
    },
    Isdelete: function (component, event) {
        var Phaseidx = event.target.id;
        var msg = 'Are you sure you want to delete this item?';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {

            var action = component.get("c.DeletephaseValidation");
            action.setParams({
                Phaseid: Phaseidx
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var data = response.getReturnValue();
                //alert(data);
                if (data) {

                    var action = component.get("c.Deletephase");
                    action.setParams({
                        Phaseid: Phaseidx
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();

                        if (state == "SUCCESS") {
                            var data = response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'Phase Deleted succesfully',
                                messageTemplate: 'Record {0} created! See it {1}!',
                                duration: ' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            toastEvent.fire();

                            // $A.get('e.force:refreshView').fire();  
                            //location.reload();
                            var action = component.get('c.PhaseCard');
                            $A.enqueueAction(action);
                        }
                        else {
                            var errors = response.getError();
                            component.set("v.showErrors", true);
                            component.set("v.errorMessage", errors[0].message);
                        }
                        var action = component.get('c.PhaseCard');
                        $A.enqueueAction(action);
                    });
                    $A.get('e.force:refreshView').fire();
                    $A.enqueueAction(action);
                    //  var action = component.get('c.PhaseCard');
                    //  $A.enqueueAction(action);
                } else {

                    // error message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Phase cannot be deleted as it has Resource',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'Error',
                        mode: 'pester'
                    });
                    toastEvent.fire();

                }
            });
            $A.get('e.force:refreshView').fire();
            $A.enqueueAction(action);
            //var action = component.get('c.PhaseCard');
            //  $A.enqueueAction(action);
        }

    },
    UpdatePhase: function (component, event) {
        if (component.get('v.Buttonshelp') != 'Divert') {
            //var action = component.get('c.PhaseCard');
            //$A.enqueueAction(action);

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Phase Updated succesfully',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration: ' 5000',
                key: 'info_alt',
                type: 'success',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('Save Done');
            //$A.get('e.force:refreshView').fire();  
            //location.reload();
            var action = component.get('c.PhaseCard');
            $A.enqueueAction(action);

        } else {
            component.set('v.Buttonshelp', '');
        }

    },
    handleFilesChange: function (component, event, helper) {
        //debugger
        var recID = component.get("v.recordId");

        var Name = component.find("PName").get("v.value");
        var week = component.find("PWeek").get("v.value");
        if (week != null && week != "") {
            week = component.find("PWeek").get("v.value");
        } else {
            week = null;
        }
        var Description = component.find("PDescription").get("v.value");
        var Blendedcheckbox = component.find("Blendedcheckbox").get("v.value");
        var BRate = component.find("BRate").get("v.value");
        var action = component.get("c.PhaseNameValidation");

        action.setParams({
            recoId: recID,
            AName: Name


        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if (data) {
                //Error Msg
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Phase Name already Exist',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration: ' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                var action = component.get("c.CancelPhase");
                $A.enqueueAction(action);
                //var actions = component.get("c.createRecord");
                //$A.enqueueAction(actions);
            }
        });
        $A.enqueueAction(action);
    },
    createRecord: function (component, event, helper) {

        component.set('v.editVisible1', true);
        component.set('v.HideAddPhase', false);

    },
    InsertPhase: function (component, event, helper) {
        debugger
        var recID = component.get("v.recordId");
        var Name = component.find("PName").get("v.value");
        var week = component.find("PWeek").get("v.value");
        if (week != null && week != "") {
            week = component.find("PWeek").get("v.value");
        } else {
            week = null;
        }
        var Description = component.find("PDescription").get("v.value");
        var Blendedcheckbox = component.find("Blendedcheckbox").get("v.value");
        var BRate = component.find("BRate").get("v.value");

        var action = component.get("c.InsertPhaseFn");
        //alert(recID)
        action.setParams({
            recoId: recID,
            AName: Name,
            Aweek: week,
            ADescription: Description,
            ABlendedcheckbox: Blendedcheckbox,
            ABRate: BRate

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if (state == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Phase ' + Name + ' added succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration: ' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else {
                var errors = response.getError();
                component.set("v.showErrors", true);
                component.set("v.errorMessage", errors[0].message);
            }
        });
        $A.enqueueAction(action);

        var evt = $A.get("e.c:AddPhaseConection");
        evt.setParams({
        });
        evt.fire();

        component.set('v.editVisible1', false);
        component.set('v.HideAddPhase', true);

    },
    CancelPhase: function (component, event, helper) {
        component.set("v.Name", "");
        component.set('v.editVisible1', false);
        component.set('v.HideAddPhase', true);
    },
    handleDepChange: function (component, event, helper) {

        var recID = component.get("v.PhaseIddep");
        var selectPhase = event.getParam("value");
        //alert(selectPhase);
        var action = component.get("c.OnChangePhaseDepent");
        action.setParams({
            recordId: recID,
            SeltdPh: selectPhase
        });
        action.setCallback(this, function (response) {
            var data = response.getReturnValue();
            debugger
            console.log(JSON.stringify(data));
            var state = response.getState();
            if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: errors[0].message,
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'Error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);


    }
})