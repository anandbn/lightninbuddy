({
    showMyToast: function (component, event, helper) {

        var appEvent = $A.get("e.c:ShowWelcomeMat");
        var theJson = '[{"title":"Update your user profile","sldsIcon":null,"linkUrl":"http://#","bodyText":"Make sure you upload a photo and join the new employees  chatter group"},{"title":"Track adoption with Dashboards","sldsIcon":"action:approval","linkUrl":"https://appexchange.salesforce.com/appxListingDetail?listingId=a0N30000004gHhLEAU","bodyText":"Click to install your adoption dashboards."},{"title":"Business Value Dashboards","sldsIcon":"action:approval","linkUrl":"https://www.salesforce.com","bodyText":"Track your business goals with these dashboards"},{"title":"Talk to your manager about Quota","sldsIcon":"action:goal","linkUrl":null,"bodyText":"Talk to your manager about Sales Strategy"}]';
        var eventParams = {
            title: "Hello World",
            bodyText: "Heloooooo Worldly creatures",
            actionId: "a010b00000eRXM6AAO",
            tileConfigJson: theJson
        };
        appEvent.setParams(eventParams);
        appEvent.fire();
    }
})