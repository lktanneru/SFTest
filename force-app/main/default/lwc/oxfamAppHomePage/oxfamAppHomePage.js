import { LightningElement, wire, track, api } from 'lwc';

import getSingleContact from '@salesforce/apex/SubmissionCls.getEntity';
import { NavigationMixin } from 'lightning/navigation';
import pubsub from 'c/pubSub';

export default class oxfamAppHomePage extends NavigationMixin(LightningElement) {

    @track l_All_Types;
    @track TypeOptions;
    error;
    selectedValue

    connectedCallback() {
       this.selectedValue = 'Select Country Or Region';
    }

    handleOnBlur(){
        this.selectedValue = 'Select Country Or Region';
    }

    @wire(getSingleContact)
    WiredObjects_Type({ error, data }) {
        if (data) {
            try {
                this.l_All_Types = data;
                let options = [];
                options.push({ label:'Select Country Or Region', value: 'Select Country Or Region' });

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key].Name, value: data[key].Name +';'+data[key].Id });

                    // Here Name and Id are fields from sObject list.
                }
                this.TypeOptions = options;

            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }

    }

    navigateToEntityPage(val) {
        this.selectedValue = val.target.value
        if(val.target.value !== 'Select Country Or Region'){
            this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Country_HomePage",
            }
            , state: {
                "c__id": val.target.value
            }
        });
        }
    }


}