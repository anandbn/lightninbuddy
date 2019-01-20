trigger UpdateImageCarouselJSONConfig on lightningbuddy__Carousel_Image__c (after insert,after update,after delete) {

    if(!Trigger.isDelete){
		UpdateImageConfigJsonHandler.updateJSONConfig(Trigger.new[0]);
    }else{
		UpdateImageConfigJsonHandler.updateJSONConfig(Trigger.old[0]);
        
    }
    
}