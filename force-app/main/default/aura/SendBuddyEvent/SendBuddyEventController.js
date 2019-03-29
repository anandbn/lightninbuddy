({
    sendBuddyEvent : function(component, event, helper) {

        window.setTimeout(  
            $A.getCallback(function() {
                var appEvent = $A.get("e.c:BuddyEvent");
                var eventParams = { 
                    object:component.get('v.object'),
                    pageType:component.get('v.pageType'),
                    objectSubTab:component.get('v.objectSubTab')
                };
                appEvent.setParams(eventParams);
                appEvent.fire();
                
            }), 3000
        );
        

    }
})