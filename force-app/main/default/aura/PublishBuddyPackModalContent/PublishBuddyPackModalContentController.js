({
	"publishAction" : function(cmp, event, helper) {
		var publishEvent = $A.get("e.c:BuddyPackPublishEvent");
        publishEvent.setParams({
            "packName":cmp.get('v.packName'),
            "description":cmp.get('v.description')
        });
        publishEvent.fire();
        cmp.find('overlayLib').notifyClose();

	}
})