public class EvidenceChecklistController {
    
    public class EvidenceWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String QuestionName { get; set; }
        @AuraEnabled public String evidenceType { get; set; }
        @AuraEnabled public List<String> BoxLinks { get; set; }
        @AuraEnabled public String Attachments { get; set; }
    }
    
    @AuraEnabled
    public static List<Box_Link__c> fetchDataFromBoxTable(String onlineSubId) { 
        List<EvidenceWrapper> evidenceDataList = new List<EvidenceWrapper>();
        
        // Fetch Oxfam_Answer__c records with related Box_Links__c
        List<Box_Link__c> boxLinksWithQuestions = 
            
            [SELECT Box_Link__c,Type__c, Question__r.Name,Question__r.Short_Description__c,Evidence_Training__r.Name
                    ,Evidence_Training__r.Question__r.Name,Evidence_Training__r.Question__r.Short_Description__c,Evidence_Type_For_Training__c
            FROM Box_Link__c 
            WHERE Online_Submission__c = :onlineSubId
        ];
        system.debug(boxLinksWithQuestions);
        return boxLinksWithQuestions;
    }


    
}