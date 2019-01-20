public with sharing class UpdateImageConfigJsonHandler {
    
    public static void updateJSONConfig(lightningbuddy__Carousel_Image__c imgConfig)
    {
        List<ImageConfig> configList = new List<ImageConfig>();
        if(Carousel_Image__c.sObjectType.getDescribe().isAccessible()){
            for(Carousel_Image__c img : [select Id,Name,Description__c,Image_Url__c 
                                                         from Carousel_Image__c
                                                         where Actions__c=:imgConfig.Actions__c]){
                                                             configList.add(new ImageConfig(img.Image_Url__c,img.Name,img.Description__c));                                                       
                                                         }
            String jsonStr = JSON.serialize(configList);
            if(	Actions__c.sobjectType.getDescribe().isUpdateable() && 
              	Schema.sObjectType.Actions__c.fields.Image_Carousel_Config__c.isUpdateable()){
                Actions__c actionToUpdate 
                    = new Actions__c(Id=imgConfig.Actions__c,
                                                     Image_Carousel_Config__c=jsonStr);
                update actionToUpdate;
                
            }
            
        }
        
    }
    
    public class ImageConfig {
        public String imgSrc {get; set;}
        public String cardTitle {get; set;}
        public String cardDescription {get; set;}
        public ImageConfig(String srcUrl,String title,String description){
            this.imgSrc = srcUrl;
            this.cardTitle=title;
            this.cardDescription=description;
        }
    }
}