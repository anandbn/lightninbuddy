public with sharing class UpdateTileConfigJsonHandler {
    public static void updateJSONConfig(lightningbuddy__Welcome_Mat_Tile__c tileConfig)
    {
        List<TileConfig> configList = new List<TileConfig>();
        if(Carousel_Image__c.sObjectType.getDescribe().isAccessible()){
            for(Welcome_Mat_Tile__c tile : [select Title__c,Action__c,Body__c,Link__c,Icon__c 
                                         from Welcome_Mat_Tile__c
                                         where Action__c=:tileConfig.Action__c])
            {
                configList.add(new TileConfig(tile.Title__c,tile.Body__c,tile.Link__c,tile.Icon__c));                                                       
            }
            String jsonStr = JSON.serialize(configList);
            if(	lightningbuddy__Actions__c.sobjectType.getDescribe().isUpdateable() && 
               Schema.sObjectType.Actions__c.fields.Welcome_Mat_Tile_Config__c.isUpdateable()){
                   Actions__c actionToUpdate = new Actions__c(Id=tileConfig.Action__c,
                                                              Welcome_Mat_Tile_Config__c=jsonStr);
                   
                   update actionToUpdate;
               }
            
        }
        
    }
    
    public class TileConfig {
        public String title {get; set;}
        public String bodyText {get; set;}
        public String linkUrl {get; set;}
        public String sldsIcon {get; set;}
        public TileConfig(String title,String bodyText,String linkUrl,String sldsIcon){
            this.bodyText = bodyText;
            this.title=title;
            this.linkUrl=linkUrl;
            this.sldsIcon = sldsIcon;
        }
    }
}