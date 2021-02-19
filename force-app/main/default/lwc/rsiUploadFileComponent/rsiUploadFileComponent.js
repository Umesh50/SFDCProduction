/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-09-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-09-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, track, api } from 'lwc';

export default class RsiUploadFileComponent extends LightningElement {

    @api parentId = '';
    @api documentType;
    statusIcon = 'utility:error';
    iconStatus = 'error';

    get acceptedFormats () {
        return ['.pdf'];
    }
}