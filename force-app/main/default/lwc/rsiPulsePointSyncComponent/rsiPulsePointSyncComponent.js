/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-03-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-02-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, track, api,wire} from 'lwc';
import initOppty from '@salesforce/apex/RSI_MerchantApplicationPulsePointSync.initComponent';
import createApp from '@salesforce/apex/RSI_MerchantApplicationPulsePointSync.createApplication';
import uploadApp from '@salesforce/apex/RSI_UpdateMerchantAppInformation.executeIntegration';
import uploadSign from '@salesforce/apex/RSI_SignatureHelper.uploadSignaturePage';
import promoteAndDemote from '@salesforce/apex/RSI_PromoteAndDemoteHellper.promoteAndDemote';
import submit from '@salesforce/apex/RSI_PromoteAndDemoteHellper.submitApp';
import updateMPA from '@salesforce/apex/RSI_UpdateMPASection.getUpdateMPASection';

import { getRecord } from 'lightning/uiRecordApi';
// import standard toast event
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
const FIELDS = [
    'opportunity.Name',
    'opportunity.StageName',
    'opportunity.isPromote__c'
];
export default class RsiPulsePointSyncComponent extends LightningElement {
    @api recordId;
    @track appNum = '';
    @track formNum = '';
    @track demoteAction =false;
    @track displaySyncButton = false;
    enableCreateAppButton = false;
    syncButtonEnabled = false;
    isLoading = true;
    promoteDisabled = true;
    demoteDiabled = true;
    selectedItemValue
    opportunity;
    oppSatus;
    isPromote;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading opportunity',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.opportunity = data;
            this.oppSatus = this.opportunity.fields.StageName.value;
            this.isPromote = this.opportunity.fields.isPromote__c.value;
            console.log('this.oppSatus------------',this.oppSatus);
            if(this.isPromote){
                this.demoteDiabled = false
            }
            else if(!this.isPromote && this.oppSatus == 'Sent for Signature'){
                this.promoteDisabled = false;
            }
            
        }
    }
    async connectedCallback () {
        console.log (this.recordId);
        initOppty ({opptyId : this.recordId}).then(result => {
            this.setupNumbers (result);
        }).catch (error => {
            console.log ('Unable to fetch Application information');
        });
    }
    handleOnselect(event){
        this.selectedItemValue = event.detail.value;
        if(this.selectedItemValue == 'MainMenuItem')
        this.submitToPulsePoint();
        if(this.selectedItemValue == 'MenuItemOne')
        this.createApplication();
        if(this.selectedItemValue == 'MenuItemTwo')
        this.syncApplication();
        if(this.selectedItemValue == 'MenuItemThree')
        this.uploadSignature()
        if(this.selectedItemValue == 'MenuItemFour')
        this.promoteAndDemote('promote')
        if(this.selectedItemValue == 'MenuItemFive')
        this.syncAdditionalFiles(); 
        if(this.selectedItemValue == 'MenuItemSix')
        this.promoteAndDemote('demote')
        if(this.selectedItemValue == 'MenuItemSeven')
        this.handleSubmit()
        if(this.selectedItemValue == 'MenuItemEight')
        this.refreshApplicationNotes();
    }
    createApplication () {
        //This event will be called to create the application in PulsePoint
        createApp ({opptyId : this.recordId}).then(result => {
            this.setupNumbers (result);
            this.showToastMessage ('Success', 'Application created in Pulsepoint!');
            this.syncApplication ();
        }).catch (error => {
            this.showToastMessage ('error', 'Unable to create Application in Pulsepoint. Please contact a System Administrator.');
            console.log ('Unable to create Application in Pulsepoint');
        });
    }

    setupNumbers (opptyRec) {
        if (opptyRec.Id === this.recordId && opptyRec != null) {
            this.appNum     = opptyRec.Merchant_Application_No__c;
            this.formNum    = opptyRec.Merchant_Application_Document_No__c;
        }
        if (this.appNum != '' && this.appNum != undefined && this.appNum != null) {
            this.enableCreateAppButton = true;
            this.syncButtonEnabled = false;
        } else {
            this.enableCreateAppButton = false;
            this.syncButtonEnabled = true;
        }
        this.isLoading = false;
    }

    syncApplication () {
        updateMPA ({oppId : this.recordId}).then (result => {}).catch(error =>{});

        uploadApp ({oppId : this.recordId}).then (result => {
            this.showToastMessage ('success', 'Successfully synced Salesforce Data with Pulsepoint');
            this.uploadSignature();
        }).catch (error => {
            this.showToastMessage ('error', 'Unable to sync Salesforce data with Pulsepoint. Please contact a System Administrator');
        });
    }

    showToastMessage = (toastType, messageText) => {
        //Generic method to show a toast message. It is being used throughout the code
        const event = new ShowToastEvent ({
            variant: toastType,
            message: messageText
        });
        this.dispatchEvent (event);
    }

    uploadSignature () {
        uploadSign ({recId: this.recordId}).then (result => {
            this.showToastMessage ('success', 'Signature Document uploaded successfully');
                this.promoteAndDemote('promote');
        }).catch (error => {
            this.showToastMessage ('error', 'Unable to upload the Signature Document');
        });
    }
    displayButtons(event){
        this.displaySyncButton = event.target.checked;
    }
    promoteAndDemote(keyData){
        console.log('keyData----'+keyData);
        promoteAndDemote ({oppId: this.recordId,keyName:keyData}).then (result => {
            if(keyData == 'promote'){
                this.promoteDisabled = true;
                this.demoteDiabled = false;
                this.showToastMessage ('success', 'Application Submited to office successfully');
            }
            else{
                this.demoteDiabled = true;
                this.promoteDisabled = false;
                this.showToastMessage ('success', 'Application Returned by office successfully');
                this.syncApplication ();
            }
        }).catch (error => {
            this.showToastMessage ('error', 'Application Unable to Submited to office ');
        });
    }

    handleSubmit(){
        submit ({oppId: this.recordId}).then (result => {
            if(result == 'Success')
            this.showToastMessage ('success', 'Record Submitted successfully');
            else
            this.showToastMessage ('error', result);
        }).catch (error => {
            this.showToastMessage ('error', 'Unable to send application');
        });
    }

    syncAdditionalFiles(){
        //called child component method to show all files
        this.template.querySelector("c-rsi-show-all-app-file").handleFileModel();
    }

    refreshApplicationNotes(){
        this.template.querySelector("c-rsi-refresh-app-notes").getApplicationNotes();
    }

    submitToPulsePoint(){
        if (this.appNum == '' || this.appNum == undefined || this.appNum == null) {
            this.createApplication(); 
          } else { 
            this.promoteAndDemote('demote');
             }
    }
}