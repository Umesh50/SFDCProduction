import { api, LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMcCode from '@salesforce/apex/RSI_MccCode.getMcccodeList';

export default class RsiBusinessEnvironment extends LightningElement {

   @track areDetailsVisible = false
   @track Visible = false
   @track Days = false
   @api accountId;
   @api readStatusOnly;
    @api picklistValueCtr;

    @track nameErrorValue =false;
    @track nameErrorText ='';
    @track nameError ='';

    @track phoneErrorValue =false;
    @track phoneErrorText ='';
    @track phoneError ='';

   status=false;
 

  connectedCallback(){
      if(this.readStatusOnly == 'true'){
          this.status = true;  
      }else{
          this.status = false;
      }
 } 

 
 handlewithoutSave(event) {
    //custom event to pass Account Id and Opportunity Id to parent component
    const passEvent = new CustomEvent('foursave', {  detail: { isStepFourFieldSave :true}});
    this.dispatchEvent(passEvent);
  }
 handleProDescValidation(event){
     this.handlewithoutSave();
    var nameVal = event.detail.value;
    this.nameErrorValue =false;
    var regex = new RegExp("^[0-9a-zA-Z. \b]+$");
    if(!regex.test(nameVal) && nameVal){
     this.nameErrorValue =true;
     this.nameErrorText = 'Special characters not allowed';
     this.nameError = 'slds-has-error';
    }
    if (!this.nameErrorValue){
        this.nameError = '';
    }

}

handlePhoneValidation(event){
    this.handlewithoutSave();
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

}
 handleOnLoad(event){
    const records = event.detail.records;
    for(var key in records) {
        console.log('----data---'+records[key].fields.Seasonal__c.value);
        if(records[key].fields.Seasonal__c.value == 'Yes')
            this.areDetailsVisible = true;
    }
 }
   handleSuccess() {
       //custom event to pass Account Id and Opportunity Id to parent component
    const passEvent = new CustomEvent('foursave', {  detail: { isStepFourFieldSave :false}});
    this.dispatchEvent(passEvent);
    const evt = new ShowToastEvent({
        title: "Success!",
        message: "The record has been successfully saved.",
        variant: "success",
    });
    this.dispatchEvent(evt);
	
    
}
   
handleError() {
    const evt = new ShowToastEvent({
        title: "Error!",
        message: "The record has not saved.",
        variant: "error",
    });
    this.dispatchEvent(evt);
}
    handleSesonalChange(event){
        this.handlewithoutSave();
        const fieldValue = event.detail.value;
        if(fieldValue == 'Yes')
            this.areDetailsVisible = true; 
        else    
            this.areDetailsVisible = false;
            
    }
    handleDataRecieved(event){
        this.handlewithoutSave();
        let numberOfDays;
        const fieldValue = event.detail.value;
        if(fieldValue == "At Point of Sale")
            numberOfDays = 'Zero'
        else if(fieldValue == "Same Day")
            numberOfDays = 0
        else if(fieldValue == "Next Day")
            numberOfDays = 1
            else if(fieldValue == "Second Day")
            numberOfDays = 2
            else if(fieldValue == "Within a Week")
            numberOfDays = 5
            else if(fieldValue == "Monthly")
            numberOfDays = 30
            else if(fieldValue == "Yearly")
            numberOfDays = 365
        console.log('numberOfDays-----------'+numberOfDays);
        const inputFields = this.template.querySelectorAll(
                   'lightning-input-field'
               );
        if(inputFields){
            inputFields.forEach(field => {
            if(field.fieldName=="No_of_Days__c")
                field.value = numberOfDays;
            });
        }        
    }

    handleDataUpdate(event){
     this.handlewithoutSave();

        let copyIndustryStandards;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if(inputFields){
            inputFields.forEach(field => {
            if(field.fieldName=="Copy_Industry_Standards__c")
                copyIndustryStandards = field.value ;
            });
        }        
        const fieldValue = event.detail.value;
        if((fieldValue == "5499A - Convenience Stores" || fieldValue == "4812 - Cell Phone Stores"|| fieldValue == "5411 - Grocery Stores" || fieldValue == "5422D - Meat Market" || fieldValue == "5499O - Mini Markets"||  fieldValue == "5251D - Plumbing Supplies" ||  fieldValue == "5511A-Car&Truck (New&Used)"  || fieldValue == "5541 - Gas Stations (None-Pump)"|| fieldValue == "5699A - MISC Apparel" || fieldValue == "5812 - Restaurants (non-fast food)" || fieldValue == "5912 - Drug Stores and Pharmacies" || fieldValue == "5921A - Liquor Stores" || fieldValue == "5993-Retail.Cigar,Pipe & Tobacco") && copyIndustryStandards == true){
            this.picklistValueCtr = fieldValue;
            this. mcCodeCtr();
        }
    }

    handleDataUpdate1(event){
        this.handlewithoutSave();

        let picklistValue;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'

        );
        console.log('inside-------------');
        if(inputFields){
            inputFields.forEach(field => {
            if(field.fieldName=="Industry_MCC_Code__c")
                picklistValue = field.value ;
            });
        }   
        console.log('inside3-------------'+picklistValue);   
        const fieldValue = event.detail.checked;
        console.log('inside1-------------'+fieldValue);
        if((picklistValue == "5499A - Convenience Stores" || picklistValue == "4812 - Cell Phone Stores"|| picklistValue == "5411 - Grocery Stores" || picklistValue == "5422D - Meat Market" || picklistValue == "5499O - Mini Markets"||  picklistValue == "5251D - Plumbing Supplies" ||  picklistValue == "5511A-Car&Truck (New&Used)"  || picklistValue == "5541 - Gas Stations (None-Pump)"|| picklistValue == "5699A - MISC Apparel" || picklistValue == "5812 - Restaurants (non-fast food)" || picklistValue == "5912 - Drug Stores and Pharmacies" || picklistValue == "5921A - Liquor Stores" || picklistValue == "5993-Retail.Cigar,Pipe & Tobacco") && fieldValue == true){

        console.log('inside22-------------'+fieldValue);
            this.picklistValueCtr = picklistValue;
           this. mcCodeCtr();
        }
    }
    showToastMessage = (toastType, messageText) => {
        //Generic method to show a toast message. It is being used throughout the code
        const event = new ShowToastEvent ({
            variant: toastType,
            message: messageText
        });
        this.dispatchEvent (event);
    }
    mcCodeCtr(){
        getMcCode ({picklistName : this.picklistValueCtr}).then(result => {
            console.log('result-------------'+JSON.stringify(result));
            let resp = result;
            console.log('---'+resp[0].Name);
            const inputFields1 = this.template.querySelectorAll(
                'lightning-input-field'
            );
            if(inputFields1){
                inputFields1.forEach(field => {
                if(field.fieldName == "Annual_Revenue__c")
                field.value = resp[0].Annual_Revenue__c;
                if(field.fieldName == "Total_Monthly_Sales__c")
                    field.value = resp[0].Total_Monthly_Sales__c;
                if(field.fieldName == "Average_Ticket__c")
                    field.value = resp[0].Average_Ticket__c;
                if(field.fieldName == "Highest_Ticket_Amount__c")
                    field.value = resp[0].Highest_Ticket_Amount__c;
                if(field.fieldName == "Highest_Ticket_Frequency__c")
                    field.value = resp[0].Highest_Ticket_Frequency__c;
                });
            }
        }).catch (error => {
            this.showToastMessage ('error', 'Error'+error);
        });
    }
}