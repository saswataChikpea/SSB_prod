({
    CardView: function (component, event, helper) {
        //console.log('recordId', component.get('v.recordId'));
        var action = component.get('c.getProjects');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS' && component.isValid()) {
                //get contact list                
                //debugger
                var result = response.getReturnValue();
                for (var i = 0; result.length > i; i++) {
                    result[i].cardvisble = false;
                    result[i].cardvisble1 = false;
                }
                component.set('v.PrjList', result);
            } else {
                alert('ERROR...');
            }
        });
        $A.enqueueAction(action);
    },
    AccordinView: function (component, event, helper) {

        var action = component.get('c.getPhase');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS' && component.isValid()) {
                //get contact list
                component.set('v.PhResLst', response.getReturnValue());
            } else {
                alert('ERROR...');
            }
        });
        $A.enqueueAction(action);
    },

    NewProject: function (component, event, helper) {
        //  var PrjName = component.find("PrjName").get("v.value");
        // var AccName = component.find("AccName").get("v.value");
        // console.log('PrjName', PrjName, AccName);
        /*
           var Recid = event.target.id;
           //alert(Recid);
           // var name_element = document.getElementById(Recid+'_T01').value; 
           //alert(name_element);
           
          var PrjName  = component.find("PrjName").get("v.value");
          var AccName  = component.find("AccName").get("v.value");
          
           //var param = event.getParams(); //get event params
          // var fields = param.response.fields; //get all field info
           //console.log('FirstName-' + fields.FirstName.value);
           //component.set(Recid);	
         //  alert(fields.Name.value);
           //alert(fields.Account__c.value);
          
           
           
           
         if(PrjName == null || AccName == null){
             
               var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       message: 'Please enter the project Name or Select the Account',
                       messageTemplate: 'Record {0} created! See it {1}!',
                       duration:' 5000',
                       key: 'info_alt',
                       type: 'error',
                       mode: 'pester'
                        });
                   toastEvent.fire();
               
           }else {
                
               var action = component.get("c.NewProjectApx");
               action.setParams({
               recordId  : Recid,
               Pname     : PrjName,
               Accid     : AccName
               
           });
           
           action.setCallback(this, function(response){
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
                       duration:' 5000',
                       key: 'info_alt',
                       type: 'success',
                       mode: 'pester'
                   });
                   toastEvent.fire();
               }
               else if(state == "ERROR"){
                   var errors = response.getError(); 
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       message: 'Something went wrong!',
                       messageTemplate: 'Record {0} created! See it {1}!',
                       duration:' 5000',
                       key: 'info_alt',
                       type: 'error',
                       mode: 'pester'
                        });
                   toastEvent.fire();
   
               }
           });
           $A.enqueueAction(action);
           }
           */
        var Phaseidx = event.target.id;
        console.log('Phaseidx', Phaseidx);
        var loadvalues = component.get('v.PrjList');
        console.log('1st loadvalues',loadvalues);
        var index = loadvalues.findIndex(x => x.Id === Phaseidx);
        console.log('index', index);
        if (loadvalues[index].cardvisble1 === false) {
            loadvalues[index].cardvisble1 = true
        }
        else {
            loadvalues[index].cardvisble1 = false;
        }
      //  loadvalues[index].cardvisble1 === false ? loadvalues[index].cardvisble1 = true : loadvalues[index].cardvisble1 = false;
        console.log('2nd loadvalues',loadvalues);
        component.set('v.PrjList', loadvalues);
        console.log('end');

    },
    PhaseRedirect: function (component, event, helper) {

        var Phaseidx = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Phaseidx,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    Showphase: function (component, event, helper) {

        debugger
        var Phaseidx = event.target.id;
        var loadvalues = component.get('v.PrjList');

        var index = loadvalues.findIndex(x => x.Id === Phaseidx);
        loadvalues[index].cardvisble == false ? loadvalues[index].cardvisble = true : loadvalues[index].cardvisble = false;
        component.set('v.PrjList', loadvalues);

    },

    Isdelete: function (component, event) {
        var Phaseidx = event.target.id;
        //alert(Phaseidx);
        var PhaseName = event.target.Name;
        var msg = 'Are you sure you want to delete this Template ?';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            console.log('Yes');
        }
        var action = component.get("c.RemoveTemplate");

        action.setParams({

            Tempid: Phaseidx

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();

            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Template Deleted succesfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration: ' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else if (state == "ERROR") {
                var errors = response.getError();
                component.set("v.showErrors", true);
                component.set("v.errorMessage", errors[0].message);
            }

            var action = component.get('c.CardView');
            $A.enqueueAction(action);
        });
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
    },
    doInit: function (component, event, helper) {
        var record_id = component.get("v.pageReference").state.c__id;
        console.log('Opportunity log TemplateController doInit: ' + record_id);

        component.set("v.recordId", record_id);
        console.log('recordId', component.get('v.recordId'));
    }

})