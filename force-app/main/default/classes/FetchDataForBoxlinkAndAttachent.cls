public class FetchDataForBoxlinkAndAttachent {
    
    public class EvidenceWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String QuestionName { get; set; }
        @AuraEnabled public String evidenceType { get; set; }
        @AuraEnabled public string BoxLinks { get; set; }
        @AuraEnabled public String Attachments { get; set; }
    }

    @AuraEnabled
    public static List<EvidenceWrapper> fetchBoxLinksFromOnlineSubmission(String onlineSubId) {
        List<EvidenceWrapper> evidenceDataList = new List<EvidenceWrapper>();
        // Fetch Oxfam_Answer__c records with related Box_Links__c
        
        List<Box_Link__c> boxLinksData = [
            SELECT Id,Box_Link__c,Type__c, Question__r.Name,Question__r.Short_Description__c,Evidence_Training__r.Name
                    ,Evidence_Training__r.Question__r.Name,Evidence_Training__r.Question__r.Short_Description__c,Evidence_Type_For_Training__c
            FROM Box_Link__c 
            WHERE Online_Submission__c = :onlineSubId ORDER BY Evidence_Type_For_Training__c];

        for(Box_Link__c singleBL : boxLinksData){
            EvidenceWrapper evidenceWrap = new EvidenceWrapper(); 
            if(singleBL.Type__c == null){
                evidenceWrap.Id           = singleBL.Id;
                evidenceWrap.QuestionName = singleBL.Question__r.Name;
                evidenceWrap.evidenceType = singleBL.Question__r.Short_Description__c;
                evidenceWrap.BoxLinks     = singleBL.Box_Link__c;
            }else{
                evidenceWrap.Id           = singleBL.Id;
                evidenceWrap.QuestionName = singleBL.Evidence_Training__r.Question__r.Name;
                evidenceWrap.evidenceType = singleBL.Evidence_Type_For_Training__c ;
                evidenceWrap.BoxLinks     = singleBL.Box_Link__c;
            }
            
            evidenceDataList.add(evidenceWrap);
          
        }
        return evidenceDataList;  
    }

    @AuraEnabled
    public static List<EvidenceWrapper> fetchAttachmentsFromOnlineSubmission(String onlineSubId){
            List<EvidenceWrapper> attachmentDataList = new List<EvidenceWrapper>();

            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: onlineSubId];

            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title,Evidence_Relates_To__c,Evidence_Type__c 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];

            for(ContentVersion singleFile : docs){
                EvidenceWrapper attachmentWrap = new EvidenceWrapper(); 
                    attachmentWrap.Id           = singleFile.ContentDocumentId;
                    attachmentWrap.QuestionName = singleFile.Evidence_Relates_To__c;
                    attachmentWrap.evidenceType = singleFile.Evidence_Type__c;
                    attachmentWrap.Attachments  = '/sfc/servlet.shepherd/document/download/'+ singleFile.ContentDocumentId;
                
                attachmentDataList.add(attachmentWrap);
                }
            return attachmentDataList;   
    }

    @AuraEnabled
    public static List<EvidenceWrapper> fetchAttachAndBoxLinkFromOnlineSubmission(String onlineSubId){
        
        List<EvidenceWrapper> evidenceDataList = fetchBoxLinksFromOnlineSubmission(onlineSubId);
        List<EvidenceWrapper> attachmentDataList = fetchAttachmentsFromOnlineSubmission(onlineSubId);

        List<EvidenceWrapper> attachAndBoxLinkDataList = new List<EvidenceWrapper>();

        attachAndBoxLinkDataList.addAll(evidenceDataList);
        attachAndBoxLinkDataList.addAll(attachmentDataList);

        system.debug(attachAndBoxLinkDataList);
        return attachAndBoxLinkDataList;  
        
    }

    @AuraEnabled
    public static Oxfam_Online_Submission__c submissionIdFromName(String recordId){
        try {
            ProcessInstanceWorkitem recworkItem =[SELECT id,ProcessInstanceId,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE id=:recordId];
            Oxfam_Online_Submission__c subList = [SELECT Id,Name,Submission_Type__c FROM Oxfam_Online_Submission__c WHERE id=:recworkItem.ProcessInstance.TargetObjectId];
            return subList;
        } 
        catch (Exception e) {
            return null;
           // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string deleteBoxLink(Box_Link__c BoxLinkRec){
        string message='';
        try {
            delete BoxLinkRec;
            
            message = 'success';
            system.debug('this is returned   '+message);
            return message;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}