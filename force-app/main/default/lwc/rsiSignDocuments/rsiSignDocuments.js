import { LightningElement, api, track,wire } from 'lwc';
import LOGO_IMG from '@salesforce/resourceUrl/PaytreeHeaderLogo';
import getOwners from '@salesforce/apex/RSI_OwnerOfficersController.getPGuarantorOwnerList';
import getProducts from '@salesforce/apex/RSI_OwnerOfficersController.getProductList';
import getEqipProg from '@salesforce/apex/RSI_OwnerOfficersController.getEquipmentProg';
import { loadStyle } from 'lightning/platformResourceLoader';
import customLebelFont from '@salesforce/resourceUrl/RSI_hidehelptext';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import accWebsite from '@salesforce/schema/Account.Website';

const fields = [accWebsite];
export default class RsiSignDocuments extends LightningElement {
    logoImage = LOGO_IMG;
    @api recordId;
    @api accountId;
    @api objectApiName = "Opportunity";
    personalEntry = true;
    @track owners = [];
    @track products = [];
    @track equipProgId;
    @track prodtwebsite;

     
    @wire(getRecord, { recordId: '$accountId', fields })
    account;

    get proWebsite() {
        return getFieldValue(this.account.data, accWebsite);
    }
    

    renderedCallback() {
        Promise.all([
            loadStyle(this, customLebelFont)
        ])
    }
    async connectedCallback() {
        //Fetch the current data
        this.getOwnerData();
        this.getProductData();
        this.getEquipProgData();
    }

    getEquipProgData() {
        getEqipProg({ opptyId: this.recordId }).then(result => {
            for (var record of result) {
                //Loop through the records in the result
                var data = record.Id;
                this.equipProgId = data;
            }
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }
   

    getProductData() {
        getProducts({ opptyId: this.recordId }).then(result => {
            var allRecs = [];       //This is the variable that is set as the owners[] later

            for (var record of result) {
                //Loop through the records in the result
                var data = this.getProductRow(record);
                allRecs.push(data);
            }
            this.products = allRecs;
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }
    getOwnerData() {
        //Call Apex class and fetch the Owners
        getOwners({ opptyId: this.recordId }).then(result => {
            var allRecs = [];       //This is the variable that is set as the owners[] later
            var ownerNum = 0;       //This identifies the Owner #. We are unable to use for:index as it starts from 0 and therefore opt for this
            for (var record of result) {
                //Loop through the records in the result

                //Increment Owner Number. For the first run, this sets it as 1.
                ownerNum++;
                //Identify if this is the First Record, i.e. the Primary Owner / Officer record
                var recOne = record.Primary_Owner_Or_Officer__c ? true : false;
                //Setup the data to be stored in the owner[] variable. It consists of Record Id, Owner Type, Identifier of whether it's the Primary or not and finally the Owner #
                var data = this.getDataRow(record, recOne, ownerNum, record.Ownership_Percentage__c);
                allRecs.push(data);
            }
            this.owners = allRecs;
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }

    getDataRow(record, recOne, ownerNum, percentVal) {
        var recId = '';
        var ownType = '';
        var personalEntry;
        var businessEntry;
        if (record != '') {
            recId = record.Id;
            ownType = record.Owner_Type__c;
            if (recOne == true) {
                personalEntry = true;
            } else {
                personalEntry = record.Owner_Type__c == '2' ? true : false;
                businessEntry = record.Owner_Type__c == '3' ? true : false;
            }
        }
        var data = { Id: recId, ownerType: ownType, recNumOne: recOne, ownerNum: ownerNum, personalEntry: personalEntry, businessEntry: businessEntry, percentVal: percentVal };
        return data;
    }


    getProductRow(record) {
        var recId = '';
        var pName = '';
        var ownType = '';
        var qty = '';
        var price = '';
        if (record != '') {
            recId = record.Id;
            pName = record.Product2.Name;
            ownType = record.Ownership_Type__c;
            qty = record.Quantity;
            price = record.UnitPrice;
            if(record.Product_Website__c){
            this.prodtwebsite=record.Product_Website__c;
            }
        }
        var data = { Id: recId, pName: pName, ownType: ownType, qty: qty, price: price };
        return data;
    }

    moveToStepTwo(event) {
        console.log(' In moveToStepTwo');
        const custEvent = new CustomEvent("gotostep2");
        this.dispatchEvent(custEvent);
    }

}