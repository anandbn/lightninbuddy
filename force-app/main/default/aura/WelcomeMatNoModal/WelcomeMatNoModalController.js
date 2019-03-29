({
    initialize:function(cmp,event,helper){
        if(cmp.get('v.tileConfigJson') !=null && cmp.get('v.tileConfigJson')!="" && cmp.get('v.tileConfigJson').length > 0){
            cmp.set('v.tiles',JSON.parse(cmp.get('v.tileConfigJson')));
			
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