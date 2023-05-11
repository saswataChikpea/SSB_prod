({
    myAction : function(component, event, helper){
        var quoteId = component.get('v.recordId');
        var QuoteList = [];
        QuoteList.push(quoteId);
        var action = component.get('c.quoteToOrder');
        action.setParams({"qidList":QuoteList});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            var orderID = response.getReturnValue();
            console.log(orderID);
            if (state === "SUCCESS") {
                if(orderID == 'Cannot convert to Order. Quote\'s Status is not Open'){
                    alert(orderID);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
        			dismissActionPanel.fire();
                }else{
                    debugger
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": quoteId
                    });
                    navEvt.fire();
                    
                     $A.get('e.force:refreshView').fire();  
                    location.reload();
                    
                }
            }
            else if (state === "ERROR") {
                alert("error");
                console.log(actionResult.getError());
                alert(actionResult.getError());
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    }
})