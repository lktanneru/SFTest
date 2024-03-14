trigger CloneOnlineSubmissionTrigger on Oxfam_Online_Submission__c (after update,before insert) {
    
    if(trigger.isAfter && trigger.isUpdate){
        //approval process
        for(Oxfam_Online_Submission__c onlineSub : trigger.new)
        {
            if(onlineSub.Approval_Status__c == 'Approved')
            {
                CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onlineSub);                
            }
        }
        
    }
 
    if(trigger.isBefore && trigger.isInsert){
        
        CloneOnlineSubmissionHandler.cloneException(trigger.new);
    }
}