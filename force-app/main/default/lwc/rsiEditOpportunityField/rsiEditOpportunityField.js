import { LightningElement, track, api } from 'lwc';

export default class RsiEditOpportunityField extends LightningElement {
    @api indElmnt;
    @track showDate         = false;
    @track showText         = false;
    @track showTextArea     = false;
    @track showPickList     = false;
    @track showCheckBox     = false;
    @track showSection      = false;
    @track showLookup       = false;
    @track fieldSize        = 6;

    get setupDisplayType () {
        var elementType = this.indElmnt.fieldDataType;
        switch (elementType) {
            case 'Date':
                this.showDate = true;
                break;
            case 'Text':
                this.showText = true;
                break;
            case 'Text Area':
                this.showTextArea = true;
                break;
            case 'Picklist':
                this.showPickList = true;
                break;
            case 'Checkbox':
                this.showCheckBox = true;
                break;
            case 'Section':
                this.showSection = true;
                break;
            case 'Lookup':
                this.showLookup = true;
                break;
            default:
                break;
        }
        this.fieldSize = this.indElmnt.fullWidthField ? 12 : 6;
    }
}