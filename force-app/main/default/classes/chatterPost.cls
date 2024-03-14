public with sharing class chatterPost {
    
    @AuraEnabled
    public static List<string> chatterPostFeed(String getEntityName, String getReportYear, String getTab, String getOnlineSubId, String commentValue, String getCoreStdEntity, List<String> mentionUser){
        system.debug('Parameters -->'+ getEntityName + getReportYear + getTab + getOnlineSubId + commentValue + mentionUser);
        List<String> UserIds = new List<string>();
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        Boolean result = getTab.equals('Submit For Approval');
        if(result){
            textSegmentInput.text = commentValue + ': ' + ' ' + getEntityName + ' ' + getReportYear + ' ' + getTab + ' '; 
        }
        else{
            String splitTab = getTab.split(' ').get(0);
            textSegmentInput.text = commentValue + ': ' + ' ' + getEntityName + ' ' + getReportYear + ' ' + splitTab + ' ';
        }
        messageBodyInput.messageSegments.add(textSegmentInput);
        for(string userid : mentionUser){
            
            ConnectApi.MentionSegmentInput objMessageSegmentIp = new ConnectApi.MentionSegmentInput();
            objMessageSegmentIp.id = userid;
            UserIds.add(userid);
            
            messageBodyInput.messageSegments.add(objMessageSegmentIp); 
        }
        system.debug('UserIds' +UserIds);
        system.debug(messageBodyInput.messageSegments);
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        //feedItemInput.createdById = '';
        //feedItemInput.subjectId = getOnlineSubId;
        feedItemInput.subjectId = getCoreStdEntity;
        system.debug(feedItemInput);
        // 
        if(!Test.isRunningTest()){
        	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
        //system.debug(FeedElement);
        return UserIds;
    }
    
    @AuraEnabled
    public static void sendEmailNotification(String OnlineSubId, List<String> TaggedUsers){
        try {
            system.debug('user id'+ TaggedUsers);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId([select Id from contact limit 1].Id); 
            message.setSenderDisplayName('Hive'); 
            message.setReplyTo('no-reply@oxfam.com');
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            message.setTreatTargetObjectAsRecipient( false);
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Chatter Notification Email Template'];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(OnlineSubId); //This is important for the merge fields in template to work
            message.setToAddresses(TaggedUsers);
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            //system.debug('messages -->'+messages);
            system.debug('message.toAddresses' +message.toAddresses);
            if (results[0].success) 
            {
                System.debug('The email was sent successfully');
            } else {
                System.debug('The email failed to send: '+  results[0].errors[0].message);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateURLToSubField(String onSubField,String onlineSubId){
        List<Oxfam_Online_Submission__c> onlineSubList = new List<Oxfam_Online_Submission__c>();
        for(Oxfam_Online_Submission__c onlineSub : [Select Id, Current_URL_To_Pass_To_Chatter__c from Oxfam_Online_Submission__c where Id=:onlineSubId]){
            onlineSub.Current_URL_To_Pass_To_Chatter__c = onSubField;
            onlineSubList.add(onlineSub);
        }
        update onlineSubList;
        system.debug('onlineSubList -->'+onlineSubList);
    }
    
    
    @AuraEnabled
    public static void updateOnlineSubFieldWithCS(string corestd,string onlineSubId){
       if(corestd != null){
            List<Oxfam_Online_Submission__c> onlineSubList = new List<Oxfam_Online_Submission__c>();
        for(Oxfam_Online_Submission__c onlineSub : [Select Id, Core_standard_selected__c from Oxfam_Online_Submission__c where Id=:onlineSubId]){
            onlineSub.Core_standard_selected__c = corestd;
            onlineSubList.add(onlineSub);
        }
       
       
        update onlineSubList;
        system.debug('onlineSubList -->'+onlineSubList); 
     }  
   }
    
    
    
    @AuraEnabled
    public static string updateCoreStandEntityFieldWithURL(string urlToPass,string subType ,string coreStdId){
        string message = '';
        system.debug('corstdId: ' +coreStdId);
        system.debug('url  '+ urlToPass );
        if(coreStdId != null){
            List<Oxfam_Core_Standard_Entity__c> coreStdEntityList = new List<Oxfam_Core_Standard_Entity__c>();
            for(Oxfam_Core_Standard_Entity__c VarCoreStdEntity : [select Id,URL_to_pass_from_chatter_comment__c,Selected_Submission_Type__c FROM Oxfam_Core_Standard_Entity__c WHERE Id=:coreStdId]){
                VarCoreStdEntity.URL_to_pass_from_chatter_comment__c = urlToPass;
                VarCoreStdEntity.Selected_Submission_Type__c = subType;
                coreStdEntityList.add(VarCoreStdEntity);
            }
            update coreStdEntityList;
            message='success';	
        }
        return message;
    } 
    
    //This is triggerHandler for chatterCommentTrigger
    // to get user Ids/emails from commentBody field from FeedComment Object when user makes a comment in chatter post
    public static void getUserIdsFromCommentBody(List<FeedComment> FeedList){
        string CorestdEntId;
        Map<String, string> fullNameToId = new Map<String, string>();
        for(FeedComment VarFeed : FeedList){
            string CommentMain = VarFeed.CommentBody;
            CorestdEntId = VarFeed.ParentId;
            string threadParent = VarFeed.ThreadParentId;
            system.debug('threadParent     '+ threadParent);
            Pattern mentionPattern = Pattern.compile('@\\w+\\s\\w+');
            Matcher matcher = mentionPattern.matcher(CommentMain);
            List<String> mentionedUsers = new List<String>();
            while (matcher.find()) {
                String mention = matcher.group();
                // remove the '@' symbol from the mention
                String fullName = mention.substring(1).trim();
                mentionedUsers.add(fullName);
                
            }
            List<User> users = [SELECT email,Id, FirstName, LastName FROM User WHERE Name IN: mentionedUsers];
            system.debug('users  '+users );
            for (User u : users) {
                fullNameToId.put(u.FirstName + ' ' + u.LastName, u.email);
            }
        }
        
        system.debug(CorestdEntId+'===='+fullNameToId.values().toString());
        if(fullNameToId !=null && !fullNameToId.isEmpty()){
        	sendCommentEmailNotification(CorestdEntId,fullNameToId.values());
        }
    }
    
    //This method is used to send an email to the mentioned user for comments made on chatter
    @AuraEnabled
    public static void sendCommentEmailNotification(String CorestdEntId, List<String> TaggedUsers) {
        try {
            // Create a new email message
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            
            // Set the email message properties
            message.setTargetObjectId([SELECT Id FROM Contact LIMIT 1].Id); 
            message.setSenderDisplayName('Hive'); 
            message.setReplyTo('no-reply@oxfam.com');
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            message.setTreatTargetObjectAsRecipient(false);
            
            // Get the email template to use for the email message
            EmailTemplate emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name = 'Comment Notification Email Template'];
            message.setTemplateId(emailTemplate.Id); 
            
            // Set the related record for the email message
            message.setWhatId(CorestdEntId);
            
            // Add the tagged users as recipients to the email message
            message.setToAddresses(TaggedUsers);
            
            // Send the email message
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
            
            // Check if the email was sent successfully and log the result
            if (results[0].success) {
                System.debug('The email was sent successfully');
            } else {
                System.debug('The email failed to send: '+  results[0].errors[0].message);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}