public class countryPageCls {
    
    @AuraEnabled(cacheable=true)
    public static string affiliateOfficeApex(string str){
        list<Entity_Role__c> entityList= [SELECT  Affiliate_Office__r.name FROM Entity_Role__c where Role__c='Executive Affiliate'	and Entity__c = :str ];
        if(entityList.size()>0){
            return entityList[0].Affiliate_Office__r.name;
        }else 
            return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Entity_Role__c> partnerOfficeApex(string str){
        return [SELECT  Affiliate_Office__r.name FROM Entity_Role__c where Role__c='Partner Affiliate' and Entity__c = :str ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Online_Submission__c> getSubmissionType(){
        return [SELECT Submission_Type__c FROM Oxfam_Online_Submission__c];
    }
    
    @AuraEnabled(cacheable=false)
    public static List<Oxfam_Question__c> getQuestions(string coresStd, string qtnCat){
        return [SELECT id,Name,Question__c,Question_Type__c,Mandatory__c,Question_Number__c,Short_Description__c from Oxfam_Question__c where Question_Category__c =:qtnCat and Core_Standard__r.Name =:coresStd ORDER BY Question_Number__c ASC];
    }
    /*@AuraEnabled(cacheable=true)
    public static List<Oxfam_Core_Standard__c> getcoreStandard(){
        return [SELECT Name,Id,Core_Standard_Number__c from Oxfam_Core_Standard__c order by Core_Standard_Number__c asc];
    }*/
     @AuraEnabled(cacheable=true)
     public static List<Oxfam_Core_Standard_Entity__c> coreStandard(String entityId,String reportId){
         List<Oxfam_Core_Standard_Entity__c> lstCSE = new List<Oxfam_Core_Standard_Entity__c>();
         If(reportId =='' || reportId == null || reportId=='undefined'){
             lstCSE =  [SELECT id,Name,Core_Standard__c,Core_Standard__r.Name,Core_Standard__r.Core_Standard_Number__c from Oxfam_Core_Standard_Entity__c WHERE  Entity__c =:entityId
         			order by Core_Standard__r.Core_Standard_Number__c  ];
        }
        
         lstCSE= [SELECT id,Name,Core_Standard__c,Core_Standard__r.Core_Standard_Number__c,Core_Standard__r.Name from Oxfam_Core_Standard_Entity__c WHERE  Entity__c =:entityId
     			 AND Reporting_Period__c =:reportId order by Core_Standard__r.Core_Standard_Number__c ];
         System.Debug(lstCSE);
         return lstCSE;
     }
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Reporting_Period__c> getreportingPeriod(){
        return [SELECT Name from Oxfam_Reporting_Period__c order by name asc];
    }
    
    @AuraEnabled 
    public static List<Oxfam_Answer__c> createAnswerRecord(Oxfam_Answer__c ansRecord){
        map<String,String> qusAnsIdMap = new map<String,String>();
        List<Oxfam_Answer__c> answerlist = new List<Oxfam_Answer__c>();
        answerlist.add(ansRecord);
        upsert answerlist;
        for(Oxfam_Answer__c aOxfam : answerlist){
            qusAnsIdMap.put(ansRecord.Question__c,aOxfam.Id);  
        }
        List<Box_Link__c> allBoxLinkToUpdate = new List<Box_Link__c>(); 
        List<Box_Link__c> allBoxLink = [Select Id,Question__c,Answer__c from Box_Link__c where Question__c  IN :qusAnsIdMap.keySet()];
        for(Box_Link__c aBoxLink : allBoxLink){
            aBoxLink.Answer__c = qusAnsIdMap.get(aBoxLink.Question__c);
            allBoxLinkToUpdate.add(aBoxLink);
        }
        update allBoxLinkToUpdate;
        return answerlist;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Oxfam_Core_Standard_Entity__c> coreStandardEntityMandatory(string entityName){
        return [SELECT Name,Id,Mandatory__c,Entity__r.Name,Core_Standard__r.Name from Oxfam_Core_Standard_Entity__c 
                where Entity__r.Name=:entityName and Mandatory__c='Yes'];
    }
    
    @AuraEnabled
    public static Oxfam_Online_Submission__c insertOnlineSub(Oxfam_Online_Submission__c onlineSubmission){
        onlineSubmission.Entity_User__c = [select Id FROM Oxfam_Entity_User__c where  Entity__c=:onlineSubmission.Entity__c and User__c=:userinfo.getUserId()].Id;
        insert onlineSubmission;
        return onlineSubmission;
    }
    @AuraEnabled
    public static Oxfam_Online_Submission__c updateOnlineSub(Oxfam_Online_Submission__c onlineSubmission){
        update onlineSubmission;
        return onlineSubmission;
    }
    
    @AuraEnabled
    public static Oxfam_Online_Submission__c getOnlineSub(string entityId){
        Oxfam_Online_Submission__c onlineSub;
        string EntityIsSplit = entityId.split(';')[1];
        if(EntityIsSplit != '')
        {
            onlineSub = [select id,Name__c, Role__c, Email__c,Submission_Type__c,Reporting_Period__c,
                         Entity__c,Entity__r.Name,Entity_User__c,Reporting_Period__r.Name,Approval_Status__c 
                         FROM Oxfam_Online_Submission__c where Approval_Status__c!='Approved' and Entity__c=:EntityIsSplit and Entity__c in 
                         (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId()) order by LastModifiedDate desc  limit 1];
        }
        /*else if(entityId == '')
{ 
onlineSub = [select id,Name__c, Role__c, Email__c,Submission_Type__c,Reporting_Period__c,
Entity__c,Entity__r.Name,Entity_User__c,Reporting_Period__r.Name 
FROM Oxfam_Online_Submission__c where Approval_Status__c!='Approved' and Entity__c in 
(select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId()) order by LastModifiedDate desc  limit 1];            
}*/
        return onlineSub;
    }
    
    @AuraEnabled(cacheable=true)
    public static Oxfam_Core_Standard_Entity__c coreStandardEntityRecord(string entityName, string corestdName, string reportid){
        system.debug('coreStandardEntityRecord is called'+entityName+corestdName+reportid);
        Oxfam_Core_Standard_Entity__c obj = new Oxfam_Core_Standard_Entity__c();
        obj = [SELECT Id from Oxfam_Core_Standard_Entity__c where Core_Standard__r.Name=:corestdName and Reporting_Period__c=:reportid and 
               Entity__c=:entityName];
        return obj;
    } 
    
    @AuraEnabled
    public static List<Oxfam_Answer__c> getAnswer(string onlineSubId){
        List<Oxfam_Answer__c> answerList = [select Id,Answer__c,Descriptive_Answer__c,Online_Submission__c,Question__c,
                                            Question__r.Question__c,(Select Id,Box_Link__c,Answer__c,Online_Submission__c FROM Box_Links__r),
                                            Core_Standard_Entity__c,Score__c,Box_Link__c from Oxfam_Answer__c where 
                                            Online_Submission__c =:onlineSubId];
        return answerList;
    } 
    public Class BoxWrapper{
        @AuraEnabled
        public Integer index;
        @AuraEnabled
        public String boxId;
        @AuraEnabled
        public String boxLink;
        @AuraEnabled
        public String answerId;
        @AuraEnabled
        public String questionId;
        @AuraEnabled
        public String OnlineSubmissionId;
    }
    @AuraEnabled
    public static void saveBoxLinks(String allBoxLinks){
        List<BoxWrapper> BoxWrapperList = (List<BoxWrapper>)JSON.deserialize(allBoxLinks, List<BoxWrapper>.class);
        List<Box_Link__c> boxList = new List<Box_Link__c>();
        for(BoxWrapper aBoxWrapper : BoxWrapperList){
            Box_Link__c aBoxLink = new Box_Link__c();
            aBoxLink.Id = aBoxWrapper.boxId != ''? aBoxWrapper.boxId : null;
            aBoxLink.Online_Submission__c = aBoxWrapper.OnlineSubmissionId;
            aBoxLink.Answer__c = aBoxWrapper.answerId != '' ? aBoxWrapper.answerId : null;
            aBoxLink.Box_Link__c = aBoxWrapper.boxLink;
            aBoxLink.Question__c = aBoxWrapper.questionId != '' ? aBoxWrapper.questionId :null;
            boxList.add(aBoxLink);
        }
        system.debug(boxList);
        upsert boxList;
    }
    @AuraEnabled
    public static List<BoxWrapper> getBoxLinks(String questionId,String answerId, string OnlineSubmissionId){ 
        List<Box_Link__c> boxList = [Select Id,Answer__c,Online_Submission__c,Box_Link__c,Question__c 
                                        FROM Box_Link__c 
                                        WHERE Question__c = :questionId
                                        AND Answer__c = :answerId 
                                        AND Online_Submission__c =: OnlineSubmissionId ];
        Integer index = 1;
        List<BoxWrapper> wrapperListToReturn = new List<BoxWrapper>();
        for(Box_Link__c aBoxLink : boxList){
            BoxWrapper aBoxWrapper = new BoxWrapper();
            aBoxWrapper.index = index;
            aBoxWrapper.boxId = aBoxLink.Id;
            aBoxWrapper.boxLink = aBoxLink.Box_Link__c;
            aBoxWrapper.answerId = aBoxLink.Answer__c;
            aBoxWrapper.OnlineSubmissionId = aBoxLink.Online_Submission__c;
            aBoxWrapper.questionId = aBoxLink.Question__c;
            wrapperListToReturn.add(aBoxWrapper);
            index++;
        }
        return wrapperListToReturn; 
    }
    @AuraEnabled
    public static Map<string,Decimal> getQuestionsForProgressBar(List<String> coresStd, List<String> qtnCat,string onlineSubId){
        Map<String,Decimal> tabProgressMap = new Map<String,Decimal>();

        // Query for all core standards that match the filter criteria
        List<Oxfam_Core_Standard__c> allCoreStandards = [
            SELECT Id, Name,Core_Standard_Number__c 
            FROM Oxfam_Core_Standard__c
            WHERE Id IN :coresStd
            ORDER BY Core_Standard_Number__c asc
    ];

        // Initialize the map with all core standards and set their scores to zero
        for (Oxfam_Core_Standard__c coreStd : allCoreStandards) {
        tabProgressMap.put(coreStd.Name, 0.0 );
        }

        List<Oxfam_Answer__c> allAnswers =  [Select Id,Core_Standard_Entity__c,Score__c,Question__c,Question__r.Core_Standard__c,Question__r.Core_Standard__r.Name,Question__r.Weightage__c,Question__r.Question_Category__c,
                                             Answer__c 
                                             From Oxfam_Answer__c 
                                             WHERE Question__r.Core_Standard__c IN:coresStd 
                                             AND Question__r.Question_Category__c IN :qtnCat
                                             AND Online_Submission__c =: onlineSubId
                                             ORDER BY Question__r.Core_Standard__r.Core_Standard_Number__c ASC];
        for(Oxfam_Answer__c aOxfamAnswer : allAnswers){
            // if (aOxfamAnswer.Score__c> 0){
                String coreStdName = aOxfamAnswer.Question__r.Core_Standard__r.Name;
                if (tabProgressMap.containsKey(coreStdName)) {
                    Decimal existingScore = tabProgressMap.get(coreStdName);
                    Decimal newScore = existingScore + aOxfamAnswer.Score__c;
                    tabProgressMap.put(coreStdName, newScore);  
                } else {
                tabProgressMap.put(coreStdName, aOxfamAnswer.Score__c); 
                }
            // } 
        } 
        system.debug('thei is return  '+ tabProgressMap.values());
        return tabProgressMap;
    }
    @AuraEnabled
    public static void saveTrainingLinks(String data){
        List<BoxTrainingWrapper> BoxTrainingWrapperList = (List<BoxTrainingWrapper>)JSON.deserialize(data, List<BoxTrainingWrapper>.class);
        system.debug(BoxTrainingWrapperList);
        List<Box_Link__c> boxList = new List<Box_Link__c>();
        for(BoxTrainingWrapper aBoxWrapper : BoxTrainingWrapperList){
            Box_Link__c aBoxLink = new Box_Link__c();
            aBoxLink.Id = aBoxWrapper.boxId != ''? aBoxWrapper.boxId : null;
            aBoxLink.Evidence_Training__c = aBoxWrapper.trainingId != '' ? aBoxWrapper.trainingId : null;
            aBoxLink.Type__c = aBoxWrapper.trainingType;
            aBoxLink.Box_Link__c = aBoxWrapper.boxLink;
            aBoxLink.Online_Submission__c = aBoxWrapper.submissionId;
            boxList.add(aBoxLink);
        }
        system.debug(boxList);
        upsert boxList;
    }
    @AuraEnabled
    public static List<BoxTrainingWrapper> getTrainingLinks(String trainingId,String trainingType){
        List<Box_Link__c> boxList = [Select Id,Evidence_Training__c,Online_Submission__c,Box_Link__c,Type__c,Question__c FROM Box_Link__c
                                     WHERE Evidence_Training__c = :trainingId AND Type__c = :trainingType];
        Integer index = 1;
        List<BoxTrainingWrapper> wrapperListToReturn = new List<BoxTrainingWrapper>();
        for(Box_Link__c aBoxLink : boxList){
            BoxTrainingWrapper aBoxWrapper = new BoxTrainingWrapper();
            aBoxWrapper.index = index;
            aBoxWrapper.boxId = aBoxLink.Id;
            aBoxWrapper.boxLink = aBoxLink.Box_Link__c;
            aBoxWrapper.trainingId = aBoxLink.Evidence_Training__c;
            aBoxWrapper.trainingType = aBoxLink.Type__c;
            aBoxWrapper.submissionId = aBoxLink.Online_Submission__c;
            wrapperListToReturn.add(aBoxWrapper);
            index++;
        }
        return wrapperListToReturn;
    }
    public Class BoxTrainingWrapper{
        @AuraEnabled
        public Integer index;
        @AuraEnabled
        public String boxId;
        @AuraEnabled
        public String boxLink;
        @AuraEnabled
        public String trainingId;
        @AuraEnabled
        public String trainingType;
        @AuraEnabled
        public String submissionId;
        
        
    }
}