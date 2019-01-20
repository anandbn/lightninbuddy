public with sharing class UpdateRecordCriteriaConfigJsonHandler {
    public static void updateJSONConfig(lightningbuddy__Record_Criteria__c criteria)
    {
        List<RecordCriteria> configList = new List<RecordCriteria>();
        if(Carousel_Image__c.sObjectType.getDescribe().isAccessible()){
            for(Record_Criteria__c recCriteria : [select Field_Name__c,Field_Value__c 
                                         from Record_Criteria__c
                                         where Action__c=:criteria.Action__c])
            {
                configList.add(new RecordCriteria(recCriteria.Field_Name__c,recCriteria.Field_Value__c));                                                       
            }
            String jsonStr = JSON.serialize(configList);
            System.debug('>>>>> Criteria JSON : '+jsonStr);
            if(	lightningbuddy__Actions__c.sobjectType.getDescribe().isUpdateable() && 
               Schema.sObjectType.Actions__c.fields.Record_Update_Criteria__c.isUpdateable()){
                   Actions__c actionToUpdate = new Actions__c(Id=criteria.Action__c,
                                                              Record_Update_Criteria__c=jsonStr);
                   
                   update actionToUpdate;
               }
            
        }
        
    }
    
    public class RecordCriteria {
        public String fieldName {get; set;}
        public String fieldValue {get; set;}
        public RecordCriteria(String fieldName,String fieldValue){
            this.fieldName = fieldName;
            this.fieldValue=fieldValue;
        }
    }
}