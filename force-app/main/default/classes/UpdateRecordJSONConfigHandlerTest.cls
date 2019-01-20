@IsTest
public class UpdateRecordJSONConfigHandlerTest {
    @testSetup static void setup() {
        Schema.DescribeSObjectResult sObjDesc = lightningbuddy__Actions__c.sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recTypes = sObjDesc.getRecordTypeInfosByDeveloperName();
        System.debug('>>>>>> recordTypes : '+recTypes);
        lightningbuddy__Actions__c action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Welcome_Mat').getRecordTypeId(),
                                                                           Name='Test Welcome Mat',
                                                                           lightningbuddy__Object__c='Home',
                                                                           lightningbuddy__Page_Type__c='Home');
        insert action;
    }
    public static testmethod void testUpdateJsonConfig(){
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Record_Update_Criteria__c,'1:Criteria Config JSON is not null');
        lightningbuddy__Record_Criteria__c criteria = new lightningbuddy__Record_Criteria__c(lightningbuddy__Field_Name__c='Test',
                                                                                             lightningbuddy__Field_Value__c='Test',
                                                                                             lightningbuddy__Action__c=action.Id);
        insert criteria;
        action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from lightningbuddy__Actions__c limit 1];
        System.assert(action.lightningbuddy__Record_Update_Criteria__c!=null, '2:Criteria Config JSON JSON is null');
        String expectJson = '[{"fieldValue":"Test","fieldName":"Test"}]';
        System.assertEquals(expectJson,action.lightningbuddy__Record_Update_Criteria__c, '3:Criteria Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigMultiple(){
        Actions__c action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Record_Update_Criteria__c,'4:Criteria Config JSON is not null');
        lightningbuddy__Record_Criteria__c criteria = new lightningbuddy__Record_Criteria__c(lightningbuddy__Field_Name__c='Test',
                                                                                             lightningbuddy__Field_Value__c='Test',
                                                                                             lightningbuddy__Action__c=action.Id);
        insert criteria;
        criteria = new lightningbuddy__Record_Criteria__c(lightningbuddy__Field_Name__c='Test2',
                                                          lightningbuddy__Field_Value__c='Test2',
                                                          lightningbuddy__Action__c=action.Id);
        insert criteria;
        action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from Actions__c limit 1];
        System.assert(action.lightningbuddy__Record_Update_Criteria__c!=null, '5:Criteria Config JSON is null');
        String expectJson = '[{"fieldValue":"Test","fieldName":"Test"},{"fieldValue":"Test2","fieldName":"Test2"}]';
        system.debug('6: JSON =  '+action.lightningbuddy__Record_Update_Criteria__c);
        System.assertEquals(expectJson,action.lightningbuddy__Record_Update_Criteria__c, '6:Criteria Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigDelete(){
        Actions__c action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Record_Update_Criteria__c,'4:Criteria Config JSON is not null');
        lightningbuddy__Record_Criteria__c criteria = new lightningbuddy__Record_Criteria__c(lightningbuddy__Field_Name__c='Test',
                                                                                             lightningbuddy__Field_Value__c='Test',
                                                                                             lightningbuddy__Action__c=action.Id);
        insert criteria;
        criteria = new lightningbuddy__Record_Criteria__c(lightningbuddy__Field_Name__c='Test2',
                                                          lightningbuddy__Field_Value__c='Test2',
                                                          lightningbuddy__Action__c=action.Id);
        insert criteria;
        action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from Actions__c limit 1];
        System.assert(action.lightningbuddy__Record_Update_Criteria__c!=null, '5:Criteria Config JSON is null');
        String expectJson = '[{"fieldValue":"Test","fieldName":"Test"},{"fieldValue":"Test2","fieldName":"Test2"}]';
        system.debug('6: JSON =  '+action.lightningbuddy__Record_Update_Criteria__c);
        System.assertEquals(expectJson,action.lightningbuddy__Record_Update_Criteria__c, '6:Criteria JSON not matching');

        delete criteria;
        action = [select Id,Name,lightningbuddy__Record_Update_Criteria__c from Actions__c limit 1];
        expectJson = '[{"fieldValue":"Test","fieldName":"Test"}]';
        system.debug('7: JSON =  '+action.lightningbuddy__Record_Update_Criteria__c);
        System.assertEquals(expectJson,action.lightningbuddy__Record_Update_Criteria__c, '7:Delete Criteria Config JSON not matching');

    }
}