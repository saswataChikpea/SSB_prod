({
    downloadXmlFile : function(component,event) {
        console.log('downloadXmlFile : project_id:'+component.get('v.recordId'));
        //call apex class method
        var action = component.get('c.generateXmlForThirdParty');
        action.setParams({
            'project_id' : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-dd_HH:mm:ss");
            var file_name = 'Generated_XML_'+today+'_.xml';
            console.log('file_name : '+file_name);
            console.log('state :'+state);
            if (state === "SUCCESS") {
                console.log('Response : '+response.getReturnValue());
                //****
                if (response.getReturnValue() == null){return;} 
        
                // ####--code for create a temp. <a> html tag [link tag] for download the xml file--####     
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/xml;charset=utf-8,' + encodeURI(response.getReturnValue());
                hiddenElement.target = '_self'; // 
                hiddenElement.download = file_name;  // xml file Name* you can change it.[only name not .xml] 
                document.body.appendChild(hiddenElement); // Required for FireFox browser
                hiddenElement.click(); // using click() js function to download xml file
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }else {
                console.log('Error occurred.');
            }
        });
        $A.enqueueAction(action);
    }
})