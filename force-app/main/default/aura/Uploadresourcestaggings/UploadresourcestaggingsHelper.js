({
    CSV2JSON: function (component,csv) {
        
        console.log('@@@ Incoming csv = ' + csv);
        
        //var array = [];
        var arr = []; 
        
        arr =  csv.split('\n');;
        //console.log('@@@ Array  = '+array);
        console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        console.log('@@@ json = '+ json);
        return json;
        
        
    },
    
    CreateAccount : function (component,jsonstr){
        debugger
        console.log('@@@ jsonstr' + jsonstr);
        var UsageJSONdata = JSON.parse(jsonstr);
        if(UsageJSONdata.length > 0){
            for(var i=0 ; i<UsageJSONdata.length; i++){                            
                              
            }            
            var myUsageJSON = JSON.stringify(UsageJSONdata);  
        }
         ;
        var action = component.get("c.insertData");        
        action.setParams({
            "strfromlex" : myUsageJSON
            
        });
                        component.set("v.Likedisable",false);


        action.setCallback(this, function(response) {            
            var state = response.getState();            
            //var state1 = re sponse.getReturnValue(); 
            $A.get("e.force:closeQuickAction").fire();          
            if (state == "SUCCESS")
            {  
                //alert("Usage stagingd Inserted Succesfully");    
                $A.get("e.force:closeQuickAction").fire();
                //$A.get('e.force:refreshView').fire();                                        
                this.successmessage();
            }
            if (state == "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                    alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(action);    
        
    },
    successmessage : function (){
        
        var resultsToast = $A.get("e.force:showToast");                         
        resultsToast.setParams({
            "title": "Success",
            "message": "Hours Uploaded Succesfully",
            "type" : "success"                    
            //alert("Usage stagingd Inserted Succesfully");  */                   
        });                
        resultsToast.fire();
        $A.get("e.force:closeQuickAction").fire();
        
    }
    
})