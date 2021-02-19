/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-11-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-08-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, api, track,wire } from 'lwc';
import deleteRecord from '@salesforce/apex/RSI_OwnerOfficersController.deleteOwnerOfficer';
import {loadStyle} from 'lightning/platformResourceLoader';
import customLebelFont from '@salesforce/resourceUrl/rsi_labelFont';
import getDBAPhone from '@salesforce/apex/RSI_OwnerOfficersController.getOppDBAPhone';

export default class RsiOwnersOrOfficersPersonal extends LightningElement {
    @api opptyId;
    @api recordId;
    @api recNumOne;
    @api ownerType;
    @api lastrow;
    @api allOwners = [];
    @api soleProp;
    personalEntry = true;
    businessEntry = false;
    typeClass = 'hideLine';
    disablePersonalCheck = false;
    @track errorText = '';
    @track dobErrorValue =false;
    @track dobErrorText = '';
    @track dobError ='';
    @track phoneErrorValue =false;
    @track phoneErrorText = '';
    @track phoneError ='';
    @track errorValue = false;
    @track percentError = '';
    @api readStatusOnly;
    @track dba_Phone_Number;

    @track ibphoneErrorValue =false;
    @track ibphoneErrorText = '';
    @track ibphoneError ='';
    status=false;
  
    renderedCallback() {
        Promise.all([
            loadStyle(this, customLebelFont)
        ])
    }
    connectedCallback () {
        if(this.readStatusOnly == 'true'){
            this.status = true;  
        }else{
            this.status = false;
        }
        this.toggleDisplay();
        this.getOppDBAPhone();
    }

    handlewithoutSave(event) {
        //custom event to pass Account Id and Opportunity Id to parent component
        const passEvent = new CustomEvent('fivescreensave', {  detail: { isStepFiveFieldSave :true}});
        this.dispatchEvent(passEvent);
      }

    handleSuccess (event) {
        //custom event to pass Account Id and Opportunity Id to parent component
        const passEvent = new CustomEvent('fivescreensave', {  detail: { isStepFiveFieldSave :false}});
        this.dispatchEvent(passEvent);

        this.recordId = event.detail.id;
        //var dataToPass = {recordId : event.detail.id, percentOwnership : event.detail["fields"].Ownership_Percentage__c.value};
        const eventSaved = new CustomEvent ("recordsaved", {detail : 'RecordSaved'});
        this.dispatchEvent (eventSaved);
    }

    ownerTypeToggle (event) {
        this.handlewithoutSave();
        this.ownerType = event.detail.value;
        this.toggleDisplay();
    }

    toggleDisplay () {
        //console.log ('Owner Type value: ' + this.ownerType);
        if (this.ownerType == ''  || this.ownerType == null || this.ownerType == undefined) {
            this.ownerType = '2';
            //console.log ('Owner Type value updated: ' + this.ownerType);
        }
        this.personalEntry = this.ownerType == '2' ? true : false;
        this.businessEntry = this.ownerType == '3' ? true : false;
        this.typeClass = this.recNumOne ? 'hideLine' : 'showLine';
        console.log (this.typeClass);
        this.disablePersonalCheck = this.personalEntry && !this.recNumOne ? true : false;
    }

    deleteRec () {
        if (confirm('This will delete the selected Owners Or Officers Record.\nDo you want to proceed?')) {
            deleteRecord ({recId : this.recordId}).then (result => {
                if (result != 'Success'){
                    alert (result);
                }
                const eventSaved = new CustomEvent ("recordsaved", {detail : 'RecordDeleted'});
                this.dispatchEvent (eventSaved);
            }).catch (error => {
                console.log (error);
            });
        }
    }

    addOwner () {
        const eventAdd = new CustomEvent ("addowner");
        this.dispatchEvent (eventAdd);
    }

    percentChanges (event) {
        this.handlewithoutSave();
        this.errorValue = false;
        var percentValue = parseFloat(event.detail.value);
        if (percentValue < 25) {
            this.errorText = 'Ownership % must be 25% or greater';
            this.errorValue = true;
            this.percentError = 'slds-has-error';
        }
        //Now loop through all the Owner records and check the Percentage value. If we are exceeding 100, show error
        var totalPercent = 0;
        for (var record of this.allOwners) {
            if (record.Id != this.recordId) {
                totalPercent += record.percentVal;
            }
        }
        console.log ('Total Pre: ' + totalPercent);
        console.log ('Field Val: ' + percentValue);
        totalPercent = totalPercent + parseFloat(percentValue);
        console.log ('Total Post: ' + totalPercent);
        if (totalPercent > 100) {
            this.errorText = 'Ownership can\'t be more than 100%';
            this.errorValue = true;
            this.percentError = 'slds-has-error';
        }
        if (this.soleProp && percentValue < 100) {
            this.errorText = 'Ownership % has to be 100%';
            this.errorValue = true;
            this.percentError = 'slds-has-error';
        }
        if (!this.errorValue){
            this.percentError = '';
        }
    }

    runChecks(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.Address_Type__c = 'PRA';
        var errorFound = false;
        if (!(fields.Ownership_Percentage__c < 25 || fields.Ownership_Percentage__c > 100)) {
            errorFound = true;
        } else if (fields.Ownership_Percentage__c < 100 && this.soleProp) {
            errorFound = true;
        }
        if (!this.errorFound) {
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
       

    }
   handleDOB(event){
    this.handlewithoutSave(); 
       var dt = event.detail.value;
       var month=dt.substring(0,2);
       this.dobErrorValue =false;
       var temp =true;
       if(/\D/.test(dt)){
        this.dobErrorValue =true;
        this.dobErrorText = 'DOB must be numeric value only';
        this.dobError = 'slds-has-error';
        temp=false;
       }
       if(temp){
       if(dt.length != 8  && dt.length >= 1){
        this.dobErrorValue =true;
        this.dobErrorText = 'DOB must be in "MMDDYYYY" format';
        this.dobError = 'slds-has-error';
        temp=true;
       }
      }
       if(parseInt(month) > 12){
        this.dobErrorValue =true;
        this.dobErrorText = 'Month must be less than or equal to 12';
        this.dobError = 'slds-has-error';
       }

       var day=dt.substring(2,4);
       var yr=dt.substring(4,8);
       var mdays = new Date(yr, month, 0).getDate();
       if(parseInt(day) > mdays){
        this.dobErrorValue =true;
        this.dobErrorText = 'Days must be less than or equal to '+mdays;
        this.dobError = 'slds-has-error';
       }

       if(yr.length == 4){
       var strDate =new Date(yr,month,day);
       var dobDate = new Date(strDate.getFullYear(),(strDate.getMonth()-1),strDate.getDate());
       var years = new Date(new Date() -dobDate).getFullYear() - 1970;
       if(years < 18 || years >115){
        this.dobErrorValue =true;
        this.dobErrorText = 'Age must be between 18 to 115 years';
        this.dobError = 'slds-has-error';
       }
    }
     if (!this.dobErrorValue){
        this.dobError = '';
    }
   }

   handlePhone(event){
    this.handlewithoutSave();   
    var hPhone = event.detail.value;
     this.phoneErrorValue =false;

     if(!/^[23456789]\d{9}$/.test(hPhone) && hPhone){
        this.phoneErrorValue =true;
        this.phoneErrorText = 'This field must be a valid phone #.';
        this.phoneError = 'slds-has-error';
       }
       
     if(this.dba_Phone_Number){
     if(hPhone.toString() == this.dba_Phone_Number.toString()){
        this.phoneErrorValue =true;
        this.phoneErrorText = 'Owner/Officer Home Phone # must not be same as DBA Phone #';
        this.phoneError = 'slds-has-error';
     }
    }
     if (!this.phoneErrorValue){
        this.phoneError = '';
    }
   }
  
   handlePhoneValidation(event){
    this.handlewithoutSave();
    var phoneVal = event.detail.value;
    this.ibphoneErrorValue =false;
    if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
     this.ibphoneErrorValue =true;
     this.ibphoneErrorText = 'This field must be a valid phone #.';
     this.ibphoneError = 'slds-has-error';
    }
    if (!this.ibphoneErrorValue){
        this.ibphoneError = '';
    }
}
    getOppDBAPhone(){
        getDBAPhone ({opptyId : this.opptyId}).then (result => {
            for (var record of result) {
                //Loop through the records in the result
               this.dba_Phone_Number =record.DBA_Phone__c;
            }
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    }
}