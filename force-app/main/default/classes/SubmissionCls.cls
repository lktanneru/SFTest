public class SubmissionCls {
    public SubmissionCls(){
        List<SObject> summaryList = new List<SObject>();  
    }
    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getSubmission(){
        return [SELECT Submission_Type__c FROM Oxfam_Online_Submission__c GROUP BY Submission_Type__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Entity__c> getEntity(){
        return [Select name from Oxfam_Entity__c  where id in (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId())];
    }
    
    @AuraEnabled
    public static Safeguarding_Focal_Point__c createSafeFocalPoint(Safeguarding_Focal_Point__c safeFocalPoint){
        upsert safeFocalPoint;
        return safeFocalPoint;
    }
    
    @AuraEnabled
    public static List<Safeguarding_Focal_Point__c> getSafeFocalPoint(string onlineSubId){
        return [select Id,Name,Office_Sub_Office__c,Online_Submission__c from Safeguarding_Focal_Point__c where Online_Submission__c=:onlineSubId];
    }
    @AuraEnabled
    public static string deleteSafeFocalPt(Safeguarding_Focal_Point__c safeFocalPoint){
        delete safeFocalPoint;
        return 'success';
    }
    @AuraEnabled
    public static Information_Provider__c createSafeInfoProv(Information_Provider__c safeInfoProv){
        system.debug('This is called Information prov');
        upsert safeInfoProv;
        return safeInfoProv;
    }
    @AuraEnabled
    public static List<Information_Provider__c> getSafeInfoProv(string onlineSubId){
        return [select Id,Name,Role__c,Type_Of_Information__c,Online_Submission__c from Information_Provider__c where Online_Submission__c=:onlineSubId];
    }
    @AuraEnabled
    public static string deleteSafeInfoProv(Information_Provider__c safeInfoProv){
        delete safeInfoProv;
        return 'success';
    }
    @AuraEnabled
    public static string deleteAnswer(string osid){
        List<Oxfam_Answer__c> lstAns = [select Id,Question__c,Answer__c,Core_Standard_Entity__c,Descriptive_Answer__c,Score__c 
                                        from Oxfam_Answer__c where Online_Submission__c =:osid];
        delete lstAns;
        return 'success';
    }
    
    @AuraEnabled
    public static Oxfam_Summary__c  createSummary(Oxfam_Summary__c summaryList){
       
            upsert summaryList;
            return summaryList;          
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Core_Standard__c> getCoreStandardGuidence(string coresStd){
        return [Select Id,Name,Core_Standard_Number__c,Description__c,Document_Ref__c,Guidance__c 
                FROM Oxfam_Core_Standard__c where Name =:coresStd];
    }

    @AuraEnabled
    public static List<Oxfam_Core_Standard__c> getCoreStandard(){
        return [Select Id,Name,Core_Standard_Number__c 
                FROM Oxfam_Core_Standard__c
                ORDER BY Core_Standard_Number__c ASC ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Online_Submission__c> displayListOS(string os_name){
        return [SELECT Id,Name,Name__c,Role__c,Email__c,Submission_Type__c,Entity__r.Name,Reporting_Period__r.Name FROM Oxfam_Online_Submission__c WHERE Name=:os_name];
    }   
    
    @AuraEnabled
    public static List<Oxfam_Answer__c> displayListQA(string os_name,string coreStdName){
        return [SELECT Id,Descriptive_Answer__c,Answer__c,Question__r.Question_Number__c,Question__r.Question__c,
        Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,(Select Box_Link__c from Box_Links__r),
        Core_Standard_Entity__r.Core_Standard__r.Name
        FROM Oxfam_Answer__c 
        WHERE Online_Submission__c=:os_name 
        AND Core_Standard_Entity__r.Core_Standard__r.Name=: coreStdName
        ORDER BY Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Safeguarding_Focal_Point__c> displayFocal(string os_name){
        return [SELECT Id,Name,Office_Sub_Office__c FROM Safeguarding_Focal_Point__c WHERE Online_Submission__c=:os_name];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Information_Provider__c> displayInfoProv(string os_name){
        return [SELECT Name,Role__c,Type_Of_Information__c FROM Information_Provider__c WHERE Online_Submission__c=:os_name];
    }
    
    @AuraEnabled
    public static List<Oxfam_evidence_training__c> createTrainingTable(List<Oxfam_evidence_training__c> TrainingRecord){
        insert TrainingRecord;
        return TrainingRecord;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_evidence_training__c> getTrainingList(string os_name){
        return [SELECT Id,Name,Date_Of_Training__c,Attendance_Sheet__c,Code_of_Conduct__c,
                Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                Number_of_partners__c,PSEA_Policy__c,Safeguarding_Policy__c,Total_Trained_Staff__c,
                Who_Delivered_the_Training__c,Other_evidence__c,Training_materials__c,(Select Type__c,Box_Link__c from Box_Links__r) 
                from Oxfam_evidence_training__c WHERE Online_Submission__c =:os_name];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Evidence_Partner__c> getPartnerList(string os_name){
        return [SELECT Id,Name,Contact_or_Working_with_Children__c,CS_PSEA_in_Partner_Capacity_Assessment__c,CS_PSEA_in_Partner_Working_Agreement__c,
                       CS_and_PSEA_Policy_in_Place__c,Date_of_the_last_CS_training__c,Date_of_the_last_PSEA_training__c,Partner_since__c,
                       PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c 
                FROM Evidence_Partner__c WHERE Online_Submission__c =:os_name];
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Project__c> getProjectList(string os_name){    
        return [SELECT Id,Name,If_No_Risk_Assessment_Explain__c,Is_the_Risk_Assessment_completed__c,
                partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,Project_Start_Date__c,
                When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                from Project__c WHERE Online_Submission__c =:os_name]; 
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Summary__c> getSummaryList(string os_name){
        return [SELECT Id,Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c FROM Oxfam_Summary__c
                WHERE Online_Submission__c =: os_name];
    }
    
     @AuraEnabled
     public static string deleteTraining(Oxfam_evidence_training__c delTrainingRec){
        delete delTrainingRec;
        return 'success';
    }
    @AuraEnabled
     public static string deletePartner(Evidence_Partner__c delPartnerRec){
        delete delPartnerRec;
        return 'success';
    }
    
    @AuraEnabled
     public static string deleteProject(Project__c delProjectRec){
        delete delProjectRec;
        return 'success';
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getAttachmentList(string os_name){
            string onlineSubId = [SELECT Id FROM Oxfam_Online_Submission__c WHERE Name=:os_name].Id;
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :onlineSubId];
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

            System.debug('mapIdTitle '+mapIdTitle);
            return mapIdTitle;
    }

    @AuraEnabled
    public static Oxfam_Online_Submission__c getSubmissionType(string os_name){
        Oxfam_Online_Submission__c onlineSub;
        List<Oxfam_Online_Submission__c> recordInfo = [SELECT Id,Submission_Type__c, Name From Oxfam_Online_Submission__c where Name like: '%'+os_name+'%' LIMIT 1];
        
        if(recordInfo != null && recordInfo.size() > 0) {
            onlineSub = recordInfo[0];
            
            return onlineSub;
        }
         else{
             return null;
         }        
    }
}