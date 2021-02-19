import { LightningElement,track,api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAllNotes from '@salesforce/apex/RSI_PPointApplicationNotes.getPPointNotes';

export default class RsiRefreshAppNotes extends LightningElement {

  @api recordId;
  @track isLoading = false;


  @api getApplicationNotes(){
    this.isLoading =true;
    getAllNotes({ oppid : this.recordId}).then(result => {
        if(result){
          this.showToastMessage ('Success', 'Notes has been refresh Successfully!');
          this.isLoading =false;
        }else{
          this.showToastMessage ('Success', 'There is existing notes');
          this.isLoading =false;
        }
     }).catch(error => {
      this.showToastMessage ('error', 'Unable to refresh the notes');
      this.isLoading =false;
         console.log(' file not uploaded');
     })
  }

  showToastMessage = (toastType, messageText) => {
    //Generic method to show a toast message. It is being used throughout the code
    const event = new ShowToastEvent ({
        variant: toastType,
        message: messageText
    });
    this.dispatchEvent (event);
}

}