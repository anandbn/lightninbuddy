public with sharing class UpdateToasterAlertParamConfigJsonHandler {
    public static void updateJSONConfig(lightningbuddy__Toaster_Alert_Param__c paramConfig)
    {
        List<AlertParamConfig> configList = new List<AlertParamConfig>();
        if(Toaster_Alert_Param__c.sObjectType.getDescribe().isAccessible()){
            for(Toaster_Alert_Param__c param : [select Name,Link__c,Actions__c
                                         from lightningbuddy__Toaster_Alert_Param__c
                                         where Actions__c=:paramConfig.Actions__c 
                                         order by Order__c asc])
                                         {
                                             configList.add(new AlertParamConfig(param.Name,param.Link__c));                                                       
                                         }
            String jsonStr = JSON.serialize(configList);
            if(	Actions__c.sobjectType.getDescribe().isUpdateable() && 
               Schema.sObjectType.Actions__c.fields.Toaster_Alert_Param_Config__c.isUpdateable()){
                   Actions__c actionToUpdate 
                       = new Actions__c(Id=paramConfig.Actions__c,
                                        Toaster_Alert_Param_Config__c=jsonStr);
                   update actionToUpdate;
                   
               }
            
        }
        
    }
    
    public class AlertParamConfig {
        public String label {get; set;}
        public String url {get; set;}
        public AlertParamConfig(String theLabel,String theUrl){
            this.label = theLabel;
            this.url=theUrl;
        }
    }
}