({
    toggleVisibility : function(cmp, event, helper) {
        helper.toggleAttributeAndFireEvent(cmp,event,'v.isOpen');
    },
    toggleExpansion : function(cmp, event, helper) {
        //When you expand, you also set to to maximize
        if(!cmp.get('v.isExpanded')){
            cmp.set('v.isOpen',true);
        }
        helper.toggleAttributeAndFireEvent(cmp,event,'v.isExpanded');
    } ,
    closeComposer:  function(cmp, event, helper){
        var dockCmpEvent = cmp.getEvent("dockCmpEvent");
        dockCmpEvent.setParams({
            "destroy":true
        });
        dockCmpEvent.fire();

    }
})
