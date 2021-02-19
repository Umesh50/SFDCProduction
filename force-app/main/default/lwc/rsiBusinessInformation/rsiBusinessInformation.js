import {api, LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class rsiBusinessInformation extends LightningElement {
    @track openmodel = false;
    @track isPopUpOpen = false;
    @track isAddress = false;;
    @track addButtonDisabled = false;
    @track isMaiilingAddress = false;
    @track isShippingAddress = false;
    @track delteDiabled = true;
    @track toogle1 = false;
    @track toogle2 = false;
    @api accountId;
    @api recordId;
    @api objectApiName;
    @track currentOwnerMonth;
    @track currentOwnerYear;
    @api readStatusOnly;
    @api isShippingToogle = false;
    @api isMaiilingToogle = false;
    @track isOneTime = true;

    @track dBAPhoneErrorValue =false;
    @track dBAPhoneErrorText ='';
    @track dBAPhoneError ='';

    
    @track mobPhoneErrorValue =false;
    @track mobPhoneErrorText ='';
    @track mobPhoneError ='';

    @track mailPhoneErrorValue =false;
    @track mailPhoneErrorText ='';
    @track mailPhoneError ='';

    @track shipPhoneErrorValue =false;
    @track shipPhoneErrorText ='';
    @track shipPhoneError ='';

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
    const passEvent = new CustomEvent('thirdsave', {  detail: { isStepThreeFieldSave :true}});
    this.dispatchEvent(passEvent);
  }

  handleDBAPhoneValidation(event){
      this.handlewithoutSave();
    var phoneVal = event.detail.value;
    this.dBAPhoneErrorValue =false;
    if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
     this.dBAPhoneErrorValue =true;
     this.dBAPhoneErrorText = 'This field must be a valid phone #.';
     this.dBAPhoneError = 'slds-has-error';
    }
    if (!this.dBAPhoneErrorValue){
        this.dBAPhoneError = '';
    }

}

handleMobPhoneValidation(event){
    this.handlewithoutSave();
    var phoneVal = event.detail.value;
    this.mobPhoneErrorValue =false;
    if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
     this.mobPhoneErrorValue =true;
     this.mobPhoneErrorText = 'This field must be a valid phone #.';
     this.mobPhoneError = 'slds-has-error';
    }
    if (!this.mobPhoneErrorValue){
        this.mobPhoneError = '';
    }

}

handleShippingPhoneValidation(event){

    this.handlewithoutSave();
    var phoneVal = event.detail.value;
    this.shipPhoneErrorValue =false;
    if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
     this.shipPhoneErrorValue =true;
     this.shipPhoneErrorText = 'This field must be a valid phone #.';
     this.shipPhoneError = 'slds-has-error';
    }
    if (!this.shipPhoneErrorValue){
        this.shipPhoneError = '';
    }

}

handleMailingPhoneValidation(event){
    this.handlewithoutSave();
    var phoneVal = event.detail.value;
    this.mailPhoneErrorValue =false;
    if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
     this.mailPhoneErrorValue =true;
     this.mailPhoneErrorText = 'This field must be a valid phone #.';
     this.mailPhoneError = 'slds-has-error';
    }
    if (!this.mailPhoneErrorValue){
        this.mailPhoneError = '';
    }

}
  
  handleOnLoad(event){
    const records = event.detail.records;
    for(var key in records) {
        console.log('----data---'+records[key].fields.Accepting_Cards__c.value);
        console.log('this.isOneTime--2--'+this.isOneTime);
        if(this.isOneTime){
            if(records[key].fields.Shipping_Address__c.value != null || records[key].fields.Shipping_Country__c.value != null || records[key].fields.Shipping_State__c.value != null || records[key].fields.Shipping_City__c.value !=null || records[key].fields.Shipping_Zip__c.value !=null || records[key].fields.Shipping_Phone__c.value !=null){
                this.isShippingAddress = true;
                this.isOneTime = false;
            }else{
                this.isShippingAddress = false;
                this.isOneTime = false;
            }  
            if(records[key].fields.Mailing_Address__c.value != null || records[key].fields.Mailing_Country__c.value != null || records[key].fields.Mailing_State__c.value != null || records[key].fields.Mailing_City__c.value != null || records[key].fields.Mailing_Zip__c.value != null || records[key].fields.Mailing_Zip__c.value != null ){
                this.isMaiilingAddress = true;
                this.isOneTime = false;
            }else{
                this.isMaiilingAddress = false;
                this.isOneTime = false;
            }  
            if(!this.isShippingAddress || !this.isMaiilingAddress)
                this.addButtonDisabled = false;
            else
                this.addButtonDisabled = true;              
        }  
    }
    
  }
    handleSuccessTost() {
         //custom event to pass Account Id and Opportunity Id to parent component
    const passEvent = new CustomEvent('thirdsave', {  detail: { isStepThreeFieldSave :false}});
    this.dispatchEvent(passEvent);
        const evt = new ShowToastEvent({
            title: "Success!",
            message: "The record has been successfully saved.",
            variant: "success",
        });
        this.dispatchEvent(evt);
        if(this.isMaiilingAddress && this.isShippingAddress){
            this.isMaiilingToogle = false;
             this.isShippingToogle = false;
             this.delteDiabled = true;
         }
    }
       
    handleErrorTost() {
        const evt = new ShowToastEvent({
            title: "Error!",
            message: "The record has not saved.",
            variant: "error",
        });
        this.dispatchEvent(evt);
    }
    handleSuccess(event){
         //custom event to pass Account Id and Opportunity Id to parent component
         const passEvent = new CustomEvent('thirdsave', {  detail: { isStepThreeFieldSave :false}});
         this.dispatchEvent(passEvent);
        this.openmodel = false;
       
        this.isPopUpOpen = true;
       
        
    }
    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        console.log('fields-'+fields);
        if((this.currentOwnerMonth != fields.Current_Ownership_Months__c) || (this.currentOwnerYear != fields.Current_Ownership_Years__c)){
            console.log('fields-'+fields);
            this.isPopUpOpen = false;    
        }
        if((fields.Current_Ownership_Years__c == 0 || (fields.Current_Ownership_Months__c == 0 && fields.Current_Ownership_Years__c == 1)|| (fields.Current_Ownership_Months__c == 11 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 10 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 9 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 8 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 7 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 6 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 5 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 4 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 3 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 2 && fields.Current_Ownership_Years__c == 0)||(fields.Current_Ownership_Months__c == 1 && fields.Current_Ownership_Years__c == 0)) && (this.currentOwnerMonth != fields.Current_Ownership_Months__c || this.currentOwnerYear != fields.Current_Ownership_Years__c)){
           
            this.openmodel = true;
            this.currentOwnerMonth = fields.Current_Ownership_Months__c;
            this.currentOwnerYear = fields.Current_Ownership_Years__c;   
        }else{
            this.template.querySelector('lightning-record-edit-form').submit(fields);
            
        }
        
     }
     handleSuccessoPP(event){
        const toastEvent = new ShowToastEvent({ 
            title: 'Application Updated', 
            message: 'Application Updated Successfully!!!', 
            variant: 'success' 
        }); 
        this.dispatchEvent( toastEvent ); 
     }
     addAddress(event){
         if(!this.isMaiilingAddress)
            this.isMaiilingToogle = true;
        if(!this.isShippingAddress)
            this.isShippingToogle = true;
         this.isAddress = true;
         this.addButtonDisabled = true;
         this.delteDiabled = false;
     }
     displayMailingAddress(event){
        this.handlewithoutSave();
        this.isMaiilingAddress = event.target.checked;
     }
     displayShippingAddress(event){
        this.handlewithoutSave();
        this.isShippingAddress = event.target.checked;
        this.isOneTime = false;
        console.log('this.isOneTime--2--'+this.isOneTime);
     }
     removeAddress(event){
        this.addButtonDisabled = false;
        this.delteDiabled = true;
        this.isAddress = false;
        if(this.isMaiilingToogle){
            this.isMaiilingToogle = false;
            this.isMaiilingAddress = false;
        }
        if(this.isShippingToogle){
            this.isShippingToogle = false;
            this.isShippingAddress = false;
        }
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
     }
     get condition(){
        return (this.isMaiilingAddress || this.isShippingAddress) ? true : false;
     }
     handleLegalName(event){
         this.handlewithoutSave();
        const legalDbaName = event.target.value;
        let fieldData;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            if(legalDbaName == 1){
                inputFields.forEach(field => {
                    if(field.fieldName == 'DBA_Name__c')
                    fieldData = field.value;
                    if(field.fieldName == 'Corporate_Name__c')
                    field.value = fieldData;
                });
            }else{
                inputFields.forEach(field => {
                    if(field.fieldName == 'Corporate_Name__c')
                    field.value = '';
                });
            } 
        }
    }
    yearBetween(event){
        this.handlewithoutSave();
        const yearEstablished = event.target.value;
        console.log('yearEstablished------------'+yearEstablished);
        let date1 = new Date().getFullYear();
        let month = new Date().getMonth();
        console.log('month------------'+month);
        let yearsDiff = date1 - yearEstablished ;
        console.log('yearsDiff----'+yearsDiff);
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if(inputFields){
            inputFields.forEach(field => {
                if(field.fieldName=="Current_Ownership_Years__c")
                    field.value = yearsDiff;
                if(field.fieldName == "Current_Ownership_Months__c")
                    field.value = month;
            });
        }

    }
}