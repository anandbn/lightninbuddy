({
	initializeCards : function(cmp, event, helper) {
        
        if(cmp.get('v.cardInfo') !=null){
            cmp.set('v.cardList',JSON.parse(cmp.get('v.cardInfo')));
        }
	}
})