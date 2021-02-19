import {
    LightningElement,
    wire,
    track
} from 'lwc';
import {
    getRecord
} from 'lightning/uiRecordApi';

import USER_ID from '@salesforce/user/Id';

import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';

import PHONE_FIELD from '@salesforce/schema/User.Phone';
import SALESTEAMNO_FIELD  from '@salesforce/schema/User.SalesTeamNo__c';


export default class Rsiuserinfo extends LightningElement {
    @track error ;
    @track email ; 
    @track name;
    @track phone;
    CloseDate;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD,EMAIL_FIELD,PHONE_FIELD,SALESTEAMNO_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.email = data.fields.Email.value;
            this.name = data.fields.Name.value;
           this.salesTeamNo = data.fields.SalesTeamNo__c.value;
            this.phone = data.fields.Phone.value;
            let d = new Date();
            this.CloseDate = d.toLocaleDateString(('en-US'));
        
        }
    }

}