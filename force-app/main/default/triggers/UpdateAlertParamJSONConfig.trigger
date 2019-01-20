trigger UpdateAlertParamJSONConfig on lightningbuddy__Toaster_Alert_Param__c (after insert,after update,after delete) {

    if(!Trigger.isDelete){
		UpdateToasterAlertParamConfigJsonHandler.updateJSONConfig(Trigger.new[0]);
    }else{
		UpdateToasterAlertParamConfigJsonHandler.updateJSONConfig(Trigger.old[0]);
        
    }
    
}