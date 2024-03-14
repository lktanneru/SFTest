public class PreviousSubmissionController {
    @AuraEnabled
    public static Oxfam_Online_Submission__c getOnlineSub(string subType, String entity, string reportPeriod){
            Oxfam_Online_Submission__c onlineSub;        
           List<Oxfam_Online_Submission__c> lstOnlineSub = [SELECT Id,Name,Name__c, Role__c, Email__c,Submission_Type__c,Reporting_Period__c,
                                                   Entity__c,Entity__r.Name,Entity_User__c,Reporting_Period__r.Name 
                                                   from Oxfam_Online_Submission__c where Submission_Type__c=:subType 
                                                   and Entity__c=:entity and Reporting_Period__c =:reportPeriod and Approval_Status__c='Approved'
                                                   order by LastModifiedDate desc limit 1];
        if (lstOnlineSub != null && lstOnlineSub.size() > 0) {
           onlineSub = lstOnlineSub[0];
           return onlineSub;
       }
        else{
            return null;
        }
       }

    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Task__c> getTaskList(string onlineSubId){
        return [SELECT Id,Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Due_Date__c,
                Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name,Reporting_Period__r.Name
                FROM Oxfam_Task__c
                WHERE Online_Submission__c =:onlineSubId
                ORDER BY Due_Date__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Safeguarding_Focal_Point__c> getFocalList(string onlineSubId){
        return [SELECT Id,Name,Office_Sub_Office__c FROM Safeguarding_Focal_Point__c WHERE Online_Submission__c =:onlineSubId];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Information_Provider__c> getInfoList(string onlineSubId){
       return [SELECT Name,Role__c,Type_Of_Information__c FROM Information_Provider__c WHERE Online_Submission__c =:onlineSubId]; 
    }
    
    @AuraEnabled
    public static List<Oxfam_Answer__c> getQAList(string onlineSubId,string coreStdName){ 
        return [SELECT Id,Descriptive_Answer__c,Answer__c,Question__r.Question_Number__c,Question__r.Question__c,
        Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,
        Core_Standard_Entity__r.Core_Standard__r.Name,(Select Box_Link__c from Box_Links__r)
        FROM Oxfam_Answer__c 
        WHERE Online_Submission__c=:onlineSubId  
        AND Core_Standard_Entity__r.Core_Standard__r.Name=: coreStdName
        ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
  }   
    
    
    @AuraEnabled(cacheable=true)
    public static List<Evidence_Partner__c> getPartnerList(string onlineSubId){
        system.debug('Method called');
        return [SELECT Id,Name,Contact_or_Working_with_Children__c,CS_PSEA_in_Partner_Capacity_Assessment__c,CS_PSEA_in_Partner_Working_Agreement__c,
                       CS_and_PSEA_Policy_in_Place__c,Date_of_the_last_CS_training__c,Date_of_the_last_PSEA_training__c,Partner_since__c,
                       PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c 
                FROM Evidence_Partner__c WHERE Online_Submission__c =:onlineSubId];
                
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectList(string onlineSubId){
        return [SELECT Id,Name,If_No_Risk_Assessment_Explain__c,Is_the_Risk_Assessment_completed__c,
                partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,Project_Start_Date__c,
                When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                from Project__c WHERE Online_Submission__c =:onlineSubId];
    }
    
    @AuraEnabled
    public static List<Oxfam_evidence_training__c> getTrainingList(string onlineSubId){
        return [SELECT Id,Name,Date_Of_Training__c,Attendance_Sheet__c,Code_of_Conduct__c,
                Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                Number_of_partners__c,PSEA_Policy__c,Safeguarding_Policy__c,Total_Trained_Staff__c,
                Who_Delivered_the_Training__c,Other_evidence__c,Training_materials__c,(Select Id,Box_Link__c,Type__c From Box_Links__r) 
                from Oxfam_evidence_training__c WHERE Online_Submission__c =:onlineSubId];
                
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Summary__c> getSummaryList(string onlineSubId){
        return [SELECT Id,CS4_Interview_Template__c,CS4_Reference_Check_Template__c,CS5_Training_Records__c,CS6_Safeguarding_Reporting_Procedure__c,
                CS7_Examples_of_community_level_feedback__c,CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,
                Online_Submission__c,Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c FROM Oxfam_Summary__c
                WHERE Online_Submission__c =: onlineSubId];
    }
    @AuraEnabled
    public static Map<ID, String> getAttachmentList(string onlineSubId){
        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: onlineSubId];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            system.debug('thsi is returned   '+mapIdTitle);
            return mapIdTitle;
    }
    @AuraEnabled()
    public static List<Oxfam_evidence_training__c> getTrainingBoxLink(String onlineSubId){
        return [Select Id,Name,Online_Submission__c,Question__r.Name,Question__r.Core_Standard__r.Name,Question__r.Short_Description__c,Date_Of_Training__c,(Select Type__c,Box_Link__c From Box_Links__r)
                from Oxfam_evidence_training__c
                WHERE Online_Submission__c = :onlineSubId];  
    }

    @AuraEnabled
    public static List<Oxfam_Answer__c> getAllQuestionAnswers(string onlineSubId){
        try {
            return [SELECT Id,Descriptive_Answer__c,Answer__c,Question__r.Question_Number__c,Question__r.Question__c,
                    Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,
                    Core_Standard_Entity__r.Core_Standard__r.Name,(Select Box_Link__c from Box_Links__r)
                    FROM Oxfam_Answer__c 
                    WHERE Online_Submission__c=:onlineSubId  
                    ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}