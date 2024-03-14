trigger AnswerBoxFieldTrigger on Oxfam_Answer__c (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        AnswerBoxFieldTriggerHandler.answerUpdateContext(trigger.newMap,trigger.oldMap);
    }

}