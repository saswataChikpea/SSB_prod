({
    ResCard : function(component, event, helper) {
        var recID = component.get("v.recordId");
        //component.set("v.reloadForm", true);
        var action = component.get('c.getResc');
        action.setParams({
            recordId : recID             
        });
        action.setCallback(this, function(response){
            var response= response.getReturnValue();
            if(response.length > 0){
                for(var i=0 ;response.length > i; i++ ){
                 /*   var sf = staffresponse.filter(function(element){
                        
                        return response[i].ChikPeaSSB__Item__r.Name == element.ChikPeaSSB__Staff_Roles__c;
                    })
                    if(sf.length > 0){
                        response[i].staffDetails = sf;
                    }*/
                    //response[i].cardvisble = true;   
                    response[i].HideEdit = true;
                }
                if(response[0].ChikPeaSSB__Phase__r.ChikPeaSSB__Weeks__c > 0)
                {
                    component.set('v.hide' , "true");
                    component.set('v.hideEst' , "false");
                } 
            }
            component.set("v.Reslist",response);
            component.set("v.Reslist1", response);
            //$A.get('e.force:refreshView').fire();
        });
      

       var staffresponse;
        var action1 = component.get('c.getRescStaffing');        
        action1.setCallback(this, function(response){
            var response1 = response.getReturnValue();
            if(response1.length > 0){
                 staffresponse = response1;
            }            
        });
        $A.enqueueAction(action1);
          $A.enqueueAction(action);
                
        
    },
    handleNumberChange: function(component, event, helper){        
        component.set("v.Numbersuport", 789);                  
    },
    onstaffchange:function(component, event, helper){
       var selectrole = component.find("mySelect").get("v.value");
        var selectresid = component.find("resourceid").get("v.value");
        
         
        
        
        alert('99219--'+selectrole);
        alert('99219'+selectresid);
        
  },
    
    EditPhaseCard : function (component, event, helper){
        var Phaseidx = event.target.id;  
        console.log('Phaseidx---'+Phaseidx);
        component.set('v.Resourceidd',Phaseidx);
        var loadvalues = component.get('v.Reslist');  
        console.log('loadvalues---'+loadvalues);
        
        var loadvalues = component.get('v.Reslist1');  
        var index = loadvalues.findIndex(x => x.Id === Phaseidx);
        console.log('index---'+index);
        
        //alert(loadvalues[index].HideEdit);
        if(loadvalues[index].HideEdit == true){
            loadvalues[index].HideEdit = false;
        }
        component.set('v.Reslist',loadvalues);    
        var recID = component.get("v.recordId");
        var action = component.get("c.getStaffRole");
         action.setParams({
            recordId: recID,
            ResId : Phaseidx
        });
            action.setCallback(this, function(response){
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
                console.log('array size'+ items.length);
                if(items.length == 0){
                    var item1 ={
                        "label" : "None",
                        "value": "None"
                   
                    }
                  items.push(item1) ;
                }
             component.set("v.StaffOptions", items);
            /*var item = {
                "label": '',
                "value": null
            };
            items.push(item);*/
            
           // component.set("v.StaffOptions", items);
            
            
             });
        $A.enqueueAction(action);
        
    },
   Invitestaff: function(component, event, helper) {
        var msg ='Are you sure you want to send invite?';
        if (!confirm(msg)){
            console.log('No');
            return false;
        } else {
            var RessID = event.target.id;
            //alert ('Phaseid---'+Phaseidx);
            var action = component.get("c.ToSendInvite");
            action.setParams({
                Resid : RessID
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                 });
            $A.enqueueAction(action);
            
        }
    },
    
    cancelcard : function(component, event, helper)
    {
        var action = component.get('c.ResCard');
       $A.enqueueAction(action);
    },
    
    Isdelete : function (component, event){
        var Phaseidx = event.target.id;
        //alert(Phaseidx);
        var PhaseName = event.target.Name;
        var msg ='Are you sure you want to delete this Resourse?';
        if (!confirm(msg)){
            console.log('No');
            return false;
        } else {
            
            
            var action = component.get("c.DeleteResValdiation");
            action.setParams({
                Phaseid : Phaseidx
            });
            
            
            action.setCallback(this, function(response){
                var state = response.getState();
                var data = response.getReturnValue();
                //  alert(data);
                if(data){
                    var action = component.get("c.DeleteRes");
                    action.setParams({
                        Phaseid : Phaseidx
                    });
                    
                    
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        var data = response.getReturnValue();
                        if (state == "SUCCESS") {
                            var data = response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'Resource Deleted succesfully',
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
                        var action = component.get('c.ResCard');
                        $A.enqueueAction(action);
                    });
                    $A.enqueueAction(action);
                    //$A.get('e.force:refreshView').fire();
                }else{
                    // error message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Resource cannot be deleted as it has stagings data',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                
                
            });
            $A.enqueueAction(action);
        }
        
    },
    Actual : function (component, event){
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:",
            componentAttributes: {
                // Attributes here.
            }
        });
        evt.fire(); 
    },
    
    getDetail : function(component, event, helper) {
        
        component.set('v.Buttonshelp','Divert');
        var recid = event.target.id;
        //alert(recid +'Parent id');
        var evt = $A.get("e.c:ResourseStgings");
        evt.setParams({
            
            "ResrecordId": recid
            
        });
        evt.fire();
        
    },
    
    
    UpdateRes : function(component, event, helper){
        if(component.get('v.Buttonshelp') != 'Divert')
        {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: 'Resource Updated succesfully',
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
        
        
    },
    
    Redirect : function(component, event, helper) { 
        var Phaseidx = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "detail"
        });
        navEvt.fire();
        //var href = event.srcElement.href;
    },
    displaySection1 : function(component, event, helper) {
        component.set("v.displayedSection","section1");
        var section1InputValue = component.find("sec1value");
        console.log('***section1InputValue: '+section1InputValue);
        var section2InputValue = component.find("sec2value");
        console.log('***section2InputValue: '+section2InputValue);
        /**/
        var section1InputValue = document.getElementById("myDIV");
        
        if (section1InputValue.style.display === "block") {
            section1InputValue.style.display = "none";
        } else {
            section1InputValue.style.display = "block";  
        }
    },
    
    handlestaffChange : function(component, event, helper){
        var recID = component.get("v.Resourceidd");
         var selectstaff = event.getParam("value");
        //alert(selectstaff);
        //alert(recID);
         var action = component.get("c.OnChangeStaff");
         action.setParams({
             recordId: recID,
             Seltdstaff : selectstaff
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
        });
        $A.enqueueAction(action);   

    },
    Redirects : function(component, event, helper) { 
        
        $A.get('e.force:refreshView').fire();  
        //location.reload();
        /* var Phaseidx = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "detail"
        });
        navEvt.fire();*/
            //var href = event.srcElement.href;
        }
    //handleRefresh : function(component, event, helper)
    
})