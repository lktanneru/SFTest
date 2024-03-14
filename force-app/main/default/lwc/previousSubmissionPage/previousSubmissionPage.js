import { LightningElement, wire, track } from 'lwc';

import getTaskList from '@salesforce/apex/PreviousSubmissionController.getTaskList';
import getFocalList from '@salesforce/apex/PreviousSubmissionController.getFocalList';
import getInfoList from '@salesforce/apex/PreviousSubmissionController.getInfoList';
import getQAList from '@salesforce/apex/PreviousSubmissionController.getQAList';
import getTrainingList from '@salesforce/apex/PreviousSubmissionController.getTrainingList';
import getPartnerList from '@salesforce/apex/PreviousSubmissionController.getPartnerList';
import getProjectList from '@salesforce/apex/PreviousSubmissionController.getProjectList';
import getOnlineSub from '@salesforce/apex/PreviousSubmissionController.getOnlineSub';
import getSummaryList from '@salesforce/apex/PreviousSubmissionController.getSummaryList';
import getCoreStandard from '@salesforce/apex/SubmissionCls.getCoreStandard';
import getAttachmentList from '@salesforce/apex/PreviousSubmissionController.getAttachmentList';
import getAllQuestionAnswers from '@salesforce/apex/PreviousSubmissionController.getAllQuestionAnswers'
import { NavigationMixin } from 'lightning/navigation';
import LightningAlert from "lightning/alert";
import { exportCSVFile } from 'c/utils';

const cols = [
    { label: 'Task Reference', fieldName: 'Name', type: 'text', sortable: true,wrapText: true },
    { label: 'Core Standard', fieldName: 'CoreStandard', type: 'text', sortable: true,wrapText: true },
    { label: 'Key Task', fieldName: 'Key_Task__c', type: 'text',wrapText: true },
    { label: 'Person Responsible', fieldName: 'Person_Responsible_For_The_Activity__c', sortable: true, type: 'text',wrapText: true },
    { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date-local', sortable: true,wrapText: true },
    { label: 'Status', fieldName: 'Status__c', type: 'text', sortable: true,wrapText: true },
    { label: 'Comments', fieldName: 'Comments__c', type: 'textarea',wrapText: true},
    { label: 'Completion Date', fieldName: 'Completion_Date__c', type: 'date-local', sortable: true,wrapText: true },
];

const cols1 = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Office/Sub Office', fieldName: 'Office_Sub_Office__c', type: 'text' }
];

const cols2 = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Role', fieldName: 'Role__c', type: 'text' },
    { label: 'Type Of Info', fieldName: 'Type_Of_Information__c', type: 'text' }
];

const columns = [
    //{ label: 'CS #', fieldName: 'CoreStandardNumber', sortable: true, type: 'number',initialWidth: 70 },
    //{ label: 'Core Standard', fieldName: 'coreStandardName',type:'text', initialWidth: 200},
    //{ label: 'Que No', fieldName: 'QuestionNumber', sortable: true, type: 'number', initialWidth:90 },
    { label: 'Question', fieldName: 'Question', sortable: true, type: 'text',wrapText:true },
    { label: 'Answer (Minimum Standards)', fieldName: 'Answer__c', sortable: true, type: 'text' },
    { label: 'Answer (Explanation & Good Practice)', fieldName: 'Descriptive_Answer__c', type: 'text'},
    //{ label: 'Box Link', fieldName: 'Box_Link__c', type: 'url', initialWidth: 150 }
];

const cols3 = [
    { label: 'Partner Name', fieldName: 'Name', type: 'text', initialWidth: 130 },
    { label: 'Project(s) Partner Is Involved In', fieldName: 'Project_s_Partner_is_Involved_in__c', type: 'text', initialWidth: 240 },
    { label: 'Partner Since', fieldName: 'Partner_since__c', type: 'text', initialWidth: 120 },
    { label: 'Contact Or Working With Children', fieldName: 'Contact_or_Working_with_Children__c', type: 'text', initialWidth: 260 },
    { label: 'CS and PSEA In Partner Capacity Assessment', fieldName: 'CS_PSEA_in_Partner_Capacity_Assessment__c', type: 'text', initialWidth: 320 },
    { label: 'CS and PSEA In Partner Capacity Agreement', fieldName: 'CS_PSEA_in_Partner_Working_Agreement__c', type: 'text', initialWidth: 320 },
    { label: 'Partner Code Of Conduct Or Equivalent Signed', fieldName: 'PartnerCodeofConductorequivalentSigned__c', type: 'text', initialWidth: 330 },
    { label: 'CS And PSEA Policy In Place', fieldName: 'CS_and_PSEA_Policy_in_Place__c', type: 'text', initialWidth: 210 },
    { label: 'Date Of Last CS Training', fieldName: 'Date_of_the_last_CS_training__c', type: 'text', initialWidth: 200 },
    { label: 'Date Of The Last PSEA Training', fieldName: 'Date_of_the_last_PSEA_training__c', type: 'text', initialWidth: 230 }
];

const cols4 = [
    { label: 'Project Name', fieldName: 'Name', type: 'text', initialWidth: 130 },
    { label: 'Project Start Date', fieldName: 'Project_Start_Date__c', type: 'text', initialWidth: 150 },
    { label: 'Project End Date', fieldName: 'Project_End_Date__c', type: 'text', initialWidth: 145 },
    { label: 'What Level Of Contact With Children Do The Project Activities Involve?', fieldName: 'What_level_of_contact_with_children_do__c', type: 'text', initialWidth: 480 },
    { label: 'Is The Risk Assessment Completed', fieldName: 'Is_the_Risk_Assessment_completed__c', type: 'text', initialWidth: 260 },
    { label: 'Were The Partners Involved In Risk Assessment', fieldName: 'partners_involved_in_Risk_Asses__c', type: 'text', initialWidth: 330 },
    { label: 'What Was The Last Review/Update Of Risk Assessment', fieldName: 'When_was_the_last_review_update_of_Risk__c', type: 'text', initialWidth: 380 },
    { label: 'What progress has been made on Monitoring High Risk Activities in the Risk Assessment since the last report?', fieldName: 'Progress_On_Monitoring_High_Risk__c', type: 'text', initialWidth: 720 },
    { label: 'If No Risk Assessment Has Been Completed, Please Provide An Explanation', fieldName: 'If_No_Risk_Assessment_Explain__c', type: 'text', initialWidth: 500 }
];

const cols5 = [
    { label: 'Reference', fieldName: 'Name', type: 'text', initialWidth: 200,wrapText:true},
    { label: 'Date Of Training', fieldName: 'Date_Of_Training__c', type: 'date', initialWidth: 150,wrapText:true },
    { label: 'Training Description', fieldName: 'Description_Of_Training__c', type: 'text', initialWidth: 300,wrapText:true },
    { label: 'Who Delivered The Training?', fieldName: 'Who_Delivered_the_Training__c', type: 'text', initialWidth: 240,wrapText:true },
    { label: 'Did The Training Cover Safeguarding Policy?', fieldName: 'Safeguarding_Policy__c', type: 'text', initialWidth: 330,wrapText:true },
    { label: 'Did The Training Cover PSEA Policy?', fieldName: 'PSEA_Policy__c', type: 'text', initialWidth: 280,wrapText:true },
    { label: 'Did The Training Cover Code of Conduct?', fieldName: 'Code_of_Conduct__c', type: 'text', initialWidth: 300,wrapText:true },
    { label: 'Number Of Oxfam Staff', fieldName: 'Number_of_Oxfam_staff__c', type: 'text', initialWidth: 200,wrapText:true },
    { label: 'Number Of Partners', fieldName: 'Number_of_partners__c', type: 'text', initialWidth: 170,wrapText:true },
    { label: 'Number Of Community', fieldName: 'Number_of_community__c', type: 'text', initialWidth: 190,wrapText:true },
    { label: 'Total Trained', fieldName: 'Total_Trained_Staff__c', type: 'text', initialWidth: 120,wrapText:true },
    

];

const cols6 = [
    // { label: 'CS4 Interview Template', fieldName: 'CS4_Interview_Template__c', type: 'boolean', initialWidth: 170 },
    // { label: 'CS4 Reference Check Template', fieldName: 'CS4_Reference_Check_Template__c', type: 'boolean', initialWidth: 220 },
    // { label: 'CS5 Training Records', fieldName: 'CS5_Training_Records__c', type: 'boolean', initialWidth: 150 },
    // { label: 'CS6 Safeguarding Reporting Procedure', fieldName: 'CS6_Safeguarding_Reporting_Procedure__c', type: 'boolean', initialWidth: 260 },
    // { label: 'CS7 Examples of community level feedback', fieldName: 'CS7_Examples_of_community_level_feedback__c', type: 'boolean', initialWidth: 300 },
    // { label: 'CS8 Sample Partner Capacity Assessment', fieldName: 'CS8_Sample_Partner_Capacity_Assessment__c', type: 'boolean', initialWidth: 280 },
    // { label: 'CS8 Sample Partner Working Agreement', fieldName: 'CS8_Sample_Partner_Working_Agreement__c', type: 'boolean', initialWidth: 280 },
    { label: 'Achievements', fieldName: 'Summary_Achievements__c', type: 'text' },
    { label: 'Challanges', fieldName: 'Sumamry_Challanges__c', type: 'text'},
    { label: 'Support Needed?', fieldName: 'Summary_Support_Needed__c', type: 'text'},
];

const cols7 = [

    { label: 'File Name', fieldName: 'FileName', type: 'text' },
    { label: 'Related To', fieldName: 'relatedTo', type: 'text' },
    { label: 'Download', fieldName: 'url', type: 'url' }
];

const completedPersonColumns = [
    {label: 'Name', fieldName:'Name__c',type:'text'},
    {label: 'Role',fieldName:'Role__c',type:'text'},
    {label: 'Email',fieldName:'Email__c',type:'email'}
]
export default class PreviousSubmissionPage extends NavigationMixin(LightningElement) {
    error;
    @track approversDisplayList;
    @track approversDisplayList1;
    @track approversDisplayList2;
    @track approversDisplayList3;
    @track approversDisplayList4;
    @track approversDisplayList5;
    @track approversDisplayList6;
    @track approversDisplayList7;
    @track onlineSubmissionArray;
    tempData;
    tempData1;
    tempData2;
    @track columns = columns;
    @track cols = cols;
    @track cols1 = cols1;
    @track cols2 = cols2;
    @track cols3 = cols3;
    @track cols4 = cols4;
    @track cols5 = cols5;
    @track cols6 = cols6;
    @track cols7 = cols7;
    @track completedPersonColumns = completedPersonColumns;
    @track filesList = [];
    //entityName;
    submissionType;
    @track submissionName
    onlineSubmissionId;
    entityId;
    reportPeriodId;
    isLoading = false;
    displayTabs = false;
    @track isImplPlan = true
    displayHyperLink = false
    @track allQuestionAnswers
   

    connectedCallback(){
        this.allCoreStandards()
       
    }

    fetchValue(event) {
    this.displayTabs = false
    this.displayHyperLink = true
        this.submissionType = event.detail;
        if (this.submissionType == 'Implementation Plan') {
            this.isImplPlan = false;
    }else if(this.submissionType == '6 Months Progress Report' || this.submissionType == 'Annual Report'){
        this.isImplPlan = true;
    }

    if(this.submissionType !==null && this.entityId !== null && this.reportPeriodId !==null 
            && this.submissionType !==undefined && this.entityId !== undefined && this.reportPeriodId !==undefined){
                
        this.searchHandler(this.submissionType,this.entityId,this.reportPeriodId)
    }

    }
        fetchEntityValue(event) {
        this.displayTabs = false
        this.displayHyperLink = true
        this.entityId = event.detail.split(';')[1];
        
        if(this.submissionType !==null && this.entityId !== null && this.reportPeriodId !==null 
                && this.submissionType !==undefined && this.entityId !== undefined && this.reportPeriodId !==undefined){
                    
            
                
            this.searchHandler(this.submissionType,this.entityId,this.reportPeriodId)
        } 
    }
    fetchReportPeriod(event) {
        this.displayTabs = false
        this.displayHyperLink = true
        this.reportPeriodId = event.detail.split(';')[1];
        
        if(this.submissionType !==null && this.entityId !== null && this.reportPeriodId !==null 
                && this.submissionType !==undefined && this.entityId !== undefined && this.reportPeriodId !==undefined){
                    
            this.searchHandler()
        }
    }

    async handleAlert() {
        await LightningAlert.open({
            message: "Please try with different criteria!!",
            theme: "info",
            label: "Oops! No records to display"
        });
    }


    searchHandler() {
        this.isLoading = true;
        getOnlineSub({ subType: this.submissionType, entity: this.entityId, reportPeriod: this.reportPeriodId })
            .then(result => {
            this.onlineSubmissionArray = [result]
                this.onlineSubmissionId = result.Id
            this.submissionName = result.Name
            })
            .catch(error => {
                this.error = error
            this.displayTabs = false
            this.displayHyperLink = false
                this.handleAlert();
        })
    }

    handleSubmissionNameClick(){
        this.displayTabs = true
        this.getAllQa()
    }

    getTask() {
        getTaskList({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                let tempData = JSON.parse(JSON.stringify(result));
                tempData = tempData.map(row => {
                    return { ...row, 
                        CoreStandard: row.Core_Standard_Entity__r.Core_Standard__r.Name,
                        reportPeriodName : row.Reporting_Period__r.Name}
                })
                this.approversDisplayList = tempData
            })
            .catch(error => {
                this.error = error
            })
    }

    getSafePoints() {
        getFocalList({ onlineSubId: this.onlineSubmissionId })
            .then(result1 => {
                this.approversDisplayList1 = result1
            })
            .catch(error => {
                this.error = error;
            });
    }

    getInfProv() {
        getInfoList({ onlineSubId: this.onlineSubmissionId })
            .then(result2 => {
                this.approversDisplayList2 = result2
            })
            .catch(error => {
                this.error = error;
            });
    }

    getQnA(event) {
        let coreStdName = event.target.value
        getQAList({ onlineSubId: this.onlineSubmissionId, coreStdName: coreStdName })
            .then(result3 => {
                let tempData1 = JSON.parse(JSON.stringify(result3))
                tempData1 = tempData1.map(row1 => {
                    return { ...row1, QuestionNumber: row1.Question__r.Question_Number__c, Question: row1.Question__r.Question__c, CoreStandardNumber: row1.Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c, coreStandardName: row1.Core_Standard_Entity__r.Core_Standard__r.Name }
                })
                this.approversDisplayList3 = tempData1
            })
            .catch(error => {
                this.error = error;
            });
    }

    getTrainEvd() {
        getTrainingList({ onlineSubId: this.onlineSubmissionId })
            .then(result6 => {
                this.formatTrainingData(result6);
            })
            .catch(error => {
                this.error = error
            })
    }

    formatTrainingData(result) {
        this.approversDisplayList6 = result.map(item => {
            const { Box_Links__r, ...trainings } = item;
            return { ...trainings, "_children": Box_Links__r }
        })
    }

    getPartEvd() {
        getPartnerList({ onlineSubId: this.onlineSubmissionId })
            .then(result4 => {
                this.approversDisplayList4 = result4
            })
            .catch(error => {
                this.error = error
            })
    }

    getProjEvd() {
        getProjectList({ onlineSubId: this.onlineSubmissionId })
            .then(result5 => {
                this.approversDisplayList5 = result5
            })
            .catch(error => {
                this.error = error
            })
    }

    getSum() {
        getSummaryList({ onlineSubId: this.onlineSubmissionId })
            .then(result7 => {
                this.approversDisplayList7 = result7
            })
            .catch(error => {
                this.error = error
            })
    }

    getAttachment() {
        try{
            this.template.querySelector('c-all-evidences').callingSource('previousSubmissionPage');
            //this.evidenceData = this.template.querySelector('c-all-evidences').getAllEvidences()
        }catch(error){
            console.log('error on parent'+error)
        }
        
    }

    allCoreStandards(){
        getCoreStandard().then(result=>{
            this.dynamicCoreStandards = result
            let tempData = this.dynamicCoreStandards.map((coreStd) => {
                return {
                  label: coreStd.Name.split(' ')[0],
                  value: coreStd.Name
                }
              })
              this.coreStandards = tempData
        }).catch(error=>{
            console.log(error)
        })
    }

    //Sorting logic starts here
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        
        let parseData = JSON.parse(JSON.stringify(this.approversDisplayList));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.approversDisplayList = parseData;
    }

    PDFGeneratorHandler() {

        //Navigate to visualforce page
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/PreviousSubmissionPDFPage?id=' + this.onlineSubmissionId
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }

    
    // headers for generating csv
    TaskHeaders = {
        Name: "Task Ref",
        reportPeriodName: "Reporting Period",
        CoreStandard: "Core Standard",
        Key_Task__c: "Key Task",
        Due_Date__c: "Due Date",
        Person_Responsible_For_The_Activity__c: "Person Responsible",
        Status__c: "Status",
        Completion_Date__c: "Completion Date",
        Comments__c: "Comments"
    }

    FocalHeaders = {
        Name: 'Name',
        Office_Sub_Office__c: 'Office/Sub Office Name'
    }

    InformationHeaders = {
        Name: 'Name',
        Role__c: 'Role',
        Type_Of_Information__c: 'Type Of Information',
    }
    

    getAllQa(){
        getAllQuestionAnswers({ onlineSubId: this.onlineSubmissionId}).then(result=>{
            let tempData1 = JSON.parse(JSON.stringify(result))
                tempData1 = tempData1.map(row1 => {
                    return { ...row1, QuestionNumber: row1.Question__r.Question_Number__c,
                                     Question: row1.Question__r.Question__c, 
                                     CoreStandardNumber: row1.Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c, 
                                     coreStandardName: row1.Core_Standard_Entity__r.Core_Standard__r.Name }
                })
            this.allQuestionAnswers = tempData1
        })
    }


    QuestionAndAnswersHeaders = {
        coreStandardName: 'Core Standard Name',
        QuestionNumber: 'Question Number',
        Question: 'Question',
        Answer__c: 'Yes/No Answer',
        Descriptive_Answer__c: 'Descriptive Answer',
    }


    TrainingHeaders = {
        Name: 'Reference',
        Date_Of_Training__c : 'Date Of Training',
        Description_Of_Training__c: 'Training Description',
        Who_Delivered_the_Training__c: 'Who Delivered The Training?',
        Safeguarding_Policy__c: 'Did The Training Cover Safeguarding Policy?',
        PSEA_Policy__c: 'Did The Training Cover PSEA Policy?',
        Code_of_Conduct__c: 'Did The Training Cover Code of Conduct?',
        Number_of_Oxfam_staff__c: 'Number Of Oxfam Staff',
        Number_of_partners__c: 'Number Of Partners',
        Number_of_community__c: 'Number Of Community',
        Total_Trained_Staff__c: 'Total Trained',
    }
    
    PartnerHeaders = {
        Name: 'Partner Name',
        Project_s_Partner_is_Involved_in__c: 'Project(s) Partner is Involved in',
        Partner_since__c: 'Partner since',
        Contact_or_Working_with_Children__c: 'Contact Or Working With Children',
        CS_PSEA_in_Partner_Capacity_Assessment__c: 'CS and PSEA in Partner Capacity Assessment',
        CS_PSEA_in_Partner_Working_Agreement__c: 'CS and PSEA in Partner Capacity Agreement',
        PartnerCodeofConductorequivalentSigned__c: 'partner code of conduct or equivalent signed',
        CS_and_PSEA_Policy_in_Place__c: 'CS and PSEA Policy In Place',
        Date_of_the_last_CS_training__c: 'Date of Last CS Training',
        Date_of_the_last_PSEA_training__c: 'Date of the last PSEA training',
    }

    ProjectHeaders = {
        Name: 'Project Name',
        Project_Start_Date__c: 'Project start date',
        Project_End_Date__c: 'Project End Date',
        What_level_of_contact_with_children_do__c: 'What Level Of Contact With Children Do The Project Activities Involve',
        Is_the_Risk_Assessment_completed__c: 'Is the Risk Assessment completed',
        partners_involved_in_Risk_Asses__c: 'Were The Partners Involved In Risk Assessment',
        When_was_the_last_review_update_of_Risk__c: 'What Was The Last Review/Update Of Risk Assessment',
        Progress_On_Monitoring_High_Risk__c: 'What progress has been made on monitoring High Risk Activities in the Risk Assessment since the last report?',
        If_No_Risk_Assessment_Explain__c: 'If no Risk Assessment has been completed please provide an explanation'
    }

    SummaryHeaders = {
        Summary_Achievements__c: 'Achievements',
        Sumamry_Challanges__c: 'Challanges',
        Summary_Support_Needed__c: 'Support Needed?',
    }

    AttachmentHeaders = {
        FileName: 'File Name',
        relatedTo: 'Related To',
        url: 'Download'
    }

    // csv Handlers
    handleTasksGenerator() {
        exportCSVFile(this.TaskHeaders, this.approversDisplayList, "Tasks - " +this.submissionName)
    }

    handleFocalGenerator() {
        exportCSVFile(this.FocalHeaders, this.approversDisplayList1, "SafeGuading Focal Points - "+this.submissionName)
    }

    handleInformationGenerator() {
        exportCSVFile(this.InformationHeaders, this.approversDisplayList2, "Information Providers - "+this.submissionName)
    }

    handleQnAGenerator() {
        exportCSVFile(this.QuestionAndAnswersHeaders, this.allQuestionAnswers, "Question And Answers - "+this.submissionName)
    }

    handleTrainingGenerator() {
        exportCSVFile(this.TrainingHeaders, this.approversDisplayList6, "Safeguarding Training Table(CS5) - "+this.submissionName)
    }

    handlePartnerGenerator() {
        exportCSVFile(this.PartnerHeaders, this.approversDisplayList4, "Partner Table(CS8) - "+this.submissionName)
    }


    handleProjectGenerator() {
        exportCSVFile(this.ProjectHeaders, this.approversDisplayList5, "Project Risk Assessments Table(CS9) - "+this.submissionName)
    }

    handleSummaryGenerator() {
        exportCSVFile(this.SummaryHeaders, this.approversDisplayList7, "Summary - "+this.submissionName)
    }

    handleAttachmentGenerator() {
        exportCSVFile(this.AttachmentHeaders, this.filesList, "Attachments - "+this.submissionName)
    }
}