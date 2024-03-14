@IsTest
   public class CloneOnlineSubmissionHandlerTest {
    
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
       static void cloneSubmissionAndAnswersTest()  {
         
       // Create test data
       
       Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = 'Implementation Plan', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onSub;
           
           
        oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
    	
        Oxfam_Answer__c AnswerRecord = new Oxfam_Answer__c(Answer__c = 'Yes',
                                                           Question__c = Varquestions.Id,
                                                           Core_Standard_Entity__c = CoreStdEntity.Id,
                                                           Online_Submission__c = onSub.Id);
        
        insert AnswerRecord;
           
        List<Oxfam_Online_Submission__c> submissionList = new List<Oxfam_Online_Submission__c>();
        
        submissionList.add(onSub); 
           
        //call the method 

       Test.startTest();
        
       CloneOnlineSubmissionHandler.cloneSubmissionAndAnswers(submissionList);
        
       Test.stopTest();  
           
        //check that clone was created 
        
       list<Oxfam_Online_Submission__c> clonedSubmissions = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(5, clonedSubmissions.size()); 
           
        // Check that the answers were cloned
        
        List<Oxfam_Answer__c> clonedAnswers = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedSubmissions[0].Id];
        
        System.assertEquals(1, clonedAnswers.size(), 'Expected one cloned answer record');   
      
   }//cloneSubmissionAndAnswersTest ends
       
       @IsTest
       static void cloneSubmissionAndAnswersTest1() {
           
          // Create test data
       
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onAdd = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onAdd;
           
           
        oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
    	
        Oxfam_Answer__c AnswerRecord = new Oxfam_Answer__c(Answer__c = 'Yes',
                                                           Question__c = Varquestions.Id,
                                                           Core_Standard_Entity__c = CoreStdEntity.Id,
                                                           Online_Submission__c = onAdd.Id);
        
        insert AnswerRecord;
           
        List<Oxfam_Online_Submission__c> SubList = new List<Oxfam_Online_Submission__c>();
        
        SubList.add(onAdd); 
           
        //call the method 

       Test.startTest();
        
       CloneOnlineSubmissionHandler.cloneSubmissionAndAnswers(SubList);
        
       Test.stopTest();    
       
         //check that the clone was created  
       
       list<Oxfam_Online_Submission__c> clonedSub = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(5, clonedSub.size());
           
         // Check that the answers were cloned
        
        List<Oxfam_Answer__c> clonedAnswers = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedSub[0].Id];
        
        System.assertEquals(1, clonedAnswers.size(), 'Expected one cloned answer record');     
           
           
    } //cloneSubmissionAndAnswersTest1 Ends
       
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest()   {
           
          //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onAdd = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = 'Implementation Plan', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onAdd;
           
        Oxfam_Reporting_Period__c onRep = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
        
        Oxfam_Task__c taskRecord = new Oxfam_Task__c(Name='test',
                                                     Key_Task__c='Test Key',
                                                     Due_Date__c=system.today(),
                                                     Person_Responsible_For_The_Activity__c='Test name',
                                                     Reporting_Period__c=onRep.Id,
                                                     Core_Standard_Entity__c=CoreStdEntity.Id,
                                                     Online_Submission__c=onAdd.Id);
        insert taskRecord;   
           
       //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onAdd);    
               
      Test.StopTest();
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedAdd = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedAdd.size());
           
        // Check that the tasks were cloned
        
        List<Oxfam_Answer__c> clonedtasks = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedAdd[0].Id];
        
        System.assertEquals(1, clonedtasks.size(), 'Expected one cloned task record');       
          
           
       }//cloneOnlineSubmissionAndAnswersTest Ends
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest1 () {
          
        //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onSum = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onSum;
         
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
    	
        Oxfam_Answer__c AnswerRecord = new Oxfam_Answer__c(Answer__c = 'Yes',
                                                           Question__c = Varquestions.Id,
                                                           Core_Standard_Entity__c = CoreStdEntity.Id,
                                                           Online_Submission__c = onSum.Id);
        
        insert AnswerRecord; 
           
      //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onSum);    
               
      Test.StopTest(); 
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedSub = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedSub.size()); 
        
        // Check that the answers were cloned
        
        List<Oxfam_Answer__c> clonedAnswers = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedSub[0].Id];
        
        System.assertEquals(1, clonedAnswers.size(), 'Expected one cloned answer record');    
           
           
       }//cloneOnlineSubmissionAndAnswersTest1 Ends      
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest2 () {
           
         //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onDiv = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onDiv;
      
        
        Information_Provider__c   VarInformationProvider  = new Information_Provider__c (Name ='Test Name',
                                                                                        Role__c = 'test role' ,
                                                                                        Online_Submission__c = onDiv.Id );
        insert VarInformationProvider; 
       
      //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onDiv);    
               
      Test.StopTest();  
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedSub = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedSub.size()); 
           
       //check that the information Provider were cloned
        
        List<Oxfam_Answer__c> clonedAnswers = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedSub[0].Id];
        
        System.assertEquals(1, clonedAnswers.size(), 'Expected one information Provider record');    
              
  
      } // cloneOnlineSubmissionAndAnswersTest2 ends
   
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest3 ()  {
           
        //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onResults = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onResults;
       
       Safeguarding_Focal_Point__c   varFocalpoint  = new Safeguarding_Focal_Point__c (Name ='India',
                                                                                        Office_Sub_Office__c = 'Post' ,
                                                                                        Online_Submission__c = onResults.Id );
        insert varFocalpoint; 
           
      //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onResults);    
               
      Test.StopTest();  
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedSub = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedSub.size());  
           
       //check that the safeguarding focal point  were cloned
       
        List<Oxfam_Answer__c> clonedAnswers = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedSub[0].Id];
        
        System.assertEquals(1, clonedAnswers.size());      
       
        
     } //cloneOnlineSubmissionAndAnswersTest3 ends
   
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest4 () {
           
           //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onAnt = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onAnt;
           
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c trainingRecord = new Oxfam_evidence_training__c(Online_Submission__c=onAnt.Id,
                                                                                   Question__c=Varquestions.Id,
                                                                                   Date_Of_Training__c=system.today(),
                                                                                   Description_Of_Training__c='Some Test Description',
                                                                                   PSEA_Policy__c='Yes',
                                                                                   Safeguarding_Policy__c='Yes',
                                                                                   Who_Delivered_the_Training__c = 'Sunil');
        insert trainingRecord; 
           
      //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onAnt);    
               
      Test.StopTest();
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedDiv = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedDiv.size());  
           
       //check that the evidence training  were cloned
       
        List<Oxfam_Answer__c> clonedAns = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedDiv[0].Id];
        
        System.assertEquals(1, clonedAns.size());      
           
       
       } //cloneOnlineSubmissionAndAnswersTest4 ends   
  
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest5 () {
           
        //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onHome = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onHome;
           
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Evidence_Partner__c partnerRecord = new Evidence_Partner__c(Name = 'test',
                                                                 Project_s_Partner_is_Involved_in__c = 'Test place',
                                                                 Contact_or_Working_with_Children__c = 'Working with children',
                                                                 CS_PSEA_in_Partner_Capacity_Assessment__c = 'Yes' ,
                                                                 CS_PSEA_in_Partner_Working_Agreement__c = 'Yes',
                                                                 PartnerCodeofConductorequivalentSigned__c = 'Yes',
                                                                 CS_and_PSEA_Policy_in_Place__c = 'Yes',
                                                                 Question__c = Varquestions.Id,
                                                                 Online_Submission__c =onHome.Id,
                                                                 Date_of_the_last_CS_training__c = system.today(),
                                                                 Date_of_the_last_PSEA_training__c = system.today());
        insert partnerRecord; 
       
       //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onHome);    
               
      Test.StopTest();  
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedOn = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedOn.size());  
           
       //check that the evidence partner  were cloned
       
        List<Oxfam_Answer__c> clonedAns = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedOn[0].Id];
        
        System.assertEquals(1, clonedAns.size());      
               
       
    }// cloneOnlineSubmissionAndAnswersTest5 ends
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest6 () {
           
        //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onMultiply = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onMultiply;
           
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Project__c projectRecord = new Project__c(Name='Test',
                                                  Project_Start_Date__c = system.today(),
                                                  Project_End_Date__c = system.today(),
                                                  Is_the_Risk_Assessment_completed__c='Yes',
                                                  partners_involved_in_Risk_Asses__c='Yes',
                                                  Question__c=Varquestions.Id,
                                                  Online_Submission__c=onMultiply.Id);
        insert projectRecord;
           
      //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onMultiply);    
               
      Test.StopTest(); 
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedOn = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedOn.size());  
           
       //check that the project  were cloned
       
        List<Oxfam_Answer__c> clonedAns = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedOn[0].Id];
        
        System.assertEquals(1, clonedAns.size());          
           
   }//cloneOnlineSubmissionAndAnswersTest6 ends
       
       @IsTest
       static void cloneOnlineSubmissionAndAnswersTest7 () {
           
           //create the test data
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Entity_User__c onEnUser = [select Id from Oxfam_Entity_User__c limit 1];
        
		Oxfam_Online_Submission__c onAd = new Oxfam_Online_Submission__c(
                                                             Name__c = 'Test Entity', 
                                                            Role__c = 'Manager',
                                                            Submission_Type__c = '6 Months Progress Report', 
                                                            Email__c = 'test@gmail.com', 
                                                            Entity__c = onEnt.Id, 
                                                            Reporting_Period__c = onRepYr.Id, 
                                                            Entity_User__c = onEnUser.Id,
                                                            Approval_Status__c ='Approved' );
           
           insert onAd;
           
        Oxfam_Summary__c summaryRecord = new Oxfam_Summary__c(CS4_Interview_Template__c= true, 
                                                           CS4_Reference_Check_Template__c = true,
                                                           CS5_Training_Records__c = false,
                                                           CS6_Safeguarding_Reporting_Procedure__c = true,
                                                           CS7_Examples_of_community_level_feedback__c = true,
                                                           CS8_Sample_Partner_Capacity_Assessment__c = true,
                                                           CS8_Sample_Partner_Working_Agreement__c = true,
                                                           Summary_Achievements__c = 'test',
                                                           Sumamry_Challanges__c = 'ts',
                                                           Summary_Support_Needed__c = 'tst',
                                                           Online_Submission__c = onAd.Id);
        insert summaryRecord;
        
        //Test the cloning implementation Plan
     
      Test.StartTest();
           
      CloneOnlineSubmissionHandler.cloneOnlineSubmissionAndAnswers(onAd);    
               
      Test.StopTest(); 
           
       //check that the clone was created 
       
       list<Oxfam_Online_Submission__c> clonedOn = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name__c ='Test Entity'];
       
       System.assertEquals(4, clonedOn.size());  
           
       //check that the  oxfam summary  were cloned
       
        List<Oxfam_Answer__c> clonedAns = [SELECT Id FROM Oxfam_Answer__c WHERE Online_Submission__c = :clonedOn[0].Id];
        
        System.assertEquals(1, clonedAns.size());     
              
           
    } //cloneOnlineSubmissionAndAnswersTest7 ends  
       
       
 }