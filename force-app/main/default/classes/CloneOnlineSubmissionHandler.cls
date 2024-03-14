public class CloneOnlineSubmissionHandler {
    
    public static void cloneSubmissionAndAnswers(List<Oxfam_Online_Submission__c> submissionList){
       List<Oxfam_Online_Submission__c> newVersionOSList = new List<Oxfam_Online_Submission__c>();
        
       List<Oxfam_Answer__c> newVersionAns = new List<Oxfam_Answer__c>();
        for(Oxfam_Online_Submission__c VarSubmission : submissionList){
            if(VarSubmission.Approval_Status__c == 'Approved'){
                Oxfam_Online_Submission__c cloneSubmission = new Oxfam_Online_Submission__c();
                cloneSubmission = VarSubmission.clone(false,true,false,false);
                newVersionOSList.add(cloneSubmission);
            }
        }
        insert newVersionOSList;
        List<Oxfam_Answer__c> answers = [SELECT Id,Name FROM Oxfam_Answer__c where Online_Submission__c='a098c00000so6aNAAQ'];
        //newVersionAns = answers.clone(false,true,false,false);
        
    }
    public static void cloneException(List<Oxfam_Online_Submission__c> clonedSubmissionList){
        for(Oxfam_Online_Submission__c cos : clonedSubmissionList){
            if(cos.Approval_Status__c == 'Approved' && cos.Version_Created_On__c != null )
            cos.Approval_Status__c = null;
            cos.Version_Created_On__c = null;
        }
    }
    public static void cloneOnlineSubmissionAndAnswers(Oxfam_Online_Submission__c submissionList){    
        string cloneSubmissionId = '';
        try
        {
        // Cloning online submission
        if(submissionList.Submission_Type__c=='Implementation Plan' && submissionList.Approval_Status__c == 'Approved'){
            // Clone Online Submission            
            cloneSubmissionId = CloneOnlineSubmission(submissionList, '6 Months Progress Report');
            // Create task
            Clonetask(submissionList.Id, cloneSubmissionId);
        }
        else if(submissionList.Submission_Type__c=='6 Months Progress Report' && submissionList.Approval_Status__c == 'Approved')
        {
            // Clone Online Submission            
            cloneSubmissionId = CloneOnlineSubmission(submissionList, 'Annual Report');
            // Create task
            Clonetask(submissionList.Id, cloneSubmissionId);
            // Clone Answers
            CloneAnswers(submissionList.Id, cloneSubmissionId);
          
        }
        }
        catch(Exception ex)
        {
            System.debug('Error : '+ex.getMessage());
        }
    }
    private static void Clonetask(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Oxfam_Task__c> clonedTaskList = new List<Oxfam_Task__c>(); 
        List<Oxfam_Task__c> beforeclonedTaskList = new List<Oxfam_Task__c>();
        List<Oxfam_Task__c> taskList = [SELECT Key_Task__c,Person_Responsible_For_The_Activity__c,Reporting_Period__c,Due_Date__c,
                Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__c,isCloned__c
                FROM Oxfam_Task__c WHERE Online_Submission__c=:onlineSubmissionId];

        for(Oxfam_Task__c task : taskList)
        {
            task.isCloned__c = 'No'; 
            Oxfam_Task__c clonedTask = new Oxfam_Task__c();
            clonedTask.Key_Task__c = task.Key_Task__c;
            clonedTask.Due_Date__c = task.Due_Date__c;
            clonedTask.Comments__c = task.Comments__c;
            clonedTask.Status__c = task.Status__c;
            clonedTask.Completion_Date__c = task.Completion_Date__c;
            clonedTask.Core_Standard_Entity__c = task.Core_Standard_Entity__c;
            clonedTask.Reporting_Period__c = task.Reporting_Period__c;
            clonedTask.Person_Responsible_For_The_Activity__c = task.Person_Responsible_For_The_Activity__c;
            clonedTask.Online_Submission__c = cloneSubmissionId;
            clonedTask.isCloned__c = 'Yes';
            clonedTaskList.add(clonedTask);
            beforeclonedTaskList.add(task);

        }
        insert clonedTaskList;
        update beforeclonedTaskList;
    }
    private static string CloneOnlineSubmission(Oxfam_Online_Submission__c submissionList, string submissionType)
    {
        Oxfam_Online_Submission__c cloneSubmission = new Oxfam_Online_Submission__c();
        cloneSubmission.Submission_Type__c = submissionType;
        cloneSubmission.Entity__c = submissionList.Entity__c;
        cloneSubmission.Reporting_Period__c = submissionList.Reporting_Period__c;
        cloneSubmission.Entity_User__c = submissionList.Entity_User__c;
        cloneSubmission.Name__c = submissionList.Name__c;
        cloneSubmission.Role__c = submissionList.Role__c;
        cloneSubmission.Email__c = submissionList.Email__c;
        insert cloneSubmission;
        CloneInfoProv(submissionList.Id, cloneSubmission.Id);
        CloneFocalPoint(submissionList.Id, cloneSubmission.Id);
        return cloneSubmission.Id;
    }
    private static void CloneAnswers(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Oxfam_Answer__c> clonedAnsList = new List<Oxfam_Answer__c>();
        List<Oxfam_Answer__c> lstAns = [select Id,Question__c,Answer__c,Core_Standard_Entity__c,Descriptive_Answer__c,Score__c 
                                        from Oxfam_Answer__c where Online_Submission__c =:onlineSubmissionId];
        for(Oxfam_Answer__c ans : lstAns)
        {
            Oxfam_Answer__c clonedAns = new Oxfam_Answer__c();
            clonedAns.Question__c = ans.Question__c;
            clonedAns.Answer__c = ans.Answer__c;
            clonedAns.Core_Standard_Entity__c = ans.Core_Standard_Entity__c;
            clonedAns.Descriptive_Answer__c = ans.Descriptive_Answer__c;
            clonedAns.Score__c = ans.Score__c;
            clonedAns.Online_Submission__c = cloneSubmissionId;
            clonedAnsList.add(clonedAns);
        }
        insert clonedAnsList;

        CloneTraining(onlineSubmissionId, cloneSubmissionId);
        ClonePartner(onlineSubmissionId, cloneSubmissionId);
        CloneProject(onlineSubmissionId, cloneSubmissionId);
        CloneSummary(onlineSubmissionId, cloneSubmissionId);

        
    }
    private static void CloneInfoProv(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Information_Provider__c> clonedInfoProvList = new List<Information_Provider__c>();
        List<Information_Provider__c> lstInfoProv = [select Name, Role__c, Type_Of_Information__c
                                        from Information_Provider__c where Online_Submission__c =:onlineSubmissionId];
        for(Information_Provider__c infoProv : lstInfoProv)
        {
            Information_Provider__c clonednfoProv = new Information_Provider__c();
            clonednfoProv.Name = infoProv.Name;
            clonednfoProv.Role__c = infoProv.Role__c;
            clonednfoProv.Type_Of_Information__c = infoProv.Type_Of_Information__c;
            clonednfoProv.Online_Submission__c = cloneSubmissionId;
            clonedInfoProvList.add(clonednfoProv);
        }
        insert clonedInfoProvList;
    }    
    private static void CloneFocalPoint(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Safeguarding_Focal_Point__c> clonedFocalPtList = new List<Safeguarding_Focal_Point__c>();
        List<Safeguarding_Focal_Point__c> lstFocalPt = [select Name, Office_Sub_Office__c
                                        from Safeguarding_Focal_Point__c where Online_Submission__c =:onlineSubmissionId];
        for(Safeguarding_Focal_Point__c focalPt : lstFocalPt)
        {
            Safeguarding_Focal_Point__c clonedFocalPt = new Safeguarding_Focal_Point__c();
            clonedFocalPt.Name = focalPt.Name;
            clonedFocalPt.Office_Sub_Office__c = focalPt.Office_Sub_Office__c;
            clonedFocalPt.Online_Submission__c = cloneSubmissionId;
            clonedFocalPtList.add(clonedFocalPt);
        }
        insert clonedFocalPtList;
    } 
    private static void CloneTraining(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Oxfam_evidence_training__c> clonedTrainList = new List<Oxfam_evidence_training__c>();
        List<Oxfam_evidence_training__c> lstTrain = [SELECT Attendance_Sheet__c,Code_of_Conduct__c,Date_Of_Training__c,
                Description_Of_Training__c,Number_of_community__c,Number_of_Oxfam_staff__c,
                Number_of_partners__c,PSEA_Policy__c,Question__c,Safeguarding_Policy__c,Total_Trained_Staff__c,
                Who_Delivered_the_Training__c,Other_evidence__c,Training_materials__c,Online_Submission__c
                                        from Oxfam_evidence_training__c where Online_Submission__c =:onlineSubmissionId];
        for(Oxfam_evidence_training__c traing : lstTrain)
        {
            Oxfam_evidence_training__c clonedTraing = new Oxfam_evidence_training__c();
            clonedTraing.Attendance_Sheet__c = traing.Attendance_Sheet__c;
            clonedTraing.Code_of_Conduct__c = traing.Code_of_Conduct__c;
            clonedTraing.Date_Of_Training__c = traing.Date_Of_Training__c;
            clonedTraing.Description_Of_Training__c = traing.Description_Of_Training__c;
            clonedTraing.Number_of_community__c = traing.Number_of_community__c;
            clonedTraing.Number_of_Oxfam_staff__c = traing.Number_of_Oxfam_staff__c;
            clonedTraing.Number_of_partners__c = traing.Number_of_partners__c;
            clonedTraing.Total_Trained_Staff__c = traing.Total_Trained_Staff__c;
            clonedTraing.PSEA_Policy__c = traing.PSEA_Policy__c;
            clonedTraing.Question__c = traing.Question__c;
            clonedTraing.Safeguarding_Policy__c = traing.Safeguarding_Policy__c;
            clonedTraing.Who_Delivered_the_Training__c = traing.Who_Delivered_the_Training__c;
            clonedTraing.Other_evidence__c = traing.Other_evidence__c;
            clonedTraing.Training_materials__c = traing.Training_materials__c;
            clonedTraing.Online_Submission__c = cloneSubmissionId;
            clonedTrainList.add(clonedTraing);
        }
        insert clonedTrainList;
    }
    private static void ClonePartner(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Evidence_Partner__c> clonedPartnerList = new List<Evidence_Partner__c>();
        List<Evidence_Partner__c> lstPartner = [SELECT Name,Online_Submission__c,
                CS_PSEA_in_Partner_Capacity_Assessment__c,Date_of_the_last_PSEA_training__c,
                CS_PSEA_in_Partner_Working_Agreement__c,CS_and_PSEA_Policy_in_Place__c,Contact_or_Working_with_Children__c,Date_of_the_last_CS_training__c,
                Partner_since__c,PartnerCodeofConductorequivalentSigned__c,Project_s_Partner_is_Involved_in__c,Question__c
                                        from Evidence_Partner__c where Online_Submission__c =:onlineSubmissionId];
        for(Evidence_Partner__c partner : lstPartner)
        {
            Evidence_Partner__c clonedPartner = new Evidence_Partner__c();
            clonedPartner.Name = partner.Name;
            clonedPartner.Contact_or_Working_with_Children__c = partner.Contact_or_Working_with_Children__c;
            clonedPartner.CS_PSEA_in_Partner_Capacity_Assessment__c = partner.CS_PSEA_in_Partner_Capacity_Assessment__c;
            clonedPartner.Date_of_the_last_PSEA_training__c = partner.Date_of_the_last_PSEA_training__c;
            clonedPartner.CS_PSEA_in_Partner_Working_Agreement__c = partner.CS_PSEA_in_Partner_Working_Agreement__c;
            clonedPartner.CS_and_PSEA_Policy_in_Place__c = partner.CS_and_PSEA_Policy_in_Place__c;
            clonedPartner.Date_of_the_last_CS_training__c = partner.Date_of_the_last_CS_training__c;
            clonedPartner.Partner_since__c = partner.Partner_since__c;
            clonedPartner.PartnerCodeofConductorequivalentSigned__c = partner.PartnerCodeofConductorequivalentSigned__c;
            clonedPartner.Question__c = partner.Question__c;
            clonedPartner.Project_s_Partner_is_Involved_in__c = partner.Project_s_Partner_is_Involved_in__c;
            clonedPartner.Online_Submission__c = cloneSubmissionId;
            clonedPartnerList.add(clonedPartner);
        }
        insert clonedPartnerList;
    }
    private static void CloneProject(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Project__c> clonedProjList = new List<Project__c>();
        List<Project__c> lstProj = [SELECT Name,Online_Submission__c,Question__c,If_No_Risk_Assessment_Explain__c,
                                    Is_the_Risk_Assessment_completed__c,
                partners_involved_in_Risk_Asses__c,Progress_On_Monitoring_High_Risk__c,Project_End_Date__c,Project_Start_Date__c,
                When_was_the_last_review_update_of_Risk__c,What_level_of_contact_with_children_do__c
                                        from Project__c where Online_Submission__c =:onlineSubmissionId];
        for(Project__c proj : lstProj)
        {
            Project__c clonedProj = new Project__c();
            clonedProj.Name = proj.Name;
            clonedProj.If_No_Risk_Assessment_Explain__c = proj.If_No_Risk_Assessment_Explain__c;
            clonedProj.Is_the_Risk_Assessment_completed__c = proj.Is_the_Risk_Assessment_completed__c;
            clonedProj.partners_involved_in_Risk_Asses__c = proj.partners_involved_in_Risk_Asses__c;
            clonedProj.Progress_On_Monitoring_High_Risk__c = proj.Progress_On_Monitoring_High_Risk__c;
            clonedProj.Project_End_Date__c = proj.Project_End_Date__c;
            clonedProj.Project_Start_Date__c = proj.Project_Start_Date__c;
            clonedProj.When_was_the_last_review_update_of_Risk__c = proj.When_was_the_last_review_update_of_Risk__c;
            clonedProj.What_level_of_contact_with_children_do__c = proj.What_level_of_contact_with_children_do__c;
            clonedProj.Question__c = proj.Question__c;
            clonedProj.Online_Submission__c = cloneSubmissionId;
            clonedProjList.add(clonedProj);
        }
        insert clonedProjList;
    }   
    private static void CloneSummary(string onlineSubmissionId, string cloneSubmissionId)
    {
        List<Oxfam_Summary__c> clonedSummaryList = new List<Oxfam_Summary__c>();
        List<Oxfam_Summary__c> lstSummary = [SELECT Online_Submission__c, CS4_Interview_Template__c,
                CS4_Reference_Check_Template__c,CS5_Training_Records__c,
                CS6_Safeguarding_Reporting_Procedure__c,CS7_Examples_of_community_level_feedback__c,
                CS8_Sample_Partner_Capacity_Assessment__c,CS8_Sample_Partner_Working_Agreement__c,
                Sumamry_Challanges__c,Summary_Achievements__c,Summary_Support_Needed__c
                                        from Oxfam_Summary__c where Online_Submission__c =:onlineSubmissionId];
        for(Oxfam_Summary__c summary : lstSummary)
        {
            Oxfam_Summary__c clonedSummary = new Oxfam_Summary__c();
            clonedSummary.CS4_Interview_Template__c = summary.CS4_Interview_Template__c;
            clonedSummary.CS4_Reference_Check_Template__c = summary.CS4_Reference_Check_Template__c;
            clonedSummary.CS5_Training_Records__c = summary.CS5_Training_Records__c;
            clonedSummary.CS6_Safeguarding_Reporting_Procedure__c = summary.CS6_Safeguarding_Reporting_Procedure__c;
            clonedSummary.CS7_Examples_of_community_level_feedback__c = summary.CS7_Examples_of_community_level_feedback__c;
            clonedSummary.CS8_Sample_Partner_Working_Agreement__c = summary.CS8_Sample_Partner_Working_Agreement__c;
            clonedSummary.Sumamry_Challanges__c = summary.Sumamry_Challanges__c;
            clonedSummary.Summary_Achievements__c = summary.Summary_Achievements__c;
            clonedSummary.CS8_Sample_Partner_Capacity_Assessment__c = summary.CS8_Sample_Partner_Capacity_Assessment__c;
            clonedSummary.Summary_Support_Needed__c = summary.Summary_Support_Needed__c;
            clonedSummary.Online_Submission__c = cloneSubmissionId;
            clonedSummaryList.add(clonedSummary);
        }
        insert clonedSummaryList;
    } 
}