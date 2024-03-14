public class AnswerBoxFieldTriggerHandler {
    
    public static void answerUpdateContext(Map<Id,Oxfam_Answer__c> newBoxMap , Map<Id,Oxfam_Answer__c> oldBoxMap){
        for(Oxfam_Answer__c VarAnswer : newBoxMap.values() ){
            
            string newBoxValue = VarAnswer.Box_Link__c;
            string oldBoxValue = oldBoxMap.get(VarAnswer.Id).Box_Link__c;
            
            if(oldBoxValue != newBoxValue){
                if(string.isBlank(oldBoxValue)){
                    VarAnswer.Box_Link__c = newBoxValue;
                } else if(string.isBlank(newBoxValue)){
                    VarAnswer.Box_Link__c = oldBoxValue;
                } else {
                    VarAnswer.Box_Link__c = oldBoxValue + '|||' + newBoxValue;
                }
            }
            
        }
    }

}