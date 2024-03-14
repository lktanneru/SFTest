import { LightningElement, wire, track, api } from 'lwc';

//import the custom Labels from SF org
import Title from '@salesforce/label/c.PlansAndReportTitle';
import Image from '@salesforce/label/c.PlansAndReportImage';
import OxfamDetailsOfPerson from '@salesforce/label/c.OxfamDetailsOfPerson';
import OxfamFocalPoints from '@salesforce/label/c.OxfamFocalPoints';
import OxfamInformatioProviders from '@salesforce/label/c.OxfamInformatioProviders';
import OxfamSubOfficeName from '@salesforce/label/c.OxfamSubOfficeName';
import OxfamTypeOfInformation from '@salesforce/label/c.OxfamTypeOfInformation'
import getQuestionsForProgressBar from '@salesforce/apex/countryPageCls.getQuestionsForProgressBar';
import getTask from '@salesforce/apex/TaskController.getTaskList';
import saveTask from '@salesforce/apex/TaskController.creatTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import coreStandard from '@salesforce/apex/countryPageCls.coreStandard';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import saveAnswerRecord from '@salesforce/apex/countryPageCls.createAnswerRecord';
import checkCoreStandardMandatory from '@salesforce/apex/countryPageCls.coreStandardEntityMandatory';
import insertOnlineSub from '@salesforce/apex/countryPageCls.insertOnlineSub';
import updateOnlineSub from '@salesforce/apex/countryPageCls.updateOnlineSub';
import getOnlineSub from '@salesforce/apex/countryPageCls.getOnlineSub';
import coreStandardEntityRecord from '@salesforce/apex/countryPageCls.coreStandardEntityRecord';
import getAnswer from '@salesforce/apex/countryPageCls.getAnswer';
import createSafeFocalPoint from '@salesforce/apex/SubmissionCls.createSafeFocalPoint';
import getSafeFocalPoint from '@salesforce/apex/SubmissionCls.getSafeFocalPoint';
import createSafeInfoProv from '@salesforce/apex/SubmissionCls.createSafeInfoProv';
import getSafeInfoProv from '@salesforce/apex/SubmissionCls.getSafeInfoProv';
import deleteSafeInfoProv from '@salesforce/apex/SubmissionCls.deleteSafeInfoProv';
import deleteSafeFocalPt from '@salesforce/apex/SubmissionCls.deleteSafeFocalPt';
import getTraining from '@salesforce/apex/TaskController.getTraining';
import getSummary from '@salesforce/apex/TaskController.getSummary';
import createSummary from '@salesforce/apex/SubmissionCls.createSummary';
import getPartner from '@salesforce/apex/TaskController.getPartner';
import getProject from '@salesforce/apex/TaskController.getProject';
import getExistingOnlineSub from '@salesforce/apex/TaskController.getExistingOnlineSub';
import getExistingApprovedOnlineSub from '@salesforce/apex/TaskController.getExistingApprovedOnlineSub';
import getCoreStandardGuidence from '@salesforce/apex/SubmissionCls.getCoreStandardGuidence';
import LightningConfirm from "lightning/confirm";
import pubsub from 'c/pubSub';  
//import getAttachmentList from '@salesforce/apex/PreviousSubmissionController.getAttachmentList';
//import getQAWithBoxLink from '@salesforce/apex/PreviousSubmissionController.getQAWithBoxLink';
import deleteFiles from '@salesforce/apex/FileUploaderCompHandler.deleteFiles'
import { refreshApex } from '@salesforce/apex';
import LightningAlert from "lightning/alert";
import updateCoreStandEntityFieldWithURL from '@salesforce/apex/chatterPost.updateCoreStandEntityFieldWithURL'
import updateOnlineSubFieldWithCS from '@salesforce/apex/chatterPost.updateOnlineSubFieldWithCS'
import { RefreshEvent } from 'lightning/refresh';
import submitAndProcessApprovalRequest from '@salesforce/apex/onlineSubmissionApproval.submitAndProcessApprovalRequest';
//import { handlePageRefresh } from 'c/pageRefreshHandler';



//creating the container to collect the labels
// expose the labels to use in the template.

const columns = [
    { label: 'Core Standard', fieldName: 'coreStandardName', type: 'text', initialWidth: 200 },
    { label: 'Question', fieldName: 'Question', type: 'text', initialWidth: 600 },
    {
        label: 'Box Link',
        fieldName: 'Box_Link__c.link',
        fixedWidth: 450,
        type: 'custom',
        typeAttributes: {
            treeDataSource: 'Box_Link__c',
            treeGridOptions: {
                columns: [
                    { type: 'text', fieldName: 'label', label: 'Label', initialWidth: 200 },
                    { type: 'url', fieldName: 'link', label: 'Link' }
                ],
                iconFieldName: 'iconName'
            }
        }
    }
];

const cols8 = [

    { label: 'File Name', fieldName: 'FileName', type: 'text' },
    { label: 'Related To', fieldName: 'relatedTo', type: 'text' },
    { label: 'Download', fieldName: 'url', type: 'url' },
    {
        type: 'button-icon', 
        fixedWidth: 50,
        typeAttributes: {
            iconName: 'utility:delete',
            name: 'delete',
            title: 'Delete',
            variant: 'bare'
        }
    }
];

export default class SubmissionComponent extends NavigationMixin(LightningElement) {
    // custom Labels
    labelList = {
        Title,
        Image,
        OxfamDetailsOfPerson,
        OxfamFocalPoints,
        OxfamInformatioProviders,
        OxfamSubOfficeName,
        OxfamTypeOfInformation
    };
    //End of Custom Labels
    @track activeSectionsInApprovalTab = ["Attachments", "Progress Bar", "Question And Answers", "Evidence CheckList", "Instructions","Evidence"]
    @track isReportingPick = false;
    isAllTabsVisible = false;
    section = '';
    activeValueMessage = '';
    Questions;
    @track coresStdValue;
    @track questionCategory;
    @track l_All_Types;
    @track tabs;
    @track questiontype;
    @track selectedValue;
    @track columns = columns;
    @track cols8 = cols8;
    @track filesList = [];
    @track approversDisplayList3;
    QuestionMin;
    implementFlag;
    coreStdSelected;
    reportPeriodId;
    @track reportPeriodName;
    @track showCoreStandard11 = false;
    @track showCoreStandard12 = false;
    @track showCoreStandard13 = false;
    @track showCoreStandard14 = false;
    @track showCoreStandard15 = false;
    @track showCoreStandard16 = false;
    @track showCoreStandard17 = false;
    @track showCoreStandard18 = false;
    @track showCoreStandard19 = false;
    @track showCoreStandard20 = false;
    coreStdTemp = '';
    coreStdNameTemp = '';
    onLoad = false;
    @track currentUrlToPass;
    selectedtabname;
    selectedtabvalue;
    corestdId;
    @track submissionType;
    @track entityName;
    onlineSubmissionId;
    entityId;
    loadedFrmHomeEntityId;
    loadedFrmHomeEntityName;
    currentPageReference = null;
    urlStateParameters = null;
    delsafeInfoProv;
    isApprovedRecordExist = false
    @track showMessage = ''
    retrivedAnswer;
    @track summaryId = '';
    onlineSubName;
    onlineSubRole;
    onlineSubEmail;
    onlineSubmission;
    safeFocalPoint;
    safeInfoProv;
    summaryList = {};
    @track QuestionMinMap = {};
    @track isLoading = false
    mandatoryCoreStd;
    selectedindexentity;
    selectedindexsubtype;
    selectedindexreportperiod;
    corestdentityid;
    @track approvalStatus = '';
    @track submissionComment = ''
    @track childComponentReference;
    unsavedTasks = false
    unsavedAnswers = false
    unsavedPartner = false
    unsavedTraining = false
    unsavedProject = false
    coreStandardName=''
    @track ischangedtab1=false;
    @track ischangedtab2=false;
    @track ischangedtab3=false;
    @track ischangedtab4=false;
    @track ischangedtab5=false;
    @track ischangedtab6=false;
    @track ischangedtab7=false;
    @track ischangedtab8=false;
    @track ischangedtab9=false;
    @track ischangedtab10=false;
    @track showApprovalMessage= false;
     @track submitLabel ='Submit For Approval';
    

    // yes/No piclist for answers
    @track RadioOption = [
        { label: "Yes", value: "Yes" },
        { label: "No", value: "No" }
    ];

    @api inputParams =
        {
            'reportPeriodId': '',
            'entityName': '',
            'onlineSubmissionId': ''
        };

    // picklist options for Task Status
    @track taskOptions = [
        { label: "Completed", value: "Completed" },
        { label: "In-Progress", value: "In-Progress" },
        { label: "Not Applicable Anymore", value: "Not Applicable Anymore" },
        { label: "Not Started", value: "Not Started" }
    ];

    
    handleUnsavedTasks(event){
        this.unsavedTasks = event.detail.value;
        this.coreStandardName = event.detail.corestd
    }

    
    handleUnsavedAnswers(event){
        this.unsavedAnswers = event.detail.value
        this.coreStandardName = event.detail.corestd
    }

    handleUnsavedPartner(event){
        this.unsavedPartner = event.detail.value
        this.coreStandardName = event.detail.corestd
    }

    handleUnsavedTraining(event){
        this.unsavedTraining = event.detail.value
        this.coreStandardName = event.detail.corestd
    }

    handleUnsavedProject(event){
        this.unsavedProject = event.detail.value
        this.coreStandardName = event.detail.corestd
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {

        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.selectedindexentity = this.urlStateParameters.c__id || null;
        this.loadedFrmHomeEntityId = this.selectedindexentity != null ? this.selectedindexentity.split(';')[1] : null;
        this.loadedFrmHomeEntityName = this.selectedindexentity != null ? this.selectedindexentity.split(';')[0] : null;

        this.selectedindexsubtype = this.urlStateParameters.c__subType || null;

        this.selectedindexreportperiod = this.urlStateParameters.c__RepYearName || null;


        this.coreStdTemp = this.urlStateParameters.c__coreStd || null;
        this.coreStdNameTemp = this.urlStateParameters.c__coreStdName || null;
    }

    //reusable Helper method used for showing alert messages with lightning UI
    async handleAlert(message, theme, label) {
        await LightningAlert.open({
            message: message,
            theme: theme,
            label: label
        });
    }
    showSuccessMessage = false
    submitAndApproval() {
        
        
       
        //this.isSubmitDisabled = false
        this.submissionComment = Array.from(this.template.querySelector(".submissionComment").value)
        const commentString = this.submissionComment.join("")
        submitAndProcessApprovalRequest({ onlineSub: this.onlineSubmissionId, comments: commentString })
            .then(result => {
                if (result === 'Success') {
                    this.submissionComment = ''
                    this.showSuccessMessage= true
                    this.showApprovalMessage = true
                    this.approvalStatus = 'For Approval'
                    this.submitLabel =  this.approvalStatus
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Submitted',
                            message: 'Plan Submitted for Approval',
                            variant: 'success',
                        }),
                    );
                } else if (result === 'Error submitting approval request.') {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Submission Failed',
                            message: result,
                            variant: 'error',
                        }),
                    );
                } else if (result === 'Queue not found.') {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Submission Failed',
                            message: result,
                            variant: 'error',
                        }),
                    );
                } else if(result === 'Record is either submitted for approval or approved'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Submission Failed',
                            message: result,
                            variant: 'error',
                        }),
                    );
                }

            })

    }

    @track safeInformationProvider = [
        {
            key: 0,
            Name: '',
            Role__c: '',
            Type_Of_Information__c: ''
        }
    ];

    addIP() {
        this.safeInformationProvider = [...this.safeInformationProvider, { key: this.safeInformationProvider.length }];
    }

    async delIP(event) {
        let index = event.target.dataset.id;
        const delIPResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this Information Provider?",
            theme: "success",
            label: "Delete Confirmation"
        });
        if (delIPResult) {
            this.delsafeInfoProv = {
                Id: this.safeInformationProvider[index].Id,
                Name: this.safeInformationProvider[index].Name,
                Role__c: this.safeInformationProvider[index].Role__c,
                Online_Submission__c: this.onlineSubmissionId
            };
            if(!this.safeInformationProvider[index].Id){
                this.safeInformationProvider.splice(index, 1);
            }else{
                deleteSafeInfoProv({ safeInfoProv: this.delsafeInfoProv })
                .then(result => {
                    if (result == 'success') {

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Deleted',
                                variant: 'success',
                            }),
                        );
                        this.safeInformationProvider.splice(index, 1);
                    }
                })
                .catch(error => {
                    this.error = error;
                    alert('Record not deleted')
                });
            }   
            
        }
    }

    @track SafeFocalPtItems = [
        {
            key: 0,
            Id: '',
            Name: '',
            Office_Sub_Office__c: ''
        }
    ];

    @track taskRecList1 = [];

    handleSafeFocalPInputChange(event) {
        let index = event.target.id.split('-')[0];
        if (event.target.name == 'entityFocalName') {
            this.SafeFocalPtItems[index].Name = event.target.value;
        }
        else if (event.target.name == 'entityFocalOfficeName') {
            this.SafeFocalPtItems[index].Office_Sub_Office__c = event.target.value;
        }
    }

    handleSafeInfoProInputChange(event) {
        let index = event.target.id.split('-')[0];
        if (event.target.name == 'informationProvideName') {
            this.safeInformationProvider[index].Name = event.target.value;
        }
        else if (event.target.name == 'informationProvideRole') {
            this.safeInformationProvider[index].Role__c = event.target.value;
        }
        else if (event.target.name == 'informationProvideType') {
            this.safeInformationProvider[index].Type_Of_Information__c = event.target.value;
        }
    }
    addSafeFocalPt(event) {
        this.SafeFocalPtItems = [...this.SafeFocalPtItems, { key: this.SafeFocalPtItems.length }];
    }
    delSafeFocalPtItems;
    async delSafeFocalPt(event) {
        let index = event.target.dataset.id;
        const delFocalPtResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this Focal Point?",
            theme: "success",
            label: "Delete Confirmation"
        });
        if (delFocalPtResult) {

            this.delSafeFocalPtItems = {
                Id: this.SafeFocalPtItems[index].Id,
                Name: this.SafeFocalPtItems[index].Name,
                Office_Sub_Office__c: this.SafeFocalPtItems[index].Office_Sub_Office__c,
                Online_Submission__c: this.onlineSubmissionId
            };
            if(!this.SafeFocalPtItems[index].Id){
                this.SafeFocalPtItems.splice(index, 1);
            }else{
                deleteSafeFocalPt({ safeFocalPoint: this.delSafeFocalPtItems })
                .then(result => {
                    if (result == 'success') {

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Deleted',
                                variant: 'success',
                            }),
                        );
                        this.SafeFocalPtItems.splice(index, 1);
                    }
                })
                .catch(error => {
                    this.error = error;
                    alert('Record not deleted')
                });
            }

            
        }
    }


    //to check for approved submission records

    checkApprovedSubExist(subType, entity, reportPeriod) {
        getExistingApprovedOnlineSub({ subType: subType, entity: entity, reportPeriod: reportPeriod })
            .then(result => {
                if (result === 'Record Found') {
                    this.handleAlert("This Plan is already submitted and approved", 'info', 'Approved Plan')
                    this.isApprovedRecordExist = true
                    this.coreStdTemp = null
                    this.approvalStatus = result.Approval_Status__c
                    this.isAllTabsVisible = false;
                    /*if(!this.approvalStatus){this.submitLabel ='Submit for Approval'}
                    else {this.submitLabel = this.approvalStatus } 
                    // Set the "General" tab as active
                    if(!this.onLoad){
                        const tabset = this.template.querySelector('lightning-tabset');
                        if (tabset) {
                            tabset.activeTabValue = 'General';
                            
                        }
                    }*/
                    
                }

            }).catch(error => {
                this.error = error
            })
    }

    //To check the existing OS record for selected PL values
    checkOnlineSubExist(subType, varEntityId, reportPeriod) {
        this.onlineSubmissionId = null
        getExistingOnlineSub({ subType: subType, entity: varEntityId, reportPeriod: reportPeriod })
            .then(result => {
                refreshApex(result);
                this.isAllTabsVisible = true
                if (result != null) {
                    this.onlineSubmissionId = result.Id;
                    this.onlineSubName = result.Name__c;
                    this.onlineSubRole = result.Role__c;
                    this.onlineSubEmail = result.Email__c;
                    this.submissionType = result.Submission_Type__c;
                    this.entityName = result.Entity__r.Name;
                    this.entityId = result.Entity__c;
                    this.selectedindexsubtype = result.Submission_Type__c;
                    this.reportPeriodId = result.Reporting_Period__c;
                    this.approvalStatus = result.Approval_Status__c;
                    if(!this.approvalStatus){this.submitLabel ='Submit for Approval'}
                    else {this.submitLabel = this.approvalStatus } 
                    this.selectedindexreportperiod = result.Reporting_Period__r.Name + ';' + result.Reporting_Period__c;
                    this.coreStdTemp = null
                    
                    // Set the "General" tab as active
                    if(!this.onLoad){
                        const tabset = this.template.querySelector('lightning-tabset');
                        if (tabset) {
                            tabset.activeTabValue = 'General';
                            
                        }
                    }
                    


                    this.FillAllObjects();
                } else {
                    this.taskRecList1 = [];
                    this.ClearObjects();
                   
                    if(!this.onLoad){
                        const tabset = this.template.querySelector('lightning-tabset');
                        if (tabset) {
                            tabset.activeTabValue = 'General';
                            
                        }
                    }
                    pubsub.fire('fireTaskInfoEvent', this.taskRecList1);
                   
                }
            })
            .catch(error => {
                console.log('this is the error  '+error)  
            });
    }

    ClearObjects() {
        this.approvalStatus ='';
        this.onlineSubName = '';
        this.onlineSubRole = '';
        this.onlineSubEmail = '';
        this.retrivedAnswer = [];
        this.SafeFocalPtItems = [
            {
                key: 0,
                Id: '',
                Name: '',
                Office_Sub_Office__c: ''
            }
        ];
        this.safeInformationProvider = [
            {
                key: 0,
                Name: '',
                Role__c: '',
                Type_Of_Information__c: ''
            }
        ];

        this.taskRecList1 = [];
        this.trainingList = [];

        this.projectList = [
            {
                Id: '',
                key: 0,
                Name: '',
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

        this.partnerList = [
            {
                Id: '',
                key: 0,
                Name: '',
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
        this.summaryList = {};

    }


    tab1 = { Id: '', Name: '' };
    tab2 = { Id: '', Name: '' };
    tab3 = { Id: '', Name: '' };
    tab4 = { Id: '', Name: '' };
    tab5 = { Id: '', Name: '' };
    tab6 = { Id: '', Name: '' };
    tab7 = { Id: '', Name: '' };
    tab8 = { Id: '', Name: '' };
    tab9 = { Id: '', Name: '' };
    tab10 = { Id: '', Name: '' };
    tab11 = { Id: '', Name: '' };
    tab12 = { Id: '', Name: '' };
    tab13 = { Id: '', Name: '' };
    tab14 = { Id: '', Name: '' };
    tab15 = { Id: '', Name: '' };
    tab16 = { Id: '', Name: '' };
    tab17 = { Id: '', Name: '' };
    tab18 = { Id: '', Name: '' };
    tab19 = { Id: '', Name: '' };
    tab20 = { Id: '', Name: '' };

    progressBarObj = [];

    trainingList = [
        {
            Id: '',
            key: 0,
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
            Total_Trained__c: '',
            Who_Delivered_the_Training__c: '',
            Other_evidence__c: '',
            Training_materials__c: ''

        }
    ];

    projectList = [
        {
            Id: '',
            key: 0,
            Name: '',
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

    partnerList = [
        {
            Id: '',
            key: 0,
            Name: '',
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
    fetchEntityValue(event) {
        this.entityName = event.detail.split(';')[0];
        this.entityId = event.detail.split(';')[1];
    }

    fetchReportPeriod(event) {
        this.ClearObjects();
        this.onlineSubName = '';
        this.onlineSubRole = '';
        this.onlineSubEmail = '';
       
        this.isApprovedRecordExist = false;
        this.isAllTabsVisible = true;
        
        this.reportPeriodId = event.detail.split(';')[1];
        this.reportPeriodName = event.detail.split(';')[0];
        this.fetchCoreStandards();

        //this.template.querySelector('c-plans-submission-child').modifyAnsTablesOnRepYearChange(this.submissionType,this.entityId,this.reportPeriodId)
        if (this.entityId == undefined) {
            var entityTemp = this.selectedindexentity.split(';')[1];
            this.entityId = entityTemp;
        }
        this.checkOnlineSubExist(this.submissionType, this.entityId, this.reportPeriodId);
        this.checkApprovedSubExist(this.submissionType, this.entityId, this.reportPeriodId);

        window.history.pushState({}, null, 'Plans_And_Reports_Submission_Page?c__id=' + this.selectedindexentity + '&c__subType=' + this.submissionType + '&c__RepYearName=' + this.reportPeriodName + '&c__RepYearId=' + this.reportPeriodId + '&c__coreStd=' + this.selectedtabvalue + '&c__coreStdName=' + this.selectedtabname);
       
        //calling the getAnswers method in planssubmissionchild component
        try{
            let result = this.template.querySelector('c-plans-submission-child').notifyChangeToChild();
        }catch(error){
            //alert('error in calling child component  '+error)
        }
        
    }

    fetchValue(event) {
        this.ClearObjects();
        this.onlineSubName = '';
        this.onlineSubRole = '';
        this.onlineSubEmail = '';
        this.isApprovedRecordExist = false
        this.isAllTabsVisible = true
        this.isReportingPick = true;
        refreshApex(this.submissionType);
        
        this.submissionType = event.detail;
     
        
        if (this.submissionType == "Implementation Plan") {
            this.implementFlag = false;
        }
        else {
            this.implementFlag = true;
        }
        if (this.entityId == undefined) {
            var entityTemp = this.selectedindexentity.split(';')[1];
            this.entityId = entityTemp;
        }
        this.checkOnlineSubExist(this.submissionType, this.entityId, this.reportPeriodId);
        this.checkApprovedSubExist(this.submissionType, this.entityId, this.reportPeriodId);

        window.history.pushState({}, null, 'Plans_And_Reports_Submission_Page?c__id=' + this.selectedindexentity + '&c__subType=' + this.submissionType + '&c__RepYearName=' + this.reportPeriodName + '&c__RepYearId=' + this.reportPeriodId + '&c__coreStd=' + this.selectedtabvalue + '&c__coreStdName=' + this.selectedtabname);
        //this.template.querySelector('c-plans-submission-child').modifyAnsTablesOnSubTypChange(event.detail,this.entityId,this.reportPeriodId)
    }

    coreStandardSet = new Set();

    fetchCoreStandards(){
        console.log(this.loadedFrmHomeEntityId)
      
        coreStandard({entityId:this.loadedFrmHomeEntityId,reportId :this.reportPeriodId})
            .then(result => {
                this.tabs = result;
                if (result != null) {
                    result.forEach(ele => {
                        if (ele.Core_Standard__r.Core_Standard_Number__c == 1) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab1 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 2) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab2 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 3) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab3 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 4) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab4 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 5) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab5 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 6) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab6 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 7) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab7 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 8) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab8 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 9) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab9 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 10) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab10 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }

                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 11 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab11 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }


                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 12 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab12 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 13 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab13 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 14 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab14 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 15 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab15 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 16 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab16 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 17 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab17 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 18 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab18 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 19 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab19 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }
                        else if (ele.Core_Standard__r.Core_Standard_Number__c == 20 && ele.Core_Standard__r.Core_Standard_Number__c!==null) {
                            this.coreStandardSet.add(ele.Core_Standard__c);
                            this.tab20 = {
                                Id: ele.Core_Standard__c,
                                Name: ele.Core_Standard__r.Name
                            }
                        }

                    });
                }
                this.getProgressBarDetail();
            })
            .catch(error => {
                this.error = error;
            });

    }

    connectedCallback() {
        this.isReportingPick = false
        this.isAllTabsVisible = false
        this.onLoad = true; 
        this.implementFlag = true;
        this.manCoreStd = false;
       
        
        if (this.selectedindexsubtype !== null) {
            let event = { detail: this.selectedindexsubtype };
            this.fetchValue(event);
        }

       
        if (this.selectedindexreportperiod !== null) {
         
            var repYear = this.selectedindexreportperiod + ';' + this.urlStateParameters.c__RepYearId;
            let event = { detail: repYear };
            this.fetchReportPeriod(event);
        }


        if (this.coreStdTemp != '' && this.coreStdTemp != null) {
            this.coreStdSelected = true;

            let event = { target: { label: this.coreStdNameTemp, value: this.coreStdTemp } };

            this.handleActive(event);

        }

    }
    progressBarList = [];

    getProgressBarDetail() {
        let questionCategory = new Set();
        questionCategory.add('Explanation and Good Practices');
        questionCategory.add('Minimum Standard and Evidence');
        let progressBarList = [];
        getQuestionsForProgressBar({
            coresStd: Array.from(this.coreStandardSet),
            qtnCat: Array.from(questionCategory),
            onlineSubId : this.onlineSubmissionId
        }).then(result => {
           
            for (let key in result) {
                
                let progressObj = { tabName: key, progressVal: result[key] };
                progressBarList.push(progressObj);
            }
            this.progressBarList = progressBarList;
           
        }).catch(error => {
            this.error = error;
        });
    }

    renderedCallback() {
   
        if (this.coreStdTemp != undefined && this.coreStdTemp != null) {
            this.template.querySelector('lightning-tabset').activeTabValue = this.coreStdTemp;
           
        }
       
    }
    taskBackupList = []
    handleTaskAddition(event){
        this.taskBackupList= event.detail.value;
        this.taskRecList = event.detail.value;
    }

    async handleTabSelection(event) {
        this.ischangedtab1=false;
        this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;
        this.getProgressBarDetail()
        
        
        this.coreStdSelected = false;

        
        if (!this.onLoad) {
          
            this.coreStdTemp = event.target.value;
        
        }

        //This is event to hide chatter section when we click on General & Summary and submit for approval Tab
        var eveVal = { 'entityId': '', 'reportPeriodId': '', 'coresStdValue': '', 'tabType': 'nonCore' };
        const tabChangeEvent = new CustomEvent('tabChange', {
            detail: { eveVal }
        });
        this.dispatchEvent(tabChangeEvent);
        

        if(this.unsavedAnswers){
            this.handleAlert("Please Save The Answer(s) in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Answer(s)')
            return
        }
        if(this.unsavedTasks){
            this.handleAlert("Please Save The Task(s) in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Task(s)')
            this.taskRecList  = this.taskBackupList 
            return
        }
        if(this.unsavedPartner){
            this.handleAlert("Please Save The Partner Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Partner Table)')
            return
        }
        if(this.unsavedTraining){
            this.handleAlert("Please Save The Training Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Training Table')
            return
        }
        if(this.unsavedProject){
            this.handleAlert("Please Save The Project Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Project Table')
            return
        }
        this.taskBackupList=[];
        this.template.querySelector('c-all-evidences').getAllEvidences()
    }


    handleActive(event) {
        this.ischangedtab1=false;
        this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;
       
        
        this.selectedtabname = event.target.label;
         if(this.selectedtabname==='CS1 Plan'){
         this.ischangedtab1=true;
        this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;   
       }
        if(this.selectedtabname==='CS2 Focal Points'){
         this.ischangedtab2=true;  
        this.ischangedtab1=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false; 
       }
        if(this.selectedtabname==='CS3 CoC'){
         this.ischangedtab3=true;
         this.ischangedtab2=false;
        this.ischangedtab1=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;   
       }
        if(this.selectedtabname==='CS4 Recruitment & Screening'){
         this.ischangedtab4=true; 
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab1=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;  
       }
        if(this.selectedtabname==='CS5 Training'){
         this.ischangedtab5=true; 
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab1=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;  
       }
        if(this.selectedtabname==='CS6 Reporting & Responding'){
         this.ischangedtab6=true; 
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab1=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;  
       }
        if(this.selectedtabname==='CS7 Feedback and Complaints'){
         this.ischangedtab7=true; 
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab1=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false;  
       }
        if(this.selectedtabname==='CS8 Partners'){
         this.ischangedtab8=true;  
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab1=false;
        this.ischangedtab9=false;
        this.ischangedtab10=false; 
       }
        if(this.selectedtabname==='CS9 Risk Assessment'){
         this.ischangedtab9=true;  
         this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab1=false;
        this.ischangedtab10=false; 
       }
        if(this.selectedtabname==='CS10 Images and Personal Info'){
         this.ischangedtab10=true; 
        this.ischangedtab2=false;
        this.ischangedtab3=false;
        this.ischangedtab4=false;
        this.ischangedtab5=false;
        this.ischangedtab6=false;
        this.ischangedtab7=false;
        this.ischangedtab8=false;
        this.ischangedtab9=false;
        this.ischangedtab1=false;  
       }
        
       if(this.unsavedAnswers){
        this.handleAlert("Please Save The Answer(s) in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Answer(s)')
        return
        }
        if(this.unsavedTasks){
            this.taskRecList = this.taskBackupList
            this.handleAlert("Please Save The Task(s) in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Task(s)')
            return
        }
        if(this.unsavedPartner){
            this.handleAlert("Please Save The Partner Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Partner Table')
            return
        }
        if(this.unsavedTraining){
            this.handleAlert("Please Save The Training Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Training Table')
            return
        }
        if(this.unsavedProject){
            this.handleAlert("Please Save The Project Table in "+this.coreStandardName+" Before Moving To The Next Tab", 'info', 'Unsaved Project Table')
            return
        }
       this.taskBackupList =[];


        this.selectedTabShort = this.selectedtabname.split(' ')[0];
        
        this.selectedtabvalue = event.target.value;
        
        this.coreStdTemp = event.target.value;
        
        this.coreStdSelected = true;
        window.history.pushState({}, null, 'Plans_And_Reports_Submission_Page?c__id=' + this.selectedindexentity + '&c__subType=' + this.submissionType + '&c__RepYearName=' + this.reportPeriodName + '&c__RepYearId=' + this.reportPeriodId + '&c__coreStd=' + this.selectedtabvalue + '&c__coreStdName=' + this.selectedtabname);
        this.activeValueMessage = event.target.value;
        this.manCoreStd = false;
        if (this.mandatoryCoreStd != null) {
            this.mandatoryCoreStd.forEach(elem => {
                if (elem.Core_Standard__r.Name == event.target.label) {
                    this.manCoreStd = true;
                }
            });
        }

        this.coresStdValue = event.target.label;

        coreStandardEntityRecord({ entityName: this.entityId, corestdName: this.coresStdValue, reportid: this.reportPeriodId })
            .then(result => {
                //refreshApex(result);
                this.corestdentityid = result.Id;


                this.currentUrlToPass = window.location.href
                updateCoreStandEntityFieldWithURL({ urlToPass: this.currentUrlToPass, subType: this.submissionType, coreStdId: this.corestdentityid })
                    .then(result => {
                        if (result === 'success') {

                        }
                    })
                    .catch(error => {
                        console.error('error while updating record')
                    })
            })
            .catch(error => {
                this.corestdentityid = undefined;
                console.log('Error displaying core standard values', error);
            });

        updateOnlineSubFieldWithCS({ corestd: this.selectedTabShort, onlineSubId: this.onlineSubmissionId })
            .then(result => {

            }).catch(error => {
                console.log(error)
            })

        getCoreStandardGuidence({ coresStd: this.coresStdValue })
            .then(result => {
                this.coreStandardList = result;
                this.corestdId = this.coreStandardList;
            })
            .catch(error => {
                console.error('Error displaying core standard values')
            });

        this.taskRecList = [];
            
        try{
            let result = this.template.querySelector('c-plans-submission-child').notifyChangeToChild();
        }catch(error){
            console.log(error)
        }

        // this event is listened by chatterRecordCompAura 
        var eveVal = { 'entityId': this.entityId, 'reportPeriodId': this.reportPeriodId, 'coresStdValue': this.coresStdValue, 'tabType': 'Core' };
        const tabChangeEvent = new CustomEvent('tabChange', {
            detail: { eveVal }
        });
        this.dispatchEvent(tabChangeEvent);
        this.FillAllObjects();
    }
     
    loadOnlineSub() {
        this.ClearObjects()
        getOnlineSub({ entityId: this.selectedindexentity })
            .then(result => {
                
                this.onlineSubmissionId = result.Id;
                this.onlineSubName = result.Name__c;
                this.onlineSubRole = result.Role__c;
                this.onlineSubEmail = result.Email__c;
                this.entityName = result.Entity__r.Name;
                this.entityId = result.Entity__c;
                
                
                this.FillAllObjects();
            })
            .catch(error => {
                this.error = error.message;
                console.log('error==>' + this.error);
            });
    }

    FillAllObjects() {
        getTask({ onlineSubId: this.onlineSubmissionId })
            .then(result => {

                if (result.length > 0) {
                    this.taskRecList1.pop();
                    for (var key in result) {

                        this.taskRecList1.push({
                            Id: result[key].Id, key: key, Due_Date__c: result[key].Due_Date__c, Status__c: result[key].Status__c,
                            Person_Responsible_For_The_Activity__c: result[key].Person_Responsible_For_The_Activity__c, Completion_Date__c: result[key].Completion_Date__c,
                            Comments__c: result[key].Comments__c, Key_Task__c: result[key].Key_Task__c, coreStandard: result[key].Core_Standard_Entity__c,
                            coreStandardId: result[key].Core_Standard_Entity__r.Core_Standard__c, isexisting: true
                        });
                    }
                    if(this.taskBackupList){
                        if(this.taskBackupList.length >0){

                            this.taskRecList = this.taskBackupList
                        }
                    }
                    
                    pubsub.fire('fireTaskInfoEvent', this.taskRecList1);
                } else {
                    this.taskRecList1 = [];

                    pubsub.fire('fireTaskInfoEvent', this.taskRecList1);
                }

            })
            .catch(error => {
                this.error = error;
            });

        getAnswer({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                this.retrivedAnswer = result;
                this.onLoad = false;
            })
            .catch(error => {
                this.error = error;
            });

        getSafeFocalPoint({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                if (result.length > 0) {
                    this.SafeFocalPtItems.pop();
                    for (var key in result) {
                        this.SafeFocalPtItems.push({ key: key, Id: result[key].Id, Name: result[key].Name, Office_Sub_Office__c: result[key].Office_Sub_Office__c });
                    }
                }
                //pubsub.fire('firesafeFocalEvent',this.taskRecList1);
            })
            .catch(error => {
                this.error = error;
            });

        getSafeInfoProv({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                if (result.length > 0) {
                    this.safeInformationProvider.pop();
                    for (var key in result) {
                        this.safeInformationProvider.push({ key: key, Id: result[key].Id, Name: result[key].Name, Role__c: result[key].Role__c, Type_Of_Information__c: result[key].Type_Of_Information__c });
                    }
                }
            })
            .catch(error => {
                this.error = error;
            });

        getTraining({ onlineSubId: this.onlineSubmissionId })
            .then(result => {

                if (result.length > 0) {
                    this.trainingList.pop();
                    for (var key in result) {
                        this.trainingList.push({
                            Id: result[key].Id, key: key, Name: result[key].Name, Attendance_Sheet__c: result[key].Attendance_Sheet__c,
                            Code_of_Conduct__c: result[key].Code_of_Conduct__c, Date_Of_Training__c: result[key].Date_Of_Training__c,
                            Description_Of_Training__c: result[key].Description_Of_Training__c, Number_of_community__c: result[key].Number_of_community__c, coreStandard: result[key].Core_Standard_Entity__c,
                            Number_of_Oxfam_staff__c: result[key].Number_of_Oxfam_staff__c, Number_of_partners__c: result[key].Number_of_partners__c,
                            PSEA_Policy__c: result[key].PSEA_Policy__c, Question__c: result[key].Question__c,
                            Safeguarding_Policy__c: result[key].Safeguarding_Policy__c, Total_Trained__c: result[key].Total_Trained__c,
                            Who_Delivered_the_Training__c: result[key].Who_Delivered_the_Training__c, Other_evidence__c: result[key].Other_evidence__c,
                            Training_materials__c: result[key].Training_materials__c
                        });
                    }
                }

            })
            .catch(error => {
                this.error = error;
            });

        getPartner({ onlineSubId: this.onlineSubmissionId })
            .then(result => {

            this.partnerList = [];
                if (result.length > 0) {
                  //  this.partnerList.pop();
                    for (var key in result) {
                        this.partnerList.push({
                            Id: result[key].Id,
                            key: key,
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
                    }
                }

            })
            .catch(error => {
                this.error = error;
            });

        getProject({ onlineSubId: this.onlineSubmissionId })
            .then(projresult => {
                    this.projectList = [];
                if (projresult.length > 0) {
                   // this.projectList.pop();
                    for (var key in projresult) {
                        this.projectList.push({
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
                
                }

            })
            .catch(error => {
                this.error = error;
            });

        getSummary({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                if (result != null) {
                    this.summaryId = result.Id;
                    this.summaryList = {
                        CS4_Interview_Template__c: result.CS4_Interview_Template__c,
                        CS4_Reference_Check_Template__c: result.CS4_Reference_Check_Template__c,
                        CS5_Training_Records__c: result.CS5_Training_Records__c,
                        CS6_Safeguarding_Reporting_Procedure__c: result.CS6_Safeguarding_Reporting_Procedure__c,
                        CS7_Examples_of_community_level_feedback__c: result.CS7_Examples_of_community_level_feedback__c,
                        CS8_Sample_Partner_Capacity_Assessment__c: result.CS8_Sample_Partner_Capacity_Assessment__c,
                        CS8_Sample_Partner_Working_Agreement__c: result.CS8_Sample_Partner_Working_Agreement__c,
                        CS10_Informed_Consent_Template__c : result.CS10_Informed_Consent_Template__c,
                        Sumamry_Challanges__c: result.Sumamry_Challanges__c,
                        Summary_Achievements__c: result.Summary_Achievements__c,
                        Summary_Support_Needed__c: result.Summary_Support_Needed__c
                    };
                }
            })
            .catch(error => {
                this.error = error;
            });

        if (this.selectedindexentity != "") {
            checkCoreStandardMandatory({ entityName: this.entityName })
                .then(result => {
                    this.mandatoryCoreStd = result;
                })
                .catch(error => {
                    this.error = error;
                });
        }

        if (this.submissionType != "" && this.submissionType == "Implementation Plan") {
            this.implementFlag = false;
        }
        else {
            this.implementFlag = true;
        }

    }

    OnSumbitInf() {
        this.isLoading = true
        this.onlineSubName = this.template.querySelector('.onlineSubName').value;
        this.onlineSubRole = this.template.querySelector('.onlineSubRole').value;
        this.onlineSubEmail = this.template.querySelector('.onlineSubEmail').value;
        let isSuccess = false;
        if (this.submissionType == "" && this.entityId == "" && this.reportPeriodId == "" &&
            this.onlineSubName == "" && this.onlineSubRole == "" && this.onlineSubEmail == "") {
            alert("Enter all mandatory fields");
             this.isLoading = false;
            return;
        }
        let checkMandatory= false;
         this.safeInformationProvider.forEach(safe => {
             if(!safe.Name){
                 checkMandatory = true;
             }
         });

         this.SafeFocalPtItems.forEach(safe => {
             if(!safe.Name){
                 checkMandatory = true;
                 this.isLoading = false;
             }
         });

         if(checkMandatory){
              alert("Enter all mandatory fields");
            return;
         }

        if (this.onlineSubmissionId == undefined || (this.loadedFrmHomeEntityId != null && this.entityId != this.loadedFrmHomeEntityId)) {


            this.onlineSubmission = {
                Name__c: this.onlineSubName,
                Role__c: this.onlineSubRole,
                Email__c: this.onlineSubEmail,
                Submission_Type__c: this.submissionType,
                Entity__c: this.loadedFrmHomeEntityId != null ? this.loadedFrmHomeEntityId : this.entityId,
                Reporting_Period__c: this.reportPeriodId
            };
            insertOnlineSub({ onlineSubmission: this.onlineSubmission })
                .then(result => {

                    this.onlineSubmissionId = result.Id;
                    isSuccess = true;
                    this.isLoading = false
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
                    isSuccess = false;
                    this.isLoading = false
                });
            setTimeout(function () {
                this.SafeFocalPtItems.forEach(safe => {
                    if(safe.name !=null && safe.Name!='' && safe.Name!= undefined ){
                    this.safeFocalPoint = {
                        Name: safe.Name == ''? null : safe.Name,
                        Office_Sub_Office__c: safe.Office_Sub_Office__c==''? null : safe.Office_Sub_Office__c,
                        Online_Submission__c: this.onlineSubmissionId
                    };
                    }


                    createSafeFocalPoint({ safeFocalPoint: this.safeFocalPoint })
                        .then(result => {
                            this.error = undefined;
                            if (this.message !== undefined) {
                                isSuccess = true;

                            }
                        })

                        .catch(error => {
                            isSuccess = false;
                        });
                });
                
                this.safeInformationProvider.forEach(safe => {
                    this.safeInfoProv={};
                    if( safe.Name !=null && safe.Name!=''  && safe.Name!= undefined){
                    this.safeInfoProv = {
                        Name: safe.Name == ''? null : safe.Name,
                        Role__c: safe.Role__c == ''? null : safe.Role__c,
                        Type_Of_Information__c: safe.Type_Of_Information__c == ''? null : safe.Type_Of_Information__c,
                        Online_Submission__c: this.onlineSubmissionId
                    };
                    }


                    createSafeInfoProv({ safeInfoProv: this.safeInfoProv })
                        .then(result => {

                            this.error = undefined;
                            if (this.message !== undefined) {
                                isSuccess = true;
                            }
                        })

                        .catch(error => {
                            isSuccess = false;
                        });
                });
            }.bind(this), 3000);
            if (isSuccess) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved',
                        variant: 'success',
                    }),
                );
            }
            else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on Creation of Online Submission',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );

            }
        }
        else {
            this.onlineSubmission = {
                Id: this.onlineSubmissionId,
                Name__c: this.onlineSubName,
                Role__c: this.onlineSubRole,
                Email__c: this.onlineSubEmail,
                Submission_Type__c: this.submissionType,
                Entity__c: this.entityId,
                Reporting_Period__c: this.reportPeriodId
            };

            updateOnlineSub({ onlineSubmission: this.onlineSubmission })
                .then(result => {
                    this.isLoading = false
                    this.onlineSubmissionId = result.Id;
                    this.error = undefined;
                    if (this.message !== undefined) {
                        isSuccess = true;
                    }
                    this.SafeFocalPtItems.forEach(safe => {

                        this.safeFocalPoint = {
                            Id: safe.Id == '' ? null : safe.Id,
                            Name: safe.Name,
                            Office_Sub_Office__c: safe.Office_Sub_Office__c,
                            Online_Submission__c: this.onlineSubmissionId
                        };
                        createSafeFocalPoint({ safeFocalPoint: this.safeFocalPoint }).then(result => {
                            isSuccess = true;
                        }).catch(error => {
                            isSuccess = false;
                            
                        });
                    });
                    this.safeInformationProvider.forEach(safe => {

                        this.safeInfoProv = {
                            Id: safe.Id == '' ? null : safe.Id,
                            Name: safe.Name,
                            Role__c: safe.Role__c,
                            Type_Of_Information__c: safe.Type_Of_Information__c,
                            Online_Submission__c: this.onlineSubmissionId
                        };
                        createSafeInfoProv({ safeInfoProv: this.safeInfoProv })
                            .then(result => {
                                isSuccess = true;
                            })

                            .catch(error => {
                                isSuccess = false;
                            });
                    });
                })

                .catch(error => {

                    this.message = undefined;
                    this.errror = error;
                    isSuccess = false;
                    this.isLoading = false
                });

            setTimeout(function () {


                if (isSuccess) {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Saved',
                            variant: 'success',
                        }),
                    );
                }
                else if (!isSuccess) {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error on Creation of Online Submission',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );

                }
            }, 3000);

        }
    }



    @api
    myRecordId;

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert('No. of files uploaded : ' + uploadedFiles.length);
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
    @track taskRecList = [];
    taskRecList1 = [];
    // this is to handle add row button
    handleaddRow() {
        this.safeTaskIndex++;
        this.taskRecList = [...this.taskRecList, {
            key: this.taskRecList.length,
            coreStandardId: this.activeValueMessage
        }];
        this.taskRecList1 = [...this.taskRecList1, {
            key: this.taskRecList1.length,
            coreStandardId: this.activeValueMessage
        }];
    }

    delTask(event) {
        this.taskRecList.splice(event.target.dataset.id, 1);
        this.taskRecList1.splice(event.target.dataset.id, 1);
    }
    // to save the Task record
    tskList;


    handleonsave() {

        this.taskRecList.forEach(safe => {
            if (!this.implementFlag) {
                this.tskList = {
                    Core_Standard_Entity__c: this.corestdentityid,
                    Online_Submission__c: this.onlineSubmissionId,
                    Reporting_Period__c: this.reportPeriodId,
                    Key_Task__c: safe.Key_Task__c,
                    Due_Date__c: safe.Due_Date__c,
                    Completion_Date__c: safe.Completion_Date__c,
                    Person_Responsible_For_The_Activity__c: safe.Person_Responsible_For_The_Activity__c,
                    Comments__c: safe.Comments__c,
                    Status__c: safe.Status__c
                };
            }
            else {
                this.tskList = {
                    Core_Standard_Entity__c: this.corestdentityid,
                    Online_Submission__c: this.onlineSubmissionId,
                    Reporting_Period__c: this.reportPeriodId,
                    Key_Task__c: safe.Key_Task__c,
                    Comments__c: safe.Comments__c,
                    Due_Date__c: safe.Due_Date__c,
                    Completion_Date__c: safe.Completion_Date__c,
                    Person_Responsible_For_The_Activity__c: safe.Person_Responsible_For_The_Activity__c,
                    Status__c: safe.Status__c
                };

            }
            saveTask({ taskList: this.tskList })
                .then(result => {
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
                            title: 'Error Creating Task',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        });
    }

    handleonchange(event) {
        if (event.target.name == 'KeyTask')
            this.taskRecList[this.safeTaskIndex].Key_Task__c = event.target.value;
        else if (event.target.name == 'DueDate')
            this.taskRecList[this.safeTaskIndex].Due_Date__c = event.target.value;
        else if (event.target.name == 'TaskCompletionDate')
            this.taskRecList[this.safeTaskIndex].Completion_Date__c = event.target.value;
        else if (event.target.name == 'PersonResponsible')
            this.taskRecList[this.safeTaskIndex].Person_Responsible_For_The_Activity__c = event.target.value;
        else if (event.target.name == 'comments')
            this.taskRecList[this.safeTaskIndex].Comments__c = event.target.value;

        this.taskRecList1 = this.taskRecList;
    }
    handleChange(event) {
        this.taskRecList[this.safeTaskIndex].Status__c = event.target.value;
        this.taskRecList1 = this.taskRecList;
    }

    handleSectionToggle(event) {
        this.section = event.detail.openSections;

    }

    handleOnSaveSummary() {
        if (this.onlineSubmissionId != null) {
            let i;
            let CS4_Interview_Template__c = false;
            let CS4_Reference_Check_Template__c = false;
            let CS5_Training_Records__c = false;
            let CS6_Safeguarding_Reporting_Procedure__c = false;
            let CS7_Examples_of_community_level_feedback__c = false;
            let CS8_Sample_Partner_Capacity_Assessment__c = false;
            let CS8_Sample_Partner_Working_Agreement__c = false;
            let CS10_Informed_Consent_Template__c = false;
            let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
            let Summary_Achievements__c = this.template.querySelector(".SummaryAchievements").value;
            let Sumamry_Challanges__c = this.template.querySelector(".SummaryChallanges").value;
            let Summary_Support_Needed__c = this.template.querySelector(".SummarySupportNeeded").value;
            for (i = 0; i < checkboxes.length; i++) {
                if (i == 0) {
                    CS4_Interview_Template__c = checkboxes[i].checked;
                }
                else if (i == 1) {
                    CS4_Reference_Check_Template__c = checkboxes[i].checked;
                }
                else if (i == 2) {
                    CS5_Training_Records__c = checkboxes[i].checked;
                }
                else if (i == 3) {
                    CS6_Safeguarding_Reporting_Procedure__c = checkboxes[i].checked;
                }
                else if (i == 4) {
                    CS7_Examples_of_community_level_feedback__c = checkboxes[i].checked;
                }
                else if (i == 5) {
                    CS8_Sample_Partner_Capacity_Assessment__c = checkboxes[i].checked;
                }
                else if (i == 6) {
                    CS8_Sample_Partner_Working_Agreement__c = checkboxes[i].checked;
                } 
                else if (i == 7) {
                    CS10_Informed_Consent_Template__c = checkboxes[i].checked;
                }
            }

            let summaryRecList = {
                Id: this.summaryId == '' ? null : this.summaryId,
                Online_Submission__c: this.onlineSubmissionId,
                CS4_Interview_Template__c: CS4_Interview_Template__c,
                CS4_Reference_Check_Template__c: CS4_Reference_Check_Template__c,
                CS5_Training_Records__c: CS5_Training_Records__c,
                CS6_Safeguarding_Reporting_Procedure__c: CS6_Safeguarding_Reporting_Procedure__c,
                CS7_Examples_of_community_level_feedback__c: CS7_Examples_of_community_level_feedback__c,
                CS8_Sample_Partner_Capacity_Assessment__c: CS8_Sample_Partner_Capacity_Assessment__c,
                CS8_Sample_Partner_Working_Agreement__c: CS8_Sample_Partner_Working_Agreement__c,
                CS10_Informed_Consent_Template__c : CS10_Informed_Consent_Template__c,
                Sumamry_Challanges__c: Sumamry_Challanges__c,
                Summary_Achievements__c: Summary_Achievements__c,
                Summary_Support_Needed__c: Summary_Support_Needed__c
            };
            createSummary({ summaryList: summaryRecList })
                .then(result => {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved',
                        variant: 'success',
                    }),
                    );

                    this.handleSummary();
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error on Summary',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        }
    }

    handleOnSaveEvidence() {
        if (this.onlineSubmissionId != null) {
            let i;
            let CS4_Interview_Template__c = false;
            let CS4_Reference_Check_Template__c = false;
            let CS5_Training_Records__c = false;
            let CS6_Safeguarding_Reporting_Procedure__c = false;
            let CS7_Examples_of_community_level_feedback__c = false;
            let CS8_Sample_Partner_Capacity_Assessment__c = false;
            let CS8_Sample_Partner_Working_Agreement__c = false;
            let CS10_Informed_Consent_Template__c = false;
            let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
            for (i = 0; i < checkboxes.length; i++) {
                if (i == 0) {
                    CS4_Interview_Template__c = checkboxes[i].checked;
                }
                else if (i == 1) {
                    CS4_Reference_Check_Template__c = checkboxes[i].checked;
                }
                else if (i == 2) {
                    CS5_Training_Records__c = checkboxes[i].checked;
                }
                else if (i == 3) {
                    CS6_Safeguarding_Reporting_Procedure__c = checkboxes[i].checked;
                }
                else if (i == 4) {
                    CS7_Examples_of_community_level_feedback__c = checkboxes[i].checked;
                }
                else if (i == 5) {
                    CS8_Sample_Partner_Capacity_Assessment__c = checkboxes[i].checked;
                }
                else if (i == 6) {
                    CS8_Sample_Partner_Working_Agreement__c = checkboxes[i].checked;
                }
                else if (i == 7) {
                    CS10_Informed_Consent_Template__c = checkboxes[i].checked;
                }
            }

            let summaryRecList = {
                Id: this.summaryId == '' ? null : this.summaryId,
                Online_Submission__c: this.onlineSubmissionId,
                CS4_Interview_Template__c: CS4_Interview_Template__c,
                CS4_Reference_Check_Template__c: CS4_Reference_Check_Template__c,
                CS5_Training_Records__c: CS5_Training_Records__c,
                CS6_Safeguarding_Reporting_Procedure__c: CS6_Safeguarding_Reporting_Procedure__c,
                CS7_Examples_of_community_level_feedback__c: CS7_Examples_of_community_level_feedback__c,
                CS8_Sample_Partner_Capacity_Assessment__c: CS8_Sample_Partner_Capacity_Assessment__c,
                CS8_Sample_Partner_Working_Agreement__c: CS8_Sample_Partner_Working_Agreement__c,
                CS10_Informed_Consent_Template__c : CS10_Informed_Consent_Template__c
            };
            createSummary({ summaryList: summaryRecList })
                .then(result => {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved',
                        variant: 'success',
                    }),
                    );

                    this.handleSummary();
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error on Summary',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        }
    }

    handleSummary() {
        getSummary({ onlineSubId: this.onlineSubmissionId })
            .then(result => {
                if (result != null) {
                    this.summaryList = [];
                    this.summaryId = result.Id;
                    this.summaryList = {
                        CS4_Interview_Template__c: result.CS4_Interview_Template__c,
                        CS4_Reference_Check_Template__c: result.CS4_Reference_Check_Template__c,
                        CS5_Training_Records__c: result.CS5_Training_Records__c,
                        CS6_Safeguarding_Reporting_Procedure__c: result.CS6_Safeguarding_Reporting_Procedure__c,
                        CS7_Examples_of_community_level_feedback__c: result.CS7_Examples_of_community_level_feedback__c,
                        CS8_Sample_Partner_Capacity_Assessment__c: result.CS8_Sample_Partner_Capacity_Assessment__c,
                        CS8_Sample_Partner_Working_Agreement__c: result.CS8_Sample_Partner_Working_Agreement__c,
                        CS10_Informed_Consent_Template__c : result.CS10_Informed_Consent_Template__c,
                        Sumamry_Challanges__c: result.Sumamry_Challanges__c,
                        Summary_Achievements__c: result.Summary_Achievements__c,
                        Summary_Support_Needed__c: result.Summary_Support_Needed__c
                    };
                }
            })
            .catch(error => {
                this.error = error;
            });
    }

   

    get isSubmitDisabled() {
        return (this.approvalStatus === 'For Approval' || this.approvalStatus === 'Approved') ? true : false
    }
    

}