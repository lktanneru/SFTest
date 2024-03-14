({
        handleTabChange: function(cmp,event,helper) {
           
            var eveValue = event.getParam("eveVal");            
            cmp.set('v.tabType', eveValue.tabType);
         var action = cmp.get('c.coreStandardEntityRecord');
        action.setParams({
            "entityName" : eveValue.entityId,
            "corestdName" : eveValue.coresStdValue,
            "reportid" : eveValue.reportPeriodId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                cmp.set('v.id', a.getReturnValue().Id);
            }
        });
        $A.enqueueAction(action);
           

    },
    itemsChange: function(cmp, evt) {
        var subId = evt.getParam("value");
        $A.createComponent("forceChatter:feed", {"type": "record","subjectId":subId,"feedDesign":"DEFAULT"}, function(feed) {
            var feedContainer = cmp.find("feedContainer");
            feedContainer.set("v.body", feed);
        });
    }
})