({
    "handleBuddyEvent" : function(cmp, event, helper) {
        console.log(new Date()+' - Lightning Buddy Event received');
        //console.log('Lightning Buddy Event received:\n'+JSON.stringify(event.getParams(),null,4))
        var consoleTabId = event.getParam('consoleTabId');
        var tabsAndEvents = cmp.get('v.tabsAndEvents');
        if(consoleTabId!=null && tabsAndEvents[consoleTabId] !=null){
            //We processed the event for this tab already
            return;
        }
        cmp.set('v.object',event.getParam('object'));
        cmp.set('v.pageType',event.getParam('pageType'));
        cmp.set('v.recordId',event.getParam('recordId'));
        cmp.set('v.record',event.getParam('record'));
        cmp.set('v.objectSubTab',event.getParam('objectSubTab'));
        cmp.set('v.customCriteriaEvaluated',event.getParam('customCriteriaEvaluated'));
        if(cmp.get('v.pageType')==='Record Detail' && 
            cmp.get('v.record') == null &&
            (cmp.get('v.object')!='Dashboard' && cmp.get('v.object')!='Report')){
            //For record detail, don't do anything if there's no record data
            //The BuddyRecordUpdate should fire the same event with the record data
            return;
        }
        var userInfo = cmp.get('v.userInfo');
        if(!userInfo){
            var getUsrInfoAction = cmp.get('c.getLoggedInUser');
            var usrPromise = helper.executeAction(cmp,getUsrInfoAction);
            usrPromise.then(
                $A.getCallback(function(result){
                    cmp.set('v.userInfo',result);
                    var getAction = cmp.get("c.getAction");
                    getAction.setParams({ 
                        objName: cmp.get('v.object'),
                        pageType: cmp.get('v.pageType'),
                        recordId: cmp.get('v.recordId'),
                        objectSubTab: cmp.get('v.objectSubTab')
                    });
                    var actionPromise = helper.executeAction(cmp, getAction);
                    return actionPromise;
                })
            ).then(
                $A.getCallback(function(result){
                    helper.afterUserInfoCallback(result,cmp,event);
                })
                
            ).catch(
                $A.getCallback(function(error){
                    console.log('An error occurred : ' + error.message);
                }) 
            );            
        }else{
            var getAction = cmp.get("c.getAction");
            getAction.setParams({ 
                objName: cmp.get('v.object'),
                pageType: cmp.get('v.pageType'),
                recordId: cmp.get('v.recordId'),
                objectSubTab: cmp.get('v.objectSubTab')
            });
            var actionPromise = helper.executeAction(cmp, getAction);
			actionPromise.then(
                $A.getCallback(function(result){
                    helper.afterUserInfoCallback(result,cmp,event);
                })
            );
            
        }
        
    },
    "handleShowPopover" : function(cmp, event, helper) {
        
        var appEvent = $A.get("e.c:ShowPopoverEvent");
        appEvent.setParams({ 
            popoverText:cmp.get('v.popoverMsgToSend'),
            popoverElementClass: cmp.get('v.popoverElementClass')
        });
        appEvent.fire();  
    },
    "handleRegisterPopover" : function(cmp, event, helper) {
        helper.handlePopoverRegistration(cmp,event);
        
    }
})