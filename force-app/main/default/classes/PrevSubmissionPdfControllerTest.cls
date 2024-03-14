@IsTest
public class PrevSubmissionPdfControllerTest {
   
    @testSetup
    static void setup() {
        
        Oxfam_Entity__c EntityRecord = OSTestDataFactory.createEntityRecord();
        
        Oxfam_Reporting_Period__c RepPeriodRecord = OSTestDataFactory.createRepPeriodRecord();
        
        Oxfam_Entity_User__c EntityUserRecord = OSTestDataFactory.createEntityUserRecord();
        
        Oxfam_Online_Submission__c onlineSubRecord = OSTestDataFactory.createOnlineSubRecord();
        
        Safeguarding_Focal_Point__c FocalPointRecord = OSTestDataFactory.createFocalPointRecord();
        
        Information_Provider__c infoProviderRecord = OSTestDataFactory.createInfoProviderRecord();
        
        Oxfam_Core_Standard__c coreStandardRecord = OSTestDataFactory.createCoreStandardRecord();
        
        Oxfam_Question__c questionRecord = OSTestDataFactory.createQuestoinRecord();
        
        Oxfam_Core_Standard_Entity__c coreStdEntityRecord =  OSTestDataFactory.createCoreStdEntityRecord();
        
        Oxfam_Answer__c anwerRecord = OSTestDataFactory.createAnswerRecord();
                
        Oxfam_Task__c taskRecord = OSTestDataFactory.createTaskRecord();
        
        Oxfam_evidence_training__c  TrainingRecord = OSTestDataFactory.createTrainingRecord();
        
        Oxfam_Summary__c SummaryRecord = OSTestDataFactory.createSummaryRecord();
        
        Evidence_Partner__c PartnerRecord = OSTestDataFactory.createPartnerRecord();
        
        Project__c ProjectRecord = OSTestDataFactory.createProjectRecord();
    }
     
    @IsTest
    
    static void OnlineSubmissionTest(){
       
        //Create the test data
        
        Oxfam_Online_Submission__c VarOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Online_Submission__c  Test = [SELECT Id,Name,Submission_Type__c from Oxfam_Online_Submission__c WHERE Id= :VarOS.Id];
        
        //set current page parameters
        
        ApexPages.currentPage().getParameters().put('id', Test.Id);
        
        //instantiate the controller
        
        PrevSubmissionPdfController controller = new PrevSubmissionPdfController();
        
        
        
        
     }

}