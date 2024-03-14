@IsTest
public class PreviousSubmissionControllerTest {
    
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
        
       // ContentVersion CreateRecord = OSTestDataFactory.createcontentrecord();
        
       // ContentDocument documents = OSTestDataFactory.documentrecord();
        
       // ContentDocumentLink onCon = OSTestDataFactory.contentrecord();
    }
    
  @IsTest
   static void getOnlineSubTest()  {
       
       Oxfam_Online_Submission__c onSub = [SELECT Id,name,Entity__r.name,Reporting_Period__r.Name,Submission_Type__c FROM Oxfam_Online_Submission__c Limit 1];
        
       System.debug(onSub.Submission_Type__c);
       
       system.debug(onSub.Entity__r.name);
       
       system.debug(onSub.Reporting_Period__r.Name);
        
        Test.startTest();
        
        Oxfam_Online_Submission__c result = PreviousSubmissionController.getOnlineSub(onSub.Submission_Type__c,onSub.Entity__r.name,onSub.Reporting_Period__r.Name);
        
        Test.stopTest();
        
        if (result != null && onSub!=null){
            system.assertEquals(onSub.Name, result.Name);
        } 
            
        //  Verify the result
        
        if (result != null && onSub!=null)
        system.assertEquals(onSub.id,result.id);
        
        if (result != null && onSub!=null)
        System.assertEquals(onSub.Name__c, result.Name__c);
        
        if (result != null && onSub!=null) 
        System.assertEquals(onSub.Entity__c, result.Entity__c);
        
        if (result != null && onSub!=null)
        System.assertEquals(onSub.Reporting_Period__c, result.Reporting_Period__c);    
              
   } //getOnlineSubTest Ends
    
    
    @IsTest
    static void getTaskListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id FROM Oxfam_Online_Submission__c];
        
       List<Oxfam_Task__c> OnTask = [SELECT Id,Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Due_Date__c,
                                Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                                FROM Oxfam_Task__c Where Online_Submission__c = :DisOS.Id order by Due_Date__c];
        
        Test.StartTest();
        
        List<Oxfam_Task__c> Add = PreviousSubmissionController.getTaskList(DisOS.Id);
        
        Test.StopTest();
        
        system.assertEquals(OnTask.Size(),Add.Size());
        
    }//getTaskListTest Ends
    
    
    @IsTest
    static void getFocalListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id FROM Oxfam_Online_Submission__c];
        
        List<Safeguarding_Focal_Point__c> VarSafe = [SELECT Id,Name,Office_Sub_Office__c FROM Safeguarding_Focal_Point__c WHERE Online_Submission__c = :DisOS.Id];
        
        Test.StartTest();
        
        List<Safeguarding_Focal_Point__c> Results = PreviousSubmissionController.getFocalList(DisOS.Id);
        
        Test.StopTest();
        
        system.assertEquals(VarSafe.Size(),Results.Size());
        
        
    }//getFocalListTest Ends 
    
    
    @IsTest
    static void getInfoListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id FROM Oxfam_Online_Submission__c];
        
        list<Information_Provider__c> VarInfo = [SELECT Name,Role__c,Type_Of_Information__c FROM Information_Provider__c WHERE Online_Submission__c = :DisOS.Id];
        
        Test.StartTest();
        
        lIst<Information_Provider__c> Add = PreviousSubmissionController.getInfoList(DisOS.Id);
        
        Test.StopTest();
        
        system.assertequals(VarInfo.Size(),Add.Size());
        
    }//getInfoListTest Ends
    
    
    @IsTest
    
    static void getQAListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
       
        Oxfam_Core_Standard__c VarCoreStandard = [SELECT Id,Name,Core_Standard_Number__c FROM Oxfam_Core_Standard__c];
        
        List<Oxfam_Answer__c> QAList =  [SELECT Id,name FROM Oxfam_Answer__c WHERE Online_Submission__c=:DisOs.Id AND
                                           Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c=: VarCoreStandard.Core_Standard_Number__c
                                           ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
         
        Test.startTest(); 
        
        List<Oxfam_Answer__c> AnswerList = PreviousSubmissionController.getQAList(DisOs.Name,VarCoreStandard.Name);
         
        system.debug(DisOs.Name+'====='+VarCoreStandard.Core_Standard_Number__c);
        
        Test.stoptest();
        
        system.assertEquals(0,AnswerList.size());
        
        //system.assertequals(QAList.Descriptive_Answer__c,AnswerList.Descriptive_Answer__c);
        
        
    }//getQAListTest Ends
    
    
   /* @IsTest
    static void getQAWithBoxLinkRTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
        
        List<Oxfam_Answer__c> QAList =  [SELECT Id,name FROM Oxfam_Answer__c WHERE Question__r.Question_Type__c NOT IN ('Yes/No','Descriptive') AND Online_Submission__c=:DisOs.Id 
                                         ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
        
        Test.startTest(); 
        
        List<Oxfam_Answer__c> AnswerList = PreviousSubmissionController.getQAWithBoxLink(DisOs.Name);
         
        Test.stoptest();
        
        //verfiy the results
        
        system.assertequals(0,AnswerList.size()); 
        
        
    }//getQAWithBoxLinkRTest Ends  */
    
    
    @IsTest
    
    static void getPartnerListTest(){
        
      Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
      
      List<Evidence_Partner__c> ParList = [SELECT Id, name,Project_s_Partner_is_Involved_in__c, Contact_or_Working_with_Children__c,
                                           CS_PSEA_in_Partner_Capacity_Assessment__c,CS_PSEA_in_Partner_Working_Agreement__c, 
                                          PartnerCodeofConductorequivalentSigned__c, CS_and_PSEA_Policy_in_Place__c, Question__c,
                                          Online_Submission__c, Date_of_the_last_CS_training__c, Date_of_the_last_PSEA_training__c FROM Evidence_Partner__c WHERE Online_Submission__c = :DisOS.Id];
     Test.startTest();
     
     List<Evidence_Partner__c> TecList = PreviousSubmissionController.getPartnerList(DisOS.Name);
     
     Test.stopTest();
     
     System.assertEquals(0,TecList.size()); 
   
    }//getPartnerListTest ends
    
    
    @IsTest
    static void getProjectListTest(){
        
      Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
       
      List<Project__c> Statelist = [SELECT Id,name ,Question__c,Project_Start_Date__c,Project_End_Date__c,Is_the_Risk_Assessment_completed__c,partners_involved_in_Risk_Asses__c,Online_Submission__c FROM Project__c WHERE Online_Submission__c = :DisOS.Id];
        
      Test.startTest();
        
      List<Project__c> CenterList = PreviousSubmissionController.getProjectList(DisOS.Id);
       
      Test.stopTest();
      
      System.assertEquals(1,CenterList.size());  
        
    } //getProjectListTest Ends
    
    
    @IsTest
    static void getTrainingListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
        
        List<Oxfam_evidence_training__c> TrainingList = [SELECT Id, Date_Of_Training__c, Description_Of_Training__c, PSEA_Policy__c, Safeguarding_Policy__c,Question__c FROM Oxfam_evidence_training__c WHERE Online_Submission__c=: DisOS.Id];
        
        Test.startTest();
       
        List<Oxfam_evidence_training__c> getList = PreviousSubmissionController.getTrainingList(DisOS.Id);
        
        Test.stopTest();
        
        System.assertEquals(1,getList.size());
        
    }//getTrainingListTest Ends
    
    
    @IsTest
    static void getSummaryListTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c ];
        
        List<Oxfam_Summary__c> SumList = [SELECT Id,CS4_Interview_Template__c,CS4_Reference_Check_Template__c,CS5_Training_Records__c,CS6_Safeguarding_Reporting_Procedure__c,CS7_Examples_of_community_level_feedback__c,
                                          CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,Summary_Achievements__c,Sumamry_Challanges__c,
                                          Summary_Support_Needed__c,Online_Submission__c FROM Oxfam_Summary__c WHERE Online_Submission__c = :DisOS.Id];
        
        
        Test.startTest();
        
        List<Oxfam_Summary__c> AddList = PreviousSubmissionController.getSummaryList(DisOS.Id);
        
        Test.stopTest();
        
        System.assertEquals(1,AddList.size());
   
    }//getSummaryListTest ends
    
    
    @IsTest
    
    static void getAttachmentListTest() {
        
        //create the test online submission record
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c ];
        
        //create the test attachement 
        
        ContentVersion testAttachment = new ContentVersion();
        
        testAttachment.Title = 'Test Attachment';
        
        testAttachment.PathOnClient = 'test.txt';
        
        Blob bodyBlob = Blob.valueOf('Test Attachment Body');
        
        testAttachment.VersionData = bodyBlob;
        
        insert testAttachment;
        
        // creating the content document 
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:testAttachment.Id].ContentDocumentId;
        
        // Create a ContentDocumentLink between the attachment and the Online Submission
        
        ContentDocumentLink testLink = new ContentDocumentLink();
        
        testLink.LinkedEntityId = DisOS.Id;
        
        testLink.ContentDocumentId = conDocId;
        
        Insert testLink;
 
        // Call the getAttachmentList method
        
        Map<ID, String> attachmentMap = PreviousSubmissionController.getAttachmentList(DisOS.Id);
        
        // Assert that the attachment was retrieved successfully
        
        System.assertEquals(1, attachmentMap.size());
        
    }// getAttachmentListTest ends
       
    @IsTest
    
    static void getAllQATest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c];
       
        Oxfam_Core_Standard__c VarCoreStandard = [SELECT Id,Name,Core_Standard_Number__c FROM Oxfam_Core_Standard__c];
        
        List<Oxfam_Answer__c> QAList =  [SELECT Id,name FROM Oxfam_Answer__c WHERE Online_Submission__c=:DisOs.Id AND
                                           Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c=: VarCoreStandard.Core_Standard_Number__c
                                           ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
         
        Test.startTest(); 
        
        List<Oxfam_Answer__c> AnswerList = PreviousSubmissionController.getAllQuestionAnswers(DisOs.Name);
         
        system.debug(DisOs.Name+'====='+VarCoreStandard.Core_Standard_Number__c);
        
        Test.stoptest();
        
        system.assertEquals(0,AnswerList.size());
        
        //system.assertequals(QAList.Descriptive_Answer__c,AnswerList.Descriptive_Answer__c);
        
        
    }//getQAListTest Ends
    
    
    
    
    
    
  
    
    
     /* public Static @IsTest void getOnlineSubtest() {
        List <Oxfam_Online_Submission__c> displaylist = new list <Oxfam_Online_Submission__c>  ();
        Oxfam_Online_Submission__c Vardisplay = new Oxfam_Online_Submission__c (Name__c = 'test b', Role__c = 'Mnager',Submission_Type__c = 'implementation plan' , Email__c = 'test@gmail.com', Entity__c = 'a0A8c00000hypiAEAQ',Reporting_Period__c = 'a078c00000lJHQaAAO', Entity_User__c = 'a0C8c00000YHYF4EAP'); 
        displaylist .add(Vardisplay);
        insert displaylist ;
        Test.startTest();
        
        PreviousSubmissionController.getOnlineSub('implementation plan','a0A8c00000hypiAEAQ', 'a078c00000lJHQaAAO');
       
        Test.stopTest();
        System.assertEquals(displayList.size(),1);
        
    }//getonlinesubtest ends
    
    public static @IsTest void getTaskListtest(){
         List<Oxfam_Task__c> consolidatedList = new List<Oxfam_Task__c>();
        Oxfam_Task__c Varconsolidated = new Oxfam_Task__c(Name = 'CS1/Task-0497',
                                                          Due_Date__c = date.parse('10/6/2022'),
                                                          Person_Responsible_For_The_Activity__c = 'srikanth',
                                                          Completion_Date__c = date.parse('10/19/2022'),
                                                          Status__c = 'Completed',
                                                          Key_Task__c = 'task 1',
                                                          Comments__c = 'this is completed',
                                                          Reporting_Period__c = 'a078c00000lJHFZAA4',
                                                          Online_Submission__c = 'a098c00000t6UI6AAM',
                                                          Core_Standard_Entity__c = 'a0B8c000011x8kQEAQ');
        consolidatedList.add(Varconsolidated);
        insert consolidatedList;
        
        Test.startTest();
      
        PreviousSubmissionController.getTaskList('a0A8c00000hyphyEAA');
        
        Test.stopTest();
        System.assertEquals(consolidatedList.size(),1);
    }//getTasklList test ends
    
    public static @IsTest void  getFocalListtest () {
      List <Safeguarding_Focal_Point__c> Focalpointlist = new list<Safeguarding_Focal_Point__c>();
      Safeguarding_Focal_Point__c   varFocalpoint  = new Safeguarding_Focal_Point__c (Name ='India', Office_Sub_Office__c = 'Post' ,Online_Submission__c = 'a098c00000sszfbAAA' );
      Focalpointlist.add(varFocalpoint);
      insert Focalpointlist; 
      Test.startTest();
        
        PreviousSubmissionController.getFocalList('a098c00000sszfbAAA');
       
        Test.stopTest();
        System.assertEquals(Focalpointlist.size(),1); 
    }// getFocalListtest ends
    
    public static @IsTest void getInfoListtest () {
        List <Information_Provider__c> SafeInfoProvlist = new list <Information_Provider__c>();
        Information_Provider__c VarSafeInfo = new Information_Provider__c (Name = 'test a', Role__c = 'Manager', Type_Of_Information__c = 'test the info', Online_Submission__c = 'a098c00000sszfbAAA' );
        SafeInfoProvlist .add(VarSafeInfo);
        Insert SafeInfoProvlist;
        Test.startTest();
        
        PreviousSubmissionController.getInfoList('a098c00000sszfbAAA');
       
        Test.stopTest();
        System.assertEquals(SafeInfoProvlist.size(),1); 
     }// getInfoListtest ends
    
    public static @IsTest void getQAListtest() {
        list<Oxfam_Answer__c> testList = new list<Oxfam_Answer__c>();
        Oxfam_Answer__c varTest = new Oxfam_Answer__c(Question__c = 'a058c00000dFkA0AAK', Answer__c = 'Yes', Descriptive_Answer__c = 'test the descriptive', Core_Standard_Entity__c = 'a0B8c000011x8kQEAQ', Online_Submission__c = 'a098c00000t6UE0AAM');
        testList.add(varTest);
        insert testList ;
        
        Test.startTest(); 
        
        PreviousSubmissionController.getQAList('testb', 3);
        Test.stopTest();
        System.assertEquals(testList.size(),1);
    }//getQAListtest ends
    
    public static @IsTest void getQAWithBoxLinktest () {
        list<Oxfam_Answer__c> testList = new list<Oxfam_Answer__c>();
        Oxfam_Answer__c varTest = new Oxfam_Answer__c(Question__c = 'a058c00000dFkA0AAK', Answer__c = 'Yes', Descriptive_Answer__c = 'test the descriptive', Core_Standard_Entity__c = 'a0B8c000011x8kQEAQ', Online_Submission__c = 'a098c00000t6UE0AAM');
        testList.add(varTest);
        insert testList ;
        
        Test.startTest(); 
        
        PreviousSubmissionController.getQAWithBoxLink('testb');
        Test.stopTest();
        System.assertEquals(testList.size(),1);
        
    }//getQAWithBoxLinktest ends
    
    public static @IsTest void getTrainingListtest () {
         List<Oxfam_evidence_training__c> getTrainingList = new List<Oxfam_evidence_training__c>();
        Oxfam_evidence_training__c  VarTrain = new Oxfam_evidence_training__c (Question__c = 'a058c00000dFsCQAA0', 
                                                                                Online_Submission__c = 'a098c00000t6UE0AAM',
                                                                                Total_Trained_Staff__c = 6,
                                                                                Date_Of_Training__c = Date.parse('10/19/2022'),
                                                                                Description_Of_Training__c = 'test',
                                                                                Who_Delivered_the_Training__c = 'chandra',
                                                                                Safeguarding_Policy__c = 'Yes',
                                                                                Code_of_Conduct__c = 'Yes',
                                                                                Number_of_Oxfam_staff__c = 1,
                                                                                Number_of_partners__c = 2,
                                                                                Number_of_community__c = 3);
        
       getTrainingList.add(VarTrain);
       insert getTrainingList;
        Test.startTest();
      
        PreviousSubmissionController.getTrainingList('a098c00000t6UE0AAM');
        
        Test.stopTest();
        System.assertEquals(getTrainingList.size(),1);

    }//getTrainingListtest ends
    
    public static @IsTest void getProjectListtest() {
        List<Project__c> ProjectList = new List <Project__c>();
        Project__c Varproject = new Project__c(Name = 'test',
                                               Project_Start_Date__c = Date.parse('10/25/2022'),
                                               Project_End_Date__c = Date.parse('10/25/2022'),
                                               Is_the_Risk_Assessment_completed__c = 'Yes',
                                               partners_involved_in_Risk_Asses__c = 'No',
                                               When_was_the_last_review_update_of_Risk__c = 'test',
                                               Progress_On_Monitoring_High_Risk__c = 'test',
                                               Question__c = 'a058c00000dFsVHAA0',
                                               Online_Submission__c = 'a098c00000t6UE0AAM');
        ProjectList.add(Varproject);
        insert ProjectList;
        
        Test.startTest();
      
        PreviousSubmissionController.getProjectList('a098c00000t6UE0AAM');
        
        Test.stopTest();
        System.assertEquals(ProjectList.size(),1);

    }//getprojectList test ends
    
    public static @IsTest void getPartnerListtest () {
        List<Evidence_Partner__c> getpartnerList = new List<Evidence_Partner__c>();
        Evidence_Partner__c Varpartner = new Evidence_Partner__c(Name = 'hnnas',
                                                                 Project_s_Partner_is_Involved_in__c = 'dfs',
                                                                 Contact_or_Working_with_Children__c = 'Working with children',
                                                                 CS_PSEA_in_Partner_Capacity_Assessment__c = 'Yes' ,
                                                                 CS_PSEA_in_Partner_Working_Agreement__c = 'Yes',
                                                                 PartnerCodeofConductorequivalentSigned__c = 'Yes',
                                                                 CS_and_PSEA_Policy_in_Place__c = 'Yes',
                                                                 Question__c = 'a058c00000dFsUeAAK',
                                                                 Online_Submission__c = 'a098c00000t6UE0AAM',
                                                                 Date_of_the_last_CS_training__c = date.parse('10/26/2022'),
                                                                 Date_of_the_last_PSEA_training__c = date.parse('10/26/2022') );
        getpartnerList.add(Varpartner);
        insert getpartnerList;
        Test.startTest();
      
        PreviousSubmissionController.getPartnerList('a098c00000t6UE0AAM');
        
        Test.stopTest();
        System.assertEquals(getpartnerList.size(),1);
    }//getPartnerListtest ends
    
    public static @IsTest void getSummaryListtest () {
        List<Oxfam_Summary__c> SummaryList = new List<Oxfam_Summary__c>();
        Oxfam_Summary__c VarSummary = new Oxfam_Summary__c(CS4_Interview_Template__c= true, 
                                                           CS4_Reference_Check_Template__c = true,
                                                           CS5_Training_Records__c = true,
                                                           CS6_Safeguarding_Reporting_Procedure__c = true,
                                                           CS7_Examples_of_community_level_feedback__c = true,
                                                           CS8_Sample_Partner_Capacity_Assessment__c = true,
                                                           CS8_Sample_Partner_Working_Agreement__c = true,
                                                           Summary_Achievements__c = 'test',
                                                           Sumamry_Challanges__c = 'ts',
                                                           Summary_Support_Needed__c = 'tst',
                                                           Online_Submission__c = 'a098c00000t6UE0AAM');
        SummaryList.add(VarSummary);
        insert SummaryList;
        
        Test.startTest();
      
        PreviousSubmissionController.getSummaryList('a098c00000t6UE0AAM');
        
        Test.stopTest();
        System.assertEquals(SummaryList.size(),1);

    }*/
    
  
}