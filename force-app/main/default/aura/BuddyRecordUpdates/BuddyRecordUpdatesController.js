({
    "recordUpdated" : function(cmp, event, helper) {
        
        helper.handleRecordUpdated(cmp,event);
    },
    "handleSubTabEvent" : function(cmp, event, helper) {
        if(!cmp.get('v.subtabClickEventSent')){
            helper.objectSubtabClicked(cmp,event);
        }
        cmp.set('v.subtabClickEventSent',true)
    },
})