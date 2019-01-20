public with sharing class BreadCrumbController {
    @AuraEnabled
    public static BreadCrumbSettings initializeSettings(){
        
        BreadCrumbSettings settings = new BreadCrumbSettings();
        if(Url_Path_Mapping__mdt.sObjectType.getDescribe().isAccessible()){
            settings.urlMappings = [SELECT Url__c,Object__c,Query_String__c,MasterLabel  
                                    FROM Url_Path_Mapping__mdt ];
        }
        return settings;
        
    }
}