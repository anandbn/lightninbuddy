@IsTest
public class UpdateTileConfigJsonHandlerTest {
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
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Welcome_Mat_Tile_Config__c,'1:Tile Config JSON is not null');
        lightningbuddy__Welcome_Mat_Tile__c tile = new lightningbuddy__Welcome_Mat_Tile__c(lightningbuddy__Title__c='Test',
                                                                                           lightningbuddy__Body__c='Test',
                                                                                           lightningbuddy__Link__c='http://www.test.com',
                                                                                           lightningbuddy__Icon__c='action:approval',
                                                                                           lightningbuddy__Action__c=action.Id);
        insert tile;
        action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from lightningbuddy__Actions__c limit 1];
        System.assert(action.lightningbuddy__Welcome_Mat_Tile_Config__c!=null, '2:Tile Config JSON JSON is null');
        String expectJson = '[{"title":"Test","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test"}]';
        System.assertEquals(expectJson,action.lightningbuddy__Welcome_Mat_Tile_Config__c, '3:Tile Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigMultiple(){
        Actions__c action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Welcome_Mat_Tile_Config__c,'4:Tile Config JSON is not null');
        lightningbuddy__Welcome_Mat_Tile__c tile = new lightningbuddy__Welcome_Mat_Tile__c(lightningbuddy__Title__c='Test',
                                                                                           lightningbuddy__Body__c='Test',
                                                                                           lightningbuddy__Link__c='http://www.test.com',
                                                                                           lightningbuddy__Icon__c='action:approval',
                                                                                           lightningbuddy__Action__c=action.Id);
        insert tile;
        tile = new lightningbuddy__Welcome_Mat_Tile__c(lightningbuddy__Title__c='Test2',
                                                       lightningbuddy__Body__c='Test2',
                                                       lightningbuddy__Link__c='http://www.test.com',
                                                       lightningbuddy__Icon__c='action:approval',
                                                       lightningbuddy__Action__c=action.Id);
        insert tile;
        action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from Actions__c limit 1];
        System.assert(action.lightningbuddy__Welcome_Mat_Tile_Config__c!=null, '5:Tile Config JSON is null');
        String expectJson = '[{"title":"Test","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test"},{"title":"Test2","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test2"}]';
        system.debug('6: JSON =  '+action.lightningbuddy__Welcome_Mat_Tile_Config__c);
        System.assertEquals(expectJson,action.lightningbuddy__Welcome_Mat_Tile_Config__c, '6:Tile Config JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigDelete(){
        Actions__c action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Welcome_Mat_Tile_Config__c,'4:Tile Config JSON is not null');
        lightningbuddy__Welcome_Mat_Tile__c tile = new lightningbuddy__Welcome_Mat_Tile__c(lightningbuddy__Title__c='Test',
                                                                                           lightningbuddy__Body__c='Test',
                                                                                           lightningbuddy__Link__c='http://www.test.com',
                                                                                           lightningbuddy__Icon__c='action:approval',
                                                                                           lightningbuddy__Action__c=action.Id);
        insert tile;
        tile = new lightningbuddy__Welcome_Mat_Tile__c(lightningbuddy__Title__c='Test2',
                                                       lightningbuddy__Body__c='Test2',
                                                       lightningbuddy__Link__c='http://www.test.com',
                                                       lightningbuddy__Icon__c='action:approval',
                                                       lightningbuddy__Action__c=action.Id);
        insert tile;
        action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from Actions__c limit 1];
        System.assert(action.lightningbuddy__Welcome_Mat_Tile_Config__c!=null, '5:Tile Config JSON is null');
        String expectJson = '[{"title":"Test","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test"},{"title":"Test2","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test2"}]';
        system.debug('6: JSON =  '+action.lightningbuddy__Welcome_Mat_Tile_Config__c);
        System.assertEquals(expectJson,action.lightningbuddy__Welcome_Mat_Tile_Config__c, '6:Tile Config JSON not matching');
        delete tile;
        action = [select Id,Name,lightningbuddy__Welcome_Mat_Tile_Config__c from Actions__c limit 1];
        expectJson = '[{"title":"Test","sldsIcon":"action:approval","linkUrl":"http://www.test.com","bodyText":"Test"}]';
        system.debug('7: JSON =  '+action.lightningbuddy__Welcome_Mat_Tile_Config__c);
        System.assertEquals(expectJson,action.lightningbuddy__Welcome_Mat_Tile_Config__c, '7:After Delete Tile Config JSON not matching');
    }
}