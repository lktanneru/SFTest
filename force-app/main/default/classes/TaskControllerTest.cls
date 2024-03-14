@IsTest
private class TaskControllerTest {
    
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
    
    @isTest
    static void getTaskListTest(){
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name FROM Oxfam_Online_Submission__c Limit 1];
        
        Oxfam_Core_Standard_Entity__c coreStdEntity = [SELECT Id FROM Oxfam_Core_Standard_Entity__c limit 1];
        
        List<Oxfam_Task__c> taskList=[SELECT Id,Key_Task__c,Due_Date__c,Completion_Date__c,Person_Responsible_For_The_Activity__c,Status__c,Comments__c,
                                      Core_Standard_Entity__c,Core_Standard_Entity__r.Core_Standard__c
                                      FROM Oxfam_Task__c 
                                      WHERE Online_Submission__c=:onSub.Id 
                                      AND Core_Standard_Entity__c!=null 
                                      AND Core_Standard_Entity__c=:coreStdEntity.Id 
                                      order by Name ASC];
        Test.startTest();
        
        List<Oxfam_Task__c> taskListOriginal = TaskController.getTaskList(onSub.Id,coreStdEntity.Id );
        
        Test.stopTest();
        
        System.assertEquals(taskList.size(),taskListOriginal.size());
        
    }//gettaskList test ends  
    
    @isTest
    static void creatTaskTest(){
        // Get the test task record created by the test data factory
        List<Oxfam_Reporting_Period__c> onRep = [select Id from Oxfam_Reporting_Period__c];
        Oxfam_Reporting_Period__c VaronRep = onRep[0];
        Oxfam_Task__c testTask = new Oxfam_Task__c(Name='Test Task',
                                                   Key_Task__c='key',
                                                   Due_Date__c=date.today(),
                                                   Person_Responsible_For_The_Activity__c='Test name',
                                                   Reporting_Period__c=VaronRep.Id);
        
        // Call the method with the test task record
        testTask.Key_Task__c = 'Updated Test key task'; // Change the key task to verify the update
        List<Oxfam_Task__c> createdTasks = TaskController.creatTask(testTask);
        
        // Verify the result
        System.assertEquals(1, createdTasks.size(), 'The method should return a list with one task record');
        System.assertEquals('Updated Test key task', createdTasks[0].Key_Task__c, 'The subject should be updated');
        System.assertEquals(UserInfo.getUserId(), createdTasks[0].OwnerId, 'The owner ID should be set to the current user');
    }
    
    @isTest
    static void updateTaskTest(){
        
        List<Oxfam_Task__c> taskList = [select Id,Key_Task__c from Oxfam_Task__c];
        
        Oxfam_Task__c taskRec = taskList[0];
        
        taskRec.Key_Task__c = 'key updated';
        
        Test.startTest();
        List<Oxfam_Task__c> updatedTasks = TaskController.updateTask(taskRec);
        Test.stopTest();
        
        system.assertEquals(1, updatedTasks.size());
        system.assertEquals('key updated', updatedTasks[0].Key_Task__c);
        System.assertEquals(UserInfo.getUserId(), updatedTasks[0].OwnerId, 'The owner ID should be set to the current user');
    }
    
    @isTest
    static void createTrainingTest(){
        
        List<Oxfam_evidence_training__c> trainingList = [select Id,Name,Date_Of_Training__c from Oxfam_evidence_training__c];
        
        Oxfam_evidence_training__c trainingRec = trainingList[0]; 
        
        Test.startTest();
        
        Oxfam_evidence_training__c createdTraining = TaskController.createTraining(trainingRec);
        
        Test.stopTest();
        
        system.assertEquals(createdTraining.Date_Of_Training__c, trainingRec.Date_Of_Training__c);
        
    }//create training test ends here
    
    @isTest
    static void createPartnerTest(){
        List<Evidence_Partner__c> PartnerList = [SELECT Id,Name,Partner_since__c FROM Evidence_Partner__c];
        
        Evidence_Partner__c VarPartner = PartnerList[0];
        
        VarPartner.Partner_since__c = '1970';
        
        Test.startTest();
        Evidence_Partner__c createdPartner = TaskController.createPartner(VarPartner);
        Test.stopTest();
        
        system.assertEquals('test', createdPartner.Name);
        system.assertEquals('1970', createdPartner.Partner_since__c);
    }
    
    @isTest
    static void createProjectTest(){
        List<Project__c> projectList = [select Id from Project__c];
        
        Project__c VarProject = projectList[0];
        
        VarProject.What_level_of_contact_with_children_do__c = 'test';
        
        Test.startTest();
        Project__c result = TaskController.createProject(VarProject);
        Test.stopTest();
        
        system.assertEquals('test', result.What_level_of_contact_with_children_do__c);
    }
    
    
    
    
    @isTest
    static void getConsolidatedTaskTest() {
        
        string subId = [SELECT Id,Name from Oxfam_Online_Submission__c limit 1].Id;  
        
        List<Oxfam_Task__c> taskList = [SELECT Id,Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Reporting_Period__r.name,Due_Date__c,
                                        Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                                        FROM Oxfam_Task__c
                                        WHERE Online_Submission__c=:subId
                                        ORDER BY Due_Date__c Asc];     
        
        
        Test.startTest();
        
        List<Oxfam_Task__c> result = TaskController.getConsolidatedTask(subId);
        
        Test.stopTest();
        System.assertEquals(taskList.size(),result.size());
        
    }//getconsolidated test ends
    
    @IsTest
    static  void getConsolidatedTask1test() {
        
        Oxfam_Entity__c entityRecord = [SELECT Id FROM Oxfam_Entity__c limit 1];
        
        List<Oxfam_Core_Standard_Entity__c> coreStdEntList = [SELECT Core_Standard__c,Entity__c 
                                                              FROM Oxfam_Core_Standard_Entity__c 
                                                              WHERE Entity__c=:entityRecord.Id
                                                              AND Entity__c in (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId())];
        
        List<Oxfam_Task__c> taskList = new List<Oxfam_Task__c>();
        for(SObject item : coreStdEntList)
        {
            List<Oxfam_Task__c> taskList1 = new List<Oxfam_Task__c>();
            taskList1 = [SELECT Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Reporting_Period__r.name,Due_Date__c,
                         Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                         FROM Oxfam_Task__c 
                         WHERE Core_Standard_Entity__c=:item.Id
                         AND isCloned__c = 'Yes'
                         ORDER BY Due_Date__c];
            taskList.addall(taskList1);
        }
        
        Test.startTest();
        
        List<Oxfam_Task__c> result =TaskController.getConsolidatedTask1(entityRecord.Id);
        
        Test.stopTest();
        System.assertEquals(result.size(),taskList.size());
        
    }//getConsolidatedTask1test ends
    
    @isTest
    static void UpdateTasksTest(){
        
        list<Oxfam_Task__c> taskList = [select Id from Oxfam_Task__c];
        
        Oxfam_Task__c VarTask = taskList[0];
        
        VarTask.Key_Task__c='This is testing';
        
        Test.startTest();
        string result = TaskController.UpdateTasks(VarTask);
        
        system.assertEquals('Success: Tasks updated successfully', result);
        
    }//update task test ends here
    
    @IsTest
    static void getTrainingtest () {
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name FROM Oxfam_Online_Submission__c Limit 1];
        
        List<Oxfam_evidence_training__c> trainingList = [SELECT Id,Name,Date_Of_Training__c,Attendance_Sheet__c,Code_of_Conduct__c,
                                                         Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                                                         Number_of_partners__c,PSEA_Policy__c,Question__c,Safeguarding_Policy__c,Total_Trained_Staff__c,
                                                         Who_Delivered_the_Training__c,Other_evidence__c,Training_materials__c,Online_Submission__c 
                                                         from Oxfam_evidence_training__c where Online_Submission__c=:onSub.Id order by Name ASC]; 
        
        Test.startTest();
        
        List<Oxfam_evidence_training__c> result = TaskController.getTraining(onSub.Id);
        
        Test.stopTest();
        System.assertEquals(trainingList.size(),result.size());
        
    }//get training test ends
    
    @IsTest
    static void getPartnerTest () {
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name FROM Oxfam_Online_Submission__c Limit 1];
        
        List<Evidence_Partner__c> parterRecord =  [SELECT Id,Name,Contact_or_Working_with_Children__c,Online_Submission__c,CS_PSEA_in_Partner_Capacity_Assessment__c,
                                                   CS_PSEA_in_Partner_Working_Agreement__c,CS_and_PSEA_Policy_in_Place__c,Date_of_the_last_CS_training__c,Date_of_the_last_PSEA_training__c,
                                                   Partner_since__c,PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c,Question__c
                                                   from Evidence_Partner__c  where Online_Submission__c=:onSub.Id ORDER BY serial_number__c ASC];
        
        Test.startTest();
        
        List<Evidence_Partner__c> result = TaskController.getPartner(onSub.Id);
        
        Test.stopTest();
        System.assertEquals(parterRecord.size(),result.size());
        
    }//getPartner List ends
    
    @IsTest
    static void getProjectTest() {
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name FROM Oxfam_Online_Submission__c Limit 1];
        
        List<Project__c> projectList = [SELECT Id,Name,Online_Submission__c,Question__c,If_No_Risk_Assessment_Explain__c,Is_the_Risk_Assessment_completed__c,
                                        partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,Project_Start_Date__c,
                                        When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                                        from Project__c  where Online_Submission__c=:onSub.Id];  
        
        Test.startTest();
        
        List<Project__c> result = TaskController.getProject(onSub.Id);
        
        Test.stopTest();
        
        System.assertEquals(ProjectList.size(),result.size());
        
    }//getproject test ends 
    
    @isTest
    static void getExistingOnlineSubTest(){
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name,Entity__r.name,Reporting_Period__r.Name,Submission_Type__c FROM Oxfam_Online_Submission__c Limit 1];
        
        Test.startTest();
        
        Oxfam_Online_Submission__c result = TaskController.getExistingOnlineSub(onSub.Submission_Type__c,onSub.Entity__r.name,onSub.Reporting_Period__r.Name);
        
        Test.stopTest();
        
        if (result != null && onSub!=null){
            system.assertEquals(onSub.Name, result.Name);
        }
    }//get existing onlinesub test ends here
    
    @isTest
    static void getExistingApprovedOnlineSubTest(){
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name,Entity__r.name,Reporting_Period__r.Name,Submission_Type__c FROM Oxfam_Online_Submission__c Limit 1];
        
        Test.startTest();
        
        string result = TaskController.getExistingApprovedOnlineSub(onSub.Submission_Type__c,onSub.Entity__r.name,onSub.Reporting_Period__r.Name);
        
        Test.stopTest();
        
        if (result != null && onSub!=null){
            system.assertEquals('Record Found', result,'The message should be "Record Found" if a matching record is found');
        }
        
    }// get approved online sub ends here
    
    @IsTest
    static void getSummaryTest(){
        
        Oxfam_Online_Submission__c onSub = [SELECT Id,name FROM Oxfam_Online_Submission__c Limit 1];
        
        List<Oxfam_Summary__c> summaryList = [SELECT Id,Online_Submission__c, CS4_Interview_Template__c,
                                              CS4_Reference_Check_Template__c,CS5_Training_Records__c,
                                              CS6_Safeguarding_Reporting_Procedure__c,CS7_Examples_of_community_level_feedback__c,
                                              CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,
                                              Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c
                                              from Oxfam_Summary__c  where Online_Submission__c=:onSub.Id];
        
        Test.startTest();
        
        Oxfam_Summary__c result = TaskController.getSummary(string.valueOf(onSub.Id));
        
        Test.stopTest();
        
        System.assertEquals('test',result.Summary_Achievements__c);
        
     }//getsummary test ends
     
}