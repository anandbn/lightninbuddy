@IsTest
public class LightningBuddyActionControllerTest {
    @testSetup static void setup() {
        
        Schema.DescribeSObjectResult sObjDesc = lightningbuddy__Actions__c.sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recTypes = sObjDesc.getRecordTypeInfosByDeveloperName();
        System.debug('>>>>>> recordTypes : '+recTypes);
        List<lightningbuddy__Actions__c> toInsert = new List<lightningbuddy__Actions__c>();
        Actions__c action;
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Image_Carousel').getRecordTypeId(),
                                                Name='Test Image Carousel',
                                                lightningbuddy__Object__c='Home',
                                                lightningbuddy__Page_Type__c='Home');
        toInsert.add(action);
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Popover').getRecordTypeId(),
                                                Name='Test Popover',
                                                lightningbuddy__Object__c='Contact',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Popover_Text__c='Test');
        toInsert.add(action);
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Popover',
                                                lightningbuddy__Object__c='Case',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Action_Text__c='Test');
        toInsert.add(action);

        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Only Once',
                                                lightningbuddy__Object__c='Contact',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Action_Text__c='Test',
                                               	lightningbuddy__Recurrence__c='Only once');
        toInsert.add(action);
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Days after',
                                                lightningbuddy__Object__c='Campaign',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Action_Text__c='Days after certain date',
                                               	lightningbuddy__Recurrence__c='Days after certain date',
                                               	lightningbuddy__Recurrence_Date__c=System.today().addDays(-1),
                                               	lightningbuddy__Recurrence_Days__c=1
                                                
                                               );
        toInsert.add(action);
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Days after 2',
                                                lightningbuddy__Object__c='Contract',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Action_Text__c='Days after certain date',
                                               	lightningbuddy__Recurrence__c='Days after certain date',
                                               	lightningbuddy__Recurrence_Date__c=System.today(),
                                               	lightningbuddy__Recurrence_Days__c=0
                                                
                                               );
        toInsert.add(action);
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Days after 3',
                                                lightningbuddy__Object__c='Asset',
                                                lightningbuddy__Page_Type__c='Home',
                                                lightningbuddy__Action_Text__c='Days after certain date',
                                               	lightningbuddy__Recurrence__c='Days after certain date',
                                               	lightningbuddy__Recurrence_Date__c=System.today().addDays(7),
                                               	lightningbuddy__Recurrence_Days__c=1
                                                
                                               );
        toInsert.add(action);

        insert toInsert;

        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Sub Tab Action',
                                                lightningbuddy__Object__c='lightningbuddy__Actions__c',
                                                lightningbuddy__Page_Type__c='Record Detail',
                                                lightningbuddy__Subtab_Name__c='MySubTab',
                                                lightningbuddy__Record_Id__c=toInsert[0].Id,
                                                lightningbuddy__Action_Text__c='Test');
        insert action;


        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Record Detail Rich_Text ',
                                                lightningbuddy__Object__c='lightningbuddy__Actions__c',
                                                lightningbuddy__Page_Type__c='Record Detail',
                                                lightningbuddy__Record_Id__c=toInsert[0].Id,
                                                lightningbuddy__Action_Text__c='Test');
        insert action;
        
        action = new lightningbuddy__Actions__c(RecordTypeId=recTypes.get('Rich_Text').getRecordTypeId(),
                                                Name='Test Record Update Rich_Text ',
                                                lightningbuddy__Object__c='lightningbuddy__Actions__c',
                                                lightningbuddy__Page_Type__c='Record Update',
                                                lightningbuddy__Action_Text__c='Test');
        insert action;
        
        action = toInsert[2];
        
        lightningbuddy__Action_User_Preference__c usrPref 
            = new lightningbuddy__Action_User_Preference__c(lightningbuddy__Action__c=action.Id,
                                                            lightningbuddy__User__c=UserInfo.getUserId(),
                                                            lightningbuddy__Unique_Id__c=UserInfo.getUserId()+'_'+action.Id);
        insert usrPref;
        action = toInsert[3];
        usrPref 
            = new lightningbuddy__Action_User_Preference__c(lightningbuddy__Action__c=action.Id,
                                                            lightningbuddy__User__c=UserInfo.getUserId(),
                                                            lightningbuddy__Unique_Id__c=UserInfo.getUserId()+'_'+action.Id);
        insert usrPref;
        action = toInsert[5];
        usrPref 
            = new lightningbuddy__Action_User_Preference__c(lightningbuddy__Action__c=action.Id,
                                                            lightningbuddy__User__c=UserInfo.getUserId(),
                                                            lightningbuddy__Unique_Id__c=UserInfo.getUserId()+'_'+action.Id,
                                                           	lightningbuddy__Dismissed_Date__c=System.today()
                                                           );
        insert usrPref;

    }
    public static testmethod void testGetUserInfo(){
        User usr = LightningBuddyActionController.getLoggedInUser();
        System.assertEquals(UserInfo.getProfileId(),usr.ProfileId,'ProfileId mismatch');
        System.assertEquals(UserInfo.getUserName(),usr.Username,'Username mismatch');
        System.assertEquals(UserInfo.getUserId(),usr.Id,'User Id mismatch');
    }
    
    public static testmethod void testGetPopoverMessageToDisplay(){
        String popoverText = LightningBuddyActionController.getPopoverMessageToDisplay('Contact', 'Home', null);
        System.assertEquals('Test', popoverText, 'Popover text mismatch');
    }
    public static testmethod void testNullPopoverMessageToDisplay(){
        String popoverText = LightningBuddyActionController.getPopoverMessageToDisplay('Case', 'Home', null);
        System.assertEquals(null, popoverText, 'Popover text NULL mismatch');
    }
    
    public static testmethod void testActionWithRecordId(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Image Carousel' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('lightningbuddy__Actions__c', 
                                                                                                     'Record Detail',
                                                                                                     action.Id,
                                                                                                     null);
        System.assertEquals(1, actionsToDisplay.size(), 'No actions fetched for Action record detail');
        System.assertEquals('Test', actionsToDisplay[0].lightningbuddy__Action_Text__c, 'Action text mismatch');
    }

    
    public static testmethod void testActionWithoutRecordId(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Image Carousel' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Home', 
                                                                                                     'Home',
                                                                                                     null,
                                                                                                     null);
        System.assertEquals(1, actionsToDisplay.size(), 'No actions fetched for Home:Home');
    }    
    public static testmethod void testActionWithUserPreferences(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Image Carousel' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Case', 
                                                                                                     'Home',
                                                                                                     null,
                                                                                                     null);
        System.assertEquals(0, actionsToDisplay.size(), 'Actions fetched for Case:Home when not expected');
    }
    public static testmethod void testActionWithRecordUpdate(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Record Update Rich_Text' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('lightningbuddy__Actions__c', 
                                                                                                     'Record Update',
                                                                                                     action.Id,
                                                                                                     null);
        System.assertEquals(1, actionsToDisplay.size(), 'No actions fetched for Action record detail');
        System.assertEquals('Test', actionsToDisplay[0].lightningbuddy__Action_Text__c, 'Action text mismatch');
    }
    
    public static testmethod void testNoActions(){
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Dashboard', 
                                                                                                     'Home',
                                                                                                    null,
                                                                                                     null);
        System.assertEquals(null, actionsToDisplay, 'Actions fetched for Dashboard home');
    }
    
    public static testmethod void testRunOnlyOnce(){
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Contact', 
                                                                                                     'Home',
                                                                                                    null,
                                                                                                     null);
        System.assertEquals(null, actionsToDisplay, 'Actions fetched for Contact Home');
    }
    
    public static testmethod void testDaysAfterADate(){
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Campaign', 
                                                                                                     'Home',
                                                                                                    null,
                                                                                                     null);
        System.assertEquals(1, actionsToDisplay.size(), 'No actions fetched for Campaign Home');
        System.assertEquals('Days after certain date', actionsToDisplay[0].lightningbuddy__Action_Text__c, 'Action text mismatch');
    }
    public static testmethod void testDaysAfterADateNoAction(){
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Contract', 
                                                                                                     'Home',
                                                                                                     null,
                                                                                                     null);
        System.assertEquals(null, actionsToDisplay, 'testDaysAfterADateNoAction = Actions fetched for Contract Home when not expected');
    }
    
    public static testmethod void testDaysAfterAFutureDate(){
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('Asset', 
                                                                                                     'Home',
                                                                                                     null,
                                                                                                     null);
        System.assertEquals(null, actionsToDisplay, 'testDaysAfterADateNoAction = Actions fetched for Contract Home when not expected');
    }

    public static testmethod void testObjectSubTab(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Sub Tab Action' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('lightningbuddy__Actions__c', 
                                                                                                     'Record Detail',
                                                                                                     null,
                                                                                                     'MySubTab');
        System.assertEquals(1, actionsToDisplay.size(), 'testObjectSubTab = Actions empty when action expected');
    }

    public static testmethod void testObjectSubTabWithRecordId(){
        lightningbuddy__Actions__c action = [select Id from lightningbuddy__Actions__c where Name='Test Sub Tab Action' limit 1];
        
        List<lightningbuddy__Actions__c> actionsToDisplay = LightningBuddyActionController.getAction('lightningbuddy__Actions__c', 
                                                                                                     'Record Detail',
                                                                                                     action.Id,
                                                                                                     'MySubTab');
        System.assertEquals(1, actionsToDisplay.size(), 'testObjectSubTabWithRecordId = Actions returned when none expected');
    }
}