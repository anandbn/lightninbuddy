@IsTest
public class UpdateAlertParamConfigHandlerTest {
    @testSetup static void setup() {
        Schema.DescribeSObjectResult sObjDesc = lightningbuddy__Actions__c.sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recTypes = sObjDesc.getRecordTypeInfosByDeveloperName();
        System.debug('>>>>>> recordTypes : '+recTypes);
        lightningbuddy__Actions__c action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Toaster_Alert').getRecordTypeId(),
                                                                           Name='Test Alert Params',
                                                                           lightningbuddy__Object__c='Home',
                                                                           lightningbuddy__Page_Type__c='Home');
        insert action;
    }
    public static testmethod void testUpdateJsonConfig(){
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Toaster_Alert_Param_Config__c,'1:Alert Config JSON is not null');
        lightningbuddy__Toaster_Alert_Param__c param = new lightningbuddy__Toaster_Alert_Param__c( Name='Param1',
                                                                                                      lightningbuddy__Actions__c=action.Id,
                                                                                                   	  lightningbuddy__Link__c='http://www.test.com');
        insert param;
        action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from lightningbuddy__Actions__c limit 1];
        System.assert(action.lightningbuddy__Toaster_Alert_Param_Config__c!=null, '2:Alert Config JSON JSON is null');
        String expectJson = '[{"url":"http://www.test.com","label":"Param1"}]';
        System.assertEquals(expectJson,action.lightningbuddy__Toaster_Alert_Param_Config__c, '3:Alert Param Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigMultiple(){
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Toaster_Alert_Param_Config__c,'1:Alert Config JSON is not null');
        lightningbuddy__Toaster_Alert_Param__c param = new lightningbuddy__Toaster_Alert_Param__c( Name='Param1',
                                                                                                      lightningbuddy__Actions__c=action.Id,
                                                                                                   	  lightningbuddy__Link__c='http://www.test.com');
        insert param;
        param = new lightningbuddy__Toaster_Alert_Param__c( Name='Param2',
                                                            lightningbuddy__Actions__c=action.Id,
                                                            lightningbuddy__Link__c='http://www.test.com');
        insert param;
        action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from lightningbuddy__Actions__c limit 1];
        System.assert(action.lightningbuddy__Toaster_Alert_Param_Config__c!=null, '2:Aler Config JSON JSON is null');
        String expectJson = '[{"url":"http://www.test.com","label":"Param1"},{"url":"http://www.test.com","label":"Param2"}]';
        System.assertEquals(expectJson,action.lightningbuddy__Toaster_Alert_Param_Config__c, '3:Alert Param Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigDelete(){
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Toaster_Alert_Param_Config__c,'1:Aler Config JSON is not null');
        lightningbuddy__Toaster_Alert_Param__c param = new lightningbuddy__Toaster_Alert_Param__c( Name='Param1',
                                                                                                      lightningbuddy__Actions__c=action.Id,
                                                                                                   	  lightningbuddy__Link__c='http://www.test.com');
        insert param;

        param = new lightningbuddy__Toaster_Alert_Param__c( Name='Param2',
                                                            lightningbuddy__Actions__c=action.Id,
                                                            lightningbuddy__Link__c='http://www.test.com');
        insert param;
        action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from Actions__c limit 1];
        System.assert(action.lightningbuddy__Toaster_Alert_Param_Config__c!=null, '5:Aler Config JSON is null');
        String expectJson = '[{"url":"http://www.test.com","label":"Param1"},{"url":"http://www.test.com","label":"Param2"}]';
        system.debug('6: JSON =  '+action.lightningbuddy__Toaster_Alert_Param_Config__c);
        System.assertEquals(expectJson,action.lightningbuddy__Toaster_Alert_Param_Config__c, '6:Aler JSON not matching');

        delete param;
        action = [select Id,Name,lightningbuddy__Toaster_Alert_Param_Config__c from Actions__c limit 1];
        expectJson = '[{"url":"http://www.test.com","label":"Param1"}]';
        system.debug('7: JSON =  '+action.lightningbuddy__Toaster_Alert_Param_Config__c);
        System.assertEquals(expectJson,action.lightningbuddy__Toaster_Alert_Param_Config__c, '7:Delete Alert Config JSON not matching');

    }
}