({
    
    loadContactList: function(component, event, helper){
       helper.onLoad(component, event);
    },
    
        downloadCsv : function(component,event,helper){
                    var stockData = component.get("v.ListOfprojects");
                    var csv = helper.convertArrayOfObjectsToCSV(component,stockData); 


        }
    
})