({
    showMyToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissable',
            key: 'announcement',
            type:'other',
            title:'My Message Title',
            message: 'This is a required message',
            duration:2000,
            messageTemplate: 'Record {0} created! See it {1}!',
            messageTemplateData: ['Salesforce', {
                url: 'http://www.salesforce.com/',
                label: 'here',
            }
                                 ]
        });
        toastEvent.fire();
    }
})