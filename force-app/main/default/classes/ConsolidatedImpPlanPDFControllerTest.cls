@IsTest
public class ConsolidatedImpPlanPDFControllerTest {

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
    }
 
    @IsTest
    static void ConsolidatedImpPlanPDFControllerTest() {
        
      //create the test data
     
      Oxfam_Entity__c Varox =  [Select id , name from Oxfam_Entity__c ] ;
        
      Oxfam_Core_Standard_Entity__c VarEn = [Select id, Entity__c, Core_Standard__c from Oxfam_Core_Standard_Entity__c where Entity__c =:Varox.Id];
        
      Oxfam_Task__c VarTask = [Select id , name, Core_Standard_Entity__c from Oxfam_Task__c where Core_Standard_Entity__c =:VarEn.Id];  
        
      //Set current page parameters
      
      ApexPages.currentPage().getParameters().put('id', Varox.Id);
        
      //instantiate the controller
     
      ConsolidatedImpPlanPDFController controller = new ConsolidatedImpPlanPDFController();
        
      //Assert the results
      
      system.assertequals(null,controller.Id); //doubt
        
      system.assertequals(VarTask.name,controller.TaskList[0].Name); 
   
     } //ConsolidatedImpPlanPDFControllerTest ends
  
 
    
}