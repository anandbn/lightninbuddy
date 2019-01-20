@IsTest
public class ActionUserPreferenceControllerTest {
    @testSetup static void setup() {
        Schema.DescribeSObjectResult sObjDesc = lightningbuddy__Actions__c.sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recTypes = sObjDesc.getRecordTypeInfosByDeveloperName();
        System.debug('>>>>>> recordTypes : '+recTypes);
        lightningbuddy__Actions__c action = new Actions__c(RecordTypeId=recTypes.get('Image_Carousel').getRecordTypeId(),
                                           Name='Test Image Carousel',
                                           lightningbuddy__Object__c='Home',
                                           lightningbuddy__Page_Type__c='Home');
        insert action;
    }
    public static testmethod void testDismissActionForever(){
    	lightningbuddy__Actions__c action = [select Id,Name from lightningbuddy__Actions__c limit 1];
        ActionUserPreferenceController.dismissActionForever(action.Id);
        List<lightningbuddy__Action_User_Preference__c> userPref = [select lightningbuddy__Action__c,lightningbuddy__User__c,lightningbuddy__Unique_Id__c 
                                                    from lightningbuddy__Action_User_Preference__c
                                                   where lightningbuddy__Action__c = :action.Id];
        
        System.assertEquals(1,userPref.size(),'Action user preferences not saved.');
        System.assertEquals(UserInfo.getUserId(),userPref[0].lightningbuddy__User__c,'User Id mismatch.');
        System.assertEquals(action.Id,userPref[0].lightningbuddy__Action__c,'Action Id mismatch.');
    }
}