({
	"initSettings":function(cmp,event,callbackFn){
        var action = cmp.get("c.initializeSettings");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set("v.settings", response.getReturnValue());
                console.log(new Date()+' - Settings fetched and initialized');
                console.log(new Date()+' - callbackFn !=null : '+(callbackFn!=null?"Yes":"No"));
                if(callbackFn){
                    callbackFn(cmp,event);
                }
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
        
    },
    "parseUrlAndSendEvent": function(theUrl,theUrlQryStr,cmp,event){
        var settings = cmp.get('v.settings');
        cmp.set('v.tabUrl',theUrl);
        cmp.set('v.tabUrlParams',theUrlQryStr);
        if(!settings){
            this.initSettings(cmp,event,this.parseUrlAndSendEventCallback);
        }else{
            this.parseUrlAndSendEventCallback(cmp,event);
        }
               
    },
    "parseUrlAndSendEventCallback":function(cmp,event){
		var evtLoc = cmp.get('v.tabUrl');
        var evtQryString = cmp.get('v.tabUrlParams');
        if(evtQryString){
            evtQryString.substring(1);
        }
        var settings = cmp.get('v.settings');
        
        console.log(new Date()+' - path = '+evtLoc+',queryString = '+evtQryString);
        var breadCrumbMatch;
        for(var i=0;i<settings.urlMappings.length;i++){
            var theUrl = settings.urlMappings[i];
            var urlRegEx = new RegExp(theUrl.lightningbuddy__Url__c);
            var myArray = urlRegEx.exec(evtLoc);
            var qryStrArray;
            var urlMatch=false,
                qryStringMatch=false;
            if(myArray){
                urlMatch=true;
            }
            if(myArray && theUrl.lightningbuddy__Query_String__c && evtQryString){
                var qryStrMatch = new RegExp(theUrl.lightningbuddy__Query_String__c);
                qryStrArray = qryStrMatch.exec(evtQryString);
                if(qryStrArray){
                    qryStringMatch=true;
                }
            }
            if(urlMatch || qryStringMatch){
                breadCrumbMatch = new Object();
                breadCrumbMatch.eventType = theUrl.MasterLabel;
                breadCrumbMatch.eventObject = myArray[1];
                if(myArray.length == 3){
                    breadCrumbMatch.recordId=myArray[2]
                }
                if(!breadCrumbMatch.eventObject && theUrl.lightningbuddy__Object__c){
                    breadCrumbMatch.eventObject = theUrl.lightningbuddy__Object__c;
                }
                if(qryStringMatch){
                    breadCrumbMatch.queryStringParams =qryStrArray[1]; 
                }
                break;
            }
        }
        
        if(breadCrumbMatch){
            console.log('breadCrumbMatch:\n'+JSON.stringify(breadCrumbMatch,null,4));        
            console.log('about to fire an Buddy action ...');
            var appEvent = $A.get("e.c:BuddyEvent");
            var currentTabId = event.getParam('currentTabId');
            var eventParams = { 
                object:breadCrumbMatch.eventObject,
                pageType:breadCrumbMatch.eventType,
                recordId:breadCrumbMatch.recordId,
                consoleTabId:currentTabId
            };
            if(breadCrumbMatch.queryStringParams){
                eventParams.record={"fields":{
                                        "filterName":{
                                            "value":breadCrumbMatch.queryStringParams
                                        }
                					}
                                   };
            }
            appEvent.setParams(eventParams);
            appEvent.fire();              
        }         
    }
})