@isTest
public class chatterPostTest {
    @isTest
    static void testChatterPost(){
        
        Oxfam_Entity__c onEnt = new Oxfam_Entity__c(
            Name = 'India');
        insert onEnt;
        
        Oxfam_Reporting_Period__c onRepYr = new Oxfam_Reporting_Period__c(
            Name = 'FY 23-24',
            Start_Date__c = system.today(),
            End_Date__c	 = system.today(),
            Implementation_Plan_Due_Date__c = system.today(),
            Annual_Report_Due_Date__c = system.today());
        insert onRepYr;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser@safeguardingportal.com');
        insert u;
        
        Oxfam_Entity_User__c onEnUser = new Oxfam_Entity_User__c(
            Name = 'India/Test',
            User__c = u.Id,    
            Entity__c = onEnt.Id);   
        insert onEnUser;
        
        Oxfam_Core_Standard__c coreStandard = new Oxfam_Core_Standard__c(
            Name='CS1 Plan', 
            Core_Standard_Number__c = 12,
            Description__c = 'Test Description',
            Document_Ref__c = 'www.oxfam.org.ou',
            Guidance__c = 'Test Guidance');
        insert coreStandard;
        
        Oxfam_Core_Standard_Entity__c onCoreStdEnt = new Oxfam_Core_Standard_Entity__c(
            Core_Standard__c = coreStandard.Id,
            Mandatory__c = 'Yes',
            Entity__c = onEnt.Id,
            Reporting_Period__c = onRepYr.Id);
        insert onCoreStdEnt;
        
        Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
            Name__c = 'Test Entity', 
            Role__c = 'Manager',
            Submission_Type__c = 'Implementation Plan', 
            Email__c = 'test@gmail.com', 
            Entity__c = onEnt.Id, 
            Reporting_Period__c = onRepYr.Id, 
            Entity_User__c = onEnUser.Id);
        insert onSub;
        
        Contact con = new Contact();
        con.LastName = 'Test1';
        con.Title = 'Mrs';
        insert con;
        
        List<String> mentionedUsers = new List<String>();
        mentionedUsers.add(u.Id);
        Test.startTest();    
        chatterPost.chatterPostFeed(onSub.Entity__c, onSub.Reporting_Period__c, 'CS1 Plan', onSub.Id, 'Test Comment', onSub.Entity__c, mentionedUsers);        
        String onlineSubId = onSub.Id;
        chatterPost.sendEmailNotification(onlineSubId,mentionedUsers);
        chatterPost.updateURLToSubField('https://safeguardingportal.lightning.force.com/lightning/n/Plans_And_Reports_Submission_Page?c__id=India;a0A8c00000hypiDEAQ&c__subType=6%20Months%20Progress%20Report&c__RepYearName=FY19-20&c__RepYearId=a078c00000lJHQaAAO&c__coreStd=a048c000011MQrUAAW&c__coreStdName=CS1%20Plan', onSub.Id);
        chatterPost.updateOnlineSubFieldWithCS( onCoreStdEnt.Id,onSub.Id);
        String message = chatterPost.updateCoreStandEntityFieldWithURL('https://safeguardingportal.lightning.force.com/lightning/n/Plans_And_Reports_Submission_Page?c__id=Pacific;a0A8c00000hyphyEAA&c__subType=6%20Months%20Progress%20Report&c__RepYearName=FY21-22&c__RepYearId=a078c00000lJHFdAAO&c__coreStd=a048c000011MVsSAAW&c__coreStdName=CS6%20Reporting%20&%20Responding','6 Months Progress Report', onCoreStdEnt.Id);
        system.assertEquals('success', message);
        Test.stopTest();
    }
        
    @isTest
    static void testChatterCommentTrigger() {
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Title = 'Mr';
        insert con;
        
        Oxfam_Core_Standard__c coreStandard = new Oxfam_Core_Standard__c(
            Name='CS1 Plan', 
            Core_Standard_Number__c = 12,
            Description__c = 'Test Description',
            Document_Ref__c = 'www.oxfam.org.ou',
            Guidance__c = 'Test Guidance');
        insert coreStandard;
        
        List<FeedComment> fCommentList = new List<FeedComment>();
        FeedItem fItem = new FeedItem();
        fItem.ParentId = coreStandard.Id;
        fItem.body = 'Test';
        insert fItem;
        
        FeedComment fCmt = new FeedComment();
        fCmt.CommentBody = '@' + userinfo.getName() + ' Chatter Test';
        fCmt.FeedItemId = fItem.Id;
        fCommentList.add(fCmt);
        
        Test.startTest();
        insert fCommentList;
        FeedComment fcQ = [Select Id ,CommentBody , FeedItemId ,ParentId from FeedComment WHERE Id = :fCmt.Id];
        System.assertEquals(fcQ.ParentId ,coreStandard.Id);
        chatterPost.getUserIdsFromCommentBody(fCommentList);
        Test.stopTest();
        
        fCmt.CommentBody = '@' + userinfo.getName() + ' updated comment';
        update fCmt;
     }
    
    @isTest
    static void testupdateURLToSubField() {
        
       //creating the onlinesubmissiontest record
    
      Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
            Name__c = 'Test Entity', 
            Role__c = 'Manager',
            Submission_Type__c = 'Implementation Plan', 
            Email__c = 'test@gmail.com', 
            Current_URL_To_Pass_To_Chatter__c = 'Old Url');
        insert onSub; 
        
        //Call the method to update the URL
        
        String newURL = 'New URL';
        
        chatterPost.updateURLToSubField(newURL,onSub.Id);
        
        //Retrive the updated record
        
        Oxfam_Online_Submission__c updatedOnlineSub = [SELECT Current_URL_To_Pass_To_Chatter__c FROM Oxfam_Online_Submission__c WHERE Id = :OnSub.Id];
       
        //Assert that the field was updated correctly 
        
        System.assertEquals(newURL, updatedOnlineSub.Current_URL_To_Pass_To_Chatter__c);
    }//testupdateURLToSubField Ends
    
    @isTest
    static void testupdateCoreStandEntityFieldWithCS() {
        
        Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
            Name__c = 'Test Entity', 
            Role__c = 'Manager',
            Submission_Type__c = 'Implementation Plan', 
            Email__c = 'test@gmail.com', 
            Core_standard_selected__c = 'Old Core Standard');
        insert onSub; 
        
        //Call the method with non- null corestd parameter
       
        string newCorestd = 'New Core Standard';
        
        chatterPost.updateOnlineSubFieldWithCS(newCorestd, onSub.Id);
        
        //Rrtrive the updated Record
        
        Oxfam_Online_Submission__c updatedOnlineSub = [SELECT Core_standard_selected__c FROM Oxfam_Online_Submission__c WHERE Id = :onSub.Id];
        
         // Assert that the field was updated correctly
        
        System.assertEquals(newCoreStd, updatedOnlineSub.Core_standard_selected__c);
        
    }//testupdateCoreStandEntityFieldWithCS Ends
    
    
     @isTest
    static void testupdateCoreStandEntityFieldWithCSNull() {
        
        Oxfam_Online_Submission__c onSub = new Oxfam_Online_Submission__c(
            Name__c = 'Test Entity', 
            Role__c = 'Manager',
            Submission_Type__c = 'Implementation Plan', 
            Email__c = 'test@gmail.com', 
            Core_standard_selected__c = 'Old Core Standard');
        insert onSub; 
        
        //Call the method with non- null corestd parameter
       
        string newCorestd = 'New Core Standard';
        
        chatterPost.updateOnlineSubFieldWithCS(null, onSub.Id);
        
        //Rrtrive the updated Record
        
        Oxfam_Online_Submission__c unchangedOnlineSub = [SELECT Core_standard_selected__c FROM Oxfam_Online_Submission__c WHERE Id = :onSub.Id];
        
         // Assert that the field was updated correctly
        
        System.assertEquals('Old Core Standard', unchangedOnlineSub.Core_standard_selected__c);
        
    }//testupdateCoreStandEntityFieldWithCSNull Ends
    
    
    @IsTest
    
    static void testUpdateCoreStandEntityFieldWithURL() {
        
        // Create a test Oxfam_Core_Standard_Entity__c record
      
       Oxfam_Core_Standard__c coreStandard = new Oxfam_Core_Standard__c(
            Name='CS1 Plan', 
            Core_Standard_Number__c = 12,
            Description__c = 'Test Description',
            Document_Ref__c = 'www.oxfam.org.ou',
            Guidance__c = 'Test Guidance');
        insert coreStandard;
        
        Oxfam_Entity__c onEnt = new Oxfam_Entity__c(
            Name = 'India');
        insert onEnt;
        
        Oxfam_Core_Standard_Entity__c onCoreStdEnt = new Oxfam_Core_Standard_Entity__c(
            Core_Standard__c = coreStandard.Id,
            Mandatory__c = 'Yes',
            Entity__c = onEnt.Id,
            URL_to_pass_from_chatter_comment__c = 'Old URL',
            Selected_Submission_Type__c = 'Old Sub Type');
        insert onCoreStdEnt; 
        
        //Call the method to update the fields
      
        String newURL = 'New URL';
        
        String newSubType = 'New Sub Type';
        
        String coreStdId = onCoreStdEnt.Id;
        
        String resultMessage = chatterPost.updateCoreStandEntityFieldWithURL(newURL, newSubType, coreStdId);
        
        // Retrieve the updated record
        
        Oxfam_Core_Standard_Entity__c updatedCoreStdEntity = [SELECT URL_to_pass_from_chatter_comment__c, Selected_Submission_Type__c FROM Oxfam_Core_Standard_Entity__c WHERE Id = :coreStdId];
        
        
    }//testUpdateCoreStandEntityFieldWithURLEnds
    
   @isTest
    static void testUpdateCoreStandEntityFieldWithURLNullId() {
        
        // Call the method with a null coreStdId parameter
        
        String newURL = 'New URL';
        
        String newSubType = 'New Sub Type';
        
        String resultMessage = chatterPost.updateCoreStandEntityFieldWithURL(newURL, newSubType, null);
        
        // Assert the result message when coreStdId is null
        
        System.assertEquals('', resultMessage);
    
    } // testUpdateCoreStandEntityFieldWithURLNullId Ends
    
    
    
    
    
}