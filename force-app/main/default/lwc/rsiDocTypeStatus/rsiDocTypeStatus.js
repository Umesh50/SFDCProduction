import { LightningElement, track, api } from 'lwc';
import fetchFiles from '@salesforce/apex/RSI_UploadFileController.getFiles';

export default class RsiDocTypeStatus extends LightningElement {

    @track dataToDisplay;
    @track docTypeToStatus;
    @api selOption;
    @track isShowCheckbox = false;
    @track fileData = [];
    @api recordId;

    @api
    get currentrecordid() {
        return this.recordId;
    }

    set currentrecordid(value) {
        this.recordId = JSON.parse(JSON.stringify(value));
        console.log('recordId value--' + JSON.stringify(value));
    }

    @api
    get doctypetostatus() {
        return this.docTypeToStatus;
    }

    set doctypetostatus(value) {
        this.docTypeToStatus = JSON.parse(JSON.stringify(value));
        console.log('doctypetostatus value--' + JSON.stringify(value));
    }

    @api
    get seloption() {
        return this.dataToDisplay;
    }

    set seloption(value) {
        console.log('this.docTypeToStatus--' + JSON.stringify(this.docTypeToStatus));
        console.log('selOption value--' + JSON.stringify(value));

        this.selOption = JSON.parse(JSON.stringify(value));

        for (var indDoc of this.docTypeToStatus) {
            if (indDoc.key == this.selOption) {
                this.isShowCheckbox = true;
                this.dataToDisplay = indDoc;
                break;
            } else {
                this.isShowCheckbox = false;
            }
        }

        this.getRecFiles();
    }

    @api
    getRecFiles() {
        console.log('In getRecFiles');
        console.log('this.recordId--' + this.recordId);
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
            // this.anyUploads = true;
            this.setSuccessIcon();
        }
    }

    setSuccessIcon() {
        console.log('this.selOption--' + this.selOption);
        for (var indDoc of this.docTypeToStatus) {
            for (var file of this.fileData) {
                if (indDoc.key == file.LatestPublishedVersion.Document_Type__c && indDoc.key == this.selOption) {
                    this.dataToDisplay.iconName = 'utility:success';
                    this.dataToDisplay.iconTitle = 'File Uploaded';
                    this.dataToDisplay.iconVariant = 'success';
                    break;
                }
            }
        }
    }
}