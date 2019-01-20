({
    "afterLodashLoaded":function(cmp,event,helper){
        window.lodash = window._;
    },
    "doInit":function(cmp,event,helper){
		helper.initSettings(cmp,event);
    },
    "handleLocationChangeEvent":function(cmp, event, helper) {
        helper.saveBreadCrumbEvent(cmp,event);
    }
})