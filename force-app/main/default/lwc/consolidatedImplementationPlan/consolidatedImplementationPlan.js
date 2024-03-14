import { LightningElement, wire, track } from 'lwc';
import getTaskList from '@salesforce/apex/TaskController.getConsolidatedTask1';
import { exportCSVFile } from 'c/utils';
import {NavigationMixin} from 'lightning/navigation'; 
import UpdateTasks from '@salesforce/apex/TaskController.UpdateTasks';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import refreshApex from '@salesforce/apex';
import {  CurrentPageReference } from 'lightning/navigation';
//import checkForExistingSubmission from '@salesforce/apex/TaskController.checkForExistingSubmission';
// datatable columns with row actions. Set sortable = true
const columns = [
    { label: 'Task Reference', fieldName: 'Name', sortable: true, type: 'text',initialWidth:150 },
    { label: 'ReportingPeriod', fieldName: 'ReportingPeriod', sortable: true, type: 'text',initialWidth:150 },
    { label: 'CoreStandard', fieldName: 'CoreStandard', sortable: true, type: 'text',initialWidth:150 },
    { label: 'Key Task', fieldName: 'Key_Task__c', sortable: true, type: 'text', editable: true,initialWidth:150  },
    { label: 'Due Date', fieldName: 'Due_Date__c', sortable: true, type: 'date-local', editable: true,initialWidth:150  },
    { label: 'Person Responsible', fieldName: 'Person_Responsible_For_The_Activity__c', sortable: true, type: 'text', editable: true,initialWidth:170  },
    { label: 'Status', fieldName: 'Status__c', sortable: true, type: 'statusPicklist', editable: false,wrapText:true,initialWidth:230,
        typeAttributes:{
            options:{fieldName:'pickListOptions'},
            value: {fieldName: 'Status__c'},
            placeholder : 'Select Status',
            context: { fieldName: 'Id' }
            
        } 
    },
    { label: 'Comments/Updates', fieldName: 'Comments__c', sortable: true, type: 'CommentsTextArea', editable: false,initialWidth:250 ,wrapText:true,
        typeAttributes: {
            comments:{fieldName:'CommentsTextArea'},
            value: {fieldName: 'Comments__c'},
            placeholder : 'Comment Here',
            context: { fieldName: 'Id' }
            }  
    },
    { label: 'Completion date (only if task already completed)', fieldName: 'Completion_Date__c', sortable: true, type: 'date-local', editable: true ,initialWidth:150 },
];


export default class ConsolidatedImplementationPlan extends NavigationMixin(LightningElement) {
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @track tempData;
    @track fullTableData = [];
    @track filteredTableData = [];
    @track timer;
    @track filterBy = 'Key_Task__c';
    @track fieldItemValues = [];
    notifyChangeIds;
    fldsItemValues = [];
    @track isLoading = false
    lastSavedData = [];
    @track consolidateImpPlanMesssage='<h3>Guidance:</h3><b>New tasks cannot be created </b> from the Consolidated Implementation Plan.  New tasks can only be created from an online submission such as an Implementation Plan, 6 Month Progress Report or Annual Report.</br>To create a new task, go to the Country Homepage, then click on the <b>“Draft and Submit New Plans and Reports”</b> button.  Select the Plan or Report for the current reporting period, then navigate to relevant  Core Standard tab (you may need to fill in the General tab first).  Create the task in the Task section and click the Save Task button.  The task will now appear in the Consolidated Implementation Plan.';

    @track pickListOptions = [
        { label: "Completed", value: "Completed" },
        { label: "In-Progress", value: "In-Progress" },
        { label: "Not Applicable Anymore", value: "Not Applicable Anymore" },
        { label: "Not Started", value: "Not Started" }
    ];
    

    // headers for generating csv
    TaskHeaders = {
        Name: "Task Ref",
        ReportingPeriod: "Reporting Period",
        CoreStandard: "Core Standard",
        Key_Task__c: "Key Task",
        Due_Date__c: "Due Date",
        Person_Responsible_For_The_Activity__c: "Person Responsible",
        Status__c: "Status",
        Comments__c: "Comments",
        Completion_Date__c: "Completion Date",
    }



    /* this is for bulk record updation*/
    //==================================
   async refresh() {
    await refreshApex(this.data);
   }
    taskObj;
    async saveHandleAction(event) {
        this.isLoading = true
        this.fldsItemValues = event.detail.draftValues;
        const inputsItems = this.fldsItemValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = this.fldsItemValues.map(row => { return { "Id": row.Id } });
       
        const promises = inputsItems.map(recordInput => UpdateTasks({data: recordInput}));
        Promise.all(promises).then(res => {
            this.isLoading = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Task Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.fldsItemValues = [];	
           
            // Refresh LDS cache and wires
            getRecordNotifyChange(notifyChangeIds);
            this.getConsolidatedTask(this.loadedFrmHomeEntityId); 
        }).catch(error => {
            this.isLoading = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.fldsItemValues = [];
        });
    //}.bind(this), 1500);

    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
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
        this.data = parseData;
    }

    //search Logic starts here

    handleSearch(event) {
        const { value } = event.target
        window.clearTimeout(this.timer)
        if (value) {
            this.timer = window.setTimeout(() => {
                this.data = this.data.filter(eachObj => {
                    const val = eachObj[this.filterBy] ? eachObj[this.filterBy] : ''
                    return val.toLowerCase().includes(value)
                    
                })
            }, 200)

        } else {            
            this.getConsolidatedTask(this.loadedFrmHomeEntityId); 
        }
    }

    get filterByOption() {

        return [
            { label: "Key Task", value: "Key_Task__c" },
            { label: "Due Date", value: "Due_Date__c" },
            { label: "Person Responsible", value: "Person_Responsible_For_The_Activity__c" },
            { label: "Reporting Period", value: "ReportingPeriod" },
            { label: "Status", value: "Status__c" },
            { label: "Core Standard", value: "CoreStandard" }
        ]
    }

    handleSearchBy(event) {
        this.filterBy = event.target.value
    }

    handleBackButton() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Country_HomePage" 
            },
             state: {
                "c__id": this.selectedindexentity
            }
        });
    }

    handleCreateTask() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Plans_And_Reports_Submission_Page"
            }
            , state: {
                "c__id": this.selectedindexentity,
            }
        });

    }

    // csv generation logic starts here
    handleCSVGenerator() {
        exportCSVFile(this.TaskHeaders, this.data, "Consolidated_Implementation_Plan")
    }
    @track entityName;
    entityId
    fetchEntityValue(event) {
        this.entityName = event.detail.split(';')[0];
        this.entityId = event.detail.split(';')[1];
        this.getConsolidatedTask(this.entityId);
    }
    
    currentPageReference = null;
    urlStateParameters = null;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }
    selectedindexentity;loadedFrmHomeEntityId;loadedFrmHomeEntityName
    setParametersBasedOnUrl() {
        this.selectedindexentity = this.urlStateParameters.c__id || null;
        this.loadedFrmHomeEntityId = this.selectedindexentity!= null ?this.selectedindexentity.split(';')[1]: null;
        this.loadedFrmHomeEntityName = this.selectedindexentity!= null ?this.selectedindexentity.split(';')[0]: null;
        this.getConsolidatedTask(this.loadedFrmHomeEntityId);
    }
    @track submissionType;
    //@track selectedindexsubtype;
    //isSubTypeSelected=false;
    fetchValue(event){
    this.submissionType = event.detail;
    this.selectedindexsubtype = this.submissionType
    //this.isSubTypeSelected=true;
    this.getConsolidatedTask(this.loadedFrmHomeEntityId);
}
    
    handleRefreshClick() {
        const entityId = this.loadedFrmHomeEntityId; 
        this.getConsolidatedTask(entityId);
    }

    getConsolidatedTask(entityId)
    {
        this.isLoading = true
        getTaskList({entId:entityId})  
                .then(result => {
                    this.isLoading = false
                    let tempData = JSON.parse(JSON.stringify(result));
                    tempData = tempData.map(row => {
                        return { ...row, ReportingPeriod: row.Reporting_Period__r.Name, CoreStandard: row.Core_Standard_Entity__c!= null?row.Core_Standard_Entity__r.Core_Standard__r.Name :''};
                    });
                    
                    this.data = tempData;

                    this.data.forEach(ele => {
                        ele.pickListOptions = this.pickListOptions;
                    })
                    this.lastSavedData = JSON.parse(JSON.stringify(this.data));
                    
                    
                })
                .catch(error => {
                    this.isLoading = false
              this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'An Error Occured!!',
                            variant: 'error'
                        })
                    );
                });
    }

    handleCellValueChange(event){
        event.stopPropagation()
        let dataRecievedTextArea = event.detail.data;
        let UpdatedItemTextArea = {Id: dataRecievedTextArea.context, 
                                   Comments__c: dataRecievedTextArea.value 
                                  }

        this.updateDraftValues(UpdatedItemTextArea);
        this.updateDataValues(UpdatedItemTextArea);
                            
    }

    picklistChanged(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem = { Id: dataRecieved.context, Status__c: dataRecieved.value };
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
 
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
 
        //write changes back to original data
        this.data = [...copyData];
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.fldsItemValues];
        
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.fldsItemValues = [...copyDraftValues];
        } else {
            this.fldsItemValues = [...copyDraftValues, updateItem];
        }
    }

    //handler to handle cell changes & update values in draft values
    handleCellChange(event) {
        this.updateDraftValues(event.detail.draftValues[0]);
    }

    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.fldsItemValues = [];
    }

    generatePDFHandler(){
        this.loadedFrmHomeEntityId = this.selectedindexentity!= null ?this.selectedindexentity.split(';')[1]: null;
        this[NavigationMixin.GenerateUrl]({
        type: 'standard__webPage',
        attributes: {
            url: '/apex/ConslidatedImpPlanPDFPage?id=' + this.loadedFrmHomeEntityId+'&SubType='+this.submissionType
        }
        
    }).then(generatedUrl => {
        window.open(generatedUrl);
    });
}
}