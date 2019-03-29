({
    "executeAction": function(cmp, action, callback) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    "afterUserInfoCallback": function(result,cmp,event){
        var usrInfo = cmp.get('v.userInfo');
        var actions = result;
        var customCriteriaEvaluated = cmp.get('v.customCriteriaEvaluated');
        if(actions){
            for(var i=0;i<actions.length;i++){
                var actionToShow = actions[i];
                if(actionToShow){
                    if(this.isEnabledForProfile(usrInfo,actionToShow)){
                        if(!actionToShow.lightningbuddy__Use_Custom_Criteria_Handler__c && this.meetsRecordCriteria(actionToShow,cmp)){
                            this.handleAction(cmp,event,actionToShow);
                            break;
                        }else if(actionToShow.lightningbuddy__Use_Custom_Criteria_Handler__c){
                            if (customCriteriaEvaluated) {
                                this.handleAction(cmp, event, actionToShow);
                                break;
                            }else{
                                //Need to fire the custom criteria event
                                var appEvent = $A.get("e.c:CustomCriteriaEvent");
                                var eventParams = {
                                    object: cmp.get('v.object'),
                                    pageType: cmp.get('v.pageType'),
                                    recordId: cmp.get('v.recordId'),
                                    record: cmp.get('v.record'),
                                    objectSubTab: cmp.get('v.objectSubTab')

                                };
                                appEvent.setParams(eventParams);
                                appEvent.fire();
                            }

                
                        }
                    }
                }                    
            }                    
        }
    },
    "handleAction": function(cmp,event,action){
        var consoleTabId = event.getParam('consoleTabId');
        var tabsAndEvents = cmp.get('v.tabsAndEvents');
        if(consoleTabId){
            tabsAndEvents[consoleTabId]=true;
        }else{
            var currentTime = new Date().getTime();
            var evtKey= cmp.get('v.object')+'-' +cmp.get('v.pageType')+'-'+cmp.get('v.objectSubTab');
            tabsAndEvents[evtKey]=currentTime;
        }

        var modalBody,modalFooter;
        var showOnlyOnce = (action.lightningbuddy__Recurrence__c=='Only once'?true:false);
        if(action && action.RecordType.Name === 'Rich Text'){
            $A.createComponents([
                ["c:ModalContent",{"modalContent":action.lightningbuddy__Action_Text__c}],
                ["c:ModalFooter",{"actionId":action.Id,"showOnlyOnce":showOnlyOnce}]
            ],function(components , status) {
                if (status === "SUCCESS") {
                    modalBody = components[0];
                    modalFooter = components[1]
                    cmp.find('overlayLib').showCustomModal({
                        header:action.Name,
                        body: modalBody,
                        footer:modalFooter,
                        showCloseButton: false
                    });
                }                               
            }
                               );                    
        }else if(action && action.RecordType.Name === 'File'){
            $A.get('e.lightning:openFiles').fire({
                recordIds: [action.lightningbuddy__File_Id__c]
            });
            
        }else if(action && action.RecordType.Name === 'Popover'){
            cmp.set('v.popoverMsgToSend',action.lightningbuddy__Popover_Text__c);
        }else if(action && action.RecordType.Name === 'Image Carousel'){
            $A.createComponents([
                				["c:ImageCarousel", {"cardInfo":action.lightningbuddy__Image_Carousel_Config__c}],
                				["c:ModalFooter",{"actionId":action.Id,"showOnlyOnce":showOnlyOnce}]
                			   ],
                               function(components , status) {
                                   if (status === "SUCCESS") {
                                       modalBody = components[0];
                                       modalFooter = components[1]
                                       cmp.find('overlayLib').showCustomModal({
                                           header: action.Name,
                                           body: modalBody, 
                                           footer:modalFooter,
                                           showCloseButton: true
                                       })
                                   }                               
                               }
                              );                      
        }else if(action && action.RecordType.Name === 'Video'){
            $A.createComponents([["c:Video", 
                                                   {
                                                       "videoSrc":action.lightningbuddy__Video_Link__c,
                                                       "videoType":action.lightningbuddy__Video_Type__c
                                                   }
                                 ],
                                 ["c:ModalFooter",{"actionId":action.Id,"showOnlyOnce":showOnlyOnce}]
 							   ],
                               function(components , status) {
                                   if (status === "SUCCESS") {
                                       modalBody = components[0];
                                       modalFooter = components[1]
                                       cmp.find('overlayLib').showCustomModal({
                                           header: action.Name,
                                           body: modalBody,
                                           footer:modalFooter,
                                           showCloseButton: true
                                       })
                                   }                               
                               }
                              );                      
        }else if(action && action.RecordType.Name === 'Object Quick Action'){
            var actionAPI = cmp.find("quickActionAPI");
            var args = {actionName: cmp.get('v.object')+'.'+action.lightningbuddy__Quick_Action_API_Name__c,
                        entityName: cmp.get('v.object')};
            actionAPI.selectAction(args).then(function(result) {
                console.log('Quick action invoked...');
            }).catch(function(e){
                if(e.errors){
                    console.log('Error invoking quick action:'+e.errors);
                    //If the specified action isn't found on the page, show an error message in the my component 
                }
            });       
            
        }else if(action && action.RecordType.Name === 'Flow'){
            var modalBody;
            var cmpParams = {	"flowName":action.lightningbuddy__Lightning_Flow_API_Name__c,
                    "actionId":action.Id,
                    "showOnlyOnce":showOnlyOnce
            };
            if(action.lightningbuddy__Record_Id_as_Input_Variable__c){
                cmpParams.recordId=cmp.get('v.recordId');
            }

            $A.createComponents([
                ["c:BuddyFlow",cmpParams],
            ],function(components , status) {
                if (status === "SUCCESS") {
                    modalBody = components[0];
                    cmp.find('overlayLib').showCustomModal({
                        header: action.Name,
                        body: modalBody,
                        showCloseButton: false
                    });
                }                               
            });            
        }else if(action && action.RecordType.Name === 'Welcome Mat'){
            var appEvent = $A.get("e.c:ShowWelcomeMat");
            var eventParams = {
                "title":action.lightningbuddy__Welcome_Mat_Title__c,
                "bodyText":action.lightningbuddy__Welcome_Mat_Body__c,
                "backgroundImgUrl":action.lightningbuddy__Welcome_Mat_Background_Image__c,
                "tileConfigJson":action.lightningbuddy__Welcome_Mat_Tile_Config__c,
                "actionId":action.Id,
                "showOnlyOnce":showOnlyOnce
            };
            appEvent.setParams(eventParams);
            appEvent.fire();
                                 
        }else if(action && action.RecordType.Name === 'Toaster Alert'){
            var toastEvent = $A.get("e.force:showToast");
            var alertParams = {
                mode: action.lightningbuddy__Toaster_Alert_Mode__c,
                key: action.lightningbuddy__Toaster_Alert_Icon__c,
                type:action.lightningbuddy__Toaster_Alert_Type__c,
                title:action.lightningbuddy__Toaster_Alert_Title__c,
                message: action.lightningbuddy__Toaster_Alert_Message__c,
                duration: action.lightningbuddy__Toaster_Alert_Duration__c*1000             
            };
            if(action.lightningbuddy__Toaster_Alert_Param_Config__c){
                var alertMsgParams = JSON.parse(action.lightningbuddy__Toaster_Alert_Param_Config__c);
                if(alertMsgParams && alertMsgParams.length>0){
                    alertParams.messageTemplate=action.lightningbuddy__Toaster_Alert_Message__c;
                    alertParams.messageTemplateData=alertMsgParams;
                }
        	
            }
            toastEvent.setParams(alertParams);
            toastEvent.fire();            
        }      
    },
    "handlePopoverRegistration":function(cmp,event){        
        //popover componet in record home was loaded and is now registering to see if there
        //any popover messages to send to the component.   
        console.log(new Date()+' - Register popover called....');
        
        var action = cmp.get("c.getPopoverMessageToDisplay");
        action.setParams({ 
            objName: cmp.get('v.object'),
            pageType: cmp.get('v.pageType'),
            recordId: cmp.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
        		console.log(new Date()+' - About to fire popover event');
                cmp.set('v.popoverElementClass',event.getParam('popoverElementClass'));
                var showPopoverEvent = $A.get("e.c:ShowPopoverEvent");
                showPopoverEvent.setParams({ 
                    popoverText: response.getReturnValue(),
                    popoverElementClass: event.getParam('popoverElementClass')
                });
                showPopoverEvent.fire();
            }
            
        });
        $A.enqueueAction(action); 
        
    },
    "isEnabledForProfile": function(usrInfo,actionToShow){
        var usrProfileId = usrInfo.ProfileId.substring(0,usrInfo.ProfileId.length-3);
        var usrProfileName = usrInfo.Profile.Name;
        //Only execute the action if there's no profile filter or
        //if there's a profile filter that matches with logged in user's profile
        if(!actionToShow.lightningbuddy__Enabled_Profiles__c){
            return true;
        }else{
            if(actionToShow.lightningbuddy__Enabled_Profiles__c.includes(usrProfileId)){
                return true;
            }else if(actionToShow.lightningbuddy__Enabled_Profiles__c.includes(usrProfileName)){
                return true;
            }else{
                return false;
            }
        }
            
    },
    "meetsRecordCriteria": function(actionToShow,cmp){
		var executeAction=true;
        var record = cmp.get('v.record');
        if(actionToShow.lightningbuddy__Record_Update_Criteria__c){
	        var criteriaList = JSON.parse(actionToShow.lightningbuddy__Record_Update_Criteria__c);
            for(var j=0;j<criteriaList.length;j++){
                executeAction = executeAction && record.fields[criteriaList[j].fieldName].value === criteriaList[j].fieldValue;
            }

        }
        return executeAction;            
    }
})