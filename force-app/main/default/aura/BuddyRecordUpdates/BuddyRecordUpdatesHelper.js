({
    "handleRecordUpdated" : function(cmp,event){
        var changeType = event.getParams().changeType;
        
        if (changeType === "CHANGED") {
            var appEvent = $A.get("e.c:BuddyEvent");
            appEvent.setParams({ 
                object:cmp.get('v.record').apiName,
                pageType:'Record Update',
                record:cmp.get('v.record'),
                recordId:cmp.get('v.recordId')
            });
            appEvent.fire();        
        }else if(changeType === "LOADED"){
            //When the record is loaded fire the Record Detail event
            var appEvent = $A.get("e.c:BuddyEvent");
            var createdDate = cmp.get('v.record').fields.CreatedDate.value;
            var modifiedDate = cmp.get('v.record').fields.LastModifiedDate.value;
            //If created date is same as modified date and record was created in the last second
            if(createdDate === modifiedDate && Math.abs(Date.now() - Date.parse(modifiedDate)) <=1000){
                appEvent.setParams({ 
                    object:cmp.get('v.record').apiName,
                    pageType:'Record Create',
                    record:cmp.get('v.record'),
                    recordId:cmp.get('v.recordId')
                });
            }else{
                appEvent.setParams({ 
                    object:cmp.get('v.record').apiName,
                    pageType:'Record Detail',
                    record:cmp.get('v.record'),
                    recordId:cmp.get('v.recordId')
                });
            }
            
            appEvent.fire();        
            
        }
        
    },

    "objectSubtabClicked" : function(cmp,event){
        var appEvent = $A.get("e.c:BuddyEvent");
        appEvent.setParams({ 
            object:event.getParam('object'),
            pageType:event.getParam('pageType'),
            objectSubTab:event.getParam('objectSubTab'),
            record:cmp.get('v.record'),
            recordId:cmp.get('v.recordId')
        });
        console.log(new Date()+' - About to fire a BuddyEvent from subObjectTabClicked');
        appEvent.fire();        

    }
})