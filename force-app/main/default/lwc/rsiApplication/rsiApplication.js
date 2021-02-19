/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 12-31-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   14-12-2020   Umesh Kumar   Initial Version
**/
import {LightningElement,api,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {loadStyle} from 'lightning/platformResourceLoader';
import customLebelFont from '@salesforce/resourceUrl/rsi_labelFont';
export default class RsiApplication extends LightningElement {

    @api accountId;
    @api recordId;
    @api readStatusOnly;
    @track nameErrorValue =false;
    @track nameErrorText ='';
    @track nameError ='';

    @track phoneErrorValue =false;
    @track phoneErrorText ='';
    @track phoneError ='';
    @track nextWithoutSave =false;

     status=false;
    @track refreshView = false;

     renderedCallback() {

        Promise.all([
            loadStyle(this, customLebelFont)
        ])
    }

    connectedCallback(){

        if(this.readStatusOnly == 'true'){
            this.status = true;
        }else{
            this.status = false;
        }
   }
  
   handlewithoutSave(event) {
    //custom event to pass Account Id and Opportunity Id to parent component
    const passEvent = new CustomEvent('opportunityselection', {
        detail: { recordId: this.recordId, selectedAccountId: this.accountId ,isStepOneFieldSave:true}});
           this.dispatchEvent(passEvent);
  }
 

    handleSuccess(event) {
        this.recordId = event.detail.id;
        const payload = event.detail;
        var objJSON = JSON.parse(JSON.stringify(payload));
        this.accountId = objJSON["fields"]["AccountId"]["value"];
        const evt = new ShowToastEvent({
            title: "Success!",
            message: "The record has been successfully saved.",
            variant: "success",
        });
        this.dispatchEvent(evt);
        //custom event to pass Account Id and Opportunity Id to parent component
        const passEvent = new CustomEvent('opportunityselection', {
         detail: { recordId: this.recordId, selectedAccountId: this.accountId ,isStepOneFieldSave:false}
            });
            this.dispatchEvent(passEvent);
        this.refreshView = false;
    }

    handleError(event) {
        const evt = new ShowToastEvent({
            title: "Error!",
           message: "The record has not saved.",
            variant: "error",
        });
        this.dispatchEvent(evt);
    }

    SubmitHandler(event) {

        const fields = event.detail.fields;
        this.nextWithoutSave =true;
        if (this.recordId == undefined) {
            fields.StageName = 'New';
        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.refreshView = true;
    }

    handleAppNameValidation(event){
        var nameVal = event.detail.value;
        this.nameErrorValue =false;
        var regex = new RegExp("^[0-9a-zA-Z \b]+$");
        if(!regex.test(nameVal) && nameVal){
         this.nameErrorValue =true;
         this.nameErrorText = 'This field cannot contain special characters.';
         this.nameError = 'slds-has-error';
        }
        if (!this.nameErrorValue){
            this.nameError = '';
        }
       this.handlewithoutSave();
    }
    handlePhoneValidation(event){
        var phoneVal = event.detail.value;
        this.phoneErrorValue =false;
        if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
         this.phoneErrorValue =true;
         this.phoneErrorText = 'This field must be a valid phone #.';
         this.phoneError = 'slds-has-error';
        }
        if (!this.phoneErrorValue){
            this.phoneError = '';
        }
        this.handlewithoutSave();
    }

}