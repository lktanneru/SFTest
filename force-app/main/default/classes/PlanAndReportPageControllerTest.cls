@IsTest
public class PlanAndReportPageControllerTest {
    
      @testSetup
       static void setup(){
        
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
        
        Affiliate_Office__c Office =  OSTestDataFactory.createOfficeRecord();
        
        Entity_Role__c EntRoleRecord = OSTestDataFactory.createEntityRoleRecord();
        
        Entity_Role__c RoleRecord = OSTestDataFactory.createEntityRoleRecord1();
    }
     
       @IsTest
    static void getSubmissionTypeTest() {
        
       list<Oxfam_Online_Submission__c> VarOs = [SELECT Submission_Type__c FROM Oxfam_Online_Submission__c];
        
        Test.StartTest();
        
        List<Oxfam_Online_Submission__c> Results = planAndReportPageController.getSubmissionType();
        
        Test.StopTest();
        
        System.assertEquals(VarOs.Size(),Results.Size());
        
        }
    
   }