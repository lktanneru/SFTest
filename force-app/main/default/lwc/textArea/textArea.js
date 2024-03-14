import { LightningElement, api, track,wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id'



export default class TextArea extends LightningElement {
    @api value;
    @api placeholder;
    @api comments;
    @api context;
    @track isEditing = false;
    @track oldValue =''
    @track userId = USER_ID;
    @track userName
    @track isDisabled = false

    connectedCallback(){
        console.log('coming in text area')
    }

    @wire(getRecord, { recordId: '$userId', fields: [NAME_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.userName = getFieldValue(data, NAME_FIELD);
        } else if (error) {
           console.log(error)
        }
    }

    handleEditClick() {
        this.isDisabled = true
        this.oldValue = this.value
        this.isEditing = true;
        const textarea = this.template.querySelector('[data-id="myTextarea"]');
        textarea.value = this.value;
    }

    handleInputChange(event) {
        this.value = this.oldValue + event.target.value; 
    }

    handleSaveClick() {
        this.isEditing = false;
        const textarea = this.template.querySelector('[data-id="myTextarea"]');
        const newValue = textarea.value.trim();
    
        // Check if the new value is empty
        if (newValue.length === 0) {
            return;
        }
     
        // Get the current timestamp 
        const formattedDateTime = new Date().toLocaleString();
    
        // Create the comment with the footprint
        let commentWithFootprint = '';
        if (this.oldValue) {
            commentWithFootprint = this.oldValue + ' \n ' +  this.userName + ' (' + formattedDateTime + '):' + newValue;
        } else {
            commentWithFootprint = this.userName + ' (' + formattedDateTime + '): ' + newValue;
        }
    
        // Update the oldValue to include the new comment
        this.oldValue = commentWithFootprint;
    
        // Fire custom event to notify parent components about the value change
        const saveEvent = new CustomEvent('textchanged', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: {
                    context: this.context,
                    value: commentWithFootprint,
                    isSource: 'textArea'
                }
            }
        });
        this.dispatchEvent(saveEvent);
    }   
    handleNewComment(){
        this.isDisabled = false
        const textarea = this.template.querySelector('[data-id="myTextarea"]');
        textarea.value = ''
    }
    

    handleCancelClick() {
        this.isEditing = false;
    }

}