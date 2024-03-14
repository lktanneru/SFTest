trigger TrainingTrigger on Oxfam_evidence_training__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        for (Oxfam_evidence_training__c VarSingleTrainingRec : Trigger.new) {
            // Convert the DateTime field to a string
            String trainingDateStr = String.valueOf(VarSingleTrainingRec.Date_Of_Training__c);
			string trainingDate = '';
            // Extract the date portion from the string
            if(trainingDateStr != null){
                trainingDate = trainingDateStr.substring(0, 10);
            }
            

            // Update the Name field with the formatted date
            VarSingleTrainingRec.Name = trainingDate + '/' + VarSingleTrainingRec.Who_Delivered_the_Training__c;
        }
    }

}