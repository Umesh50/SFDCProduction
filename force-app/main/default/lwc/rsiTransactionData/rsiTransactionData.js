import { LightningElement ,track,api,wire} from 'lwc';
import getTransList from '@salesforce/apex/RSI_PPMerchantVolume.getTransList';

const columns = [
     { label: 'TOTALNETAMT', fieldName: 'TOTALNETAMT__c', type: 'currency', sortable: true ,typeAttributes: { currencyCode: "USD"} },
     { label: 'DATECREATED', fieldName: 'DATECREATED__c' , type: 'date', sortable: true },
     { label: 'BATCHNUM', fieldName: 'BATCHNUM__c' , type: 'text', sortable: true},
     { label: 'CARDTYPE', fieldName: 'CARDTYPE__c' , type: 'text', sortable: true },
     { label: 'SECNUM', fieldName: 'SECNUM__c' , type: 'text', sortable: true },
     { label: 'TRANSDATE', fieldName: 'TRANSDATE__c' , type: 'date', sortable: true,},
     { label: 'TRANSAMT1', fieldName: 'TRANSAMT1__c' ,type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
     { label: 'TRANSAMT1', fieldName: 'TRANSAMT2__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
     { label: 'CARDTYPEID', fieldName: 'CARDTYPEID__c' , type: 'text', sortable: true},
     { label: 'CARDIDMETHOD', fieldName: 'CARDIDMETHOD__c' , type: 'text', sortable: true },
     { label: 'VOIDINDICATOR', fieldName: 'VOIDINDICATOR__c' ,type:'text', sortable: true},
     { label: 'TRANSCODE', fieldName: 'TRANSCODE__c' , type: 'text', sortable: true},
     { label: 'AUTHAMOUNT', fieldName: 'AUTHAMOUNT__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
 ];

export default class RsiTransactionData extends LightningElement {

 @api recordId ;
 @track error;
 @track volumeList ;
 @api batchNo;
 column = columns;


/* @wire(getTransList,{batchNo : '$batchNo'})
 wiredVolume({error, data }) {
     if (data) {
         this.volumeList = data;
     } else if (error) {
         this.error = error;
     }
 }*/

 async connectedCallback() {
    this.getInit();
}

@api getInit() {
    alert('PC'+this.batchNo);
    getTransList({ batchNo : this.batchNo }).then(result => {
        alert('result--'+result);
       for(r of result){
           alert(r.id);
       }
     this.volumeList = result;
    }).catch(error => {
        console.log('Encountered errors: ', error);
    });
} 
   
}