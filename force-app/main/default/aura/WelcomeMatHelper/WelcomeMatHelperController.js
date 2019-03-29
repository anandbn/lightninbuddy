({
    displayWelcomeMat: function (component, event, helper) {
        var theJson = '[{"title":"Update your user profile","sldsIcon":null,"linkUrl":"http://#","bodyText":"Make sure you upload a photo and join the new employees  chatter group"},{"title":"Track adoption with Dashboards","sldsIcon":"action:approval","linkUrl":"https://appexchange.salesforce.com/appxListingDetail?listingId=a0N30000004gHhLEAU","bodyText":"Click to install your adoption dashboards."},{"title":"Business Value Dashboards","sldsIcon":"action:approval","linkUrl":"https://www.salesforce.com","bodyText":"Track your business goals with these dashboards"},{"title":"Talk to your manager about Quota","sldsIcon":"action:goal","linkUrl":null,"bodyText":"Talk to your manager about Sales Strategy"}]';
        $A.createComponent(
            "c:WelcomeMatNoModal",
            {
                title: event.getParam('title'),
                bodyText:  event.getParam('bodyText'),
                actionId:  event.getParam('actionId'),
                tileConfigJson:  event.getParam('tileConfigJson'),
                showOnlyOnce:  event.getParam('showOnlyOnce'),
                backgroundImgUrl:  event.getParam('backgroundImgUrl'),
            },
            function (newCmp, status, errorMsg) {
                if (status === "SUCCESS") {
                    var body = component.get('v.body');
                    body.push(newCmp);
                    component.set('v.body',body);
                }
            }
        );                      


    }
})
