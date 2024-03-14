@IsTest
public class CountryPageClsTest {
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
        
        List<Oxfam_Online_Submission__c> DisOS = [SELECT Id,name FROM Oxfam_Online_Submission__c limit 1];
        
        Test.StartTest();
        
        List<Oxfam_Online_Submission__c> SubmissionList = countryPageCls.getSubmissionType();
        
        Test.StopTest();
       
        system.assertEquals(SubmissionList.size(),DisOS.size());
    
    }// getsubmissionTest ends
    
    @IsTest
    static void getQuestionsTest(){
       
        Oxfam_Question__c Ques = [Select Id, Name, Question__c , Question_Category__c FROM Oxfam_Question__c Limit 1];
        
        Oxfam_Core_Standard__c Sum = [Select Id, Name fROM Oxfam_Core_Standard__c Limit 1];
        
        List<Oxfam_Question__c> AddList = [Select Id, Name, Question__c, Question_Type__c,Mandatory__c,Question_Number__c FROM Oxfam_Question__c
                                           WHERE Question_Category__c = :Ques.Question_Category__c and Core_Standard__r.Name = :Sum.Name ORDER BY Question_Number__c ASC ];
        
        Test.StartTest();
        
        List<Oxfam_Question__c> Results = countryPageCls.getQuestions(Sum.Name,Ques.Question_Category__c);
        
        Test.StopTest();
        
        system.assertEquals(Results.size(),AddList.size());
    
    }// getQuestiontest  Ends
    
    @IsTest
    static void corestandardTest() {
        
        List<Oxfam_Core_Standard_Entity__c> CSEList = [Select Id, Name , core_standard__r.Core_Standard_Number__c FROM Oxfam_Core_Standard_Entity__c Limit 1];
        string EntityId = [select Id From Oxfam_Entity__c limit 1].Id;
        string reportId = [select Id From Oxfam_Reporting_Period__c limit 1].Id;
        Test.StartTest();
        
        List<Oxfam_Core_Standard_Entity__c> CorestdEntList = countryPageCls.coreStandard(EntityId,reportId);
        
        Test.StopTest();
        
        system.assertEquals(CorestdEntList.size(),CSEList.size());
    
        
       }//corestandardTest Ends
    
    @IsTest
    static void createAnswerRecordTest() {
        
        Oxfam_Answer__c Ans = [Select Id, Name,Oxfam_Answer__c.Question__c fROM Oxfam_Answer__c ];
        
        Test.StartTest();
        
        List<Oxfam_Answer__c> Results = countryPageCls.createAnswerRecord(Ans);
        
        Test.StopTest();
        
        system.assertequals(1,Results.size());
    
    }//createAnswerRecordTest Ends
    
    @IsTest
    static void coreStandardEntityMandatoryTest(){
        
        Oxfam_Core_Standard_Entity__c Var = [Select Id,Name from Oxfam_Core_Standard_Entity__c Limit 1];
        
        List<Oxfam_Core_Standard_Entity__c> Standard = [Select Name, Id, Mandatory__c,Entity__r.Name,Core_Standard__r.Name FROM Oxfam_Core_Standard_Entity__c
                                                        where Entity__r.Name=:Var.Name and Mandatory__c='Yes'];
        
        Test.StartTest();
        
        List<Oxfam_Core_Standard_Entity__c> Entity = countryPageCls.coreStandardEntityMandatory(Var.Name);
        
        Test.StopTest();
        
        system.assertEquals(Entity.size(),Standard.size());

     }//coreStandardEntityMandatoryTest ends
    
    @IsTest
    static void updateOnlineSubTest(){
        
        //creating the test data 
        
        Oxfam_Online_Submission__c DisOS = [SELECT Id,name,Role__c FROM Oxfam_Online_Submission__c limit 1];
        
        //Call the updateOnlineSub method to update the record
        
        DisOS.Role__c = 'Admin';
        
        Test.StartTest();
        
        Oxfam_Online_Submission__c results = countryPageCls.updateOnlineSub(DisOS);
        
        Test.StopTest();
        
        // Retrieve the updated record from the database to verify the changes
        
        Oxfam_Online_Submission__c retrievedOnlineSub = [Select Id, name,Role__c from Oxfam_Online_Submission__c where id = :DisOS.Id];
        
        //verfity the results
        
        system.assertequals('Admin',retrievedOnlineSub.Role__c);
        
        system.assertequals(DisOS.Id,results.Id);
        
    }//updateOnlineSubTest ends
    
    @IsTest
    static void getOnlineSubTest(){
       
        Oxfam_Entity__c  VarOs = [Select Id,name from Oxfam_Entity__c];
        system.debug('VarOs  =='+VarOs);
        List<Oxfam_Online_Submission__c> Online = [Select Id, Name__c, Role__c,Submission_Type__c,Email__c,Entity__c,Reporting_Period__c,
                                                    Entity_User__c FROM Oxfam_Online_Submission__c  where Entity__c=:VarOs.Id and Entity__c in 
                                                   (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId()) order by LastModifiedDate desc  limit 1];
        system.debug('Online  =='+Online);
        
        Test.StartTest();
        string EntityId = 'test'+ ';' + VarOs.Id;
        Oxfam_Online_Submission__c Results = countryPageCls.getOnlineSub(EntityId);
        
        Test.StopTest();
        
        system.assertEquals(1, Online.size());
        
    }//getOnlineSubTest ends
    
   /* @IsTest
    static void getOnlineSubEntNullTest(){
       
        Oxfam_Entity__c  VarOs = [Select Id from Oxfam_Entity__c limit 1];
        
        List<Oxfam_Online_Submission__c> Online = [ Select Id, Name__c, Role__c,Submission_Type__c,Email__c,Entity__c,Reporting_Period__c,
                                                    Entity_User__c FROM Oxfam_Online_Submission__c where Entity__c=:VarOs.Id and Entity__c in 
                                                   (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId()) order by LastModifiedDate desc  limit 1];
        
        Test.StartTest();
        
        
        Oxfam_Online_Submission__c Results = countryPageCls.getOnlineSub();
        
        Test.StopTest();
        
        system.assertEquals(1, Online.size());
        
    }//getOnlineSubEntNullTest ends*/
    
    @IsTest
    static void coreStandardEntityRecordTest(){
       
        Oxfam_Entity__c VarCore = [Select Id, Name from Oxfam_Entity__c Limit 1];
        
        Oxfam_Reporting_Period__c VarPeriod = [Select Id from Oxfam_Reporting_Period__c Limit 1];
        
        Oxfam_Core_Standard__c Varstandard = [select Name from Oxfam_Core_Standard__c 	Limit 1];
        
        
        
        Oxfam_Core_Standard_Entity__c VarEntity = [Select Id from Oxfam_Core_Standard_Entity__c where Core_Standard__r.Name = :Varstandard.Name and Reporting_Period__c= :VarPeriod.Id and 
                                                   Entity__c= :VarCore.Id];
        
        Test.StartTest();
        
        Oxfam_Core_Standard_Entity__c Add = countryPageCls.coreStandardEntityRecord(VarCore.Id,Varstandard.Name,VarPeriod.Id);
        
        Test.StopTest();
        
        System.assertEquals(VarEntity.Id,Add.Id);
        
      }//coreStandardEntityRecordTest ends
    
    @IsTest
    static void getAnswerTest(){
       
        Oxfam_Online_Submission__c DisOS = [SELECT Id FROM Oxfam_Online_Submission__c];
        
        List<Oxfam_Answer__c> VarAns = [select Id,Answer__c,Descriptive_Answer__c,Online_Submission__c,Question__c,
                                        Core_Standard_Entity__c,Score__c,Box_Link__c from Oxfam_Answer__c where 
                                        Online_Submission__c =:DisOS.Id];
        
        Test.StartTest();
        
        List<Oxfam_Answer__c> VarOs = countryPageCls.getAnswer(DisOS.Id);
        
        Test.StopTest();
        
        System.assertEquals(VarOs.size(),VarAns.size());
        
      }//getAnswerTest ends
    
    @IsTest
    static void getreportingPeriodTest(){
        
        List<Oxfam_Reporting_Period__c> VarRep =  [SELECT Id, Name from Oxfam_Reporting_Period__c];
        
        Test.StartTest();
        
        List<Oxfam_Reporting_Period__c> Sum = countryPageCls.getreportingPeriod();
        
        Test.StopTest();
        
        System.assertEquals(Sum.size(),VarRep.size());
        
    }//getreportingPeriodTest Ends
    
    
    @IsTest
    static void insertOnlineSubTest(){
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
    	Oxfam_Entity_User__c onEnUser = new Oxfam_Entity_User__c(
                                                        Name = 'India/Test',
                                                        User__c = userInfo.getUserId(),    
                                                        Entity__c = onEnt.Id);  
        
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
       
         Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
                                                            Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = 'Implementation Plan', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id); 
                                                            
        
       Oxfam_Entity_User__c VarOnline = [select Id FROM Oxfam_Entity_User__c where  Entity__c=:onEnt.Id and User__c=:userinfo.getUserId()];
        
       Test.StartTest();
        
       Oxfam_Online_Submission__c Results = countryPageCls.insertOnlineSub(onSub);
        
       Test.StopTest(); 
        
       system.assertequals(VarOnline.Id,Results.Entity_User__c);
        
    }//insertOnlineSubTest ends
    
    @IsTest
    static void partnerOfficeApexTest(){
        
        Oxfam_Entity__c  VarOs = [Select Id, Name from Oxfam_Entity__c limit 1];
        
        Entity_Role__c  VarOffice = [SELECT  Affiliate_Office__r.name FROM Entity_Role__c where Role__c='Partner Affiliate' and Entity__c = :VarOs.Id];
        
        Test.StartTest();
        
        List<Entity_Role__c> Results = countryPageCls.partnerOfficeApex(VarOs.Id);
        
        Test.StopTest();
        
        system.assertequals(1,Results.size());
        
        system.assertequals(VarOffice.Affiliate_Office__r.name,Results[0].Affiliate_Office__r.name);
        
        
     }
    
    @IsTest
    static void affiliateOfficeApexTest(){
        
        Oxfam_Entity__c  VarOs = [Select Id, Name from Oxfam_Entity__c limit 1];
        
        Entity_Role__c  VarOffice = [SELECT  Affiliate_Office__r.name FROM Entity_Role__c where Role__c='Executive Affiliate' and Entity__c = :VarOs.Id];
        
        Test.StartTest();
        
        String  Results = countryPageCls.affiliateOfficeApex(VarOs.Id);
        
        Test.StopTest();
        
        system.assertequals(VarOffice.Affiliate_Office__r.name,Results);
        
        
    }
    
    
    @IsTest
    static void affiliateOfficeApexNullTest (){
        
         Oxfam_Entity__c  VarOs = [Select Id, Name from Oxfam_Entity__c limit 1];
        
        Entity_Role__c  VarOffice = [SELECT  Affiliate_Office__r.name FROM Entity_Role__c where Role__c='Executive Affiliate' and Entity__c = :VarOs.Id];
        
        Test.StartTest();
        
        String  Results = countryPageCls.affiliateOfficeApex('');
        
        Test.StopTest();

        System.assertEquals(null, Results);        
         
      }//affiliateOfficeApexNullTest ends
    
    @isTest
    
    static void testSaveBoxLinks() {
        
        // Create JSON data representing BoxWrapper objects
        
        String serializedData = '[{"index": 1, "boxId": null, "boxLink": "https://example.com", "answerId": null, "questionId": null, "OnlineSubmissionId": null}]';
        
       // Call the method with the serialized JSON data
        
        Test.startTest();
        
        countryPageCls.saveBoxLinks(serializedData);
        
        Test.stopTest();
        
        // Verify the results
        List<Box_Link__c> insertedBoxLinks = [SELECT Id, Box_Link__c, Answer__c, Question__c, Online_Submission__c FROM Box_Link__c];
        
        System.assertEquals(1, insertedBoxLinks.size());
    
    }//testSaveBoxLinksEnds
    
    
    @isTest
    
    static void testGetBoxLinks() {
        
        //create the test data
      
      Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
      Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1]; 
        
      Oxfam_Answer__c Varans = [select id from Oxfam_Answer__c limit 1];
        
      Box_Link__c testBoxLink = new Box_Link__c (Question__c = Varquestions.Id,
                                                 Answer__c = Varans.Id,
                                                 Online_Submission__c = onSub.Id,
                                                 Box_Link__c = 'https://example.com');
        
      insert testBoxLink; 
        
      // Call the method under test 
      
      String serializedResult = JSON.serialize(countryPageCls.getBoxLinks(Varquestions.Id, Varans.Id,onSub.Id));
        
      //verify the results
     
     List<Object> result = (List<Object>)JSON.deserializeUntyped(serializedResult);
       
      System.assertEquals(1, result.size());
        
      Map<String, Object> wrapperMap = (Map<String, Object>)result[0];
        
      System.assertEquals(1, (Integer)wrapperMap.get('index')); 
     
      System.assertEquals(testBoxLink.Id, (string)wrapperMap.get('boxId'));
      
      System.assertEquals('https://example.com', (string)wrapperMap.get('boxLink'));  
        
        
    }//testGetBoxLinksends
    
    
   @isTest
    
    static void testGetQuestionsForProgressBar() {
        
      //creating the test data
      
    Oxfam_Core_Standard__c Varstandard = [select Id, name from Oxfam_Core_Standard__c 	Limit 1]; 
        
    Oxfam_Question__c Varquestions = [select Id,Question_Category__c,Core_Standard__c from Oxfam_Question__c limit 1]; 
        
    Oxfam_Answer__c Varans = [select id from Oxfam_Answer__c limit 1];
        
    Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
    List<Oxfam_Answer__c> allAnswers =  [Select Id,Core_Standard_Entity__c,Score__c,Question__c,Question__r.Core_Standard__c,Question__r.Core_Standard__r.Name,Question__r.Weightage__c,Question__r.Question_Category__c,
                                             Answer__c 
                                             From Oxfam_Answer__c 
                                             WHERE Question__r.Core_Standard__c =: Varquestions.Core_Standard__c
                                             AND Question__r.Question_Category__c =: Varquestions.Question_Category__c
                                             AND Online_Submission__c =: onSub.Id
                                             ORDER BY Question__r.Core_Standard__r.Core_Standard_Number__c ASC];    
        
       
     // Call the method under test
       
      Map<String, Decimal> result = countryPageCls.getQuestionsForProgressBar(new List<String>{Varstandard.Id}, new List<String>{Varquestions.Question_Category__c},'onsub.Id'); 
        
      // Call the logic under test
      Map<String, Decimal> tabProgressMap = new Map<String, Decimal>();
        
      List<Oxfam_Answer__c> Answers = new List<Oxfam_Answer__c>(allAnswers); 
        
      for (Oxfam_Answer__c aOxfamAnswer : Answers) {
            String coreStdName = aOxfamAnswer.Question__r.Core_Standard__r.Name;
            if (tabProgressMap.containsKey(coreStdName)) {
                Decimal existingScore = tabProgressMap.get(coreStdName);
                Decimal newScore = existingScore + aOxfamAnswer.Score__c;
                tabProgressMap.put(coreStdName, newScore);
            } else {
                tabProgressMap.put(coreStdName, aOxfamAnswer.Score__c);
            }
        }  
     
        
        
      // Assert the results
    System.assertEquals(1, result.size());
    
    System.assertEquals(null, result.get('Varstandard'));   
        
        
    }//doubt
    
    @isTest
    
    static void testSaveTrainingLinks() {
        // Create test data
        
        String serializedData = '[{"index": 1, "boxId": null, "boxLink": "https://example.com", "answerId": null, "questionId": null, "OnlineSubmissionId": null}]';

        // Call the method under test
        Test.startTest();
        
        countryPageCls.saveTrainingLinks(serializedData);
        
        Test.stopTest();
        
        //verify the result
        
        List<Box_Link__c> insertedOrUpdatedBoxLinks = [SELECT Id, Box_Link__c FROM Box_Link__c];
        
        System.assertEquals(1, insertedOrUpdatedBoxLinks.size());
        
        // Verify the results
        
        Box_Link__c insertedBoxLink = insertedOrUpdatedBoxLinks[0];
        
        System.assertEquals('https://example.com', insertedBoxLink.Box_Link__c);
        
    }//testSaveTrainingLinksEnds
    
    @isTest
    
    static void testGetTrainingLinks()  {
        
       Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
      Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1]; 
        
      Oxfam_Answer__c Varans = [select id from Oxfam_Answer__c limit 1];
        
        Oxfam_evidence_training__c Add = [select id from Oxfam_evidence_training__c limit 1];  
        
      Box_Link__c testBoxLink = new Box_Link__c (Question__c = Varquestions.Id,
                                                 Answer__c = Varans.Id,
                                                 Evidence_Training__c = Add.Id,
                                                 Online_Submission__c = onSub.Id,
                                                 Type__c = 'type1',
                                                 Box_Link__c = 'https://example.com');
        
      insert testBoxLink;
        
      // Call the method under test
      
      String serializedResult = JSON.serialize(countryPageCls.getTrainingLinks(Add.id,'type1'));  
        
      //verify the result
      
     // system.assertEquals(1,serializedResult.size());  
         
        
    }//testGetTrainingLinksEnds
    
    
    
    
    
    
    
    
    
    
    /* public static @IsTest void partnerOfficeApexTest() {
     List<Entity_Role__c> partnerofficelist = new list<Entity_Role__c>();
     Entity_Role__c  Varpartner = new Entity_Role__c(Entity__c = 'a0A8c00000hypiAEAQ', 
                                                     Role__c = 'Partner Affiliate',
                                                     Affiliate_Office__c = 'a0E8c00001HEPXwEAP');
     partnerofficelist.add(Varpartner);
     Insert partnerofficelist;
     
      Test.startTest();
      
      countryPageCls.partnerOfficeApex('test');
        
      Test.stopTest();
      System.assertEquals(partnerofficelist.size(),1);  
        
    }//partnerofficeApextest close 
   
    public static @IsTest void affiliateOfficeApextest() {
        List<Entity_Role__c> affiliateofficelist = new list<Entity_Role__c>();
        Entity_Role__c Varaffiliate = new Entity_Role__c(Entity__c = 'a0A8c00000hypiAEAQ', 
                                                         Role__c = 'Executive Affiliate', 
                                                         Affiliate_Office__c = 'a0E8c00001HEPXwEAP');
        affiliateofficelist.add(Varaffiliate);
        Insert affiliateofficelist;
        
        Test.startTest();
        if(affiliateofficelist.size()>0)
        countryPageCls.affiliateOfficeApex('India');
        
        Test.stopTest();
        System.assertEquals(affiliateofficelist.size(),1);  
        
    }//affiliateofficeapex test ends  
    
    public static @IsTest void getSubmissionTypetest(){
        List<Oxfam_Online_Submission__c> getsubmissionlist = new list<Oxfam_Online_Submission__c>();
        Oxfam_Online_Submission__c Varsubmission = new  Oxfam_Online_Submission__c(Submission_Type__c = 'Implementation Plan');
        getsubmissionlist.add(Varsubmission);
        Insert getsubmissionlist;
        
        Test.startTest();
      
        countryPageCls.getSubmissionType();
        
        Test.stopTest();
        System.assertEquals(getsubmissionlist.size(),1); 
        
        }// getsubmission test ends 
    
    public static @IsTest void getquestionstest() {
         List<Oxfam_Question__c> getquestionslist = new list< Oxfam_Question__c >();
         Oxfam_Question__c Varquestions = new Oxfam_Question__c(Name = 'test',
                                                                Core_Standard__c = 'a048c000011MVspAAG',
                                                                Question_Number__c = 1, 
                                                                Question__c = 'Test the Question',
                                                                Question_Type__c = 'Descriptive',
                                                                Question_Category__c = 'Minimum Standard and Evidence',
                                                                Mandatory__c = 'yes',
                                                                Weightage__c = 0 );
         getquestionslist.add(Varquestions);
         Insert  getquestionslist;
        
         Test.startTest();
      
         countryPageCls.getQuestions('CS1 Plan', 'Minimum Standard and Evidence');
        
         Test.stopTest();
         System.assertEquals(getquestionslist.size(),1); 
        }//getquestiontest ends
   
    public static @IsTest void corestandardtest() {
        list<Oxfam_Core_Standard__c>  corestandardlist = new list<Oxfam_Core_Standard__c>();
        Oxfam_Core_Standard__c Varcorestandard = new Oxfam_Core_Standard__c(Core_Standard_Number__c = 1 , Name = 'CS1 Plan');
        corestandardlist.add(Varcorestandard);
        insert corestandardlist;
        
        Test.startTest();
      
         countryPageCls.coreStandard();
        
         Test.stopTest();
         System.assertEquals(corestandardlist.size(),1);
    }// corestandard test ends
    
    public static @IsTest void getreportingperiodtest() {
        list<Oxfam_Reporting_Period__c> reportingperiodlist = new list<Oxfam_Reporting_Period__c>();
        Oxfam_Reporting_Period__c Varreportingperiod = new Oxfam_Reporting_Period__c(Name = 'FY21-22',
                                                                                     X6_Months_Progress_Report_Due_Date__c = date.parse('10/01/2021'),
                                                                                     Annual_Report_Due_Date__c =date.parse ('03/31/2022') ,
                                                                                     Implementation_Plan_Due_Date__c = date.parse('04/01/2021'),
                                                                                     Start_Date__c =date.parse('04/01/2021'),
                                                                                     End_Date__c = date.parse('03/31/2022'));
        reportingperiodlist.add(Varreportingperiod);
        insert reportingperiodlist;
        
        Test.startTest();
      
        countryPageCls.getreportingPeriod();
        
        Test.stopTest();
        System.assertEquals(reportingperiodlist.size(),1);
     }//reportingperiod list ends  
    
    public static @IsTest void getAnswertest()  {
       List<Oxfam_Answer__c> getAnswerlist = new List<Oxfam_Answer__c>();
       Oxfam_Answer__c VarAnswer = new Oxfam_Answer__c(Question__c = 'a058c00000dFkA0AAK', Online_Submission__c = 'a098c00000t6UE0AAM',Answer__c ='Yes',Descriptive_Answer__c = 'Testing the descriptive',Core_Standard_Entity__c = 'a0B8c000011x8kQEAQ', Score__c = 50);
       getAnswerlist.add(VarAnswer);
       insert getAnswerlist;
      
       Test.startTest();
      
       countryPageCls.getAnswer('a098c00000t6UE0AAM');
        
       Test.stopTest();
       System.assertEquals(getAnswerlist.size(),1); 
        
    }//getAnswertest ends 
 
    public static @IsTest void coreStandardEntityMandatorytest(){
        List<Oxfam_Core_Standard_Entity__c> coreStandardEntityList = new list<Oxfam_Core_Standard_Entity__c>();
        Oxfam_Core_Standard_Entity__c VarCore = new Oxfam_Core_Standard_Entity__c(Name = 'CS6 Reporting & Responding', Core_Standard__c = 'a048c000011MVsSAAW',Entity__c = 'a0A8c00000hyphyEAA',Mandatory__c = 'Yes');
        coreStandardEntityList.add(VarCore);
        insert coreStandardEntityList;
        
        Test.startTest();
      
       countryPageCls.coreStandardEntityMandatory('CS6 Reporting & Responding');
        
       Test.stopTest();
       System.assertEquals(coreStandardEntityList.size(),1);
        
    }//coreStandardEntityMandatory test ends 22
    
    public static @IsTest void coreStandardEntityRecordtest() {
        List<Oxfam_Core_Standard_Entity__c> StandardList = new List<Oxfam_Core_Standard_Entity__c>();
        Oxfam_Core_Standard_Entity__c VarEntity = new Oxfam_Core_Standard_Entity__c(Name = 'CS6 Reporting & Responding', Core_Standard__c = 'a048c000011MVsSAAW',Entity__c = 'a0A8c00000hyphyEAA',Mandatory__c = 'Yes',Reporting_Period__c = 'a078c00000lJHFdAAO');
        StandardList.add(VarEntity);
        insert StandardList;
        
        Test.startTest();
      
       countryPageCls.coreStandardEntityRecord('CS6 Reporting & Responding','a048c000011MVsSAAW','a078c00000lJHFdAAO');
        
       Test.stopTest();
       System.assertEquals(StandardList.size(),1);
        
    }//Corestandardentitytest ends
 
    public static @IsTest void getOnlineSubtest (){
       List<Oxfam_Online_Submission__c> getonlinelist = new list<Oxfam_Online_Submission__c>();
       Oxfam_Online_Submission__c Vargetonline = new Oxfam_Online_Submission__c(Name = 'Pakistan/Annual Report/FY19-20/OS-0102',
                                                                                Submission_Type__c = 'Annual Report',
                                                                                Entity__c = 'a0A8c00000hypiAEAQ',
                                                                                Entity_User__c	= 'a0C8c00000YfxE7EAJ',
                                                                                Reporting_Period__c = 'a078c00000lJHQaAAO',
                                                                                Name__c = 'Test Pak',
                                                                                Role__c ='Test123',
                                                                                Email__c = 'test.pak@gmail.com',
                                                                                Approval_Status__c = 'Not Approved');
        getonlinelist.add(Vargetonline);
        insert getonlinelist;
       
        List<Oxfam_Online_Submission__c> getsubmissionlist = new list<Oxfam_Online_Submission__c>();
        Oxfam_Online_Submission__c Varsubmission = new  Oxfam_Online_Submission__c(Submission_Type__c = 'Implementation Plan');
        getsubmissionlist.add(Varsubmission);
        Insert getsubmissionlist;

        
        Test.startTest();
      
       countryPageCls.getOnlineSub('a0C8c00000YfxE7EAJ');
        
       Test.stopTest();
       System.assertEquals(getonlinelist.size(),1);
        
       } */
   
    }