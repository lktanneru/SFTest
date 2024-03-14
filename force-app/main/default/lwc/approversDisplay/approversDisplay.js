import { LightningElement, wire, track,api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import displayListQA from '@salesforce/apex/SubmissionCls.displayListQA';
import getTaskList from '@salesforce/apex/TaskController.getConsolidatedTask';
import displayFocal from '@salesforce/apex/SubmissionCls.displayFocal';
import displayInfoProv from '@salesforce/apex/SubmissionCls.displayInfoProv';
import getTrainingList from '@salesforce/apex/SubmissionCls.getTrainingList';
import getPartnerList from '@salesforce/apex/SubmissionCls.getPartnerList';
import getProjectList from '@salesforce/apex/SubmissionCls.getProjectList';
import getSummaryList from '@salesforce/apex/SubmissionCls.getSummaryList';
import getAttachmentList from '@salesforce/apex/SubmissionCls.getAttachmentList';
import getCoreStandard from '@salesforce/apex/SubmissionCls.getCoreStandard';
import getSubmissionType from '@salesforce/apex/SubmissionCls.getSubmissionType';
import { NavigationMixin } from 'lightning/navigation';
import submissionIdFromName from '@salesforce/apex/FetchDataForBoxlinkAndAttachent.submissionIdFromName'
import { IsConsoleNavigation, getFocusedTabInfo, refreshTab } from 'lightning/platformWorkspaceApi';

const columns = [
    { label: 'Question', fieldName: 'Question', sortable: true, type: 'text',wrapText: true },
    { label: 'Answer (Minimum Standards)', fieldName: 'Answer__c', type: 'text',wrapText: true },
    { label: 'Answer (Explanation & Good Practice)', fieldName: 'Descriptive_Answer__c', type: 'text',wrapText: true},
];

const cols = [
    { label: 'Task Reference', fieldName: 'Name', type: 'text', sortable: true },
    { label: 'Core Standard', fieldName: 'CoreStandard', type: 'text', sortable: true },
    { label: 'Key Task', fieldName: 'Key_Task__c', type: 'text' },
    { label: 'Person Responsible', fieldName: 'Person_Responsible_For_The_Activity__c', sortable: true, type: 'text' },
    { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date-local', sortable: true },
    { label: 'Status', fieldName: 'Status__c', type: 'text', sortable: true },
    { label: 'Comments', fieldName: 'Comments__c', type: 'textarea',wrapText: true},
    { label: 'Completion Date', fieldName: 'Completion_Date__c', type: 'date-local', sortable: true },
];

const cols2 = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Office/Sub Office', fieldName: 'Office_Sub_Office__c', type: 'text' }
];

const cols3 = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Role', fieldName: 'Role__c', type: 'text' },
    { label: 'Type Of Info', fieldName: 'Type_Of_Information__c', type: 'text' }
]

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
    { label: 'Reference', fieldName: 'Name', type: 'text', initialWidth: 150,wrapText: true,hideDefaultActions: true },
    { label: 'Date Of Training', fieldName: 'Date_Of_Training__c', type: 'date', initialWidth: 150,hideDefaultActions: true },
    { label: 'Training Description', fieldName: 'Description_Of_Training__c', type: 'text', initialWidth: 180,wrapText:true,hideDefaultActions: true },
    { label: 'Who Delivered The Training?', fieldName: 'Who_Delivered_the_Training__c', type: 'text', initialWidth: 240,wrapText:true,hideDefaultActions: true },
    { label: 'Did The Training Cover Safeguarding Policy?', fieldName: 'Safeguarding_Policy__c', type: 'text', initialWidth: 330,hideDefaultActions: true },
    { label: 'Did The Training Cover PSEA Policy?', fieldName: 'PSEA_Policy__c', type: 'text', initialWidth: 280,hideDefaultActions: true },
    { label: 'Did The Training Cover Code of Conduct?', fieldName: 'Code_of_Conduct__c', type: 'text', initialWidth: 300,hideDefaultActions: true },
    { label: 'Number Of Oxfam Staff', fieldName: 'Number_of_Oxfam_staff__c', type: 'text', initialWidth: 200,hideDefaultActions: true },
    { label: 'Number Of Partners', fieldName: 'Number_of_partners__c', type: 'text', initialWidth: 170 ,hideDefaultActions: true},
    { label: 'Number Of Community', fieldName: 'Number_of_community__c', type: 'text', initialWidth: 190 ,hideDefaultActions: true},
    { label: 'Total Trained', fieldName: 'Total_Trained_Staff__c', type: 'text', initialWidth: 120,hideDefaultActions: true},
    
];

const cols6 = [
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

const cols7 = [
    { label: 'Achievements', fieldName: 'Summary_Achievements__c', type: 'text',wrapText: true},
    { label: 'Challanges', fieldName: 'Sumamry_Challanges__c', type: 'text',wrapText: true },
    { label: 'Support Needed?', fieldName: 'Summary_Support_Needed__c', type: 'text',wrapText: true},
];

const cols8 = [

    { label: 'File Name', fieldName: 'FileName', type: 'text'},
    { label: 'Related To', fieldName: 'relatedTo', type: 'text' },
    { label: 'Download', fieldName: 'url', type: 'url' }
];

export default class ApproversDisplay extends NavigationMixin(LightningElement) {
    @wire(IsConsoleNavigation) isConsoleNavigation;
    // activeSections = ['Display', 'Tasks', 'SafeguardingFocalPoint', 'InformationProviders', 'QuestionsAnswers',
    //     'TrainingTable', 'PartnerTable', 'ProjectTable', 'Summary', 'Evidence']
    error;
    @track approversDisplayList;
    @track approversDisplayList1;
    @track approversDisplayList2;
    @track approversDisplayList3;
    @track approversDisplayList4;
    @track approversDisplayList5;
    @track approversDisplayList6;
    @track approversDisplayList7;
    @track submissionType;
    @track SubmissionName;
    tempData;
    tempData1;
    tempData2;
    @track isImplPlan = true;
    @api recordId;
    @track columns = columns;
    @track cols = cols;
    @track cols2 = cols2;
    @track cols3 = cols3;
    @track cols4 = cols4;
    @track cols5 = cols5;
    @track cols6 = cols6;
    @track cols7 = cols7;
    @track cols8 = cols8;
    @track filesList = [];
    @track sortBy;
    @track sortDirection;
    @track fieldname;
    @track dynamicCoreStandards =[]
    @track coreStandards = [];
    @track isLoading= false;


   
    connectedCallback(){
            
             setTimeout(() => {
            this.getSubmissionRecordId();
        }, 5);
        
           
    }

    initMethod(){
       
    }

    getSubmissionRecordId(){
       //  alert(this.recordId);
        console.log('method called  '+document.title)
        submissionIdFromName({recordId: this.recordId})
        .then(result=>{
            this.submissionId  = result.Id;
            console.log('this is id  '+this.submissionId)
            this.submissionType = result.Submission_Type__c
                    this.SubmissionName = result.Name
                    if (this.submissionType == 'Implementation Plan') {
                    this.isImplPlan = false;
                    }
            
            this.allCoreStandards()
        })
        .catch(error=>{
            console.log('error is '+error)
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

    

    refreshComponent(){
        if (this.isConsoleNavigation) {
            getFocusedTabInfo().then((tabInfo) => {
                refreshTab(tabInfo.tabId,true);
            }).catch((error) => {
                console.log(error);
            });
        }
    }

    getFocalPoint() {
        
       
        displayFocal({ os_name:  this.submissionId })
            .then(result2 => {
                this.approversDisplayList2 = result2
            })
            .catch(error => {
                this.error = error;
            });
        this.refreshComponent()
    }

    getInfoProv() {
        

        displayInfoProv({ os_name:  this.submissionId })
            .then(result3 => {
                this.approversDisplayList3 = result3
            })
            .catch(error => {
                this.error = error;
            });
        this.refreshComponent()
    }
    getQnA(event) {
        this.isLoading =true
       
        let coreStdName = event.target.value;
        console.log('os is   '+ this.submissionId+'and cs name is   '+coreStdName)
        displayListQA({ os_name:  this.submissionId, coreStdName: coreStdName })
            .then(result1 => {
                this.isLoading=false
                console.log(JSON.stringify(result1))
                let tempData1 = JSON.parse(JSON.stringify(result1))
                tempData1 = tempData1.map(row1 => {
                    return { ...row1, QuestionNumber: row1.Question__r.Question_Number__c, Question: row1.Question__r.Question__c, CoreStandardNumber: row1.Core_Standard_Entity__r.Core_Standard__r.Core_Standard_Number__c, coreStandardName: row1.Core_Standard_Entity__r.Core_Standard__r.Name }
                })
                this.approversDisplayList1 = tempData1
            })
            .catch(error => {
                this.isLoading=false
                this.error = error;
            });
        this.refreshComponent()
    }

    getTask() {

       

        getTaskList({ os_name:  this.submissionId })
            .then(result => {
                let tempData2 = JSON.parse(JSON.stringify(result));
                tempData2 = tempData2.map(row => {
                    return { ...row, ReportingPeriod: row.Reporting_Period__r.Name, CoreStandard: row.Core_Standard_Entity__r.Core_Standard__r.Name };
                })
                this.approversDisplayList = tempData2
                
            })
            .catch(error => {
                this.error = error;
            });
        this.refreshComponent()
    }

    getTraining() {
        

        getTrainingList({ os_name:  this.submissionId })
            .then(result4 => {
                console.log('training list    '+ JSON.stringify(result4))
                this.formatTrainingData(result4)
            })
            .catch(error => {
                this.error = error
            })
        this.refreshComponent()
    }

    formatTrainingData(result) {
        this.approversDisplayList4 = result.map(item => {
            const { Box_Links__r, ...trainings } = item;
            return { ...trainings, "_children": Box_Links__r }
        })
    }

    getPartner() {
       

        getPartnerList({ os_name:  this.submissionId })
            .then(result5 => {
                this.approversDisplayList5 = result5
            })
            .catch(error => {
                this.error = error
            })
        this.refreshComponent()
    }

    getProject() {
       
        getProjectList({ os_name:  this.submissionId })
            .then(result6 => {
                this.approversDisplayList6 = result6
            })
            .catch(error => {
                this.error = error
            })
        this.refreshComponent()
    }

    getSummary() {
       
        getSummaryList({ os_name:  this.submissionId })
            .then(result7 => {
                this.approversDisplayList7 = result7
            })
        this.refreshComponent()
    }

    getAttachment() {
        this.template.querySelector('c-all-evidences').getAllEvidences()
        this.refreshComponent()
    }
}