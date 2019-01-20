trigger UpdateRecordCriteriaJSONConfig on lightningbuddy__Record_Criteria__c (after insert,after update, after delete) {
    if(!Trigger.isDelete){
        UpdateRecordCriteriaConfigJsonHandler.updateJSONConfig(Trigger.new[0]);
    }else{
        UpdateRecordCriteriaConfigJsonHandler.updateJSONConfig(Trigger.old[0]);
    }
}