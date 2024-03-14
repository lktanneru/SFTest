public class TaskController {
    @AuraEnabled
    public static List<Oxfam_Task__c> getTaskList(string onlineSubId, String corestdid){
        return [SELECT Id,Key_Task__c,Due_Date__c,Completion_Date__c,Person_Responsible_For_The_Activity__c,Status__c,Comments__c,
                Core_Standard_Entity__c,Core_Standard_Entity__r.Core_Standard__c
                FROM Oxfam_Task__c WHERE Online_Submission__c=:onlineSubId AND Core_Standard_Entity__c!=null AND Core_Standard_Entity__c=:corestdid order by Name ASC];
    }
    // OwnerId =:userinfo.getUserId() AND
    
    @AuraEnabled
    public static List<Oxfam_Task__c> creatTask(Oxfam_Task__c taskList){
        list<Oxfam_Task__c> resptasklist = new list<Oxfam_Task__c>();
        taskList.OwnerId = userinfo.getUserId();
        resptasklist.add(taskList);
        insert resptasklist;
        return resptasklist;
    }
    @AuraEnabled
    public static List<Oxfam_Task__c> updateTask(Oxfam_Task__c taskList){
        system.debug('apex called   '+taskList);
        list<Oxfam_Task__c> resptasklist = new list<Oxfam_Task__c>();
        taskList.OwnerId = userinfo.getUserId();
        resptasklist.add(taskList);
        update resptasklist;
        return resptasklist;
    }
    @AuraEnabled
    public static Oxfam_evidence_training__c createTraining(Oxfam_evidence_training__c trainingList){
        if(trainingList.Id== null){
        string questionId = [SELECT Id,Question__c from Oxfam_Question__c where Question_Type__c='Yes/No_With_Link_In_Training_Table'].Id;
        trainingList.Question__c = questionId;
        }
        upsert trainingList;
        return trainingList;
    }
    
    @AuraEnabled
    public static Evidence_Partner__c createPartner(Evidence_Partner__c partnerList){
        if(partnerList.Id== null){
        string questionId = [SELECT Id,Question__c from Oxfam_Question__c where Question_Type__c='Yes/No_With_Link_In_Partner_Table'].Id;
        partnerList.Question__c = questionId;
        }
        upsert partnerList;
        return partnerList;
    }
    
    @AuraEnabled
    public static Project__c createProject(Project__c projectList){        
        if(projectList.Id== null){
        string questionId = [SELECT Id,Question__c from Oxfam_Question__c where Question_Type__c='Yes/No_With_Link_In_Project_Table'].Id;
        projectList.Question__c = questionId;
        }
        upsert projectList;
        return projectList;
    } 
    
    @AuraEnabled(cacheable=true) 
    public static List<Oxfam_Task__c> getConsolidatedTask(string os_name){
        //string onlineSubId = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name=:os_name].Id;
        return [SELECT Id,Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Reporting_Period__r.name,Due_Date__c,
                Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                FROM Oxfam_Task__c
                WHERE Online_Submission__c=:os_name
                ORDER BY Due_Date__c Asc ];     
    }
    
    @AuraEnabled
    public static List<Oxfam_Task__c> getConsolidatedTask1(string entId){
        List<Oxfam_Core_Standard_Entity__c> lstCoreStd = [SELECT Core_Standard__c,Entity__c 
                FROM Oxfam_Core_Standard_Entity__c 
                WHERE Entity__c=:entId
                AND Entity__c in (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId())];
        List<Oxfam_Task__c> taskList = new List<Oxfam_Task__c>();
        for(SObject item : lstCoreStd)
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
        
        return taskList;     
    }
    
    @AuraEnabled
    public static string UpdateTasks(Object data) {
        Oxfam_Task__c tasksForUpdate = (Oxfam_Task__c) JSON.deserialize(JSON.serialize(data),Oxfam_Task__c.class);
        try {
            update tasksForUpdate;
            return 'Success: Tasks updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    } 
    
    @AuraEnabled
    public static List<Oxfam_evidence_training__c> getTraining(string onlineSubId){
        
        return [SELECT Id,Name,Date_Of_Training__c,Attendance_Sheet__c,Code_of_Conduct__c,
                Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                Number_of_partners__c,PSEA_Policy__c,Question__c,Question__r.Name,Safeguarding_Policy__c,Total_Trained_Staff__c,
                Who_Delivered_the_Training__c,Other_evidence__c,Evidence__c,Training_materials__c,Online_Submission__c 
                from Oxfam_evidence_training__c where Online_Submission__c=:onlineSubId order by Name ASC];
    }
    
    @AuraEnabled
    public static Oxfam_Summary__c getSummary(string onlineSubId){
        return [SELECT Id,Online_Submission__c, CS4_Interview_Template__c,
                CS4_Reference_Check_Template__c,CS5_Training_Records__c,
                CS6_Safeguarding_Reporting_Procedure__c,CS7_Examples_of_community_level_feedback__c,
                CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,
                CS10_Informed_Consent_Template__c,
                Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c
                from Oxfam_Summary__c  where Online_Submission__c=:onlineSubId];
    }
    
    @AuraEnabled
    public static List<Evidence_Partner__c> getPartner(string onlineSubId){
        return [SELECT Id,Name,Contact_or_Working_with_Children__c,Online_Submission__c,CS_PSEA_in_Partner_Capacity_Assessment__c,
                CS_PSEA_in_Partner_Working_Agreement__c,CS_and_PSEA_Policy_in_Place__c,Date_of_the_last_CS_training__c,Date_of_the_last_PSEA_training__c,
                Partner_since__c,PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c,Question__c
                from Evidence_Partner__c  where Online_Submission__c=:onlineSubId ORDER BY serial_number__c ASC];
    }
    
    @AuraEnabled
    public static List<Project__c> getProject(string onlineSubId){
        return [SELECT Id,Name,Online_Submission__c,Question__c,If_No_Risk_Assessment_Explain__c,Is_the_Risk_Assessment_completed__c,
                partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,Project_Start_Date__c,
                When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                from Project__c  where Online_Submission__c=:onlineSubId];  
    }
    
     @AuraEnabled
    public static Oxfam_Online_Submission__c getExistingOnlineSub(string subType, String entity, string reportPeriod){
            Oxfam_Online_Submission__c onlineSub;        
           List<Oxfam_Online_Submission__c> lstOnlineSub = [SELECT Id,Name__c, Role__c, Email__c,Submission_Type__c,Reporting_Period__c,
                                                   Entity__c,Entity__r.Name,Entity_User__c,Reporting_Period__r.Name ,Approval_Status__c
                                                   from Oxfam_Online_Submission__c where Submission_Type__c=:subType 
                                                   and Entity__c=:entity and Reporting_Period__c =:reportPeriod and Approval_Status__c!='Approved'
                                                   order by LastModifiedDate desc limit 1];
        if (lstOnlineSub != null && lstOnlineSub.size() > 0) {
           onlineSub = lstOnlineSub[0];
           return onlineSub;
       }
        else{
            return null;
        }
       }

       @AuraEnabled
    public static string getExistingApprovedOnlineSub(string subType, String entity, string reportPeriod){
            Oxfam_Online_Submission__c onlineSub;        
           List<Oxfam_Online_Submission__c> lstOnlineSub = [SELECT Id,Name,Name__c, Role__c, Email__c,Submission_Type__c,Reporting_Period__c,
                                                   Entity__c,Entity__r.Name,Entity_User__c,Reporting_Period__r.Name,Approval_Status__c 
                                                   from Oxfam_Online_Submission__c where Submission_Type__c=:subType 
                                                   and Entity__c=:entity and Reporting_Period__c =:reportPeriod and Approval_Status__c='Approved'
                                                   order by LastModifiedDate desc limit 1];
        if (lstOnlineSub != null && lstOnlineSub.size() > 0) {
           string Message = 'Record Found';
           return Message;
       }
        else{
            return null;
        }
       }

       @AuraEnabled
       Public static String deleteTask(Oxfam_Task__c delTaskRec){
            delete delTaskRec;
            return 'Success';
       }

}