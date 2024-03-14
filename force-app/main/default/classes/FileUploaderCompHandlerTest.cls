@isTest
public class FileUploaderCompHandlerTest {
    
   
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
    
    @isTest
    static void UploadFile(){
          
        String base64 = 'VGhpcyBpcyBhIHRlc3Q=';
        
        String filename = 'testFile.txt;test;test2';
        
        String recordId = '001000000000000';
        
        String docType = 'Document Type';
        
        String filename2 = 'samplefile.txt';
        
        Test.startTest();
        
        String contentLinkId = FileUploaderCompHandler.uploadFile(base64, filename, recordId, docType, filename2);
        
        Test.stopTest();
        
        System.assertEquals(contentLinkId,null);
       }
   
    //Test case 2: Upload file with invalid base64 data
    @isTest
    static void UploadFileTest1(){
       
        //creating the test data   
        
        String invalidBase64 = 'Invalid Base64';
        
        String filename = 'testFile.txt;test;test2';
        
        String recordId = '001000000000000';
        
        String docType = 'Document Type';
        
        String filename2 = 'samplefile.txt';
        
       //calling the method 
        
        Test.startTest();
        
        String contentLinkId = FileUploaderCompHandler.uploadFile(invalidBase64, filename, recordId, docType, filename2);
        
        Test.stopTest();
       
        //verifying the result
        
        System.assertEquals(contentLinkId, null);
        
    }//UploadFileTest1 Ends
    
    // Test case 3: Upload file with invalid recordId
    
    @isTest
    static void UploadFileTest2 () {
     
        //creating the test data 
        
         String base64 = 'VGhpcyBpcyBhIHRlc3Q=';
        
        String filename = 'testFile.txt;test;test2';
        
        String invalidRecordId = '001001000000000';
        
        String docType = 'Document Type';
        
        String filename2 = 'samplefile.txt';
        
       //calling the method  
        
        Test.startTest();
        
        String contentLinkId = FileUploaderCompHandler.uploadFile(base64, filename, invalidRecordId, docType, filename2);
        
        Test.stopTest();
       
       //verifying the result 
        
        System.assertEquals(contentLinkId, null);
  
    }//UploadFileTest2 ends
    
    @isTest
    static void testDeleteFiles() {
        
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
        
      FileUploaderCompHandler.deleteFiles(fileIds);

      Test.stopTest();  
   
        
        
        
        
        
        
        
        
        
        
        
        
        
        
 
      
        }
    
    
}