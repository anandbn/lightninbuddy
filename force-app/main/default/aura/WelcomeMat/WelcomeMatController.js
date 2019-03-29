({
    initialize:function(cmp,event,helper){
        if(cmp.get('v.tileConfigJson') !=null && cmp.get('v.tileConfigJson')!="" && cmp.get('v.tileConfigJson').length > 0){
            cmp.set('v.tiles',JSON.parse(cmp.get('v.tileConfigJson')));
			
        }
    },
    closeWelcomeMat : function(cmp, event, helper) {
        if(cmp.get('v.doNotShowAgain') || cmp.get('v.showOnlyOnce')){
            var action = cmp.get("c.dismissActionForever");
            action.setParams({ 
                actionId:cmp.get('v.actionId'),
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
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
        }
       cmp.destroy();
    },
    toggleDoNotShow : function(cmp, event, helper) {
        cmp.set('v.doNotShowAgain',!(cmp.get('v.doNotShowAgain')));
    },
})