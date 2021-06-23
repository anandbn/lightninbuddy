({
    initialize:function(cmp,event,helper){
        if(cmp.get('v.tileConfigJson') !=null && cmp.get('v.tileConfigJson')!="" && cmp.get('v.tileConfigJson').length > 0){
            cmp.set('v.tiles',JSON.parse(cmp.get('v.tileConfigJson')));
			
        }
    },
	
     onClick: function (cmp, event, helper) {
        var link = event.currentTarget.dataset.href;
        var urlEvent = $A.get("e.force:navigateToURL");
        var internalString = $A.get('$Label.c.InternalString');
        if (link == null || link == undefined || link == 'null') {
            // do nothing
        } else if (link.includes(internalString)) {
            urlEvent.setParams({
                "url": link
            });
            urlEvent.fire();
            cmp.destroy();
        } else {
            urlEvent.setParams({
                "url": link,
                "target": "_blank"
            });
            urlEvent.fire();
        }
    },
	
    closeWelcomeMat : function(cmp, event, helper) {
        if(cmp.get('v.doNotShowAgain') || cmp.get('v.showOnlyOnce')){
            helper.dismissClicked(cmp,event);
        }
       cmp.destroy();
    },
    toggleDoNotShow : function(cmp, event, helper) {
        cmp.set('v.doNotShowAgain',!(cmp.get('v.doNotShowAgain')));
    },
})
