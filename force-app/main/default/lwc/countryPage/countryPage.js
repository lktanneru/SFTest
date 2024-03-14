import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getSingleContact from '@salesforce/apex/SubmissionCls.getEntity';
import USER_ID from '@salesforce/user/Id'; //this is how you will retreive the USER ID of current in user.
import NAME_FIELD from '@salesforce/schema/User.Name';
import getCountryName from '@salesforce/apex/countryPageCls.affiliateOfficeApex';
import getPACountryName from '@salesforce/apex/countryPageCls.partnerOfficeApex';
import Email from '@salesforce/schema/User.Email';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import pubsub from 'c/pubSub';
import HideLightningHeader from '@salesforce/resourceUrl/HideLightningHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import Noheader from '@salesforce/resourceUrl/Noheader';
import NoSearchContainer from '@salesforce/resourceUrl/NoSearchContainer';


export default class CountryPage extends NavigationMixin(LightningElement) {
    @track value = '';
    @track currentYear = new Date().getFullYear();
    @track nextYear = this.currentYear + 1;
    error;
    @track l_All_Types;
    @track TypeOptions;
    @track countryName = '';
    countryPAName = [];
    c_id = null;
    entityName = '';
    selectedEntityName = '';
    currentPageReference = null;
    urlStateParameters = null;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.c_id = (this.urlStateParameters.c__id != null ? this.urlStateParameters.c__id.split(';')[1] : null)|| null;
        this.entityName = (this.urlStateParameters.c__id != null ? this.urlStateParameters.c__id.split(';')[0] : null) || null;
        this.selectedEntityName = this.urlStateParameters.c__id || null;
        getCountryName({ str: this.c_id })
            .then(result => {
                this.countryName = result;
            })
            .catch(error => {
                this.error = error;
            });
        this.setParametersBasedOnUrl2();
    }

    setParametersBasedOnUrl2() {
        getPACountryName({ str: this.c_id })
            .then(result => {
                this.countryPAName = [];
                result.forEach(element => {
                    let obj = {
                        Name : element.Affiliate_Office__r.Name
                    };
                    this.countryPAName.push(obj);
                });
            })
            .catch(error => {
                this.error = error;
            });
    }
   
    @track message = null;
    connectedCallback() {
        this.register();
        loadStyle(this, Noheader)
        loadStyle(this,NoSearchContainer)
    }
    register() {
        window.console.log('event registered ');
        window.console.log(this);
        if (this.message == null) {
            pubsub.register('simplevt', this.handleEvent.bind(this));
        }
    }
    handleEvent(messageFromEvt) {
        window.console.log('event handled ', messageFromEvt);
        this.message = messageFromEvt;
    }
    @wire(getSingleContact)
    WiredObjects_Type({ error, data }) {
        if (data) {
            try {
                this.l_All_Types = data;
                let options = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key].Name, value: data[key].Name +';'+data[key].Id });

                    // Here Name and Id are fields from sObject list.
                }
                this.TypeOptions = options;

            } catch (error) {
                console.error('check error here --- catch block', JSON.stringify(error));
            }
        } else if (error) {
            console.error('check error here', JSON.stringify(error));
        }

    }

    handleChange(event) {
        this.countryName = '';
        this.value = event.detail.value.split(';')[1];
        getCountryName({ str: this.value })
            .then(result => {
                this.countryName = result;
            })
            .catch(error => {
                this.error = error;
            });
        
        getPACountryName({ str: this.value })
        .then(result => {
            this.countryPAName = result;
        })
        .catch(error => {
            this.error = error;
        });
    }

    @track name;
    @track email;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, Email]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.name = data.fields.Name.value;
            this.email = data.fields.Email.value;
        }
    }


    navigateToPlansAndReportsPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Plans_And_Reports_Submission_Page"
            }, 
            state: {
                c__id: this.selectedEntityName,
                //c__RepYear: ''
                // c__subType: 'Annual Report'
            }
        });
    }

    navigateToPrevSubmission() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Previous_Submisson_Page"
            }
        });
    }

    navigateToConsolidatedImpPlan() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Consolidated_Implementation_Plan"
            },
            state: {
                "c__id" : this.selectedEntityName
            }
        });
    }

}