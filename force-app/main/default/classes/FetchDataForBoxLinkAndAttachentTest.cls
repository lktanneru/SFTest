@isTest
public class FetchDataForBoxLinkAndAttachentTest {
    
   @testSetup
    
    static void setup() {  
        
        Oxfam_Entity__c EntityRecord = OSTestDataFactory.createEntityRecord();
        
        Oxfam_Reporting_Period__c RepPeriodRecord = OSTestDataFactory.createRepPeriodRecord();
        
        Oxfam_Entity_User__c EntityUserRecord = OSTestDataFactory.createEntityUserRecord();
        
        Oxfam_Online_Submission__c onlineSubRecord = OSTestDataFactory.createOnlineSubRecord();
        
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
    
    // Define the EvidenceWrapper class inside the test class
    
    public class EvidenceWrapper {
       
        @AuraEnabled public String Id { get; set; }
        
        @AuraEnabled public String QuestionName { get; set; }
        
        @AuraEnabled public String evidenceType { get; set; }
        
        
        @AuraEnabled public String BoxLinks { get; set; }
        
        @AuraEnabled public String Attachments { get; set; }
    }
    
    @isTest
    static void testfetchBoxLinksFromOnlineSubmission() {
        
         //Create the test data
      
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c VarTrain = [Select id from Oxfam_evidence_training__c limit 1];
        
        Oxfam_Answer__c VarAns = [select id from Oxfam_Answer__c limit 1];
        
        Box_Link__c  add = new  Box_Link__c(Answer__c = VarAns.Id,
                                            Evidence_Training__c = VarTrain.Id,
                                            Question__c = Varquestions.Id,
                                            Online_Submission__c = onSub.Id,
                                            Box_Link__c = 'First Url',
                                            Type__c = '6 months progress report');
        
        Insert add;
        

        
        // Call the method to be tested
        
        List<FetchDataForBoxlinkAndAttachent.EvidenceWrapper> result = FetchDataForBoxlinkAndAttachent.fetchBoxLinksFromOnlineSubmission(onSub.Id);
        
        // Assuming EvidenceWrapper properties are mainly for data representation
        
        FetchDataForBoxlinkAndAttachent.EvidenceWrapper wrapper = new FetchDataForBoxlinkAndAttachent.EvidenceWrapper();
       
        wrapper.Id = 'TestId';
        
        wrapper.QuestionName = 'Test Question';
        
        wrapper.evidenceType = 'Test Type';
        
        //wrapper.BoxLinks = new List<String>{'Link1', 'Link2'};
        
        wrapper.Attachments = 'Attachment1, Attachment2';
        
        //verify the results
       
        System.assertEquals(1, result.size());
      
        
     }//testfetchBoxLinksFromOnlineSubmissionends
    
    public class EvidenceWrappers {
       
        @AuraEnabled public String Id { get; set; }
        
        @AuraEnabled public String QuestionName { get; set; }
        
        @AuraEnabled public String evidenceType { get; set; }
        
        
        @AuraEnabled public String BoxLinks { get; set; }
        
        @AuraEnabled public String Attachments { get; set; }
    }
    
    @isTest
    static void testfetchBoxLinksFromOnlineSubmissionwithnull() {
        
         //Create the test data
      
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c VarTrain = [Select id from Oxfam_evidence_training__c limit 1];
        
        Oxfam_Answer__c VarAns = [select id from Oxfam_Answer__c limit 1];
        
        Box_Link__c  add = new  Box_Link__c(Answer__c = VarAns.Id,
                                            Evidence_Training__c = VarTrain.Id,
                                            Question__c = Varquestions.Id,
                                            Online_Submission__c = onSub.Id,
                                            Box_Link__c = 'First Url',
                                            Type__c = ' ');
        
        Insert add;
        
        // Call the method to be tested
        
        List<FetchDataForBoxlinkAndAttachent.EvidenceWrapper> result = FetchDataForBoxlinkAndAttachent.fetchBoxLinksFromOnlineSubmission(onSub.Id);
        
        // Assuming EvidenceWrapper properties are mainly for data representation
        
        FetchDataForBoxlinkAndAttachent.EvidenceWrapper wrapper = new FetchDataForBoxlinkAndAttachent.EvidenceWrapper();
       
        wrapper.Id = 'TestId';
        
        wrapper.QuestionName = 'Test Question';
        
        wrapper.evidenceType = 'Test Type';
        
        wrapper.Attachments = 'Attachment1, Attachment2';
        
        //verify the results
       
        System.assertEquals(1, result.size());
    
    }//testfetchBoxLinksFromOnlineSubmissionwithnullEnds
    
    
    @isTest
    
    static void testDeleteBoxLink() {
      
        //create the test data
      
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c VarTrain = [Select id from Oxfam_evidence_training__c limit 1];
        
        Oxfam_Answer__c VarAns = [select id from Oxfam_Answer__c limit 1];
        
        Box_Link__c  add = new  Box_Link__c(Answer__c = VarAns.Id,
                                            Evidence_Training__c = VarTrain.Id,
                                            Question__c = Varquestions.Id,
                                            Online_Submission__c = onSub.Id,
                                            Box_Link__c = 'First Url',
                                            Type__c = '6 months progress report ');
        
        Insert add;
        
        
        //call the method to test 
        
        string result = FetchDataForBoxlinkAndAttachent.deleteBoxLink(add);
        
        // Perform assertions to validate the results
        
        System.assertEquals('success', result, 'Deletion should be successful');
        
        // Try to retrieve the deleted record - it should not exist
       
        List<Box_Link__c> deletedRecords = [SELECT Id FROM Box_Link__c WHERE Id = :add.Id];
        
        System.assertEquals(0, deletedRecords.size(), 'Deleted record should not exist');
        
        
    }//testDeleteBoxLinkends
    
    
    @isTest
    
    static void testDeleteBoxLinkException() {
        
        //call the method being tested
     
        try {
            String result = FetchDataForBoxlinkAndAttachent.deleteBoxLink(null);
            // The above line should throw an exception, so the code below won't execute
            
            System.assert(false, 'Exception should have been thrown');
        
        } catch (AuraHandledException e) {
            // Perform assertions to validate the caught exception
           
            System.assertEquals('System.AuraHandledException', e.getTypeName(), 'Exception type should match');
           
           // System.assert(e.getMessage().contains('Attempt to de-reference a null object'), 'Exception message should contain expected text');
        
        }
        
   }//testDeleteBoxLinkExceptionends
    
    @isTest
    
    static void testFetchAttachmentsFromOnlineSubmission() {
        
        //create the test online submission record
        
      Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c ];  
        
     // Create the test attachment
     
      ContentVersion testAttachment = new ContentVersion();
      
      testAttachment.Title = 'Test Attachment';
      
      testAttachment.PathOnClient = 'test.txt';
      
      Blob bodyBlob = Blob.valueOf('Test Attachment Body');
      
      testAttachment.VersionData = bodyBlob;
      
      insert testAttachment;   
        
     // Get the ContentDocument ID of the test attachment
     
     Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testAttachment.Id].ContentDocumentId;
        
     // Create a ContentDocumentLink between the attachment and the Online Submission
       
      ContentDocumentLink testLink = new ContentDocumentLink();
       
      testLink.LinkedEntityId = disOS.Id;
      
      testLink.ContentDocumentId = contentDocumentId;
       
      insert testLink;
        
      List<String> fileIds = new List<String>();
     
      fileIds.add(contentDocumentId);
        
      Test.startTest();  
        
      List<FetchDataForBoxlinkAndAttachent.EvidenceWrapper> result = FetchDataForBoxlinkAndAttachent.fetchAttachmentsFromOnlineSubmission(DisOS.Id);
        
      Test.StopTest();  
    
      //verify the results
   
      System.assertEquals(1, result.size());  
   
    }//testFetchAttachmentsFromOnlineSubmissionEnds
    
    
    @isTest
    
    static void testFetchAttachAndBoxLinkFromOnlineSubmission () {
        
         //create the test online submission record
        
      Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c ]; 
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c VarTrain = [Select id from Oxfam_evidence_training__c limit 1];
        
        Oxfam_Answer__c VarAns = [select id from Oxfam_Answer__c limit 1];
        
        Box_Link__c  add = new  Box_Link__c(Answer__c = VarAns.Id,
                                            Evidence_Training__c = VarTrain.Id,
                                            Question__c = Varquestions.Id,
                                            Online_Submission__c = DisOS.Id,
                                            Box_Link__c = 'First Url',
                                            Type__c = '6 months progress report ');
        
        Insert add; 
        
     // Create the test attachment
     
      ContentVersion testAttachment = new ContentVersion();
      
      testAttachment.Title = 'Test Attachment';
      
      testAttachment.PathOnClient = 'test.txt';
      
      Blob bodyBlob = Blob.valueOf('Test Attachment Body');
      
      testAttachment.VersionData = bodyBlob;
      
      insert testAttachment;   
        
     // Get the ContentDocument ID of the test attachment
     
     Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testAttachment.Id].ContentDocumentId;
        
     // Create a ContentDocumentLink between the attachment and the Online Submission
       
      ContentDocumentLink testLink = new ContentDocumentLink();
       
      testLink.LinkedEntityId = disOS.Id;
      
      testLink.ContentDocumentId = contentDocumentId;
       
      insert testLink;
        
      List<String> fileIds = new List<String>();
     
      fileIds.add(contentDocumentId);
        
      Test.StartTest();  
        
      List<FetchDataForBoxlinkAndAttachent.EvidenceWrapper> result = FetchDataForBoxlinkAndAttachent.fetchAttachAndBoxLinkFromOnlineSubmission(DisOS.Id);
  
      Test.StopTest();
        
      //verify the results
      
      System.assertEquals(2, result.size());  
        
    }//testFetchAttachAndBoxLinkFromOnlineSubmissionEnds
    
    
    
    @isTest
    
    static void testsubmissionIdFromNamePositive() {
        try{
            string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c ].Id; 
        
       
        	Test.StartTest();
        
        	Oxfam_Online_Submission__c add = FetchDataForBoxlinkAndAttachent.submissionIdFromName(subId);
        
        	Test.StopTest();
        }catch(exception e){throw new AuraHandledException(e.getMessage()); }
    }
    
    @isTest
    
    static void testsubmissionIdFromNameNegative() {
        
        string subId = [SELECT Id,name,Role__c,Email__c FROM Oxfam_Online_Submission__c ].Id; 
        
        Test.StartTest();
        
        Oxfam_Online_Submission__c add = FetchDataForBoxlinkAndAttachent.submissionIdFromName(subId);
        
        Test.StopTest();
        
        
    }
    
    
    
}