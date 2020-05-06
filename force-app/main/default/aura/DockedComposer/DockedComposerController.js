({
    handleToggleEvent:function(cmp,event,helper){
        console.log('Received DockedComposerEvent' + JSON.stringify(event.getParams()));
        if(event.getParam('destroy')){
            cmp.destroy();
        }else{
            cmp.set('v.isOpen',event.getParam('isOpen'));
            cmp.set('v.isExpanded',event.getParam('isExpanded'));
        }
    }
})
