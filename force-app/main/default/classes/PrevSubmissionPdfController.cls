public class PrevSubmissionPdfController {
    public Id id{get;set;}
    
    public List<Oxfam_Task__c> TaskList {get;set;}
    public List<Safeguarding_Focal_Point__c> focalPoints {get;set;}
    public List<Information_Provider__c> informationList {get;set;}
    public List<Oxfam_Answer__c> qaList {get;set;}
    public List<Oxfam_evidence_training__c> trainList {get;set;}
    public List<Evidence_Partner__c> partnerList {get;set;}
    public List<Project__c> projectList {get;set;}
    public List<Oxfam_Summary__c> summaryList {get;set;}
    public List<Oxfam_Online_Submission__c> OSList {get;set;}
    public Boolean ImpFlag { get; set; }
    public PrevSubmissionPdfController(){
        
        TaskList =new List<Oxfam_Task__c>();
        focalPoints =new List<Safeguarding_Focal_Point__c>();
        informationList =new List<Information_Provider__c>();
        qaList =new List<Oxfam_Answer__c>();
        trainList =new List<Oxfam_evidence_training__c>();
        partnerList= new List<Evidence_Partner__c>();
        projectList = new List<Project__c>();
        summaryList = new List<Oxfam_Summary__c>();
        OSLIst = new List<Oxfam_Online_Submission__c>();
        String SubmisionId = ApexPages.currentPage().getParameters().get('id');
        if(SubmisionId !=null){
            OSList = [SELECT Id,Name,Name__c,Role__c,Email__c,Submission_Type__c from Oxfam_Online_Submission__c WHERE Id=:SubmisionId Limit 1];
            
            system.debug('oslist is: '+OSList);
            ImpFlag = true;
            for(Oxfam_Online_Submission__c a : OSList){
                system.debug('before entering if boolean is:: '+ImpFlag);
                if(a.Submission_Type__c=='Implementation Plan'){
                    ImpFlag = false;       
                    system.debug('entered if condition with bolean as : '+ImpFlag);
                }
            }
            
            
            TaskList=[SELECT Id,Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Due_Date__c,
                      Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                      FROM Oxfam_Task__c
                      WHERE Online_Submission__c =:SubmisionId
                      ORDER BY Due_Date__c];
            
            focalPoints=[SELECT Id,Name,Office_Sub_Office__c 
                         FROM Safeguarding_Focal_Point__c 
                         WHERE Online_Submission__c =:SubmisionId];
            
            informationList =[SELECT Name,Role__c,Type_Of_Information__c 
                              FROM Information_Provider__c 
                              WHERE Online_Submission__c =:SubmisionId];
            
            qaList =[SELECT Id,Descriptive_Answer__c,Answer__c,Question__r.Question_Number__c,Question__r.Question__c,
                     Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Core_Standard_Entity__r.Core_Standard__r.Name
                     FROM Oxfam_Answer__c 
                     WHERE Online_Submission__c =:SubmisionId order by Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c,Question__r.Question_Number__c];
            
            trainList =[SELECT Id,Name,Attendance_Sheet__c,Code_of_Conduct__c,
                        Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                        Number_of_partners__c,PSEA_Policy__c,Safeguarding_Policy__c,Total_Trained_Staff__c,
                        Who_Delivered_the_Training__c,Other_evidence__c,Training_materials__c 
                        from Oxfam_evidence_training__c 
                        WHERE Online_Submission__c =:SubmisionId];
            
            partnerList =[SELECT Id,Name,Contact_or_Working_with_Children__c,CS_PSEA_in_Partner_Capacity_Assessment__c,
                          CS_PSEA_in_Partner_Working_Agreement__c,
                          CS_and_PSEA_Policy_in_Place__c,Date_of_the_last_CS_training__c,Date_of_the_last_PSEA_training__c,
                          Partner_since__c,
                          PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c 
                          FROM Evidence_Partner__c 
                          WHERE Online_Submission__c =:SubmisionId];
            
            projectList=[SELECT Id,Name,If_No_Risk_Assessment_Explain__c,Is_the_Risk_Assessment_completed__c,
                         partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,
                         Project_Start_Date__c,
                         When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                         from Project__c 
                         WHERE Online_Submission__c =:SubmisionId];
            
            summaryList =[SELECT Id,CS4_Interview_Template__c,CS4_Reference_Check_Template__c,CS5_Training_Records__c,CS6_Safeguarding_Reporting_Procedure__c,
                          CS7_Examples_of_community_level_feedback__c,CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,
                          Online_Submission__c,Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c FROM Oxfam_Summary__c
                          WHERE Online_Submission__c =: SubmisionId];
        }
        
    }
}