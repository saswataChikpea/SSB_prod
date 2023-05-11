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
    },
    
    saveClick : function(component, event, helper) { 
        var Rx = component.get("v.ProjectList");
        var recID = component.get("v.recordId");
        var action = component.get("c.getPrjdetails1");
        action.setParams({
            recordId: recID,
            val : Rx[0].Target_Price__c
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.ProjectList1", data);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Target Price updated succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            
            else if(state == "ERROR"){
                var errors = response.getError();                       
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
            }           
        });
        $A.enqueueAction(action);
        component.set('v.editVisible',false);
        
    },
    cancelClick : function(component, event, helper){
        component.set('v.editVisible',false);
        var action = component.get('c.doInit');
        $A.enqueueAction(action);
        
    },
    TargetPrice: function(component, event, helper){
        
        component.set('v.editVisible',true);
        
    },
    createRecord : function (component, event, helper){
        
        component.set('v.editVisible1',true);
        
    },
    InsertPhase : function(component, event, helper){
        var recID = component.get("v.recordId");
        
        var Name  = component.find("PName").get("v.value");
        var week  = component.find("PWeek").get("v.value");
       
        //var Status = component.find("PStatus").get("v.value");
        var Description = component.find("PDescription").get("v.value");
        var action = component.get("c.InsertPhaseFn");
        
        action.setParams({
            recordId : recID,
            AName    : Name,
            Aweek  : week,
            ADescription : Description
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Phase ' + Name +' added succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else if(state == "ERROR"){
                var errors = response.getError();                       
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
            }
        });
        $A.enqueueAction(action);
         var action = component.get('c.PhaseCard');
        $A.enqueueAction(action);
        component.set('v.editVisible1',false);
    },
    CancelPhase : function(component, event, helper){
        component.set("v.Name", "");
        component.set('v.editVisible1',false);
    },
    PhaseCard : function(component, event, helper) {
        var recID = component.get("v.recordId");
        //alert(recID);
        var action = component.get('c.getAcclist');
        action.setParams({
            recordId : recID
            
        });
        action.setCallback(this, function(response){
            var response= response.getReturnValue();    
            console.log('response',response);
            component.set('v.Phaselist',response)
            
          //  var model = response[0].Project__r.Project_Model__c;
            //var model = 'Agile';
           //if(model === 'Agile')
          // {
              
           // component.set('v.hide' , "true");
          // } 
        });
        
        $A.enqueueAction(action,false);
    },
    AddRes : function(component, event, helper) {
        
        component.set('v.Buttonshelp','Divert');
        var Phaseidx = event.target.id;
       // alert(Phaseidx);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "Related"
        });
        navEvt.fire();
    },
    Isdelete : function (component, event) {
        var Phaseidx = event.target.id;
        //var PhaseName = event.target.Name;
        //alert(PhaseName);
        var msg ='Are you sure you want to delete this item?';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            
            var action = component.get("c.DeletephaseValidation");
            action.setParams({
                Phaseid : Phaseidx
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var data = response.getReturnValue();
                //alert(data);
                if(data){
                    
                    var action = component.get("c.Deletephase");
                    action.setParams({
                        Phaseid : Phaseidx
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        
                        if (state == "SUCCESS") {
                            var data = response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'Phase Deleted succesfully',
                                messageTemplate: 'Record {0} created! See it {1}!',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                            
                            $A.get('e.force:refreshView').fire();  
                            location.reload();
                        }
                        else if(state == "ERROR"){
                            var errors = response.getError();                       
                            component.set("v.showErrors",true);
                            component.set("v.errorMessage",errors[0].message);
                        }
                        var action = component.get('c.PhaseCard');
                        $A.enqueueAction(action);
                    });
                    $A.get('e.force:refreshView').fire();
                    $A.enqueueAction(action);
                    
                }else{
                    
                    // error message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Phase cannot be deleted as it has Resource',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                }
          });
          $A.get('e.force:refreshView').fire();
        $A.enqueueAction(action);  
        }
        
    },
    UpdatePhase: function(component, event)
    {             
        if(component.get('v.Buttonshelp') != 'Divert')
        {
            var action = component.get('c.PhaseCard');
                    $A.enqueueAction(action);
                    
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
                              
        }else{
            component.set('v.Buttonshelp','');
        } 
     
    }
    
    //Add phase button Funtions
    ,
    createRecord : function (component, event, helper){
        
        component.set('v.editVisible1',true);
        
    },
    InsertPhase : function(component, event, helper){
        
        var recID = component.get("v.recordId");
        //alert(recID);
        var Name  = component.find("PName").get("v.value");
        //alert(Name);
        
      
        if(component.find("PWeek")){
        var week  = component.find("PWeek").get("v.value");
        //alert(week);
        }else{
             var week = null;
        }
        //var Status = component.find("PStatus").get("v.value");
        var Description = component.find("PDescription").get("v.value");
        var Blendedcheckbox = component.find("Blendedcheckbox").get("v.value");
        //alert(Blendedcheckbox);
        var BRate = component.find("BRate").get("v.value");
        //alert(BRate);
        
         //alert(Description);
        //Validation logic 
        
         var action = component.get("c.PhaseNameValidation");
        
        action.setParams({
            recoId   : recID,
            AName    : Name
           
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var data = response.getReturnValue();
               // alert(data);
                if(data){
                  //Error Msg
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Phase Name already Exist',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                }else{
            
                    
                    var action = component.get("c.InsertPhaseFn");
                    
                    action.setParams({
                        recoId   : recID,
                        AName    : Name,
                        Aweek    : week,
                        ADescription : Description,
                        ABlendedcheckbox : Blendedcheckbox,
                        ABRate:  BRate
                        
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if (state == "SUCCESS") {
                            var data = response.getReturnValue();
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'Phase ' + Name +' added succesfully',
                                messageTemplate: 'Record {0} created! See it {1}!',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }
                        else if(state == "ERROR"){
                            var errors = response.getError();                       
                            component.set("v.showErrors",true);
                            component.set("v.errorMessage",errors[0].message);
                        }
                    });
                    $A.enqueueAction(action);
                    
                    var evt = $A.get("e.c:AddPhaseConection");
                    evt.setParams({ 
                    });
                    evt.fire();
                    
                    component.set('v.editVisible1',false);
                    
                }
            
        });
        $A.enqueueAction(action);
        
    },
    CancelPhase : function(component, event, helper){
        component.set("v.Name", "");
        component.set('v.editVisible1',false);
    }
})