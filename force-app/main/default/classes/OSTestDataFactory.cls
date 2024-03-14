@isTest
public class OSTestDataFactory {
    
    
    //creating submitting Entity Record
    public static Oxfam_Entity__c createEntityRecord(){
        Oxfam_Entity__c onEnt = new Oxfam_Entity__c(
                                    Name = 'India');
        insert onEnt;
        return onEnt;
    }
    
    //creating Reporting Period Record
    public static Oxfam_Reporting_Period__c createRepPeriodRecord(){
        
        Oxfam_Reporting_Period__c onRepYr = new Oxfam_Reporting_Period__c(
                                                                    Name = 'FY23-24',
                                                                    Start_Date__c = system.today(),
                                                                    End_Date__c	 = system.today(),
                                                                    Implementation_Plan_Due_Date__c = system.today(),
                                                                    Annual_Report_Due_Date__c = system.today());
        insert onRepYr;
        return onRepYr;
    }
    
    //creating user record
    public static User createUserRecord(){
        User u = [Select Id, Name from User LIMIT 1];
        return u;
    }
    
    //create Entity user record
    public static Oxfam_Entity_User__c createEntityUserRecord(){
       
    	Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
    	Oxfam_Entity_User__c onEnUser = new Oxfam_Entity_User__c(
                                                        Name = 'India/Test',
                                                        User__c = userInfo.getUserId(),    
                                                        Entity__c = onEnt.Id);   
        insert onEnUser;
        return onEnUser;
    }

    
	//create Online Submission Record
    public static Oxfam_Online_Submission__c createOnlineSubRecord(){
    
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
                                                            Entity_User__c = onEnUser.Id);
        insert onSub;
    	return onSub;
    
    }    
    
    //create focal point record
    public static Safeguarding_Focal_Point__c createFocalPointRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c];
        system.debug('onSub'+onSub);
         
        Safeguarding_Focal_Point__c   varFocalpoint  = new Safeguarding_Focal_Point__c (Name ='India',
                                                                                        Office_Sub_Office__c = 'Post' ,
                                                                                        Online_Submission__c = onSub.Id );
        insert varFocalpoint;
        return varFocalpoint;
    }
    
    //create safeguarding Information Provider record
    public static Information_Provider__c createInfoProviderRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Information_Provider__c   VarInformationProvider  = new Information_Provider__c (Name ='Test Name',
                                                                                        Role__c = 'test role' ,
                                                                                        Online_Submission__c = onSub.Id );
        insert VarInformationProvider;
        return VarInformationProvider;
    }

    
    //create core standard record
    public static Oxfam_Core_Standard__c createCoreStandardRecord(){
    
        Oxfam_Core_Standard__c coreStandard = new Oxfam_Core_Standard__c(Name='CS1 Plan', 
                                                                         Core_Standard_Number__c = 12,
                                                                         Description__c = 'Test Description',
                                                                         Document_Ref__c = 'www.oxfam.org.ou',
                                                                         Guidance__c = 'Test Guidance');
        insert coreStandard;
        return coreStandard;
        
    }
    
    //create Question Record
    public static Oxfam_Question__c createQuestoinRecord(){
        
        Oxfam_Core_Standard__c coreStandard = [select Id from Oxfam_Core_Standard__c limit 1];
        
        Oxfam_Question__c Varquestions = new Oxfam_Question__c(Name = 'test',
                                                                Core_Standard__c = coreStandard.Id,
                                                                Question_Number__c = 1, 
                                                                Question__c = 'Test the Question',
                                                                Question_Type__c = 'Descriptive',
                                                                Question_Category__c = 'Minimum Standard and Evidence',
                                                                Mandatory__c = 'yes',
                                                                Weightage__c = 0 );
        
    	insert Varquestions;
        return Varquestions;
    }
    
    //create core standard Entity record
    public static Oxfam_Core_Standard_Entity__c createCoreStdEntityRecord(){
        
        Oxfam_Entity__c onEnt = [select Id from Oxfam_Entity__c limit 1];
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Core_Standard__c coreStandard = [select Id from Oxfam_Core_Standard__c limit 1];
        
        Oxfam_Core_Standard_Entity__c createCoreStdEntityRecord = new Oxfam_Core_Standard_Entity__c(Core_Standard__c=coreStandard.Id,
                                                                                                    Mandatory__c='Yes',
                                                                                                    Entity__c=onEnt.Id,
                                                                                                    Reporting_Period__c=onRepYr.Id);
        insert createCoreStdEntityRecord;
        return createCoreStdEntityRecord;
        
    }
       
   
    // Create Answer Record
    public static Oxfam_Answer__c createAnswerRecord(){

        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
    	
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Answer__c AnswerRecord = new Oxfam_Answer__c(Answer__c = 'Yes',
                                                           Question__c = Varquestions.Id,
                                                           Core_Standard_Entity__c = CoreStdEntity.Id,
                                                           Score__c = 3,
                                                           Online_Submission__c = onSub.Id);
        
        insert AnswerRecord;
        return AnswerRecord;
       
          }
        
       
    
    //create a Task Record
    
        public static Oxfam_Task__c createTaskRecord(){
        
        Oxfam_Reporting_Period__c onRepYr = [select Id from Oxfam_Reporting_Period__c limit 1];
        
        Oxfam_Core_Standard_Entity__c CoreStdEntity = [select Id from Oxfam_Core_Standard_Entity__c limit 1];
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Task__c taskRecord = new Oxfam_Task__c(Name='test',
                                                     Key_Task__c='Test Key',
                                                     Due_Date__c=system.today(),
                                                     Person_Responsible_For_The_Activity__c='Test name',
                                                     Reporting_Period__c=onRepYr.Id,
                                                     Core_Standard_Entity__c=CoreStdEntity.Id,
                                                     Online_Submission__c=onSub.Id);
        insert taskRecord;
        return taskRecord;
    }
    
    //creating Trining evidence record
    public static Oxfam_evidence_training__c createTrainingRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Oxfam_evidence_training__c trainingRecord = new Oxfam_evidence_training__c(Online_Submission__c=onSub.Id,
                                                                                   Question__c=Varquestions.Id,
                                                                                   Date_Of_Training__c=system.today(),
                                                                                   Description_Of_Training__c='Some Test Description',
                                                                                   PSEA_Policy__c='Yes',
                                                                                   Safeguarding_Policy__c='Yes',
                                                                                   Who_Delivered_the_Training__c = 'Sunil');
        insert trainingRecord;
        return trainingRecord;
    }
    
    //create summary Record 
    public static Oxfam_Summary__c createSummaryRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
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
                                                           Online_Submission__c = onSub.Id);
        insert summaryRecord;
        return summaryRecord;
    }
    
    //create Evidence partner table record
    public static Evidence_Partner__c createPartnerRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Evidence_Partner__c partnerRecord = new Evidence_Partner__c(Name = 'test',
                                                                 Project_s_Partner_is_Involved_in__c = 'Test place',
                                                                 Contact_or_Working_with_Children__c = 'Working with children',
                                                                 CS_PSEA_in_Partner_Capacity_Assessment__c = 'Yes' ,
                                                                 CS_PSEA_in_Partner_Working_Agreement__c = 'Yes',
                                                                 PartnerCodeofConductorequivalentSigned__c = 'Yes',
                                                                 CS_and_PSEA_Policy_in_Place__c = 'Yes',
                                                                 Question__c = Varquestions.Id,
                                                                 Online_Submission__c =onSub.Id,
                                                                 Date_of_the_last_CS_training__c = system.today(),
                                                                 Date_of_the_last_PSEA_training__c = system.today());
        insert partnerRecord;
        return partnerRecord;
    }
    
    //create Project Table record
    public static Project__c createProjectRecord(){
        
        Oxfam_Online_Submission__c onSub = [select Id from Oxfam_Online_Submission__c limit 1];
        
        Oxfam_Question__c Varquestions = [select Id from Oxfam_Question__c limit 1];
        
        Project__c projectRecord = new Project__c(Name='Test',
                                                  Project_Start_Date__c = system.today(),
                                                  Project_End_Date__c = system.today(),
                                                  Is_the_Risk_Assessment_completed__c='Yes',
                                                  partners_involved_in_Risk_Asses__c='Yes',
                                                  Question__c=Varquestions.Id,
                                                  Online_Submission__c=onSub.Id);
        insert projectRecord;
        return projectRecord;
    } 
     
    //create Affiliate office Record
    public static Affiliate_Office__c createOfficeRecord (){
        
        Affiliate_Office__c  Office = new Affiliate_Office__c(Name='Oxfam Australia');
        
        Insert Office;
        
        Return Office;
        
    }
    
    //create Entity Role Record
    
    public static Entity_Role__c createEntityRoleRecord (){
        
        Affiliate_Office__c onOff = [Select Id from Affiliate_Office__c limit 1];
        
        Oxfam_Entity__c onadd = [select Id from Oxfam_Entity__c limit 1];
        
        Entity_Role__c EntRoleRecord = new Entity_Role__c(Entity__c = onadd.Id,
                                                          Role__c = 'Partner Affiliate',
                                                          Affiliate_Office__c = onOff.Id );
        
        Insert EntRoleRecord;
        
        Return EntRoleRecord;
        
     }
    
  //  Create Entity Role Record
  
    public static Entity_Role__c createEntityRoleRecord1 () {
        
        Affiliate_Office__c onOff = [Select Id from Affiliate_Office__c limit 1];
        
        Oxfam_Entity__c onadd = [select Id from Oxfam_Entity__c limit 1];
        
        Entity_Role__c RoleRecord = new Entity_Role__c(Entity__c = onadd.Id,
                                                          Role__c = 'Executive Affiliate',
                                                          Affiliate_Office__c = onOff.Id );
        
        Insert RoleRecord;
        
        Return RoleRecord;
        
    }
    
   //create the contact record 
  
    public static Contact createcontactrecord1 () {
        
        Contact con1 = new Contact (FirstName = 'John',LastName = 'Doe',AccountId = '0012H00000HF6GQQA1');
        
        insert con1;
        
        return con1;
        
      }
    
    public static Contact createcontactrecord2 ()  {
        
        contact con2 = new contact (FirstName = 'Jane', LastName = 'Doe', AccountId = '0012H00000HF6GRQA1');
        
        insert con2;
        
        return con2;
        
    }

    public static Contact createcontactrecord3 () {
        
        contact con3 = new contact (FirstName = 'Bob', LastName = 'Smith', AccountId = '0012H00000HF6GSQA1');
        
        insert con3;
        
        return con3;
        
    } 
    
    // Create queue record
    public static Group createQueue1(){

        Group testQueue1 = new Group(Name = 'Approvers queue', Type = 'Queue');

        insert testQueue1;

        return testQueue1;
    }

    public static Group createQueue2(){

        Group testQueue2 = new Group(Name = 'Approvers queue', Type = 'Queue');

        insert testQueue2;

        return testQueue2;
    }

//creating the Box Link records
  
    public static Box_Link__c createBoxLinkrecords () {
        
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
        
        Return Add;
        
    }  

    
  
}
