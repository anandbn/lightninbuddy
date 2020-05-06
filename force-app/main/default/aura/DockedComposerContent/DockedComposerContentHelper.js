({
    toggleAttributeAndFireEvent : function(cmp,event,attributeName) {
        cmp.set(attributeName,!(cmp.get(attributeName)))
        var dockCmpEvent = cmp.getEvent("dockCmpEvent");
        dockCmpEvent.setParams({
            "isOpen" : cmp.get('v.isOpen'),
            "isExpanded":cmp.get('v.isExpanded')
        });
        dockCmpEvent.fire();

    }
})
