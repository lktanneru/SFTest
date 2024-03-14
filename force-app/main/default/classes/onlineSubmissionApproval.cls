public with sharing class onlineSubmissionApproval {
    @AuraEnabled
    public static String submitAndProcessApprovalRequest(Id onlineSub, string comments) {
        
        String message = 'Success';
        //Qurery the online submission for approval status
        List<Oxfam_Online_Submission__c> OSList = [SELECT Id,Approval_Status__c FROM Oxfam_Online_Submission__c WHERE Id=:onlineSub];
        for(Oxfam_Online_Submission__c OSSingleRec : OSList){
            if(OSSingleRec.Approval_Status__c == 'Approved' || OSSingleRec.Approval_Status__c == 'For Approval'){
                message = 'Record is either submitted for approval or approved';
            }
        }
        
        if(message =='Record is either submitted for approval or approved' ){
            return message;
        }
        
        // Query the user ID of the Manager of the submitting user
        Id managerId = [SELECT ManagerId FROM User WHERE Id = :UserInfo.getUserId()].ManagerId;
        
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(comments);
            req1.setObjectId(onlineSub);
            req1.setSubmitterId(UserInfo.getUserId());
            req1.setNextApproverIds(new List<Id>{ managerId });

            // Submit the approval request
            Approval.ProcessResult result = Approval.process(req1);

            if (!result.isSuccess()) {
                message = 'Error submitting approval request.';
            }
    
        return message;
    }
}