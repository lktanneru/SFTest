import { LightningElement, wire, track, api } from 'lwc';
import getEntityOptions from '@salesforce/apex/SubmissionCls.getEntity';

export default class EntityTypeComboBox extends LightningElement {

    @track entityOptions;
    @api selectedentity;

    @wire(getEntityOptions)
    WiredObjects_Type({ error, data }) {
        if (data) {
            try {
                let options = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key].Name, value: data[key].Name + ';' + data[key].Id });

                    // 

                    // Here Name and Id are fields from sObject list.
                }
                this.entityOptions = options;

            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }

    }

    addselectedValue(event) {
        this.dispatchEvent(new CustomEvent('entity', {
            detail: event.detail.value
        }));
    }
}