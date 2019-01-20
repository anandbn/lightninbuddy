({
    "doInit":function(cmp,event,helper){
        helper.initSettings(cmp,event);
    },
    "onTabCreated" : function(cmp, event, helper) {
        console.log("Tab created.");
        var newTabId = event.getParam('tabId');
        var workspaceAPI = cmp.find("workspace");
        var tabIdAndEvents = cmp.get('v.tabIdAndEvents');
        tabIdAndEvents[newTabId]='TabCreated';        
    },
    "onTabFocused" : function(cmp, event, helper) {
        console.log("Tab focussed.");
        var focussedTabId = event.getParam('currentTabId');
        
        if(focussedTabId){
            var tabIdAndEvents = cmp.get('v.tabIdAndEvents');
            var tabCreateEvent = tabIdAndEvents[focussedTabId];
            if(tabCreateEvent && tabCreateEvent === 'TabCreated'){
                tabIdAndEvents[focussedTabId]=undefined;
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getTabURL({
                    tabId: focussedTabId
                }).then(function(tabUrl) {
                    const theUrl = new URL(tabUrl);
                    helper.parseUrlAndSendEvent(tabUrl,null,cmp,event);
                }); 
            }       
                          
        }
        
    },
    "handleLocationChangeEvent":function(cmp, event, helper) {
        var evtLoc = window.location.pathname;
        var evtQryString = window.location.search;
        console.log(new Date()+' - path = '+evtLoc+',queryString = '+evtQryString);
		helper.parseUrlAndSendEvent(evtLoc,evtQryString,cmp,event);
    }
})