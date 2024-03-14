import { LightningElement,track,api } from 'lwc';
import fetchAttachAndBoxLinkFromOnlineSubmission from '@salesforce/apex/FetchDataForBoxlinkAndAttachent.fetchAttachAndBoxLinkFromOnlineSubmission'

import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from "lightning/confirm";
import deleteFiles from '@salesforce/apex/FileUploaderCompHandler.deleteFiles'
import deleteBoxLink from '@salesforce/apex/FetchDataForBoxlinkAndAttachent.deleteBoxLink'

const columns = [
    { label:'Evidence Relates To', fieldName: 'QuestionName', type: 'text',sortable:true },
    { label:'Evidence Type', fieldName: 'evidenceType', type: 'text',sortable:true },
    { label:'Uploads', fieldName: 'Attachments', type: 'url',wrapTex: true,hideDefaultActions:true },
    { label:'Box Links', fieldName: 'BoxLinks', type: 'url',hideDefaultActions:true },
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

]

export default class AllEvidences extends LightningElement {

    @track columns = columns
    @api submissionId
    @track evidenceData
    @track sortBy;
    @track sortDirection;
    @track BoxLinkRec={}
    @track disableDeleteIcon = false;
    isFirstRender = true;


    connectedCallback(){
       
        this.getAllEvidences()
    }
 
    @api
    getAllEvidences(){
        if(this.submissionId)
       
        fetchAttachAndBoxLinkFromOnlineSubmission({onlineSubId : this.submissionId})
        .then(result=>{ 
            this.dispatchEvent(new RefreshEvent()); 
           
            this.evidenceData = result
        }).catch(error=>{
            console.log(error)
        })
    }

    @api
    callingSource(pageName){
        
        if(pageName === 'previousSubmissionPage'){
            this.columns = [...columns].filter(col => col.type != 'button-icon');
            
        }

        this.getAllEvidences()
    }

    handleRowAction(event) {
        const action = event.detail.action;
       
        const row = event.detail.row;
       

        switch (action.name) {
            case 'delete':
                if(row.Attachments){
                    this.deleteFile(row.Id);
                }else if(row.BoxLinks){
                    this.deleteBox(row.Id)
                }
                
                break;
            default:
                break;
        }
    }
    async deleteFile(fileId) {
       
        const deleteFileResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this File?",
            theme: "success",
            label: "Delete Confirmation"
        });
        if (deleteFileResult) {
            deleteFiles({ fileIds: [fileId] })
                .then(response => {
                   
                    this.evidenceData = this.evidenceData.filter(file => {
                        if (file.Attachments) {
                            return file.Id !== fileId;
                        }
                        return true; // Keep the entry if Attachments is missing or undefined
                    });
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Deleted',
                            variant: 'success', 
                        }),
                    );
                })
        }
    }

    async deleteBox(boxId){
        const deleteBoxResult = await LightningConfirm.open({
            message: "Are you sure you want to delete this Box Link?",
            theme: "success",
            label: "Delete Confirmation"
        });
        if(deleteBoxResult){
            this.BoxLinkRec = {
                Id: boxId
        }
        deleteBoxLink({ BoxLinkRec: this.BoxLinkRec })
                .then(result => {
                    this.evidenceData = this.evidenceData.filter(box => {
                        if (box.BoxLinks) {
                            return box.Id !== boxId
                        }
                        return true // Keep the entry if box links is missing or undefined
                    })
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Deleted',
                                variant: 'success',
                            }),
                        )
                }) .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Box Link Not Deleted.',
                            variant: 'error',
                        }),
                    )
                })
        }
    }

    //Sorting logic starts here
    doSorting(event) {
        
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    @api sortData(fieldname, direction) {
        
        let parseData = JSON.parse(JSON.stringify(this.evidenceData));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // Checking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // Sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            
            // Implementing a natural sort
            let naturalSort = (a, b) => {
                let ax = [], bx = [];
                
                a.replace(/(\d+)|(\D+)/g, (_, $1, $2) => {
                    ax.push([$1 || Infinity, $2 || '']);
                });
                b.replace(/(\d+)|(\D+)/g, (_, $1, $2) => {
                    bx.push([$1 || Infinity, $2 || '']);
                });
                
                while (ax.length && bx.length) {
                    let an = ax.shift();
                    let bn = bx.shift();
                    let nn = (an[0] - bn[0]) || an[1].localeCompare(bn[1]);
                    if (nn) {
                        return nn;
                    } 
                }
                
                return ax.length - bx.length;
            };
            
            // Sorting values based on direction using naturalSort
            return isReverse * naturalSort(x.toString(), y.toString());
        });
        this.evidenceData = parseData;
    }
    

}