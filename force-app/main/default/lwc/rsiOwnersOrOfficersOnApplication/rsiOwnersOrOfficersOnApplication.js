/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-11-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-07-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, track, api, wire } from 'lwc';
import getOwners from '@salesforce/apex/RSI_OwnerOfficersController.getOwnerList';
import { getRecord } from 'lightning/uiRecordApi';

const MAXROWCOUNT = 4;
export default class RsiOwnersOrOfficersOnApplication extends LightningElement {
    @api recordId ;   //This provides us with the Opportunity Record's row id
    @track owners = [];                 //We use this tracked variable to dynamically display a list of Owners
    totalOwnPer = 0;                    //This stores the Cumulative Ownership % across all Owners / Officers records
    refreshView = false;                //This is used to indicate that the owners[] needs to be refreshed due to actions on individual line item
    @track showError = false;
    @track errorText = '';
    iconClass = 'greenIcon';
    maxRows = MAXROWCOUNT;
    @track opptyRec;
    @track error;
    @track loadDone = false;
    @track soleProp = false;
    @api readStatusOnly;
    @wire(getRecord, {recordId : '$recordId', fields : ['Opportunity.Business_Type__c']})
    wiredOppty ({error, data}) {
        if (data) {
            this.opptyRec = data;
            this.error = undefined;
            this.loadDone = true;
        } else if (error) {
            this.error = error;
            this.record = undefined;
            this.loadDone = false;
        }
    }

    handlescreenfivesave(event){
      //custom event to pass Account Id and Opportunity Id to parent component
      const passEvent = new CustomEvent('fivescreensave', {  detail: { isStepFiveFieldSave :event.detail.isStepFiveFieldSave}});
      this.dispatchEvent(passEvent);
    }

    get busType () {
        if (this.opptyRec.fields.Business_Type__c.value == '0') {
            this.soleProp = true;
        }
        return this.opptyRec.fields.Business_Type__c.displayValue;
        //console.log (this.opptyRec);
        //return 'Hello';
    }

    async connectedCallback () {
        //Fetch the current data
        this.getOwnerData();
    }

    recordSaved (event) {
        //This is called whenever an Owner / Office record is Saved or Deleted
        this.refreshView = true;
        this.getOwnerData();
    }

    getOwnerData () {
        //Call Apex class and fetch the Owners
        getOwners ({opptyId : this.recordId}).then (result => {
            var allRecs = [];       //This is the variable that is set as the owners[] later
            var ownerNum = 0;       //This identifies the Owner #. We are unable to use for:index as it starts from 0 and therefore opt for this
            var ownPercent = 0;     //This stores the owner percent across the records
            var resultLen = result.length;
            var respParty = false;
            for (var record of result) {
                //Loop through the records in the result
                //In case the Ownership % is not defined on the record, consider it as 0.
                if (record.Ownership_Percentage__c == undefined) {
                    record.Ownership_Percentage__c = 0;
                }
                //Add the Ownership %
                ownPercent = ownPercent + record.Ownership_Percentage__c;
                //Increment Owner Number. For the first run, this sets it as 1.
                ownerNum++;
                //Identify if this is the First Record, i.e. the Primary Owner / Officer record
                var recOne = record.Primary_Owner_Or_Officer__c ? true : false;
                //Identify if the Add button should show up or not. It will show up only if we have are below 6 Owner / Officer records and it's the last row
                var lastrow = resultLen < this.maxRows && ownerNum == resultLen && !this.soleProp ? true : false;
                //Setup the data to be stored in the owner[] variable. It consists of Record Id, Owner Type, Identifier of whether it's the Primary or not and finally the Owner #
                var data = this.getDataRow (record, recOne, ownerNum, lastrow, record.Ownership_Percentage__c);
                allRecs.push (data);
                if (!respParty) {
                    respParty = record.Responsible_Party__c;
                }
            }
            //Set the Total Percentage value
            this.totalOwnPer = ownPercent;
            if (allRecs.length > 0) {
                //If we have more than 0 elements in the array, this signifies that we are having records in the Database
                if (this.refreshView){
                    //This signifies that the users clicked on the 'Delete' / 'Save' button on individual Owner / Officer record and this code executed from that.
                    //Only under this instance do we check the Total Ownership %
                    if (this.totalOwnPer < 75) {
                        var notifyMsg = '\nPlease validate Ownership % across all Owners.';
                        //Identify if the Add button should show up or not. It will show up only if we have are below 6 Owner / Officer records and it's the last row
                        if (allRecs.length < this.maxRows && !this.soleProp) {
                            /*allRecs[allRecs.length - 1].lastrow = false;
                            var lastrow = allRecs.length == this.maxRows - 1  ? false : true;*/
                            notifyMsg = '\nPlease enter an additional Owner Information.';
                            //Automatically create another Owner / Officer record if we have less than 6. Pulsepoint accepts a maximum 6 Owners / Officers
                            /*var data = this.getDataRow ('', false, allRecs.length + 1, lastrow, 0);
                            console.log ('Data > ' + data);
                            allRecs.push (data);*/
                        }
                        alert ('Total Ownership % is below 75.' + notifyMsg);
                    }
                }
            } else {
                //This indicates that there is no Owner / Officer record for this Opportunity and we need to add one
                var lastrow = this.soleProp ? false : true;
                var data = this.getDataRow ('', true, 1, lastrow, 0);
                allRecs.push (data);
            }
            this.owners = allRecs;
            this.refreshView = false;
            this.runValidations (respParty);
        }).catch (error => {
            console.log ('Encountered errors: ', error);
        });
    }

    runValidations (respParty) {
        console.log ('Running Checks. Got respParty as: ' + respParty);
        this.showError = !respParty ? true : this.totalOwnPer < 75 ? true : false;
        this.errorText = !respParty ? 'At least One Responsible Party is required' : this.totalOwnPer < 75 ? 'Total Ownership % is less than 75%' : '';
        this.iconClass = !respParty ? 'redIcon' : this.totalOwnPer < 75 ? 'redIcon' : 'greenIcon';
    }

    addOwner () {
        var totalRows = this.owners.length - 1;
        console.log ('totalRows : ' + this.owners.length);
        this.owners[totalRows].lastrow = false;
        var lastrow = this.soleProp ? false : this.owners.length == this.maxRows - 1 ? false : true;
        var data = this.getDataRow ('', false, totalRows + 2, lastrow, 0);
        this.owners.push (data);
    }

    getDataRow (record, recOne, ownerNum, lastrow, percentVal) {
        var recId = '';
        var ownType = '';
        if (record != '') {
            recId = record.Id;
            ownType = record.Owner_Type__c;
        }
        var data = {Id: recId, ownerType : ownType, recNumOne : recOne, ownerNum: ownerNum, lastrow : lastrow, percentVal : percentVal};
        return data;
    }
}