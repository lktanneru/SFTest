public class ConsolidatedImpPlanPDFController {
    public Id id{get;set;}
    public string SubmissionType {get;set;}
    
    public List<Oxfam_Task__c> TaskList {get;set;}
    List<Oxfam_Core_Standard_Entity__c> lstCoreStd {get;set;}
    List<Oxfam_Task__c> taskList1 {get;set;}
    
    public ConsolidatedImpPlanPDFController(){
        TaskList =new List<Oxfam_Task__c>();
        String EntityId = ApexPages.currentPage().getParameters().get('id');
        //SubmissionType = ApexPages.currentPage().getParameters().get('SubType');
       
        
        lstCoreStd = [SELECT Core_Standard__c,Entity__c from Oxfam_Core_Standard_Entity__c 
                      where Entity__c=:EntityId 
                      and Entity__c in (select entity__c FROM Oxfam_Entity_User__c where User__c=:userinfo.getUserId())];
        
        for(SObject item : lstCoreStd)
        {
           taskList1 = [SELECT Name,Key_Task__c,Person_Responsible_For_The_Activity__c,Reporting_Period__r.name,Due_Date__c,
                                 Status__c,Comments__c,Completion_Date__c,Core_Standard_Entity__r.Core_Standard__r.Name
                        FROM Oxfam_Task__c 
                        WHERE Core_Standard_Entity__c=:item.Id
                        AND isCloned__c = 'Yes'
                        ORDER BY Due_Date__c ];
            TaskList.addall(taskList1);
        }    
    }

    

}