import { LightningElement,track,wire ,api} from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import fetchAllFiles from '@salesforce/apex/RSI_UPloadAdditionalFiles.getFiles';
import uploadSelectedFiles from '@salesforce/apex/RSI_UPloadAdditionalFiles.uploadSelectedFile';
import { NavigationMixin } from 'lightning/navigation';

const COLS=[  
    {label:'File Name',fieldName:'Title', type:'text'},  
    {label:'File Type',fieldName:'FileType', type:'text'}  
  ]; 

export default class RsiShowAllAppFile extends NavigationMixin(LightningElement) {
    cols=COLS; 
  @api recordId;
  @track isLoading = false;
  @track isModalOpen =false;
  @track  oppFileList =[];
  @track selectedRows = [];


  connectedCallback(){
  this.getAppFiles();
  }

  @api handleFileModel(){
    this.isModalOpen =true;
  }
  getAppFiles() {
    fetchAllFiles({ recordId: this.recordId }).then(result => {
       if(result){
        this.oppFileList = result;
       }
    }).catch(error => {
        console.log('Unable to fetch files');
    })
}

getSelectedRows(event) {
    this.selectedRows = event.detail.selectedRows;
   // this.template.getElementById("lightning-datatable").getSelectedRows();
}

  uploadFilesToPPoint(){ 
    var allids =[];
    this.isLoading =true;
    this.selectedRows.forEach(element => { allids.push(element.Id);
      //alert('id =:'+element.Id+'And File Name =:'+element.Title);
  });
    uploadSelectedFiles({ recId : this.recordId,cdId : allids}).then(result => {
      if(result){
        this.showToastMessage ('Success', 'File Uploaded Successfully in Pulsepoint!');
        this.isLoading =false;
        this.isModalOpen = true;
        this.getAppFiles();
        this.isModalOpen = false;
      }
   }).catch(error => {
    this.showToastMessage ('error', 'Unable to upload the files');
    this.isLoading =false;
    this.isModalOpen = false;
       console.log(' file not uploaded');
   })

    this.selectedRows.forEach(element => {
        //alert('id =:'+element.Id+'And File Name =:'+element.Title);
    });

   // var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows(); 
  // alert(selectedRecords.size());
  }

  showToastMessage = (toastType, messageText) => {
    //Generic method to show a toast message. It is being used throughout the code
    const event = new ShowToastEvent ({
        variant: toastType,
        message: messageText
    });
    this.dispatchEvent (event);
}
  
  closeModal() {
    this.isModalOpen = false;
    this.navigateToRecordPage();
  }

  navigateToRecordPage() {
   this.navUrl = this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recordId,
            objectApiName: 'Opportunity',
            actionName: 'view'
        }
    });
}
}