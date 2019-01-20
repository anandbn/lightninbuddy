trigger UpdateWelcomeMatJSONConfig on lightningbuddy__Welcome_Mat_Tile__c (after insert,after update,after delete) {
	if(!Trigger.isDelete){
        UpdateTileConfigJsonHandler.updateJSONConfig(Trigger.new[0]);
    }else{
        UpdateTileConfigJsonHandler.updateJSONConfig(Trigger.old[0]);
    }
}