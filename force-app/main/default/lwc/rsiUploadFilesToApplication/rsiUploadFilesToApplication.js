/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-17-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-04-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, api, track, wire } from 'lwc';
//Import libraries to Get Object data
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
//Import the object and the fields
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import DOCS_FIELD from '@salesforce/schema/Opportunity.Required_Documents__c';
import LEGAL_FIELD from '@salesforce/schema/Opportunity.Evidence_of_Legal_Status__c';
//Import the apex class methods
import updateFile from '@salesforce/apex/RSI_UploadFileController.updateFileRecord';
import fetchFiles from '@salesforce/apex/RSI_UploadFileController.getFiles';
import updateAppStatus from '@salesforce/apex/RSI_UploadFileController.getAppStatus';

// importing navigation service
import { NavigationMixin } from 'lightning/navigation';

export default class RsiUploadFilesToApplication extends NavigationMixin(LightningElement) {
    @api recordId;  //This provides us with the Opportunity Record's row id
    docTypeToStatus = []; //This will help track the File Upload status for each Document Type
    anyUploads = false; //This is flipped to true if any Document has been uploaded to Salesforce. This controls the display of the table of uploaded files
    @track fileData = [];
    reqDocsList = [];
    @track selOptions = [];
    fieldValue = '';
    initDone = false;
    nochecks = false;
    @api readStatusOnly;
     status=false;
    @track selectedLabel;
    @track selectedStatus;
     connectedCallback(){

        if(this.readStatusOnly == 'true'){
            this.status = true;
        }else{
            this.status = false;
        }
   }

    @wire(getRecord, { recordId: '$recordId', fields: [LEGAL_FIELD, DOCS_FIELD] })
    opptyRec;

    @wire(getPicklistValues, { recordTypeId: '$opptyRec.data.recordTypeId', fieldApiName: DOCS_FIELD })
    reqDocsReceived({ error, data }) {
        if (data) {
            this.reqDocsList = data.values;
            this.initMaps();
            this.getRecFiles();
        } else if (error) {
            console.log(error);
        }
    }

    initMaps() {
        if (!this.initDone) {
            console.log('Initializing');
            var docTypes = [];
            var selValues = this.opptyRec.data.fields.Required_Documents__c.value;
            var displayLegal = this.opptyRec.data.fields.Evidence_of_Legal_Status__c.displayValue;
            if (displayLegal != null) {
                var data = { key: 'Legal: ' + displayLegal, value: true, req: true, iconName: 'utility:routing_offline', iconTitle: 'Upload Pending', iconVariant: '' };
                docTypes.push(data);
                this.selOptions.push('Legal: ' + displayLegal);
                this.fieldValue = 'Legal: ' + displayLegal;
            }
            for (var single of this.reqDocsList) {
                var selValue = selValues == null ? false : selValues.includes(single.label);
                var data = { key: single.label, value: selValue, req: false, iconName: 'utility:routing_offline', iconTitle: 'Upload Pending', iconVariant: '' };
                docTypes.push(data);
                if (selValue) {
                    this.selOptions.push(single.label);
                }
            }
            this.docTypeToStatus = docTypes;
            this.initDone = true;
            this.nochecks = this.selOptions.length > 0 ? false : true;
        }
    }

    get acceptedFormats() {
        return ['.pdf'];
    }

    addRemoveUploads(event) {
        var selLab = event.target.label;
        var selVal = event.target.checked;
        this.selectedLabel = selLab;
        if(selVal)
            this.selectedStatus = true;
        else
            this.selectedStatus = false;
        this.updateApplicationStatus();
        var selVal = event.target.checked;
        if (event.target.checked) {
            this.selOptions.push(event.target.label);
        } else {
            var elms = [];
            for (var elm of this.selOptions) {
                if (elm != event.target.label) {
                    elms.push(elm);
                }
            }
            this.selOptions = elms;
        }
        this.nochecks = this.selOptions.length > 0 ? false : true;
        for (var indDoc of this.docTypeToStatus) {
            if (indDoc == selLab) {
                if (!selVal) {
                    indDoc.iconName = 'utility:routing_offline';
                    indDoc.iconTitle = 'Upload Pending'
                    indDoc.iconVariant = '';
                } else {
                    this.setSuccessIcon();
                }
            }
        }
        this.setFieldValue();
    }
    updateApplicationStatus() {
        updateAppStatus ({oppId : this.recordId,selectedLabel : this.selectedLabel,isChecked : this.selectedStatus}).then (result => {}).catch(error =>{});
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        var documentId = uploadedFiles[0].documentId;
        var fileType = event.currentTarget.name;
        console.log('fileType--------'+fileType);
        updateFile({ documentId: documentId, description: fileType, recordId: this.recordId }).then(result => {
            this.readResults(result);
            //this.template.querySelector("c-rsi-doc-type-status").getRecFiles();

            this.template
                .querySelectorAll("c-rsi-doc-type-status")
                .forEach(element => {
                    element.getRecFiles();
                });

        }).catch(error => {
            console.log('Unable to upload files');
        });
    }

    openFile(event) {
        var fileId = event.target.value;
        console.log(fileId);
        // Naviagation Service to the show preview
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                // assigning ContentDocumentId to show the preview of file
                selectedRecordId: fileId
            }
        });
    }

    getRecFiles() {
        fetchFiles({ recordId: this.recordId }).then(result => {
            this.readResults(result);
        }).catch(error => {
            console.log('Unable to fetch files');
        })
    }

    readResults(result) {
        var recList = result;
        this.fileData = recList;
        if (recList.length > 0) {
            this.anyUploads = true;
            this.setSuccessIcon();
        }
    }

    setSuccessIcon() {
        for (var indDoc of this.docTypeToStatus) {
            for (var file of this.fileData) {
                if (indDoc.key == file.LatestPublishedVersion.Document_Type__c) {
                    indDoc.iconName = 'utility:success';
                    indDoc.iconTitle = 'File Uploaded';
                    indDoc.iconVariant = 'success';
                }
            }
        }
        console.log('this.docTypeToStatus----------'+JSON.stringify(this.docTypeToStatus));
    }

    setFieldValue() {
        var fieldData = '';
        for (var elm of this.selOptions) {
            fieldData = fieldData == '' ? elm : fieldData + ';' + elm;
        }
        this.fieldValue = fieldData;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[DOCS_FIELD.fieldApiName] = this.fieldValue;
        const recordInput = { fields };
        updateRecord(recordInput).then(() => {
            console.log('Saved');
        }).catch(error => {
            console.log(error.body.message);
        });
        console.log('---status-----'+JSON.stringify(this.docTypeToStatus));
    }
}