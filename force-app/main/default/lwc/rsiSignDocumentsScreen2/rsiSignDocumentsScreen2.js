import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOwners from '@salesforce/apex/OwnerOrOfficerHelper.getOwnerOffList'; 
import getOwnersResp from '@salesforce/apex/OwnerOrOfficerHelper.getOwnerCheckOffList';
import getOwnersShipType from '@salesforce/apex/OwnerOrOfficerHelper.getOwnershipType';
import getNavigateUrl from '@salesforce/apex/RSI_NavigateToUrlGen.getNavigateUrl';
import updatecheckBox from '@salesforce/apex/OwnerOrOfficerHelper.updateOwnerOffCheckBox';
export default class RsiSignDocumentsScreen2 extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isPopUpOpen = false;
    @track data = [];
    @track data1 = [];
    @track ownerData;
    @track showButton = false;
    @track isRentalAggrement = false;
    @track isIagree = false;
    @track displayOwnerOff = false;
    async connectedCallback () {
        //Fetch the current data
        this.getOwnerData();
        this.getOwnerRespData();
        this.getOwnerType();
    }
    getOwnerType(){
        getOwnersShipType ({opptyId : this.recordId}).then (result => {
            if(result)
                this.isRentalAggrement = result;
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    }
    getOwnerData(){
        getOwners ({opptyId : this.recordId}).then (result => {
            this.data = result;
            console.log('----------'+JSON.stringify(this.data));
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    } 
    getOwnerRespData(){
        getOwnersResp ({opptyId : this.recordId}).then (result => {
            if(result.length>0){
                this.data1 = result;
                this.ownerData = result[0];
                this.isIagree = this.ownerData.I_Agree__c;
                this.displayOwnerOff = true;
            }
            else{
                const evt = new ShowToastEvent({
                    title: "Error!",
                   message: "Owner Officer's are not associated with this application",
                    variant: "error",
                });
                this.dispatchEvent(evt);
            }
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    }
    navigateToVFPage() 
{  
let appId = this.recordId;     
 const urlWithParameters = '/apex/RSI_SignaturePage?appId='+appId;
console.log('urlWithParameters...'+urlWithParameters);
this[NavigationMixin.Navigate]
({type: 'standard__webPage',
attributes: {url: urlWithParameters}}, 
false);    
 }
    
    navigateToVFPagedocument() {
        getNavigateUrl({oppId :this.recordId}).then(result =>{
            const urlWithParameters = result;
            console.log('urlWithParameters...'+urlWithParameters);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: urlWithParameters
                }
            }, false); 
        });
    }
    updateOwnerOffCheckBox(event){
        console.log('checkBoxData-----------'+this.checkBoxData);
        let checkBoxData = event.target.checked;

        console.log('this.ownerData.Id-----------'+this.ownerData.Id);
        updatecheckBox ({owfId : this.ownerData.Id,checkBoxValue:checkBoxData}).then (result => {
            console.log('result------'+result);
            if(checkBoxData)
                this.showButton = true;
            else
            this.showButton = false;
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    }
    
}