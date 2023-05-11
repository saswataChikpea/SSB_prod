({



    doInit: function (component, event, helper) {
        var opportunityID = component.get("v.opportunityID");
        console.log('Opportunity ID in Chid Comp doInit: ' + opportunityID);
        var action = component.get("c.getOppDetails");
        action.setParams({ "opportunityID": opportunityID });
        action.setCallback(this, function (actionResult) {
            console.log('Template state :' + actionResult.getState() + ' value :' + JSON.stringify(actionResult.getReturnValue()));
            if (actionResult.getState() === 'SUCCESS') {
                console.log('Response IN ' + actionResult.getReturnValue().opp_name);
                component.set("v.oppMap", actionResult.getReturnValue());
            } else {
            }
        });
        $A.enqueueAction(action);
    },
    showCaseDeletee: function (component, event, helper) {

        var PrjName = component.find("conn").get("v.value");
        component.set("v.empName,PrjName")
        // alert(PrjName);

        var AccName = component.find("AccName").get("v.value");
        // alert(AccName);

        var Prjid = component.get("v.selectedCard")
        // alert(Prjid);
        var pricebook = component.find("pricebook").get("v.value");

        console.log('pricebook===>', pricebook);

        if (PrjName == null || AccName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please enter the project Name or Select the Account',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();

        } else {

            var action = component.get("c.NewProjectApx");
            action.setParams({
                recordId: Prjid,
                Pname: PrjName,
                Accid: AccName,
                pricebookId: pricebook
            });

            component.set("v.isDisabled", true);

            action.setCallback(this, function (response) {
                var state = response.getState();
                //alert(state);

                if (state == "SUCCESS") {
                    var data = response.getReturnValue();


                    var Phaseidx = data[0].Id;

                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": Phaseidx,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'New Project created succesfully',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else if (state == "ERROR") {
                    component.set("v.isDisabled", false);
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Something went wrong! \n' + errors[0].message,
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    }

                }
            });
            $A.enqueueAction(action);
        }
    }
})