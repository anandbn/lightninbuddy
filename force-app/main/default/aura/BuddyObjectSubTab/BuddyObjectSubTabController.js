({
    sendBuddyEvent : function(cmp, event, helper) {
        var appEvent = $A.get("e.c:ObjectSubtabClickedEvent");
        var eventParams = { 
            object:cmp.get('v.objectName'),
            pageType:'Record Detail',
            objectSubTab:cmp.get('v.subTabName')
        };
        appEvent.setParams(eventParams);
        console.log(new Date() +' - Sending object subtab clicked event');
        appEvent.fire();              
    }
})