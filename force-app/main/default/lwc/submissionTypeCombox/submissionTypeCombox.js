import { LightningElement,wire,track,api } from 'lwc';
import getSubmission from '@salesforce/apex/SubmissionCls.getSubmission';

export default class SubmissionTypeCombox extends LightningElement {
    
    @track getSubmissionType;
    selectedSubmissionType;
    @api selectedsubtype;
   


    @wire(getSubmission)
    WiredObjects_Type({ error, data }) {

        if (data) {
            
            try {
                let options = [];
                 
                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....

                    options.push({ label: data[key].Submission_Type__c, value: data[key].Submission_Type__c  });
                    
                    // Here Name and Id are fields from sObject list.
                }
                this.getSubmissionType = options;
                 
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
}


    addselectedValue(event){
        this.selectedSubmissionType = event.detail.value;
        this.dispatchEvent( new CustomEvent( 'pass', {
            detail : this.selectedSubmissionType
        } ) );
    }
}