import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LightningTreeGridCmp extends NavigationMixin(LightningElement) {

    @api records; // List of records with coreStandardName, Question, Box_Link__c fields

    get columns() {
        return [
            { label: 'Core Standard', fieldName: 'coreStandardName', type: 'text', initialWidth: 200 },
            { label: 'Question', fieldName: 'Question', type: 'text', initialWidth: 600 },
            {
                label: 'Box Links',
                fieldName: 'Box_Link__c',
                type: 'url',
                typeAttributes: {
                    label: { fieldName: 'label' },
                    target: '_blank',
                },
                initialWidth: 430,
                cellAttributes: { class: 'box-link-cell' },
            },
        ]
    }



    get data() {
        // Prepare the data for tree grid
        return this.records.map((record) => {
            const boxLinks = record.Box_Link__c || [];
            const linksArray = Array.isArray(boxLinks) ? boxLinks.map(link => ({
                label: link.label || '',
                link: link.link || ''
            })) : [];
            console.log('linksArray'+linksArray)
            return {
                coreStandardName: record.coreStandardName,
                Question: record.Question,
                Box_Link__c: linksArray
            };
        });
    }


    handleBoxLinkClick(event) {
        const link = event.detail.value;
        // Open the box link in a new tab
        this[NavigationMixin.Navigate]({
          type: 'standard__webPage',
          attributes: {
            url: link,
            target: '_blank',
          }
        })
      }

}