({
	initialize : function(cmp, event, helper) {
        if(cmp.get('v.tileConfigJson') !=null){
            cmp.set('v.tiles',JSON.parse(cmp.get('v.tileConfigJson')));
			
        }
	}
})