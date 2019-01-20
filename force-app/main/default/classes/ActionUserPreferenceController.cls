public with sharing class ActionUserPreferenceController {
    @AuraEnabled
    public static void dismissActionForever(String actionId){
        String userId = UserInfo.getUserId();
        String uniqueId = UserInfo.getUserId()+'_'+actionId+ '_' + System.now().format('yyyyMMdd');
        if(Action_User_Preference__c.sObjectType.getDescribe().isAccessible() && 
           Action_User_Preference__c.sObjectType.getDescribe().isCreateable()){
               Action_User_Preference__c pref = new Action_User_Preference__c(User__c=UserInfo.getUserId(),
                                                                              Action__c =actionId,
                                                                              Unique_Id__c=uniqueId,
                                                                              Dismissed_Date__c = System.today());
               upsert pref;
               
           }
    }
}