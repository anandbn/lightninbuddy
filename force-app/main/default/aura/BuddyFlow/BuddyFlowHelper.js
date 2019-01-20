({
    storeUserPreference : function(cmp, event) {
        //Store the user preference that they don't want to see 
        //this action again.
        var action = cmp.get("c.dismissActionForever");
        action.setParams({ 
            actionId:cmp.get('v.actionId'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.find("overlayLib").notifyClose();
                console.log('User Preference updated successfully !!!');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
        cmp.find("overlayLib").notifyClose();		
    },
    finishedClicked : function(cmp,event){
        if(cmp.get('v.showOnlyOnce')){
            this.storeUserPreference(cmp,event);
        }else{
            cmp.find("overlayLib").notifyClose();
        }
        
    }
})