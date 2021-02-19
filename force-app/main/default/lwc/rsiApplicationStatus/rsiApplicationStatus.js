import { LightningElement ,api} from 'lwc';
import updateAppStatus from '@salesforce/apex/RSI_UpdateApplicationStatus.updateAppStatus';                        
export default class RsiApplicationStatus extends LightningElement {
 @api recordId;

    async connectedCallback() {
        //Fetch the current data
        this.getChangeAppStatus();
    }

    getChangeAppStatus() {
        updateAppStatus({ opptyId: this.recordId }).then(result => {
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }

}