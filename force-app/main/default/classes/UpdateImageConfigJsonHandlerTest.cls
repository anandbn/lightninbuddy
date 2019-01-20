@IsTest
public class UpdateImageConfigJsonHandlerTest {
    @testSetup static void setup() {
        Schema.DescribeSObjectResult sObjDesc = lightningbuddy__Actions__c.sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recTypes = sObjDesc.getRecordTypeInfosByDeveloperName();
        System.debug('>>>>>> recordTypes : '+recTypes);
        lightningbuddy__Actions__c action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Image_Carousel').getRecordTypeId(),
                                           Name='Test Image Carousel',
                                           lightningbuddy__Object__c='Home',
                                           lightningbuddy__Page_Type__c='Home');
        insert action;
    }
    public static testmethod void testUpdateJsonConfig(){
        lightningbuddy__Actions__c action = [select Id,Name,lightningbuddy__Image_Carousel_Config__c from lightningbuddy__Actions__c limit 1];
        System.assertEquals(null, action.lightningbuddy__Image_Carousel_Config__c,'Image JSON is not null');
        lightningbuddy__Carousel_Image__c img = new lightningbuddy__Carousel_Image__c(Name='Test',
                                                      Description__c='Test',
                                                      lightningbuddy__Image_Url__c='Test',
                                                      lightningbuddy__Actions__c=action.Id);
        insert img;
        action = [select Id,Name,lightningbuddy__Image_Carousel_Config__c from lightningbuddy__Actions__c limit 1];
        System.assert(action.lightningbuddy__Image_Carousel_Config__c!=null, 'Image JSON is null');
        String expectJson = '[{"imgSrc":"Test","cardTitle":"Test","cardDescription":"Test"}]';
        System.assertEquals(expectJson,action.lightningbuddy__Image_Carousel_Config__c, 'Image JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigMultiple(){
        Actions__c action = [select Id,Name,Image_Carousel_Config__c from Actions__c limit 1];
        System.assertEquals(null, action.Image_Carousel_Config__c,'Image JSON is not null');
        Carousel_Image__c img = new Carousel_Image__c(Name='Test',
                                                      Description__c='Test',
                                                      Image_Url__c='Test',
                                                      Actions__c=action.Id);
        insert img;
        img = new Carousel_Image__c(Name='Test2',
                                    Description__c='Test2',
                                    Image_Url__c='Test2',
                                    Actions__c=action.Id);
        insert img;
        action = [select Id,Name,Image_Carousel_Config__c from Actions__c limit 1];
        System.assert(action.Image_Carousel_Config__c!=null, 'Image JSON is null');
        String expectJson = '[{"imgSrc":"Test","cardTitle":"Test","cardDescription":"Test"},{"imgSrc":"Test2","cardTitle":"Test2","cardDescription":"Test2"}]';
        System.assertEquals(expectJson,action.Image_Carousel_Config__c, 'Image JSON not matching');
    }
    
    public static testmethod void testUpdateJsonConfigDelete(){
        Actions__c action = [select Id,Name,Image_Carousel_Config__c from Actions__c limit 1];
        System.assertEquals(null, action.Image_Carousel_Config__c,'Image JSON is not null');
        Carousel_Image__c img = new Carousel_Image__c(Name='Test',
                                                      Description__c='Test',
                                                      Image_Url__c='Test',
                                                      Actions__c=action.Id);
        insert img;
        img = new Carousel_Image__c(Name='Test2',
                                    Description__c='Test2',
                                    Image_Url__c='Test2',
                                    Actions__c=action.Id);
        insert img;
        action = [select Id,Name,Image_Carousel_Config__c from Actions__c limit 1];
        System.assert(action.Image_Carousel_Config__c!=null, 'Image JSON is null');
        String expectJson = '[{"imgSrc":"Test","cardTitle":"Test","cardDescription":"Test"},{"imgSrc":"Test2","cardTitle":"Test2","cardDescription":"Test2"}]';
        System.assertEquals(expectJson,action.Image_Carousel_Config__c, 'Image JSON not matching');

        delete img;
        action = [select Id,Name,Image_Carousel_Config__c from Actions__c limit 1];
        System.assert(action.Image_Carousel_Config__c!=null, 'Image JSON is null');
        expectJson = '[{"imgSrc":"Test","cardTitle":"Test","cardDescription":"Test"}]';
        System.assertEquals(expectJson,action.Image_Carousel_Config__c, 'Image JSON not matching');

    }

}