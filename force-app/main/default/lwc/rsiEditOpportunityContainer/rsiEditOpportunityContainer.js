import { LightningElement, track } from 'lwc';
import getSetup  from '@salesforce/apex/RSI_ApplicationEditForm.getSectionData';

export default class RsiEditOpportunityContainer extends LightningElement {

    @track uiSetup = [];

    async connectedCallback() {
        getSetup ({
            sectionName : 'Application Cover Sheet',
            opptyId : '0062i000005VRnc'
        }).then (result => {
            this.uiSetup = result;
        });
        
    }
}