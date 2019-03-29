({
    doInit : function(cmp, event, helper) {
        var flowCmp = cmp.find('flow');
        var inputVariables = [
            {name:"recordId",type:"String",value:cmp.get('v.recordId')}
        ];
        flowCmp.startFlow(cmp.get('v.flowName'),inputVariables);
    },
    handleStatusChange : function (cmp, event,helper) {
        console.log('Status changed');
        if(event.getParam("status") === "FINISHED") {
            helper.finishedClicked(cmp,event); 
        }    
   	},
    handleCancel : function(cmp, event, helper) {
        //closes the modal or popover from the component
        cmp.find("overlayLib").notifyClose();
    }
})