import { LightningElement, track, wire, api } from 'lwc';
import getreportingPeriod from '@salesforce/apex/countryPageCls.getreportingPeriod';

export default class ReportingPeriodComboBox extends LightningElement {

    @track reportingPeriodOptions;
    @api selectedreportperiod;


    @wire(getreportingPeriod)
    WiredObjects_Type({ error, data }) {
        if (data) {
            try {
                console.log(data)
                let options = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key].Name, value: data[key].Name + ';' + data[key].Id });

                    // Here Name and Id are fields from sObject list.
                }
                this.reportingPeriodOptions = options;

            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }

    }
    addselectedValue(event) {
        this.dispatchEvent(new CustomEvent('reportperiod', {
            detail: event.detail.value
        }));
    }
}