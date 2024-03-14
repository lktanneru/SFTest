public class planAndReportPageController {

    @AuraEnabled(cacheable=true)

    public static List<Oxfam_Online_Submission__c> getSubmissionType(){

        return [SELECT Submission_Type__c FROM Oxfam_Online_Submission__c];

        }
    }