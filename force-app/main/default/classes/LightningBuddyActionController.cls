public with sharing class LightningBuddyActionController {



    @AuraEnabled
    public static List<Actions__c> getAction(String objName,String pageType, String recordId,String objectSubTab){
        System.debug('objName:'+objName+',pageType:'+pageType+',recordId:'+recordId+', objectSubTab:'+objectSubTab);
        //Blank out the record Id in case it's a record update
        if(pageType == 'Record Update'){
            recordId =null;
        }
        List<Actions__c> actions; 
        if(recordId!=null){
            if(Actions__c.sObjectType.getDescribe().isAccessible()){
                if(objectSubTab != null){
                    actions = [select Id,RecordType.Name,Name,Action_Text__c,Type__c,File_Id__c,Popover_Text__c,
                            Video_Type__c,Video_Link__c,Enabled_Profiles__c,
                            Record_Update_Criteria__c,Quick_Action_API_Name__c,Image_Carousel_Config__c,
                            Lightning_Flow_API_Name__c,Recurrence__c,Recurrence_Date__c,Recurrence_Days__c,
                            Welcome_Mat_Background_Image__c,Welcome_Mat_Body__c,Welcome_Mat_Main_Image__c,
                            Welcome_Mat_Title__c,Welcome_Mat_Tile_Config__c,Toaster_Alert_Icon__c,
                                Toaster_Alert_Message__c,Toaster_Alert_Title__c,Toaster_Alert_Type__c,
                            Toaster_Alert_Mode__c,Toaster_Alert_Duration__c,Toaster_Alert_Param_Config__c,
                            Use_Custom_Criteria_Handler__c,Record_Id_as_Input_Variable__c,Docked_Display__c
                            from Actions__c
                            where Object__c=:objName
                            and Page_Type__c = :pageType
                            and RecordType.Name != 'Popover'
                            and Subtab_Name__c = :objectSubTab 
                            and Record_Id__c= :recordId];
                }else{
                    actions = [select Id,RecordType.Name,Name,Action_Text__c,Type__c,File_Id__c,Popover_Text__c,
                            Video_Type__c,Video_Link__c,Enabled_Profiles__c,
                            Record_Update_Criteria__c,Quick_Action_API_Name__c,Image_Carousel_Config__c,
                            Lightning_Flow_API_Name__c,Recurrence__c,Recurrence_Date__c,Recurrence_Days__c,
                            Welcome_Mat_Background_Image__c,Welcome_Mat_Body__c,Welcome_Mat_Main_Image__c,
                            Welcome_Mat_Title__c,Welcome_Mat_Tile_Config__c,Toaster_Alert_Icon__c,
                                Toaster_Alert_Message__c,Toaster_Alert_Title__c,Toaster_Alert_Type__c,
                            Toaster_Alert_Mode__c,Toaster_Alert_Duration__c,Toaster_Alert_Param_Config__c,
                            Use_Custom_Criteria_Handler__c,Record_Id_as_Input_Variable__c,Docked_Display__c
                            from Actions__c
                            where Object__c=:objName
                            and Page_Type__c = :pageType
                            and RecordType.Name != 'Popover' 
                            and Subtab_Name__c = null 
                            and Record_Id__c= :recordId];
                }
            }
            
        }
        if((actions == null || actions.isEmpty()) && Actions__c.sObjectType.getDescribe().isAccessible()){
            if(objectSubTab != null){
                actions = [select Id,RecordType.Name,Name,Action_Text__c,Type__c,File_Id__c,Popover_Text__c,
                        Video_Type__c,Video_Link__c,Enabled_Profiles__c,
                        Record_Update_Criteria__c,Quick_Action_API_Name__c,Image_Carousel_Config__c,
                        Lightning_Flow_API_Name__c,Recurrence__c,Recurrence_Date__c,Recurrence_Days__c,
                        Welcome_Mat_Background_Image__c,Welcome_Mat_Body__c,Welcome_Mat_Main_Image__c,
                        Welcome_Mat_Title__c,Welcome_Mat_Tile_Config__c,Toaster_Alert_Icon__c,
                                Toaster_Alert_Message__c,Toaster_Alert_Title__c,Toaster_Alert_Type__c,
                            Toaster_Alert_Mode__c,Toaster_Alert_Duration__c,Toaster_Alert_Param_Config__c,
                            Use_Custom_Criteria_Handler__c,Record_Id_as_Input_Variable__c,Docked_Display__c
                        from Actions__c
                        where Object__c=:objName
                        and Page_Type__c = :pageType
                        and Subtab_Name__c = :objectSubTab 
                        and RecordType.Name != 'Popover'];                
            }else{
                actions = [select Id,RecordType.Name,Name,Action_Text__c,Type__c,File_Id__c,Popover_Text__c,
                        Video_Type__c,Video_Link__c,Enabled_Profiles__c,
                        Record_Update_Criteria__c,Quick_Action_API_Name__c,Image_Carousel_Config__c,
                        Lightning_Flow_API_Name__c,Recurrence__c,Recurrence_Date__c,Recurrence_Days__c,
                        Welcome_Mat_Background_Image__c,Welcome_Mat_Body__c,Welcome_Mat_Main_Image__c,
                        Welcome_Mat_Title__c,Welcome_Mat_Tile_Config__c,Toaster_Alert_Icon__c,
                                Toaster_Alert_Message__c,Toaster_Alert_Title__c,Toaster_Alert_Type__c,
                            Toaster_Alert_Mode__c,Toaster_Alert_Duration__c,Toaster_Alert_Param_Config__c,
                            Use_Custom_Criteria_Handler__c,Record_Id_as_Input_Variable__c,Docked_Display__c
                        from Actions__c
                        where Object__c=:objName
                        and Page_Type__c = :pageType
                        and Subtab_Name__c = null 
                        and RecordType.Name != 'Popover'];
            }

        }
        
        
        if(actions.size()>0){
            Map<Id,lightningbuddy__Actions__c> actionMap =new Map<Id,lightningbuddy__Actions__c>();
            for(lightningbuddy__Actions__c action:actions){
                actionMap.put(action.Id,action);
            }
            Actions__c action = actions[0];
            
            List<Action_User_Preference__c> userPrefs;
            
            if(Schema.sObjectType.Actions__c.fields.Recurrence__c.isAccessible()){
                switch on action.Recurrence__c{
                    when 'Only once' {
                        userPrefs = [select Id,Action__c,Dismissed_Date__c from Action_User_Preference__c
                                     where Action__c in :actionMap.keySet()
                                     and User__c=:UserInfo.getUserId()
                                     order by Dismissed_Date__c asc ];
                        System.debug('>>> Only Once : '+userPrefs.size());
                        if(!userPrefs.isEmpty()){
                            return null;
                        }
                    }
                    when 'Days after certain date'{
                        Date dateToCheck = action.Recurrence_Date__c.addDays(Integer.valueOf(action.Recurrence_Days__c));
                        System.debug('>>>>>>>>>> Date to check:'+dateToCheck);
                        if(System.today() < dateToCheck){
                            System.debug('>>>>>>>>>> Date to take action is later than today');
                            return null;
                        }else if(System.today() == dateToCheck){
                            userPrefs = [select Id,Action__c,Dismissed_Date__c from Action_User_Preference__c
                                         where Action__c in :actionMap.keySet()
                                         and User__c=:UserInfo.getUserId()
                                         and Dismissed_Date__c = :dateToCheck];
                            
                            if(!userPrefs.isEmpty()){
                                System.debug('>>>>>>>>>> Action displayed already !!!');
                                return null;
                            }
                        }
                        
                    }
                    
                    when null{
                        for(Action_User_Preference__c pref: [select Id,Action__c,Dismissed_Date__c 
                                                             from Action_User_Preference__c
                                                             where Action__c in :actionMap.keySet()
                                                             and User__c=:UserInfo.getUserId()])
                        {
                            actionMap.remove(pref.Action__c);
                        }
                    }
                }                
            }
            
            
            return actionMap.values();
        }else{
            return null;
        }
    }

    
    @AuraEnabled
    public static String getPopoverMessageToDisplay(String objName,String pageType, String recordId){
        System.debug('objName:'+objName+',pageType:'+pageType+',recordId:'+recordId);
        if(Actions__c.sObjectType.getDescribe().isAccessible() && 
           Schema.sObjectType.Actions__c.fields.Popover_Text__c.isAccessible()){
               List<Actions__c> actions = [select Action_Text__c,Type__c,File_Id__c,Popover_Text__c
                                           from Actions__c
                                           where Object__c=:objName
                                           and Page_Type__c = :pageType
                                           and RecordType.Name = 'Popover'];
               if(!actions.isEmpty()){
                   return actions[0].Popover_Text__c;
               }else{
                   return null;
               }
           }else{
               return null;
           }
    }
    
    @AuraEnabled
    public static User getLoggedInUser(){
        return [select Id,Username,ProfileId,Profile.Name from User where Id=:UserInfo.getUserId() ];
    }
}