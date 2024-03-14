trigger chatterCommentTrigger on FeedComment (before insert, before update) {

if(trigger.isBefore && trigger.isInsert){
    system.debug('trigger.new'+trigger.new);
    chatterPost.getUserIdsFromCommentBody(trigger.new);
    
}
if(trigger.isBefore && trigger.isUpdate){
   
    chatterPost.getUserIdsFromCommentBody(trigger.new);
    system.debug(trigger.new);
}

}