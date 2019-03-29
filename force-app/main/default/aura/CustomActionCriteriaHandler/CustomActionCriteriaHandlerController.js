({
    handleCustomCriteriaEvent : function(cmp, event, helper) {
        var objName = event.getParam('object');
        var pageType = event.getParam('pageType');
        var recordId = event.getParam('recordId');
        var objectSubTab =event.getParam('objectSubTab')

        //Do you custom evaluation of criteria here and then fire the e.c:BuddyEvent
        //Make sure you register the e:lightningbuddy:BuddyEvent in your component
        var record = event.getParam('record');

        //Example criteria check
        if( record.fields['Type'].value ==='Existing Customer - Upgrade' && 
            record.fields['NextStep'].value == null &&
            !(record.fields['StageName'].value === 'Closed Won' || record.fields['StageName'].value === 'Closed Lost') &&
            record.fields['Probability'].value > 70
        ){
                var buddyEvent = $A.get("e.c:BuddyEvent");
                var eventParams = { 
                    object:objName,
                    pageType:pageType,
                    recordId:recordId,
                    record:record,
                    objectSubTab:objectSubTab,
                    customCriteriaEvaluated:true
                };  
                buddyEvent.setParams(eventParams);
                buddyEvent.fire();              
        }
        
    }
})