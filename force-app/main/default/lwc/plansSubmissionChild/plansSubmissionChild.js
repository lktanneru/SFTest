import { LightningElement, wire, track, api } from 'lwc';

//import the custom Labels from SF org
import Title from '@salesforce/label/c.PlansAndReportTitle';
import Image from '@salesforce/label/c.PlansAndReportImage';
import getTask from '@salesforce/apex/TaskController.getTaskList';
import saveTask from '@salesforce/apex/TaskController.creatTask';
import deleteTask from '@salesforce/apex/TaskController.deleteTask';
import updateTask from '@salesforce/apex/TaskController.updateTask';
import saveTraining from '@salesforce/apex/TaskController.createTraining';
import savePartner from '@salesforce/apex/TaskController.createPartner';
import saveProject from '@salesforce/apex/TaskController.createProject';
import getQuestions from '@salesforce/apex/countryPageCls.getQuestions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getTraining from '@salesforce/apex/TaskController.getTraining';
import getPartner from '@salesforce/apex/TaskController.getPartner';
import getProject from '@salesforce/apex/TaskController.getProject';
import { deleteRecord } from 'lightning/uiRecordApi';
import saveAnswerRecord from '@salesforce/apex/countryPageCls.createAnswerRecord';
import saveBoxLinks from '@salesforce/apex/countryPageCls.saveBoxLinks';
import saveTrainingLinks from '@salesforce/apex/countryPageCls.saveTrainingLinks';
import getBoxLinks from '@salesforce/apex/countryPageCls.getBoxLinks';
import getTrainingLinks from '@salesforce/apex/countryPageCls.getTrainingLinks';
import coreStandardEntityRecord from '@salesforce/apex/countryPageCls.coreStandardEntityRecord';
import getAnswer from '@salesforce/apex/countryPageCls.getAnswer';
import getCoreStandardGuidence from '@salesforce/apex/SubmissionCls.getCoreStandardGuidence';
import LightningConfirm from "lightning/confirm";
import pubsub from 'c/pubSub';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';
import deleteTraining from '@salesforce/apex/SubmissionCls.deleteTraining'
import deletePartner from '@salesforce/apex/SubmissionCls.deletePartner'
import deleteProject from '@salesforce/apex/SubmissionCls.deleteProject'

export default class PlansSubmissionChild extends NavigationMixin(LightningElement) {

    labelList = {
        Title,
        Image
    };

    //activeSections = ['Guidance', 'MinStdEvidence', 'ExplanationGoodPract', 'ProgressBar'];
    section = '';
    activeValueMessage = '';
    Questions;
    @track coresStdValue;
    @track questionCategory;
    @track l_All_Types;
    @track tabs;
    @track questiontype;
    @track selectedValue;
    @track progressBarValue = 0;
    QuestionMin;
    retrivedanswers = [];
    @track QuestionMinMap = {};
    @track submissionType;
    entityId;
    @api selectedtabname;
    @api selectedtabvalue;
    @api implementflag;
    @api mancorestd;
    @api retrivedanswer;
    @api submissionid;
    @api reportperiodid;
    @api entityname;
    @api taskreclist1;
    @api traininglist1;
    @api partnerlist1;
    @api projectlist1;
    @api corestdval;
    counter = 0;
    @track coreStandardList;
    @api recordId;
    @track uploadedFileNames = [];
    @track filesUploaded = [];
    @track optionSelected;
    partnerIndex = 0;
    @track showUploadedFilesSection = false
    value = '';
    delTrainingRec
    @track boxLink
    @track ansRecord;
    @track updans;
    @track trainRec;
    @track ans = []
    @track taskId;
    @track tskList;
    @track showComponents = false
    @track isBoxFieldDisabled = true
    @track isLoading = false
    openTrainingBoxLink;
    @track listOfTrainingBoxLinks = [];
    showLinkAddButton = false;
    @api taskbackuplist = []
    trainingId;
    trainingType;
    //submissionId;
    openLinkPopUp = false;
    selectedQuestionId;
    selectedAnswerId;
    isUnsavedTasksExists = false
    isUnsavedAnswerExists = false
    isUnsavedPartnerExists = false
    isUnsavedTrainingExists = false
    isUnsavedProjectExists = false

    // @track RadioOption = [{ label: "Yes", value: "Yes" }, { label: "No", value: "No" }];
    @track taskOptions = [
        { label: "Completed", value: "Completed" },
        { label: "In-Progress", value: "In-Progress" },
        { label: "Not Applicable Anymore", value: "Not Applicable Anymore" },
        { label: "Not Started", value: "Not Started" }];

    @track partnerOptions = [
        { label: "Contact with Children", value: "Contact with Children" },
        { label: "Working with Children", value: "Working with Children" }
    ];

    @wire(CurrentPageReference)
    pageRef;

    get RadioOption() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }

    // delete Trining row
    async delTraining(event) {
        let index = event.target.dataset.id;
        const delTrainingResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this row?",
            theme: "success",
            label: "Delete Confirmation"
        });
        
        if (delTrainingResult) {
            this.delTrainingRec = {
                Id: this.trainingList[index].Id
            };
           
            if(this.delTrainingRec.Id){
                deleteTraining({ delTrainingRec: this.delTrainingRec })
                .then(result => {
                    if (result == 'success') {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Deleted',
                                variant: 'success',
                            }),
                        );
                        this.trainingList.splice(index, 1);
                        this.handletraining();
                    }
                })
                .catch(error => {
                    this.error = error;
                    alert('Record not deleted')
                });
            }else{
                this.trainingList.splice(index, 1);
            }
            
        }
    }

    // //delete partner row
    delPartnerRec
    async delPartner(event) {
        let index = event.target.dataset.id;
        const delPartnerResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this row?",
            theme: "success",
            label: "Delete Confirmation"
        });
       
            if (delPartnerResult && this.partnerList[index]) {
                this.delPartnerRec = {
                    Id: this.partnerList[index].Id
                };
                if(this.delPartnerRec.Id){
                    deletePartner({ delPartnerRec: this.delPartnerRec })
                    .then(result => {
                        if (result == 'success') {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Deleted',
                                    variant: 'success',
                                }),
                            );
                            this.partnerList.splice(index, 1);
                            this.handlePartner();
                        }
                    })
                    .catch(error => {
                        this.error = error;
                        alert('Record not deleted')
                    });
                }else {
                    this.partnerList.splice(index, 1);
                }
                
            }
    }

    // delete project row
    delProjectRec
    async delProject(event) {
        let index = event.target.dataset.id;
        const delProjectResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this row?",
            theme: "success",
            label: "Delete Confirmation"
        });
        if (delProjectResult) {
            this.delProjectRec = {
                Id: this.projectList[index].Id
            };
            if(this.delProjectRec.Id){
                deleteProject({ delProjectRec: this.delProjectRec })
                .then(result => {
                    if (result == 'success') {

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Deleted',
                                variant: 'success',
                            }),
                        );
                        this.projectList.splice(index, 1);
                        this.handleProject();
                    }
                })
                .catch(error => {
                    this.error = error;
                    alert('Record not deleted')
                });
            }else{
                this.projectList.splice(index, 1);
            }
            
        }
    }

    delTaskRec
    async deleteTasks(event) {
        let index = event.target.dataset.id;
        const delTaskResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this row?",
            theme: "success",
            label: "Delete Confirmation"
        });
        let tsklist= JSON.parse(JSON.stringify(this.taskRecList));
        if (delTaskResult) {
                this.delTaskRec = {
                    Id: tsklist[index].Id
                };
               
                if(tsklist.Id){

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Saved Task',
                            message: 'Saved task cannot be deleted.',
                            variant: 'error',
                        }),
                    )
                }else {
                    tsklist.splice(index, 1);
                    this.taskRecList = tsklist
                    this.isUnsavedTasksExists = false

                    const e = new CustomEvent('taskrecaddiion',{
                        detail : { value:  tsklist  
                                }                      
                    }); 
                    this.dispatchEvent(e) 

                    const TaskEvent = new CustomEvent('unsavedtaskchange',{
                    detail : { value: this.isUnsavedTasksExists,
                               corestd : this.selectedtabname
                            }
                    }); 
                    this.dispatchEvent(TaskEvent)
                }
                
            }
    }

    @track taskRecList3 = [
        {
            Id: '',
            key: 0,
            Name: '',
            Due_Date__c: '',
            Status__c: '',
            Reporting_Period__c: '',
            Person_Responsible_For_The_Activity__c: '',
            Online_Submission__c: '',
            Key_Task__c: '',
            Core_Standard_Entity__c: '',
            Completion_Date__c: '',
            Comments__c: '',
            coreStandard: '',
            coreStandardId: ''

        }
    ];

    handleEvent(taskListVal) {
        this.taskRecList = taskListVal;
    }

    @track taskRecList2 = [
        {
            Id: '',
            key: 0,
            Name: '',
            Due_Date__c: '',
            Status__c: '',
            Reporting_Period__c: '',
            Person_Responsible_For_The_Activity__c: '',
            Online_Submission__c: '',
            Key_Task__c: '',
            Core_Standard_Entity__c: '',
            Completion_Date__c: '',
            Comments__c: '',
            coreStandard: '',
            coreStandardId: ''

        }
    ];

    
    connectedCallback(){
        this.notifyChangeToChild()
    }
    @api
    notifyChangeToChild() {
       
        this.trainingList1 = [];
        this.partnerList1 = [];
        this.projectList1 = [];
        
        pubsub.register('fireTaskInfoEvent', this.handleEvent.bind(this));
        getAnswer({ onlineSubId: this.submissionid })
            .then(result => {
                this.retrivedanswers = result;

            })
            .then(() => {
                this.progressBarValue = 0
                this.handleMinimumStdEvid1();
                this.handleMinimumStdEvid2();
            })
            .catch(error => {
                this.error = error;
            });

        coreStandardEntityRecord({ entityName: this.entityname, corestdName: this.selectedtabname, reportid: this.reportperiodid })
            .then(result => {
                refreshApex(result);
                this.corestdentityid = result.Id;
            })
            .catch(error => {
                this.corestdentityid = undefined;
            });


        getCoreStandardGuidence({ coresStd: this.selectedtabname })
            .then(result => {
                this.coreStandardList = result;
            })
            .catch(error => {
                console.log('Error displaying core standard values');
            });


        setTimeout(function () {
            if (this.corestdentityid != null) {
                this.getTaskInfo();
            }
            if (this.submissionid != null) {
                this.handletraining();
                this.handlePartner();
                this.handleProject();
            }
        }.bind(this), 3000);
        this.getTaskInfo()
    }//connected call back ends here 


    taskRecList1 = [
        {
            Id: '',
            key: 0,
            Name: '',
            Due_Date__c: '',
            Status__c: '',
            Reporting_Period__c: '',
            Person_Responsible_For_The_Activity__c: '',
            Online_Submission__c: '',
            Key_Task__c: '',
            Core_Standard_Entity__c: '',
            Completion_Date__c: '',
            Comments__c: '',
            coreStandard: '',
            coreStandardId: ''
        }
    ];


    
    getTaskInfo() {

        getTask({ onlineSubId: this.submissionid, corestdid: this.corestdentityid })
            .then(result => {
                if (result.length > 0) {
                    this.taskRecList1.pop();
                    for (var key in result) {
                        this.safeTaskIndex++;
                        this.taskRecList1.push({
                            Id: result[key].Id, key: key, Due_Date__c: result[key].Due_Date__c, Status__c: result[key].Status__c,
                            Person_Responsible_For_The_Activity__c: result[key].Person_Responsible_For_The_Activity__c, Completion_Date__c: result[key].Completion_Date__c,
                            Comments__c: result[key].Comments__c, Key_Task__c: result[key].Key_Task__c, coreStandard: result[key].Core_Standard_Entity__c,
                            coreStandardId: result[key].Core_Standard_Entity__r.Core_Standard__c
                        });
                    }
                    this.taskRecList = this.taskRecList1;
                    
                    if(this.taskbackuplist){
                        if(this.taskbackuplist.length >0){

                            this.taskRecList = this.taskbackuplist
                        }
                    }
                }

            })
            .catch(error => {
                this.error = error;
            });
    }

    passToParent(event) {

        this.uploadedFileNames.push({ Title: event.detail.filenameValue, Type: event.detail.fileTypeValue });
    }

    @track items = [
        { key: 0 }
    ];
    addNote() {
        this.items = [...this.items, { key: this.items.length }];
    }
    delNote(event) {
        this.items.splice(event.target.dataset.id, 1);
    }

    safeTaskIndex = 0;
    @track taskRecList = []
    //     {
    //         Id: '',
    //         key: 0,
    //         Name: '',
    //         Due_Date__c: '',
    //         Status__c: '',
    //         Reporting_Period__c: '',
    //         Person_Responsible_For_The_Activity__c: '',
    //         Online_Submission__c: '',
    //         Key_Task__c: '',
    //         Core_Standard_Entity__c: '',
    //         Completion_Date__c: '',
    //         Comments__c: '',
    //         coreStandard: '',
    //         coreStandardId: ''

    //     }
    // ];
    @track trainingList = [
        {
            Id: '',
            key: 0,
            radioKey0: '',
            radioKey1: '',
            radioKey2: '',
            Name: '',
            Attendance_Sheet__c: '',
            Code_of_Conduct__c: '',
            Date_Of_Training__c: '',
            Description_Of_Training__c: '',
            Number_of_community__c: '',
            Number_of_Oxfam_staff__c: '',
            Number_of_partners__c: '',
            PSEA_Policy__c: '',
            Question__c: '',
            Safeguarding_Policy__c: '',
            Total_Trained_Staff__c: '',
            Who_Delivered_the_Training__c: '',
            Other_evidence__c: '',
            Training_materials__c: ''

        }
    ];
    @track partnerList = [
        {
            Id: '',
            key: 0,
            Name: '',
            radioKey0: '',
            radioKey1: '',
            radioKey2: '',
            radioKey3: '',
            Project_s_Partner_is_Involved_in__c: '',
            Partner_since__c: '',
            Contact_or_Working_with_Children__c: '',
            CS_PSEA_in_Partner_Capacity_Assessment__c: '',
            CS_PSEA_in_Partner_Working_Agreement__c: '',
            PartnerCodeofConductorequivalentSigned__c: '',
            CS_and_PSEA_Policy_in_Place__c: '',
            Date_of_the_last_CS_training__c: '',
            Date_of_the_last_PSEA_training__c: ''
        }
    ];
    @track projectList = [
        {
            Id: '',
            key: 0,
            Name: '',
            radioKey0: '',
            radioKey1: '',
            Project_Start_Date__c: '',
            Project_End_Date__c: '',
            What_level_of_contact_with_children_do__c: '',
            Is_the_Risk_Assessment_completed__c: '',
            partners_involved_in_Risk_Asses__c: '',
            When_was_the_last_review_update_of_Risk__c: '',
            Progress_On_Monitoring_High_Risk__c: '',
            If_No_Risk_Assessment_Explain__c: '',
        }
    ];

    handleaddRow(event) {
        this.taskRecList.push({ key: this.taskRecList.length,Key_Task__c:"",Due_Date__c:undefined,Completion_Date__c:undefined,Person_Responsible_For_The_Activity__c:"",Comments__c:"" });
        const e = new CustomEvent('taskrecaddiion',{
            detail : { value:  this.taskRecList  
                    }
                    
                                 
        });  this.dispatchEvent(e)  

    }

    delTask(event) {
        this.taskRecList.splice(event.target.dataset.id, 1);
        this.taskreclist1.splice(event.target.dataset.id, 1);
    }
    // to save the Task record


    
    handleonsave() {
        

        if (this.corestdentityid == undefined) {

            alert('Core Standard Entity is not available. Please contact System Admin');

        } else {

            this.taskRecList.forEach(safe => {
                if (safe.Id != null && safe.Id != '') {
                    if (!this.implementflag) {

                        this.tskList = {
                            Id: safe.Id = safe.Id,
                            Core_Standard_Entity__c: this.corestdentityid,
                            Online_Submission__c: this.submissionid,
                            Reporting_Period__c: this.reportperiodid,
                            Key_Task__c: safe.Key_Task__c,
                            Due_Date__c: safe.Due_Date__c,
                            Completion_Date__c: safe.Completion_Date__c,
                            Person_Responsible_For_The_Activity__c: safe.Person_Responsible_For_The_Activity__c,
                            Comments__c: safe.Comments__c,
                            Status__c: safe.Status__c
                        };
                        this.updateTaskInfo();

                    }
                    else {

                        this.tskList = {
                            Id: safe.Id != '' ? safe.Id : null,
                            Core_Standard_Entity__c: this.corestdentityid,
                            Online_Submission__c: this.submissionid,
                            Reporting_Period__c: this.reportperiodid,
                            Key_Task__c: safe.Key_Task__c,
                            Comments__c: safe.Comments__c,
                            Due_Date__c: safe.Due_Date__c,
                            Completion_Date__c: safe.Completion_Date__c,
                            Person_Responsible_For_The_Activity__c: safe.Person_Responsible_For_The_Activity__c,
                            Status__c: safe.Status__c
                        };
                        this.updateTaskInfo();
                    }

                } else {

                    this.tskList = {
                        //Id: safe.Id='';
                        Core_Standard_Entity__c: this.corestdentityid,
                        Online_Submission__c: this.submissionid,
                        Reporting_Period__c: this.reportperiodid,
                        Key_Task__c: safe.Key_Task__c,
                        Due_Date__c: safe.Due_Date__c,
                        Completion_Date__c: safe.Completion_Date__c,
                        Person_Responsible_For_The_Activity__c: safe.Person_Responsible_For_The_Activity__c,
                        Comments__c: safe.Comments__c,
                        Status__c: safe.Status__c
                    };

                    this.saveTaskInfo();

                }

            });
        }

    }

    saveTaskInfo() {
        saveTask({ taskList: this.tskList })
            .then(result => {
                this.isUnsavedTasksExists = false
                const TaskEvent = new CustomEvent('unsavedtaskchange',{
                    detail : { value: this.isUnsavedTasksExists,
                               corestd : this.selectedtabname
                            }
                }); 
                this.dispatchEvent(TaskEvent)

                if (result.length > 0) {
                    for (var key in result) {

                        var tempArray = [];
                        tempArray = this.taskRecList.map((obj, i) => ({ ...obj, Id: result[key].Id }));
                        this.taskRecList = tempArray;
                    }
                }
                refreshApex(this.taskRecList);

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.message = undefined;
                this.errror = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error! Task Not Saved.',
                        message: error.body.pageErrors[0].message,
                        variant: 'error',
                    }),
                );
            });
    }

    updateTaskInfo() {
        updateTask({ taskList: this.tskList })
            .then(result => {
                this.isUnsavedTasksExists = false
                const event = new CustomEvent('unsavedtaskchange',{
                    detail : { value: this.isUnsavedTasksExists,
                               corestd : this.selectedtabname
                            }
                }); 
                this.dispatchEvent(event)

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {

                this.message = undefined;
                this.errror = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error! Task Not Saved.',
                        message: error.body.pageErrors[0].message,
                        variant: 'error',
                    }),
                );
            });
    }

    
    handleonchange(event) {
      
         let tsklist = JSON.parse(JSON.stringify(this.taskRecList));   
        if(this.taskRecList.length>=0){
           
            this.isUnsavedTasksExists = true
            const event1 = new CustomEvent('unsavedtaskchange',{
                detail : { value: this.isUnsavedTasksExists,
                           corestd : this.selectedtabname
                        }
            }); 
            this.dispatchEvent(event1)
        }
        let index = event.target.id.split('-')[0];
        
        if (event.target.name == 'KeyTask') {
            tsklist[index].Key_Task__c = event.target.value;
           
        }
        else if (event.target.name == 'DueDate') {
            tsklist[index].Due_Date__c = event.target.value;
        }
        else if (event.target.name == 'TaskCompletionDate') {
            tsklist[index].Completion_Date__c = event.target.value;
        }
        else if (event.target.name == 'PersonResponsible') {
            tsklist[index].Person_Responsible_For_The_Activity__c = event.target.value;
        }
        else if (event.target.name == 'comments') {
            tsklist[index].Comments__c = event.target.value;
        }


        const taskevent = new CustomEvent('taskrecaddiion',{
            detail : { value:  tsklist  
                    }
                    
                                 
        }); 
        this.dispatchEvent(taskevent)  
        this.taskRecList = tsklist;
        

    }
    handleChange(event) {
        if(this.taskRecList.length>=0){
            this.isUnsavedTasksExists = true
            const event = new CustomEvent('unsavedtaskchange',{
                detail : { value: this.isUnsavedTasksExists,
                           corestd : this.selectedtabname
                        }
            }); 
            this.dispatchEvent(event)
        }
        
        let index = event.target.id.split('-')[0];
        this.taskRecList[index].Status__c = event.target.value;
    }
    trainingIndex = 0;

    addTrainingRow() {
        this.trainingIndex++;
        this.trainingList = [...this.trainingList, {
            key: this.trainingList.length, totClass: 'Total_Trained_Staff__c' + this.trainingList.length
        }];
        

    }
    handletrainingonchange(event) {
        if(this.trainingList.length>=0){
            
            this.isUnsavedTrainingExists = true
           
            //Notify this change to the submissionCOmponent
            const event = new CustomEvent('unsavedtrainingchange',{
                detail : { value: this.isUnsavedTrainingExists,
                           corestd : this.selectedtabname 
                        }
            }); 
            this.dispatchEvent(event)
        }

        let index = event.target.id.split('-')[0];

        if (event.target.name == 'AttendanceSheet') {
            this.trainingList[index].Attendance_Sheet__c = event.target.value;
        }
        else if (event.target.label == 'Code of Conduct?') {
            if (this.trainingList[index].Code_of_Conduct__c == 'Yes')
                this.trainingList[index].Code_of_Conduct__c = 'No';
            else if (this.trainingList[index].Code_of_Conduct__c == 'No')
                this.trainingList[index].Code_of_Conduct__c = 'Yes';
            else
                this.trainingList[index].Code_of_Conduct__c = event.target.value;
        }
        else if (event.target.name == 'TrainingDate')
            this.trainingList[index].Date_Of_Training__c = event.target.value;
        else if (event.target.name == 'TrainingDesc')
            this.trainingList[index].Description_Of_Training__c = event.target.value;
        else if (event.target.name == 'NumComm') {
            this.trainingList[index].Number_of_community__c = event.target.value;
            let num = 0;
            num = parseInt(event.target.value) + parseInt(this.trainingList[index].Number_of_Oxfam_staff__c)
                + parseInt(this.trainingList[index].Number_of_partners__c);
            this.trainingList[index].Total_Trained_Staff__c = num;

            const tempquery = this.template.querySelectorAll('[data-name=temptotal]')[index];
            tempquery.value = num;
        }
        else if (event.target.name == 'NumOxfamStaff') {
            this.trainingList[index].Number_of_Oxfam_staff__c = event.target.value;
            let num = 0;
            num = parseInt(this.trainingList[index].Number_of_community__c) + parseInt(event.target.value)
                + parseInt(this.trainingList[index].Number_of_partners__c);
            this.trainingList[index].Total_Trained_Staff__c = num;
            const tempquery = this.template.querySelectorAll('[data-name=temptotal]')[index];
            tempquery.value = num;
        }
        else if (event.target.name == 'NumPartr') {
            this.trainingList[index].Number_of_partners__c = event.target.value;
            let num = 0;
            num = parseInt(this.trainingList[index].Number_of_community__c) + parseInt(this.trainingList[index].Number_of_Oxfam_staff__c)
                + parseInt(event.target.value);
            this.trainingList[index].Total_Trained_Staff__c = num;
            const tempquery = this.template.querySelectorAll('[data-name=temptotal]')[index];
            tempquery.value = num;
        }
        else if (event.target.label == 'PSEA Policy?') {
            if (this.trainingList[index].PSEA_Policy__c == 'Yes')
                this.trainingList[index].PSEA_Policy__c = 'No';
            else if (this.trainingList[index].PSEA_Policy__c == 'No')
                this.trainingList[index].PSEA_Policy__c = 'Yes';
            else
                this.trainingList[index].PSEA_Policy__c = event.target.value;
        }
        else if (event.target.label == 'Safeguarding Policy?') {
            if (this.trainingList[index].Safeguarding_Policy__c == 'Yes')
                this.trainingList[index].Safeguarding_Policy__c = 'No';
            else if (this.trainingList[index].Safeguarding_Policy__c == 'No')
                this.trainingList[index].Safeguarding_Policy__c = 'Yes';
            else
                this.trainingList[index].Safeguarding_Policy__c = event.target.value;
        }
        else if (event.target.name == 'TrainingDelivered')
            this.trainingList[index].Who_Delivered_the_Training__c = event.target.value;
        else if (event.target.name == 'Otherevidence')
            this.trainingList[index].Other_evidence__c = event.target.value;
        else if (event.target.name == 'Trainingmaterials')
            this.trainingList[index].Training_materials__c = event.target.value;

    }
    // Partner Table a058c00000dFsUfAAK


    addPartnerRow() {
        this.partnerIndex++;

        this.partnerList = [...this.partnerList, {
            key: this.partnerList.length,
            radioKey0: 'Assessment_' + this.partnerList.length + '_0',
            radioKey1: 'Agreement_' + this.partnerList.length + '_1',
            radioKey2: 'Signed_' + this.partnerList.length + '_2',
            radioKey3: 'PolicyInPlace_' + this.partnerList.length + '_3'
        }];
    }
    handlePartnerOnChange(event) {
        if(this.partnerList.length>=0){
            
            this.isUnsavedPartnerExists = true
           
            //Notify this change to the submissionCOmponent
            const event = new CustomEvent('unsavedpartnerchange',{
                detail : { value: this.isUnsavedPartnerExists,
                           corestd : this.selectedtabname 
                        }
            }); 
            this.dispatchEvent(event)
        }
        let index = event.target.id.split('-')[0];
        if (event.target.name == 'PartnerName') {
            this.partnerList[index].Name = event.target.value;
        }
        else if (event.target.name == 'PartnerInvolvedIn') {
            this.partnerList[index].Project_s_Partner_is_Involved_in__c = event.target.value;
        }
        else if (event.target.name == 'PartnerSince') {
            this.partnerList[index].Partner_since__c = event.target.value;
        }
        else if (event.target.name == 'ContactOrChildren') {
            this.partnerList[index].Contact_or_Working_with_Children__c = event.target.value;
        }
        else if (event.target.name.indexOf('Assessment') > -1) {
            if (this.partnerList[index].CS_PSEA_in_Partner_Capacity_Assessment__c == 'Yes')
                this.partnerList[index].CS_PSEA_in_Partner_Capacity_Assessment__c = 'No';
            else if (this.partnerList[index].CS_PSEA_in_Partner_Capacity_Assessment__c == 'No')
                this.partnerList[index].CS_PSEA_in_Partner_Capacity_Assessment__c = 'Yes';
            else
                this.partnerList[index].CS_PSEA_in_Partner_Capacity_Assessment__c = event.target.value;

        }
        else if (event.target.name.indexOf('Agreement') > -1) {
            if (this.partnerList[index].CS_PSEA_in_Partner_Working_Agreement__c == 'Yes')
                this.partnerList[index].CS_PSEA_in_Partner_Working_Agreement__c = 'No';
            else if (this.partnerList[index].CS_PSEA_in_Partner_Working_Agreement__c == 'No')
                this.partnerList[index].CS_PSEA_in_Partner_Working_Agreement__c = 'Yes';
            else
                this.partnerList[index].CS_PSEA_in_Partner_Working_Agreement__c = event.target.value;

        }
        else if (event.target.name.indexOf('Signed') > -1) {
            if (this.partnerList[index].PartnerCodeofConductorequivalentSigned__c == 'Yes')
                this.partnerList[index].PartnerCodeofConductorequivalentSigned__c = 'No';
            else if (this.partnerList[index].PartnerCodeofConductorequivalentSigned__c == 'No')
                this.partnerList[index].PartnerCodeofConductorequivalentSigned__c = 'Yes';
            else
                this.partnerList[index].PartnerCodeofConductorequivalentSigned__c = event.target.value;

        }
        else if (event.target.name.indexOf('PolicyInPlace') > -1) {
            if (this.partnerList[index].CS_and_PSEA_Policy_in_Place__c == 'Yes')
                this.partnerList[index].CS_and_PSEA_Policy_in_Place__c = 'No';
            else if (this.partnerList[index].CS_and_PSEA_Policy_in_Place__c == 'No')
                this.partnerList[index].CS_and_PSEA_Policy_in_Place__c = 'Yes';
            else
                this.partnerList[index].CS_and_PSEA_Policy_in_Place__c = event.target.value;

        }
        else if (event.target.name == 'CSTrainingDate')
            this.partnerList[index].Date_of_the_last_CS_training__c = event.target.value;
        else if (event.target.name == 'PSEATrainingDate')
            this.partnerList[index].Date_of_the_last_PSEA_training__c = event.target.value;
    }

    

        OpenBoxDetails(event) {
        let questionId = event.target.name;
        let existingAnswer = this.retrivedanswers.find(ans => ans.Question__c === questionId);
        let answerId = existingAnswer ? existingAnswer.Id : '';
        if (answerId != '') {
            this.isBoxFieldDisabled = false;
        }
        if (this.isBoxFieldDisabled) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please Mark Answer as Yes.',
                    variant: 'error',
                }),
            );
        }
        else if (answerId === '') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please Save the Answer.',
                    variant: 'error',
                }),
            );
        }
        else {
            this.openLinkPopUp = true;
           
            let questionId = event.target.name;
            this.selectedQuestionId = questionId;
            this.selectedAnswerId = answerId;
           
            getBoxLinks({ questionId: questionId, answerId: answerId, OnlineSubmissionId : this.submissionid }).then(result => {
                this.listOfBoxLinks = result;
                if (this.listOfBoxLinks.length === 0) {
                    this.addNewRow();
                }
            })
        }
    }

    closeModal() {
        this.openLinkPopUp = false;
    }
    submitDetails() {
        this.openLinkPopUp = false;
      
        saveBoxLinks({ allBoxLinks: JSON.stringify(this.listOfBoxLinks) }).then(result => {
            this.dispatchEvent(new RefreshEvent())
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Box – Success',
                    message: 'You have uploaded a Box link. View all uploaded Box Links on the Submit for Approval tab.',
                    variant: 'success'
                })
            );
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while creating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    handleInputChange(event) {
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;
        for (let i = 0; i < this.listOfBoxLinks.length; i++) {
            if (this.listOfBoxLinks[i].index === parseInt(index)) {
                this.listOfBoxLinks[i][fieldName] = value;
            }
        }
    }

    @track listOfBoxLinks = [];

    addNewRow() {
        let boxLink = {
            index: "",
            boxId: "",
            boxLink: "",
            answerId: this.selectedAnswerId,
            questionId: this.selectedQuestionId,
            OnlineSubmissionId : this.submissionid
        }
        if (this.listOfBoxLinks.length > 0) {
            boxLink.index = this.listOfBoxLinks[this.listOfBoxLinks.length - 1].index + 1;
        } else {
            boxLink.index = 1;
        }
        this.listOfBoxLinks.push(boxLink);
        this.showAddButton = false;
    }
    showAddButton = false;
    removeRow(event) {
        if (event.currentTarget.dataset.id != '') {
            deleteRecord(event.currentTarget.dataset.id)
                .then(() => {
                    let toBeDeletedRowIndex = event.target.name;
                    let listOfBoxLinks = [];
                    for (let i = 0; i < this.listOfBoxLinks.length; i++) {
                        let tempRecord = Object.assign({}, this.listOfBoxLinks[i]); //cloning object
                        if (tempRecord.index !== toBeDeletedRowIndex) {
                            listOfBoxLinks.push(tempRecord);
                        }
                    }
                    for (let i = 0; i < listOfBoxLinks.length; i++) {
                        listOfBoxLinks[i].index = i + 1;
                    }
                    this.listOfBoxLinks = listOfBoxLinks;
                    this.openLinkPopUp = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Link has been deleted',
                            variant: 'success'
                        })
                    );
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error while deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
        else {
            let toBeDeletedRowIndex = event.target.name;
            let listOfBoxLinks = [];
            for (let i = 0; i < this.listOfBoxLinks.length; i++) {
                let tempRecord = Object.assign({}, this.listOfBoxLinks[i]); //cloning object
                if (tempRecord.index !== toBeDeletedRowIndex) {
                    listOfBoxLinks.push(tempRecord);
                }
            }
            for (let i = 0; i < listOfBoxLinks.length; i++) {
                listOfBoxLinks[i].index = i + 1;
            }
            this.listOfBoxLinks = listOfBoxLinks;
            if (this.listOfBoxLinks.length === 0) {
                this.showAddButton = true;
            }
        }


    }


    boxHandler(event) {
        let questionId = event.target.name.split(';')[1];
        let boxLinkValue = event.target.value;
        let existingAnswer = this.retrivedanswers.find(ans => ans.Question__c === questionId);
        let Id = existingAnswer ? existingAnswer.Id : '';
        if (!existingAnswer) {
            // Update the corresponding question object with the new boxLink value
            let question = this.QuestionMin.find(q => q.Question_id.includes(questionId));

            if (question) {
                question.boxLink = boxLinkValue;
                this.boxLink = question.boxLink;
            }

            let boxArray = [{ boxLink: this.boxLink }];

            let mergedArray = this.ans.map((item, index) => ({
                ...item,
                ...boxArray[index % boxArray.length],
            }));

            this.ans = mergedArray;

        }

        if (existingAnswer) {
            let updatedAnswer = this.ans.find(ans => ans.quest === questionId);

            if (updatedAnswer) {
                updatedAnswer.boxLink = boxLinkValue;
            } else {
                this.ans.push({
                    Id: Id,
                    coreStd: this.activeValueMessage,
                    questType: this.questionCategory,
                    entity: this.corestdentityid,
                    onlineSub: existingAnswer.Online_Submission__c,
                    quest: existingAnswer.Question__c,
                    ans: existingAnswer.Answer__c,
                    boxLink: boxLinkValue
                });
            }
        }
    }

    getSelection(event) {
        this.optionSelected = event.detail.value;
    }

    addProjectRow() {
        this.projectList = [...this.projectList, {
            key: this.projectList.length,
            radioKey0: 'RiskAssessment_' + this.projectList.length + '_0',
            radioKey1: 'PartnersRiskAssessment_' + this.projectList.length + '_1'
        }];
    }

    handleProjectOnChange(event) {
        if(this.projectList.length>=0){
            
            this.isUnsavedProjectExists = true
          
            //Notify this change to the submissionCOmponent
            const event = new CustomEvent('unsavedprojectchange',{
                detail : { value: this.isUnsavedProjectExists,
                           corestd : this.selectedtabname 
                        }
            }); 
            this.dispatchEvent(event)
        }
        let index = event.target.id.split('-')[0];

        if (event.target.name == 'ProjectName') {
            this.projectList[index].Name = event.target.value;
        }
        else if (event.target.name == 'ProjectStart') {
            this.projectList[index].Project_Start_Date__c = event.target.value;
        }
        else if (event.target.name == 'ProjectDate') {
            this.projectList[index].Project_End_Date__c = event.target.value;
        }
        else if (event.target.name == 'LevelOfContact') {
            this.projectList[index].What_level_of_contact_with_children_do__c = event.target.value;
        }
        else if (event.target.label == 'RiskAssessment') {
           
            if (this.projectList[index].Is_the_Risk_Assessment_completed__c == 'Yes'){
                this.projectList[index].Is_the_Risk_Assessment_completed__c = 'No';
            }
                
            else if (this.projectList[index].Is_the_Risk_Assessment_completed__c == 'No')
                this.projectList[index].Is_the_Risk_Assessment_completed__c = 'Yes';
            else
                this.projectList[index].Is_the_Risk_Assessment_completed__c = event.target.value;

        }
        else if (event.target.label == 'PartnersRiskAssessment') {
            if (this.projectList[index].partners_involved_in_Risk_Asses__c == 'Yes')
                this.projectList[index].partners_involved_in_Risk_Asses__c = 'No';
            else if (this.projectList[index].partners_involved_in_Risk_Asses__c == 'No')
                this.projectList[index].partners_involved_in_Risk_Asses__c = 'Yes';
            else
                this.projectList[index].partners_involved_in_Risk_Asses__c = event.target.value;

        }
        else if (event.target.name == 'MonthAndYear') {
            this.projectList[index].When_was_the_last_review_update_of_Risk__c = event.target.value;
        }
        else if (event.target.name == 'ProgressRiskActivities') {
            this.projectList[index].Progress_On_Monitoring_High_Risk__c = event.target.value;
        }
        else if (event.target.name == 'Explanation') {
            this.projectList[index].If_No_Risk_Assessment_Explain__c = event.target.value;
        }
    }
    @api
    handleMinimumStdEvid1() {
        this.questionCategory = "Explanation and Good Practices";
        let questionsArr = [];

        getQuestions({ coresStd: this.selectedtabname, qtnCat: this.questionCategory })
            .then(result => {                
                for (var key in result) {
                    let isSuccess = false;
                    let isLink = false;
                    let isAns = true;
                    let retAns = "";
                    let retDescAns = "";
                    if (result[key].Question_Type__c == "Yes/No") {
                        isSuccess = true;
                        isAns = false;
                    }
                    if (result[key].Question_Type__c == "Yes/No With Link") {
                        isLink = true;
                        isAns = false;

                    }
                    if (this.retrivedanswers != null) {
                        this.retrivedanswers.forEach(e => {
                            if (result[key].Id == e.Question__c) {
                                retAns = e.Answer__c;
                                retDescAns = e.Descriptive_Answer__c == undefined ? "" : e.Descriptive_Answer__c;
                                if (e.Score__c != undefined && e.Score__c != "" && e.Score__c != null) {
                                    this.progressBarValue = this.progressBarValue + e.Score__c;
                                }
                            }
                        })
                    }

                    // Here key will have index of list of records starting from 0,1,2,....
                    questionsArr.push({
                        Question_id: result[key].Name + ';' + result[key].Id, QuesId: result[key].Id, FileNameQues: result[key].Name, Question__c: result[key].Question__c, isSuccess: isSuccess,
                        isMandatory: (result[key].Mandatory__c == 'Yes' ? true : false), QuestionNum: result[key].Question_Number__c,
                        isLink: isLink, isAns: isAns, retAns: retAns, retDescAns: retDescAns
                    });
                }

                this.Questions = questionsArr;


            })
            .catch(error => {
                this.error = error;
            });

    }
    @api
    handleMinimumStdEvid2() {
        
        this.questionCategory = "Minimum Standard and Evidence";
        let questionsArr = [];

        getQuestions({ coresStd: this.selectedtabname, qtnCat: this.questionCategory })
            .then(result => {

                for (var key in result) {
                    let isSuccess = false;
                    let isLink = false;
                    let isTrainingLink = false;
                    let isPartnerLink = false;
                    let isProjectLink = false;
                    let isAns = true;
                    let retAns = "";
                    let retDescAns = "";
                    let boxLink = '';


                    if (result[key].Question_Type__c == "Yes/No") {
                        isSuccess = true;
                        isAns = false;
                    }
                    if (result[key].Question_Type__c == "Yes/No With Link") {
                        isLink = true;
                        isAns = false;
                        this.showUploadedFilesSection = true
                    }
                    if (result[key].Question_Type__c == "Yes/No_With_Link_In_Training_Table") {
                        isTrainingLink = true;
                        isLink = false;
                        isSuccess = true;
                        isAns= false;
                        this.showUploadedFilesSection = true
                    }
                    if (result[key].Question_Type__c == "Yes/No_With_Link_In_Partner_Table") {
                        isPartnerLink = true;
                        isLink = false;
                        isAns = false;
                        isSuccess = true;
                    }
                    if (result[key].Question_Type__c == "Yes/No_With_Link_In_Project_Table") {
                        isProjectLink = true;
                        isLink = false;
                        isAns = false;
                        isSuccess = true;
                    }

                    if (this.retrivedanswers != null) {

                        this.retrivedanswers.forEach(e => {
                            if (result[key].Id == e.Question__c) {
                                retAns = e.Answer__c;
                                retDescAns = e.Descriptive_Answer__c == undefined ? "" : e.Descriptive_Answer__c;
                                boxLink = e.Box_Link__c
                                this.showComponents = retAns === 'Yes';
                                if (e.Score__c != undefined && e.Score__c != "" && e.Score__c != null) {
                                    this.progressBarValue = this.progressBarValue + e.Score__c;
                                }

                            }
                        });
                    }
                    // Here key will have index of list of records starting from 0,1,2,....
                    questionsArr.push({
                        Question_id: result[key].Name + ';' + result[key].Id,
                        QuesId: result[key].Id,
                        FileNameQues: result[key].Name + ';'+ result[key].Short_Description__c,
                        Question__c: result[key].Question__c,
                        isSuccess: isSuccess,
                        ShortDescription:result[key].Short_Description__c,
                        isMandatory: (result[key].Mandatory__c == 'Yes' ? true : false),
                        QuestionNum: result[key].Question_Number__c,
                        isLink: isLink,
                        isAns: isAns,
                        retAns: retAns,
                        retDescAns: retDescAns,
                        isTrainingLink: isTrainingLink,
                        isPartnerLink: isPartnerLink,
                        isProjectLink:
                            isProjectLink, 
                        boxLink: boxLink
                    });
                }
                this.QuestionMin = questionsArr;
                this.QuestionMinMap[this.coresStdValue.replaceAll(' ', '')] = questionsArr;
                


            })
            .catch(error => {
                this.error = error;
            });

    }

    handleSectionToggle(event) {
        this.section = event.detail.openSections;

    }

    
    ansOptions(event) {
    
        if(this.ans.length>=0){
            
            this.isUnsavedAnswerExists = true
            
            //Notify this change to the submissionCOmponent
            const event = new CustomEvent('unsavedanswerchange',{
                detail : { value: this.isUnsavedAnswerExists,
                           corestd : this.selectedtabname 
                        }
            }); 
            this.dispatchEvent(event)
        }
        let questionName = event.currentTarget.dataset.id;
        if (event.target.value === 'Yes' && questionName.includes('Evidence')) {
            this.isBoxFieldDisabled = false;
        } else {
            this.isBoxFieldDisabled = true;
        }
        let question = event.target.name.split(';')[1];

        let Id = '';
        if (this.ans.length > 0) {
            for (let i = 0; i < this.ans.length; i++) {
                if (this.ans[i].quest == question) {
                    this.ans.splice(i, 1);
                }
            }
        }

        this.ans.forEach(e => {
            if (question == e.quest) {
                this.ans.pop();
            }
        })

        this.retrivedanswers.forEach(e => {

            if (e.Question__c == question) {
                Id = e.Id;
            }
        });

        this.ans.push({
            Id: Id,
            coreStd: this.activeValueMessage,
            questType: this.questionCategory,
            entity: this.corestdentityid,
            onlineSub: this.submissionid,
            quest: event.target.name.split(';')[1],
            ans: event.detail.value
        });

        // Find the question in QuestionMin array
        const questionObj = this.QuestionMin.find(q => q.Question_id === event.target.name);
        if (questionObj) {
            // Update the answer in the question object
            questionObj.retAns = event.detail.value;

            // Update the independent variable based on the answer
            this.showComponents = event.detail.value === 'Yes';
        }
    }

    btnSaveTraining() {
        this.counter = 0;
        
        this.trainingList.forEach(trn => {
            this.trainRec =
            {
                Name:'Training',//This is hardcoded coz there is a flow written to override the name
                Online_Submission__c: this.submissionid,
                Id: trn.Id != '' ? trn.Id : null,
                Attendance_Sheet__c: trn.Attendance_Sheet__c,
                Code_of_Conduct__c: trn.Code_of_Conduct__c,
                Date_Of_Training__c: trn.Date_Of_Training__c,
                Description_Of_Training__c: trn.Description_Of_Training__c,
                Number_of_community__c: trn.Number_of_community__c,
                Number_of_Oxfam_staff__c: trn.Number_of_Oxfam_staff__c,
                Number_of_partners__c: trn.Number_of_partners__c,
                PSEA_Policy__c: trn.PSEA_Policy__c,
                Safeguarding_Policy__c: trn.Safeguarding_Policy__c,
                Total_Trained_Staff__c: trn.Total_Trained_Staff__c,
                Who_Delivered_the_Training__c: trn.Who_Delivered_the_Training__c,
                Other_evidence__c: trn.Other_evidence__c,
                Training_materials__c: trn.Training_materials__c
            }
            saveTraining({ trainingList: this.trainRec })
                .then(result => {

                    this.counter = this.counter + 1;

                    if (this.counter == this.trainingList.length) {
                        this.isUnsavedTrainingExists= false
                    
                        const event = new CustomEvent('unsavedtrainingchange',{
                        detail : { value: this.isUnsavedTrainingExists,
                                   corestd : this.selectedtabname
                                }
                        }); 
                        this.dispatchEvent(event)

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Saved',
                                variant: 'success',
                            }),
                        );
                        this.handletraining();
                    }

                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            //message: 'Training Details Not Saved.Please check your internet connection and try again',
                            message: error.body.pageErrors[0].message,
                            variant: 'error',
                        }),
                    );
                })
        });

    }
    btnSaveProject() {
        let checkMandatory= false;
        this.projectList.forEach(safe => {
            if(!safe.Name){
                checkMandatory = true;
            }
        });

        if(checkMandatory){
             alert("Mandatory field cannot be blank");
           return;
        }
        // save project Table
        this.counter = 0;
        if (this.projectList != null && this.projectList.length > 0) {
            this.projectList.forEach(project => {
                this.projectRec =
                {
                    Online_Submission__c: this.submissionid,
                    Id: project.Id != '' ? project.Id : null,
                    Name: project.Name,
                    Project_Start_Date__c: project.Project_Start_Date__c,
                    Project_End_Date__c: project.Project_End_Date__c,
                    What_level_of_contact_with_children_do__c: project.What_level_of_contact_with_children_do__c,
                    Is_the_Risk_Assessment_completed__c: project.Is_the_Risk_Assessment_completed__c,
                    partners_involved_in_Risk_Asses__c: project.partners_involved_in_Risk_Asses__c,
                    When_was_the_last_review_update_of_Risk__c: project.When_was_the_last_review_update_of_Risk__c,
                    Progress_On_Monitoring_High_Risk__c: project.Progress_On_Monitoring_High_Risk__c,
                    If_No_Risk_Assessment_Explain__c: project.If_No_Risk_Assessment_Explain__c
                }

                saveProject({ projectList: this.projectRec })
                    .then(result => {
                        this.counter = this.counter + 1;
                        if (this.counter == this.projectList.length) {
                            this.isUnsavedProjectExists = false
                            const event = new CustomEvent('unsavedprojectchange',{
                            detail : { value: this.isUnsavedProjectExists,
                                   corestd : this.selectedtabname
                                }
                            }); 
                            this.dispatchEvent(event)

                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Saved',
                                    variant: 'success',
                                }),
                            );
                            this.handleProject();
                        }

                    })
                    .catch(error => {
                        //console.error(JSON.stringify(error))
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'Project Details Not Saved.Please check your internet connection and try again',
                                variant: 'error',
                            }),
                        );
                    })
            });
        }
    } 
    btnSavePartner() {
        let checkMandatory= false;
        this.partnerList.forEach(safe => {
            if(!safe.Name){
                checkMandatory = true;
            }
        });

        if(checkMandatory){
             alert("Mandatory field cannot be blank");
           return;
        }
        // save partner Table
        this.counter = 0;
        
        this.partnerList.forEach(Partner => {
            this.partnerRec =
            {
                Online_Submission__c: this.submissionid,
                Id: Partner.Id != '' ? Partner.Id : null,
                Name: Partner.Name,
                Project_s_Partner_is_Involved_in__c: Partner.Project_s_Partner_is_Involved_in__c,
                Partner_since__c: Partner.Partner_since__c,
                Contact_or_Working_with_Children__c: Partner.Contact_or_Working_with_Children__c,
                CS_PSEA_in_Partner_Capacity_Assessment__c: Partner.CS_PSEA_in_Partner_Capacity_Assessment__c,
                CS_PSEA_in_Partner_Working_Agreement__c: Partner.CS_PSEA_in_Partner_Working_Agreement__c,
                PartnerCodeofConductorequivalentSigned__c: Partner.PartnerCodeofConductorequivalentSigned__c,
                CS_and_PSEA_Policy_in_Place__c: Partner.CS_and_PSEA_Policy_in_Place__c,
                Date_of_the_last_CS_training__c: Partner.Date_of_the_last_CS_training__c,
                Date_of_the_last_PSEA_training__c: Partner.Date_of_the_last_PSEA_training__c
            }
            savePartner({ partnerList: this.partnerRec })
                .then(result => {
                    this.counter = this.counter + 1;
                    if (this.counter == this.partnerList.length) {
                        this.isUnsavedPartnerExists = false
                        const event = new CustomEvent('unsavedpartnerchange',{
                        detail : { value: this.isUnsavedPartnerExists,
                                   corestd : this.selectedtabname
                                }
                        }); 
                        this.dispatchEvent(event)
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Saved',
                                variant: 'success',
                            }),
                        );
                        this.handlePartner();
                    }

                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Partner Details Not Saved.Please check your internet connection and try again',
                            variant: 'error',
                        }),
                    );
                })
        });

    }
    btnSaveAnswer() {
        this.isLoading = true
        this.isBoxFieldDisabled = true
        this.counter = 0;
        if (this.submissionid == "" || this.submissionid == undefined) {
            handleAlert("Complete the Online Submission process then continue", 'error', 'No submission record');
            return;
        }
        if(this.ans.length === 0){
            this.isLoading = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Nothing Modified',
                    message: 'No Answer(s) to Save',
                    variant: 'info',
                }),
            );
        }
        this.ans.forEach(acc => {
            this.ansRecord = {
                Id: acc.Id == '' ? null : acc.Id,
                Answer__c: (acc.ans == 'Yes' || acc.ans == 'No') ? acc.ans : '',
                Descriptive_Answer__c: (acc.ans != 'Yes' && acc.ans != 'No') ? acc.ans : '',
                Online_Submission__c: acc.onlineSub,
                Question__c: acc.quest,
                Core_Standard_Entity__c: acc.entity
            };
           
            saveAnswerRecord({ ansRecord: this.ansRecord, boxLinkList: JSON.stringify(this.listOfBoxLinks) })
            .then(result => {
                this.isLoading = false
                this.counter = this.counter + 1;

                if (this.counter == this.ans.length) {
                    this.isUnsavedAnswerExists= false
                    const event = new CustomEvent('unsavedanswerchange',{
                        detail : { value: this.isUnsavedAnswerExists,
                                   corestd : this.selectedtabname
                                }
                    }); 
                    this.dispatchEvent(event)

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Saved',
                            variant: 'success',
                        }),
                    );

                    this.retrivedanswers = [];
                    getAnswer({ onlineSubId: this.submissionid })
                        .then(result => {
                            this.retrivedanswers = result;
                        })
                        .then(() => {

                            this.progressBarValue = 0;
                            this.handleMinimumStdEvid1();
                            this.handleMinimumStdEvid2();
                            this.ans = [];
                            this.dispatchEvent(progressBarEvt);
                        })
                        .catch(error => {
                            this.error = error;
                        });
                }

            })
                .catch(error => {
                    console.log('error==>' + this.error);
                    this.isLoading = false
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: '“Answer(s) Not Saved.Please check your internet connection and try again.',
                            variant: 'error',
                        }),
                    );
                });
        });
    }

    @track trainingList1 = [
        {
            Id: '',
            key: 0,
            radioKey0: '',
            radioKey1: '',
            radioKey2: '',
            Name: '',
            Attendance_Sheet__c: '',
            Code_of_Conduct__c: '',
            Date_Of_Training__c: '',
            Description_Of_Training__c: '',
            Number_of_community__c: '',
            Number_of_Oxfam_staff__c: '',
            Number_of_partners__c: '',
            PSEA_Policy__c: '',
            Question__c: '',
            Safeguarding_Policy__c: '',
            Total_Trained_Staff__c: '',
            Who_Delivered_the_Training__c: '',
            Other_evidence__c: '',
            Training_materials__c: ''

        }
    ];

    handletraining() {
        this.trainingList1 = [];
        getTraining({ onlineSubId: this.submissionid })
            .then(result => {
                if (result.length > 0) {
                    this.trainingList1 = [];
                    for (var key in result) {
                        this.trainingList1.push({
                            Id: result[key].Id, key: key,
                            Name: result[key].Name, 
                            Attendance_Sheet__c: result[key].Attendance_Sheet__c,
                            Date_Of_Training__c: result[key].Date_Of_Training__c,
                            Code_of_Conduct__c: result[key].Code_of_Conduct__c,
                            Description_Of_Training__c: result[key].Description_Of_Training__c,
                            Number_of_community__c: result[key].Number_of_community__c, coreStandard: result[key].Core_Standard_Entity__c,
                            Number_of_Oxfam_staff__c: result[key].Number_of_Oxfam_staff__c, 
                            Number_of_partners__c: result[key].Number_of_partners__c,
                            PSEA_Policy__c: result[key].PSEA_Policy__c, 
                            Question__c: result[key].Question__c,
                            EvidenceType:result[key].Evidence__c,
                            questionName: result[key].Question__r.Name,
                            Safeguarding_Policy__c: result[key].Safeguarding_Policy__c, Total_Trained__c: result[key].Total_Trained__c,
                            Who_Delivered_the_Training__c: result[key].Who_Delivered_the_Training__c, Other_evidence__c: result[key].Other_evidence__c,
                            Training_materials__c: result[key].Training_materials__c, Total_Trained_Staff__c: result[key].Total_Trained_Staff__c
                        });
                    }
                    this.trainingList = this.trainingList1;
                    
                }

            })
            .catch(error => {
                this.error = error;
            });
    }

    @track partnerList1 = [
        {
            Id: '',
            key: 0,
            Name: '',
            radioKey0: '',
            radioKey1: '',
            radioKey2: '',
            radioKey3: '',
            Project_s_Partner_is_Involved_in__c: '',
            Partner_since__c: '',
            Contact_or_Working_with_Children__c: '',
            CS_PSEA_in_Partner_Capacity_Assessment__c: '',
            CS_PSEA_in_Partner_Working_Agreement__c: '',
            PartnerCodeofConductorequivalentSigned__c: '',
            CS_and_PSEA_Policy_in_Place__c: '',
            Date_of_the_last_CS_training__c: '',
            Date_of_the_last_PSEA_training__c: ''
        }
    ];

    handlePartner() {
        this.partnerList1 = [];
        getPartner({ onlineSubId: this.submissionid })
            .then(result => {
                if (result.length > 0) {
                    this.partnerList1 = [];
                    let counterPartner = 0;
                    for (var key in result) {
                        this.partnerList1.push({
                            Id: result[key].Id,
                            key: key,
                            radioKey0: 'Assessment_' + counterPartner + '_0',
                            radioKey1: 'Agreement_' + counterPartner + '_1',
                            radioKey2: 'Signed_' + counterPartner + '_2',
                            radioKey3: 'PolicyInPlace_' + counterPartner + '_3',
                            Name: result[key].Name,
                            Contact_or_Working_with_Children__c: result[key].Contact_or_Working_with_Children__c,
                            CS_PSEA_in_Partner_Capacity_Assessment__c: result[key].CS_PSEA_in_Partner_Capacity_Assessment__c,
                            CS_PSEA_in_Partner_Working_Agreement__c: result[key].CS_PSEA_in_Partner_Working_Agreement__c,
                            CS_and_PSEA_Policy_in_Place__c: result[key].CS_and_PSEA_Policy_in_Place__c,
                            Date_of_the_last_CS_training__c: result[key].Date_of_the_last_CS_training__c,
                            coreStandard: result[key].Core_Standard_Entity__c,
                            Date_of_the_last_PSEA_training__c: result[key].Date_of_the_last_PSEA_training__c,
                            Partner_since__c: result[key].Partner_since__c,
                            PartnerCodeofConductorequivalentSigned__c: result[key].PartnerCodeofConductorequivalentSigned__c,
                            Question__c: result[key].Question__c,
                            Project_s_Partner_is_Involved_in__c: result[key].Project_s_Partner_is_Involved_in__c,
                        });
                        counterPartner = counterPartner + 1;
                    }
                    this.partnerList = this.partnerList1;
                }

            })
            .catch(error => {
                this.error = error;
            });
    }

    @track projectList1 = [
        {
            Id: '',
            key: 0,
            Name: '',
            radioKey0: '',
            radioKey1: '',
            Project_Start_Date__c: '',
            Project_End_Date__c: '',
            What_level_of_contact_with_children_do__c: '',
            Is_the_Risk_Assessment_completed__c: '',
            partners_involved_in_Risk_Asses__c: '',
            When_was_the_last_review_update_of_Risk__c: '',
            Progress_On_Monitoring_High_Risk__c: '',
            If_No_Risk_Assessment_Explain__c: '',
        }
    ];

    handleProject() {
        this.projectList1 = [];
        getProject({ onlineSubId: this.submissionid })
            .then(projresult => {
                if (projresult.length > 0) {
                    this.projectList1 = [];
                    for (var key in projresult) {
                        this.projectList1.push({
                            Id: projresult[key].Id,
                            key: key,
                            Name: projresult[key].Name,
                            Project_Start_Date__c: projresult[key].Project_Start_Date__c,
                            Project_End_Date__c: projresult[key].Project_End_Date__c,
                            What_level_of_contact_with_children_do__c: projresult[key].What_level_of_contact_with_children_do__c,
                            Is_the_Risk_Assessment_completed__c: projresult[key].Is_the_Risk_Assessment_completed__c,
                            partners_involved_in_Risk_Asses__c: projresult[key].partners_involved_in_Risk_Asses__c,
                            When_was_the_last_review_update_of_Risk__c: projresult[key].When_was_the_last_review_update_of_Risk__c,
                            Progress_On_Monitoring_High_Risk__c: projresult[key].Progress_On_Monitoring_High_Risk__c,
                            If_No_Risk_Assessment_Explain__c: projresult[key].If_No_Risk_Assessment_Explain__c,
                        });
                    }
                    this.projectList = this.projectList1;
                }

            })
            .catch(error => {
                this.error = error;
            });
    }
    

    openTrainingBox(event) {
        
        let questionId = event.target.queid
       
        let existingAnswer = this.retrivedanswers.find(ans => ans.Question__c === questionId);
        
        let answerId = existingAnswer ? existingAnswer.Id : '';
       
        if (answerId != '') {
            this.isBoxFieldDisabled = false;
        }
        if (this.isBoxFieldDisabled) {
            this.openLinkPopUp = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please Mark Answer as Yes and save it, then save Training row before Box Upload.',
                    variant: 'error'
                    
                }),
            );
            return
        }
        else if (answerId === '' || answerId === undefined || answerId === null ) {
            this.openLinkPopUp = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please save the Answer as Yes, then save Training row before Box Upload',
                    variant: 'error'
                }),
            );
            return
        }
        else if(event.target.dataset.id === '' || event.target.dataset.id === undefined || event.target.dataset.id === null) {
            this.openLinkPopUp = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please save the training row before Box Upload',
                    variant: 'error'
                    
                }),
            );
            return
        }else{

        this.trainingId = event.currentTarget.dataset.id;
        this.openLinkPopUp = true
        this.trainingType = event.target.name;
        this.submissionId = event.currentTarget.dataset.value;
        this.openTrainingBoxLink = true;
        getTrainingLinks({ trainingId: this.trainingId, trainingType: this.trainingType }).then(result => {
            this.listOfTrainingBoxLinks = result;
            if (this.listOfTrainingBoxLinks.length === 0) {
                this.addNewTrainingRow();
            }
        })
    }
    }

    closeTrainingLink() {
        this.openTrainingBoxLink = false;
        this.openLinkPopUp = false
    }

    addNewTrainingRow() {
        let boxLink = {
            index: "",
            boxId: "",
            boxLink: "",
            trainingId: this.trainingId,
            trainingType: this.trainingType,
            submissionId: this.submissionId
        }
        if (this.listOfTrainingBoxLinks.length > 0) {
            boxLink.index = this.listOfTrainingBoxLinks[this.listOfTrainingBoxLinks.length - 1].index + 1;
        } else {
            boxLink.index = 1;
        }
        this.listOfTrainingBoxLinks.push(boxLink);
        this.showLinkAddButton = false;
    }


    removeTrainingRow(event) {
        if (event.currentTarget.dataset.id != '') {
            deleteRecord(event.currentTarget.dataset.id)
                .then(() => {
                    let toBeDeletedRowIndex = event.target.name;
                    let listOfTrainingBoxLinks = [];
                    for (let i = 0; i < this.listOfTrainingBoxLinks.length; i++) {
                        let tempRecord = Object.assign({}, this.listOfTrainingBoxLinks[i]); //cloning object
                        if (tempRecord.index !== toBeDeletedRowIndex) {
                            listOfTrainingBoxLinks.push(tempRecord);
                        }
                    }
                    for (let i = 0; i < listOfTrainingBoxLinks.length; i++) {
                        listOfTrainingBoxLinks[i].index = i + 1;
                    }
                    this.listOfTrainingBoxLinks = listOfTrainingBoxLinks;
                    this.openLinkPopUp = false;
                    this.openTrainingBoxLink = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Link deleted',
                            variant: 'success',
                        })
                    );
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error while deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
        else {
            let toBeDeletedRowIndex = event.target.name;
            let listOfTrainingBoxLinks = [];
            for (let i = 0; i < this.listOfTrainingBoxLinks.length; i++) {
                let tempRecord = Object.assign({}, this.listOfTrainingBoxLinks[i]); //cloning object
                if (tempRecord.index !== toBeDeletedRowIndex) {
                    listOfTrainingBoxLinks.push(tempRecord);
                }
            }
            for (let i = 0; i < listOfTrainingBoxLinks.length; i++) {
                listOfTrainingBoxLinks[i].index = i + 1;
            }
            this.listOfTrainingBoxLinks = listOfTrainingBoxLinks;
            if (this.listOfTrainingBoxLinks.length === 0) {
                this.showLinkAddButton = true;
            }
        }


    }

    submitTrainingBoxDetails() {
        this.openLinkPopUp = false;
        this.openTrainingBoxLink = false;
       
        saveTrainingLinks({ data: JSON.stringify(this.listOfTrainingBoxLinks) }).then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'You have uploaded a Box link. View all uploaded Box Links on the Submit for Approval tab.',
                    variant: 'success'
                })
            ); 
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while creating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
        
    }

    handleInputTrainingLinkChange(event) {
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;
        for (let i = 0; i < this.listOfTrainingBoxLinks.length; i++) {
            if (this.listOfTrainingBoxLinks[i].index === parseInt(index)) {
                this.listOfTrainingBoxLinks[i][fieldName] = value;
            }
        }
    }

}