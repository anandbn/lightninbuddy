({
    doInit: function(component, event, helper){
        var popoverClass = "mypopover" + Math.floor(Math.random() * Math.floor(100));
		component.set("v.popoverElementClass", popoverClass);
        var appEvent = $A.get("e.c:RegisterPopoverEvent");
        appEvent.setParams({ 
            popoverElementClass:popoverClass
        });
        appEvent.fire();  
        console.log(new Date()+' - Register popover event fired....');
    },
    handleShowPopover : function(component, event, helper) {
        console.log(new Date()+' - Handle popover event called....');
 		var popoverClass = event.getParam('popoverElementClass');
        if(component.get('v.popoverElementClass') != popoverClass){
            return;
        }
        component.find('overlayLib').showCustomPopover({
            body: event.getParam('popoverText'),
            referenceSelector:  "." + popoverClass,
            cssClass: "slds-p-around_x-small,popoverclass,slds-popover,slds-popover_walkthrough,slds-popover_feature,slds-nubbin_left,no-pointer,cPopoverTest"
        }).then(function (overlay) {
            setTimeout(function(){ 
                //close the popover after 3 seconds
                overlay.close(); 
            }, 3000);
        });
    }
})