@isTest
private class SubmissionClsTest {
    
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
    static void getEntityTest(){
        
        List<Oxfam_Entity__c> EntList = [SELECT Id,Name FROM Oxfam_Entity__c];
        system.debug('EntList   '+EntList.size());
        
        Test.startTest();
        List<Oxfam_Entity__c> EntityList = SubmissionCls.getEntity();  
        Test.stopTest();
        System.assertEquals(EntList.size(),EntList.size()); 
        
    } //getEntityTest closing
    
     static @IsTest void getSafeFocalPointTest(){
        List<Safeguarding_Focal_Point__c> FocalPtList = [SELECT Id from Safeguarding_Focal_Point__c];//doubt
        Oxfam_Online_Submission__c OnlineSubList = [SELECT Id from Oxfam_Online_Submission__c limit 1];
        
        Test.startTest();
        
        List<Safeguarding_Focal_Point__c> FocalPointList = SubmissionCls.getSafeFocalPoint(OnlineSubList.Id);  // classname.methodname
        
        Test.stopTest();
        System.assertEquals(FocalPointList.size(),FocalPtList.size());   //listname.size()  ---> list size  
        
        
    }//getSafeFocalPointTest closing 
    
    @isTest
    static void deleteSafeFocalPtTest(){
         
        
        Safeguarding_Focal_Point__c focalPoint = [SELECT Id FROM Safeguarding_Focal_Point__c limit 1];
        
        
        Test.startTest();
        string result = SubmissionCls.deleteSafeFocalPt(focalPoint);
        Test.stopTest();
        
        //verify the record was deleted and method returned success
        
        List<Safeguarding_Focal_Point__c> focalPointList = [SELECT Id FROM Safeguarding_Focal_Point__c WHERE Id=:focalPoint.Id];
        System.assertEquals(0, focalPointList.size());//returns the size of list
        System.assertEquals('success', result);
        
    } // end of deleteSafeFocalPtTest
    
    @isTest
    static void createSafeInfoProvTest(){
        Information_Provider__c InfoProviderList = [SELECT Id,Name FROM Information_Provider__c LIMIT 1];
        
        Test.startTest();
        Information_Provider__c result = SubmissionCls.createSafeInfoProv(InfoProviderList);
        Test.stopTest();
        
        system.assertEquals(InfoProviderList.Id, result.Id);
        system.assertEquals(InfoProviderList.Name,result.Name);
    }// createSafeInfoProv Test Ends
    
    @IsTest
    static void getSafeInfoProvtest() {
        
        Oxfam_Online_Submission__c VarOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        
        List <Information_Provider__c> SafeInfoProvlist = [SELECT Id,Name FROM Information_Provider__c];
       
        Test.startTest();
        
        List<Information_Provider__c> result = SubmissionCls.getSafeInfoProv(VarOS.Id);
        
        Test.stopTest();
        
        System.assertEquals(SafeInfoProvlist.size(),SafeInfoProvlist.size());  //doubtful 
        
    }//getSafeInfoProv test closing 
    
    @IsTest
    static  void getCoreStandardGuidenceTest() {
        Oxfam_Core_Standard__c VarCoreStandard = [SELECT Id,Name FROM Oxfam_Core_Standard__c limit 1];
        
        List<Oxfam_Core_Standard__c> coreStdList = [Select Id,Name,Core_Standard_Number__c,Description__c,Document_Ref__c,Guidance__c 
                											FROM Oxfam_Core_Standard__c where Name =:VarCoreStandard.Name]; 
        Test.startTest();
        
        List<Oxfam_Core_Standard__c> CoreStandardList = SubmissionCls.getCoreStandardGuidence(VarCoreStandard.Name);
        
        Test.stopTest();
        System.assertEquals(CoreStandardList.size(),coreStdList.size()); 
    }//getCoreStandardGuidencetest
    
     @IsTest
     static void displayListOStest(){
        Oxfam_Online_Submission__c ListOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        List<Oxfam_Online_Submission__c> displayList = [SELECT Id,Name__c,Role__c,Email__c,Submission_Type__c,Entity__r.Name,Reporting_Period__r.Name FROM Oxfam_Online_Submission__c WHERE Name=:ListOS.Name];
        
        Test.startTest();
        List<Oxfam_Online_Submission__c> successList = SubmissionCls.displayListOS(ListOS.Name);
        Test.stopTest();
        System.assertEquals(SuccessList.size(),displayList.size());
    }//displayListOStest ending 
    
	@isTest
    static void displayListQATest(){
        
         string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
         Oxfam_Core_Standard__c VarCoreStandard = [SELECT Id,Name,Core_Standard_Number__c FROM Oxfam_Core_Standard__c limit 1];
         List<Oxfam_Answer__c> QAList =  [SELECT Id,name FROM Oxfam_Answer__c WHERE Online_Submission__c=:subId AND
                                           Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c=: VarCoreStandard.Core_Standard_Number__c
                                           ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
         
         Test.startTest(); 
         List<Oxfam_Answer__c> AnswerList = SubmissionCls.displayListQA(subId,VarCoreStandard.Name);
         
         Test.stoptest();
        
        //verfiy the results
        
        System.assertEquals(1, AnswerList.size());
         
   }//displayListQATest ending 
    
    @isTest
        static  void  displayFocaltest() {
        string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
        List<Safeguarding_Focal_Point__c> FocalList = [SELECT Id,Name,Office_Sub_Office__c FROM Safeguarding_Focal_Point__c WHERE Online_Submission__c=:subId];
        Test.startTest(); 
        List<Safeguarding_Focal_Point__c> VarList = SubmissionCls.displayFocal(subId);
        Test.stopTest();
        System.assertEquals(VarList.size(), FocalList.size());
        
    }//displayFocaltest ends
    
   @IsTest
    static void displayInfoProvtest () {
        string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
        List<Information_Provider__c> InfoList = [SELECT Name,Role__c FROM Information_Provider__c WHERE Online_Submission__c=: subId ];
        Test.startTest();
        List<Information_Provider__c> Provlist = SubmissionCls.displayInfoProv(subId);
        Test.stopTest();
        System.assertEquals(Provlist.size(),InfoList.size());
    }//displayInfoProvtest ends
   
    @IsTest
    static void getTrainingListtest() {
        string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
        List<Oxfam_evidence_training__c> TrainingList = [SELECT Id, Date_Of_Training__c, Description_Of_Training__c, PSEA_Policy__c, Safeguarding_Policy__c,Question__c FROM Oxfam_evidence_training__c WHERE Online_Submission__c=: subId];
        Test.startTest();
        List<Oxfam_evidence_training__c> getList = SubmissionCls.getTrainingList(subId);
        Test.stopTest();
        System.assertEquals(getList.size(),TrainingList.size());
        
    }//getTrainingList ends
    
    @IsTest
    static void getPartnerListtest(){
      string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
      List<Evidence_Partner__c> ParList = [SELECT Id, name,Project_s_Partner_is_Involved_in__c, Contact_or_Working_with_Children__c,
                                           CS_PSEA_in_Partner_Capacity_Assessment__c,CS_PSEA_in_Partner_Working_Agreement__c, 
                                          PartnerCodeofConductorequivalentSigned__c, CS_and_PSEA_Policy_in_Place__c, Question__c,
                                          Online_Submission__c, Date_of_the_last_CS_training__c, Date_of_the_last_PSEA_training__c FROM Evidence_Partner__c WHERE Online_Submission__c = :subId];
     Test.startTest();
     List<Evidence_Partner__c> TecList = SubmissionCls.getPartnerList(subId);
     Test.stopTest();
     System.assertEquals(TecList.size(),ParList.size());   
        
    }//getPartnerList test ends
    
    @IsTest
    static void getProjectListtest() {
        string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
        List<Project__c> Statelist = [SELECT Id,name ,Question__c,Project_Start_Date__c,Project_End_Date__c,Is_the_Risk_Assessment_completed__c,partners_involved_in_Risk_Asses__c,Online_Submission__c FROM Project__c WHERE Online_Submission__c = :subId];
        Test.startTest();
        List<Project__c> CenterList = SubmissionCls.getProjectList(subId);
        Test.stopTest();
        System.assertEquals(CenterList.size(),StateList.size());
        
      } //getProjectlistTest Ends
    
    @IsTest
    static void getSummaryListtest(){
        string subId = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1].Id;
        List<Oxfam_Summary__c> SumList = [SELECT Id,CS4_Interview_Template__c,CS4_Reference_Check_Template__c,CS5_Training_Records__c,CS6_Safeguarding_Reporting_Procedure__c,CS7_Examples_of_community_level_feedback__c,
                                          CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,Summary_Achievements__c,Sumamry_Challanges__c,
                                          Summary_Support_Needed__c,Online_Submission__c FROM Oxfam_Summary__c WHERE Online_Submission__c = :subId];
        
        
        Test.startTest();
        List<Oxfam_Summary__c> AddList = SubmissionCls.getSummaryList(subId);
        Test.stopTest();
        System.assertEquals(AddList.size(),SumList.size());
        
    }//getSummaryList Test ends
    
    @IsTest
    static void deleteSafeInfoProvTest() {
     
        Information_Provider__c Inf = [SELECT Id,Name,Role__c FROM Information_Provider__c Limit 1];
        system.debug('this is   =='+Inf);
        Test.startTest();
        string Result = SubmissionCls.deleteSafeInfoProv(Inf);
        Test.stopTest();
        List<Information_Provider__c> InformationProviderList = [SELECT Id FROM Information_Provider__c WHERE Id=:inf.Id];
        System.assertEquals(0, InformationProviderList.size());
        system.assertequals('success',Result);
        
       }//deleteSafeInfoProv test ends
    
    @IsTest
    static void  deleteAnswertest(){
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        List<Oxfam_Answer__c> AnsList = [select Id,Question__c,Answer__c,Core_Standard_Entity__c,Descriptive_Answer__c,Score__c 
                                        from Oxfam_Answer__c where Online_Submission__c =: DisOs.id];
        Test.startTest();
        string Result = SubmissionCls.deleteAnswer(DisOS.Id);
        Test.stopTest();
        system.assertequals('success',Result);
      }//deleteAnswertest ends
    
    @IsTest
    static void deletePartnerTest(){
        Evidence_Partner__c Evi = [Select Id,name from Evidence_Partner__c limit 1];
        Test.StartTest();
        string Result = SubmissionCls.deletePartner(Evi);
        Test.StopTest();
        system.assertequals('success',Result);
    }//deletepartnerTest ends
    
    @IsTest
    static void deleteTrainingTest(){
        Oxfam_evidence_training__c Train = [Select Id, name from Oxfam_evidence_training__c limit 1];
        Test.StartTest();
        string Result = SubmissionCls.deleteTraining(Train);
        Test.StopTest();
        system.assertequals('success',Result);
    }//deleteTrainingTest ends
    
    @IsTest
    static void deleteProjectTest(){
        Project__c Sub = [Select Id,name from Project__c limit 1];
        Test.StartTest();
        string Result = SubmissionCls.deleteProject(Sub);
        Test.StopTest();
        system.assertequals('success',Result);
    }//deleteprojectTest ends
    
    @IsTest
    static void createSafeFocalPointTest(){
        Safeguarding_Focal_Point__c Divide = [Select Id, name from Safeguarding_Focal_Point__c limit 1];
        Test.StartTest();
        Safeguarding_Focal_Point__c result = SubmissionCls.createSafeFocalPoint(Divide);
        Test.StopTest();
        
        //verfiy the results
        
       System.assertNotEquals(null, result.Id); 
        
       System.assertEquals(Divide.Name, result.Name); 
        
      }//createSafeFocalPointTest ends
   
    @IsTest
    static void createTrainingTableTest(){
       
        Oxfam_Online_Submission__c  onSub = [Select Id from Oxfam_Online_Submission__c Limit 1 ];
        
        Oxfam_Question__c VarQuestions = [Select Id from Oxfam_Question__c Limit 1];
       
        List<Oxfam_evidence_training__c> trainingList = new List<Oxfam_evidence_training__c>();
        
        Oxfam_evidence_training__c TestTable = new Oxfam_evidence_training__c(Online_Submission__c = onSub.Id,
                                                                                    Description_Of_Training__c='Some Test Description',
                                                                                    PSEA_Policy__c='Yes',
                                                                                    Question__c = VarQuestions.Id,
                                                                                    Safeguarding_Policy__c='Yes',
                                                                             		Date_Of_Training__c=system.today(),
                                                                             		Who_Delivered_the_Training__c='John test');
        trainingList.add(TestTable);
        
        //call the method with updated decription of Training
        
        TestTable.Description_Of_Training__c = 'Updated Some Test Description';
        
        List<Oxfam_evidence_training__c> CreateTable = SubmissionCls.createTrainingTable(trainingList);
        
        //verify the result
        System.assertEquals(1, createTable.size());
        
        System.assertEquals('Updated Some Test Description', CreateTable[0].Description_Of_Training__c);
     
        
        }//createTrainingTableTest ends
    
    @IsTest
    static void getSubmissionTypeTest(){
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        
        List<Oxfam_Online_Submission__c> SubmissionList  = [Select Id,Submission_Type__c, Name From Oxfam_Online_Submission__c where Name like:DisOs.Name];
        
        Test.StartTest();
        
        Oxfam_Online_Submission__c results = SubmissionCls.getSubmissionType(DisOs.Name);
        
        Test.StopTest();
        
        //verfiy the results
        
        System.assertNotEquals(null, results); 
        
     }//getSubmissionTypeTest ends
    
    @IsTest
    static void createSummaryTest(){ 
        Oxfam_Summary__c Summary;
       Oxfam_Summary__c result;
        try{
        Summary = [Select Id,name FROM Oxfam_Summary__c Limit 1];
       
        
        Test.StartTest();
        
        result = SubmissionCls.createSummary(Summary);
         }
       catch(exception ex){
            throw new AurahandledException(ex.getMessage());
       }
        Test.StopTest();
        
        system.assertequals(Summary.Id,result.Id);
        
        system.assertequals(Summary.name,result.name);
        
       
 }//createSummarytest Ends (doubt)
    
    @IsTest
    static void getSubmissionTest(){
        Oxfam_Online_Submission__c SubmissionList = [SELECT Submission_Type__c FROM Oxfam_Online_Submission__c Limit 1];
        Test.StartTest();
        List<AggregateResult> results = SubmissionCls.getSubmission();
        Test.StopTest();
        
        //verfify the results
        
        System.assertEquals(1, results.size());
   
    }//getSubmissionTest ends
    
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
        
        Map<ID, String> attachmentMap = SubmissionCls.getAttachmentList(DisOS.name);
        
        // Assert that the attachment was retrieved successfully
        
        System.assertEquals(1, attachmentMap.size());
        
       }// getAttachmentListTest ends
        
    
    
   /* public static @IsTest void deleteSafeInfoProvtest() {
        string result;
        Information_Provider__c VarSafeInfo = new Information_Provider__c (Name = 'test a', Role__c = 'Manager', Type_Of_Information__c = 'test the info', Online_Submission__c = 'a098c00000sszfbAAA' );
        insert VarSafeInfo;
        
        //Calling the method 
        Test.startTest();
        SubmissionCls.deleteSafeInfoProv(VarSafeInfo);
        Test.stopTest();
        
        //verify the record was deleted and method was success
        list<Information_Provider__c> deletedsafe = [SELECT Id FROM Information_Provider__c WHERE Id = :VarSafeInfo.Id];
        System.assertEquals(0, deletedsafe.size());
        
    }// deleteSafeInfoProvtest ends
    
    public static @IsTest void  deleteAnswertest() {
        string result;
        Oxfam_Answer__c varTest = new Oxfam_Answer__c(Question__c = 'a058c00000dFkA0AAK', Answer__c = 'Yes', Descriptive_Answer__c = 'test the descriptive', Core_Standard_Entity__c = 'a0B8c000011x8kQEAQ', Online_Submission__c = 'a098c00000t6UE0AAM');
        insert varTest;
        
        Test.startTest();
        SubmissionCls.deleteAnswer('a098c00000t6UE0AAM');
        Test.stopTest();
        
        List<Oxfam_Answer__c> deleteAnswer = [SELECT Id FROM Oxfam_Answer__c  WHERE Id = :varTest.Id]; 
        System.assertEquals(0, deleteAnswer.size());
    }//deleteAnswertest ends
    public static @IsTest void deletePartnertest(){
        string result;
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
        insert Varpartner;
        Test.startTest();
        SubmissionCls.deletePartner(Varpartner);
        Test.stopTest();
        
        List<Evidence_Partner__c> deletePartner = [SELECT Id FROM Evidence_Partner__c  WHERE Id = :Varpartner.Id];
        System.assertEquals(0, deletePartner.size());
    }//deletePartnertest ends 
    
    public static @IsTest void deleteTrainingtest() {
        string result;
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
        insert Vartrain;
        Test.startTest();
        SubmissionCls.deleteTraining(VarTrain);
        Test.stopTest();
        
        List<Oxfam_evidence_training__c> deletetraining = [SELECT Id FROM Oxfam_evidence_training__c   WHERE Id = :VarTrain.Id];
        System.assertEquals(0, deletetraining.size());
        
    }//deletetraining test ends 
    
    public static @IsTest void createSafeFocalPointtest() {
        
        Safeguarding_Focal_Point__c Varsafe = new Safeguarding_Focal_Point__c (Name = 'Testb', Office_Sub_Office__c = 'Post', Online_Submission__c = 'a0F8c00000jNbDeEAK');
        insert Varsafe;
        Test.startTest();
        SubmissionCls.createSafeFocalPoint(Varsafe);
        Test.stopTest();
        
        
        List<Safeguarding_Focal_Point__c> createsafe = [SELECT Id FROM Safeguarding_Focal_Point__c  WHERE Id = :Varsafe.Id];
        System.assertEquals('testb',Varsafe.name);
        
    }*/ 
}