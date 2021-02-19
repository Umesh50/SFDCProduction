/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 01-21-2021
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   12-31-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccountRecord from '@salesforce/apex/RSI_DynamicAddRemoveRow.updateAccountRecord';
import getRecords from '@salesforce/apex/RSI_DynamicAddRemoveRow.getRecords';
import getProducts from '@salesforce/apex/RSI_DynamicAddRemoveRow.getProducts';
import deleteLineItem from '@salesforce/apex/RSI_DynamicAddRemoveRow.deleteLineItem';
import createEquipmentProgrammingRecord from '@salesforce/apex/RSI_DynamicAddRemoveRow.createEquipmentProgrammingRecord';

import getProductsWithPrice from '@salesforce/apex/RSI_DynamicAddRemoveRow.getProductsWithPrice';
import { loadStyle } from 'lightning/platformResourceLoader';
import customLebelFont from '@salesforce/resourceUrl/rsi_labelStyle';
export default class EquipmentDetails extends LightningElement {
    @track equipmentName = '';
    @track Equipment1Price;
    @track EcommerceSetupId;
    @track EBTHError = '';
    @track errorText = '';
    @track errorValue = false;
    @track wireless = false;
    @track prodSelected;
    @track MAX_CASHBACKError = '';
    @track errorTextMaxCashback = '';
    @track errorValueMaxCashback = false;

    @track isLoading = false;
    @track priceFieldName = 'Price';
    @track unitMonthString = '/ unit';
    @track varServiceProviderSelected;
    @track pinpadSimcardUnit;
    @api recordId;
    @track selectedAccountId;
    @track itemList = [];
    @track equipment1UnitPrice;
    @track equipment1Quantity;
    @api readStatusOnly;

    @track equipment1Ownership;
    @track accountRecord =
        {
            Id: '',
            Sales_Percent_Types_Card_Present__c: '',
            Sales_Percent_Types_Card_Not_Present__c: '',
            Sales_Percent_Types_Internet__c: ''
        };
    @track keyIndex = 0;
    @track error;
    @track count = 0;
    @track opportunityId;
    @track isShowFirstSection = false;
    @track isShowSecondSection = false;
    @track isShowThirdSection = false;
    @track isShowSecondEquipmentSection = false;
    @track productNameToIdMap;
    @track productNameToPriceMap;
    @track defaultEquipment = 'Pax A80';
    @track defaultEquipment2 = 'SIM Card';
    @track equipmentSelected = 'Pax A80';
    @track isPinpadChecked = false;
    @track isSimCardChecked = false;
    @track equipmentProduct2Id;
    @track equipment2Product2Id;
    @track opptyId = '0062i000005VsF5AAK';
    @track internetProductId;
    @track internetQuantity = 1;
    @track internetPrice = 0;
    @track Card_Present;
    @track Card_Not_Present;
    @track Internet;
    @track equipment1Id;
    @track isEcommerceSet = false;
    @track equipmentProgramming = {};
    @track Notes;
    @track ownershipSelected = 'Purchase';
    @track isRequiredEBT = false;
    @track ownrSLTD;
    @track showGatewayIdCheckboxes;

    @track phoneErrorValue =false;
    @track phoneErrorText ='';
    @track phoneError ='';

    status = false;
    @track options = [
        {
            label: 'RETAIL',
            value: 'RETAIL'
        },
        {
            label: 'RESTAURANT',
            value: 'RESTAURANT'
        },
        {
            label: 'LODGING',
            value: 'LODGING'
        },
        {
            label: 'CARD NOT PRESENT',
            value: 'CARD NOT PRESENT'
        }
    ];

    @api value = 'RETAIL';

    @api
    get showPurchaseCheckboxes() {
        return this.ownershipSelected === 'Purchase' ? true : false;
    }

    handlewithoutSave(event) {
        //custom event to pass Account Id and Opportunity Id to parent component
        const passEvent = new CustomEvent('secondsave', {  detail: { isStepTwoFieldSave :true}});
        this.dispatchEvent(passEvent);
      }

   // @api
   // get showGatewayIdCheckboxes() {
      //  return this.varServiceProviderSelected === 'Auth.Net Existing' ? true : false; //added by UK 00568
   // }

    @api
    get showRentalCheckboxes() {
        return this.ownershipSelected === 'Rental' ? true : false;
    }

    @api
    get showPinpadSectionForE1() {
        return this.equipmentSelected === 'Pax A80' ? true : false;
    }

    @api
    get showSimCardForE1() {
        return this.equipmentSelected === 'Pax A920' ? true : false;
    }

    @api
    get showEBTH() {
        return this.equipmentProgramming.EBT__c == true ? true : false;
    }

    @api
    get showRetailSection() {
        return this.value === 'RETAIL' ? true : false;
    }

    @api
    get showRestaurantSection() {
        return this.value === 'RESTAURANT' ? true : false;
    }

    @api
    get showLodgingSection() {
        return this.value === 'LODGING' ? true : false;
    }

    @api
    get showCardNotPresentSection() {
        return this.value === 'CARD NOT PRESENT' ? true : false;
    }

    renderedCallback() {
        Promise.all([
            loadStyle(this, customLebelFont)
        ])
    }

    async connectedCallback() {

        if (this.readStatusOnly == 'true') {
            this.status = true;
        } else {
            this.status = false;
        }
        //Fetch the current data
        console.log('recordId in dynamic--' + this.recordId);
        // let data = this.getDataRow();
        // this.itemList.push(data);
        this.opptyId = this.recordId;
        this.getData();
        this.getProducts();
        this.getProductsWithPriceMap();
    }

    handlePhoneValidation(event){
        this.handlewithoutSave(); 
        var phoneVal = event.detail.value;
        this.phoneErrorValue =false;
        if(!/^[23456789]\d{9}$/.test(phoneVal) && phoneVal){
         this.phoneErrorValue =true;
         this.phoneErrorText = 'This field must be a valid phone #.';
         this.phoneError = 'slds-has-error';
        }
        if (!this.phoneErrorValue){
            this.phoneError = '';
        }

    }

    handleTypeChange(event) {
        this.handlewithoutSave(); 
        this.value = event.detail.value;
    }

    handleSubmit1(event) {
        event.preventDefault();

        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        // and set or modify existing fields
        if (fields.Equipment__c == 'Pax A80') {
            this.equipment1Quantity = fields.Quantity;
            this.equipment1Ownership = fields.Ownership_Type__c;
        }

        if (fields.SIM_Card__c == true) {
            this.wireless = true;
        }

        //All Poynt Machines
        if (fields.Equipment__c.includes('Poynt')) {
            fields.Equipment_Type__c = '0';//Software/Equipment
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }

        if (fields.Equipment__c.includes('Pax') || fields.Equipment__c.includes('PAX')) {
            fields.Equipment_Type__c = '1';//VAR Vendor Distributed
            fields.Are_you_using_QIR__c = '0';
            fields.VAR_Vendor__c = 'V7080';
            fields.Capture_Method__c = 'HYBRD';
            fields.VAR_Product__c = '13231';
            fields.Close_Method__c = 'TAUTO';
        }

        if (this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Present__c)
            && this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c)) {
            fields.Terminal_ID_Type__c = 'CNP';
        }

        fields.OpportunityId = this.opptyId;
        fields.Product2Id = this.equipmentProduct2Id;
        console.log ('parseInt(this.Equipment1Price) > ' + parseInt(this.Equipment1Price));
        //fields.UnitPrice = parseInt(this.Equipment1Price);

        console.log('fields after 333--' + JSON.stringify(fields));
        //  You need to submit the form after modifications
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            console.log('element.id--' + JSON.stringify(element.id));
            if (element.id.includes('Equipment11Id')) {
                console.log('element.id--' + JSON.stringify(element.id));
                element.submit(fields);
            }
        });

        console.log('this.Equipment1Price1--' + this.Equipment1Price);
    }

    handleSubmit2(event) {
        event.preventDefault();

        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        if (fields.SIM_Card__c == true) {
            this.wireless = true;
        }

        //All Poynt Machines
        if (fields.Equipment__c.includes('Poynt')) {
            fields.Equipment_Type__c = '0';//Software/Equipment
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }

        if (fields.Equipment__c.includes('Pax') || fields.Equipment__c.includes('PAX')) {
            fields.Equipment_Type__c = '1';//VAR Vendor Distributed
            fields.Are_you_using_QIR__c = '0';
            fields.VAR_Vendor__c = 'V7080';
            fields.Capture_Method__c = 'HYBRD';
            fields.VAR_Product__c = '13231';
            fields.Close_Method__c = 'TAUTO';
        }

        if (this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Present__c)
            && this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c)) {
            fields.Terminal_ID_Type__c = 'CNP';
        }

        console.log('fields after--' + JSON.stringify(fields));
        //  You need to submit the form after modifications
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            console.log('element.id--' + JSON.stringify(element.id));
            if (element.id.includes('Equipment2Id')) {
                console.log('element.id--' + JSON.stringify(element.id));
                element.submit(fields);
            }
        });
    }

    handleSuccess1(event) {
        const passEvent = new CustomEvent('secondsave', { detail: { isStepTwoFieldSave :false}});
        this.dispatchEvent(passEvent); //this event added by uk.............

        this.equipment1Id = event.detail.id;
        console.log('this.equipment1Id -' + this.equipment1Id);
        console.log('this.Equipment1Price1--' + this.Equipment1Price);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity Line Item has beed created successfully.',
                variant: 'success'
            }),
        );
    }

    handleSuccess2(event) {
        const passEvent = new CustomEvent('secondsave', { detail: { isStepTwoFieldSave :false}});
        this.dispatchEvent(passEvent); //this event added by uk.............

        this.equipment2Id = event.detail.id;
        console.log('this.equipment2Id -' + this.equipment2Id);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity Line Item has beed created successfully.',
                variant: 'success'
            }),
        );
    }

    handleSuccess(event) {
        //this.recordId = event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity Line Item has beed created successfully.',
                variant: 'success'
            }),
        );
    }

    handleSuccess3(event) {
        const passEvent = new CustomEvent('secondsave', { detail: { isStepTwoFieldSave :false}});
        this.dispatchEvent(passEvent); //this event added by uk.............

        this.EcommerceSetupId = event.detail.id;
        console.log('this.EcommerceSetupId--' + this.EcommerceSetupId);

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity Line Item has beed created successfully.',
                variant: 'success'
            }),
        );

        //Update fields to Account
        this.handleAccountSave();
    }

    getProducts() {
        getProducts({ opptyId: this.recordId }).then(result => {
            console.log('In getProducts dynamic- -');
            console.log('In result--' + JSON.stringify(result));

            if (this.isNotEmpty(result)) {
                this.productNameToIdMap = result;
                this.equipmentProduct2Id = this.productNameToIdMap['Pax A80'];
                console.log('In this.equipmentProduct2Id--' + this.equipmentProduct2Id);
                this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];//'01t2i000002btEOAAY';// this.productNameToIdMap['Pax SP30'];
                this.internetProductId = this.productNameToIdMap['Gatway Processing Services'];
                console.log('In this.internetProductId--' + this.internetProductId);
            } else {

            }
        }).catch(error => {
            console.log('Encountered errors in getProducts() method:- ', error);
        });
    }

    getProductsWithPriceMap() {
        getProductsWithPrice({ opptyId: this.recordId }).then(result => {
            //console.log('In result getProductsWithPrice--' + JSON.stringify(result));

            if (this.isNotEmpty(result)) {
                this.productNameToPriceMap = result;

                // this.equipmentProduct2Id = this.productNameToIdMap['Pax A80'];
                // console.log('In this.equipmentProduct2Id--' + this.equipmentProduct2Id);
                // this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];//'01t2i000002btEOAAY';// this.productNameToIdMap['Pax SP30'];
                // this.internetProductId = this.productNameToIdMap['Gatway Processing Services'];
                // console.log('In this.internetProductId--' + this.internetProductId);
            } else {

            }
        }).catch(error => {
            console.log('Encountered errors in getProducts() method:- ', error);
        });
    }

    msToTime(s) {
        let ms = s % 1000;
        s = (s - ms) / 1000;
        let secs = s % 60;
        s = (s - secs) / 60;
        let mins = s % 60;
        let hrs = (s - mins) / 60;
        hrs = hrs < 10 ? '0' + hrs : hrs;
        mins = mins < 10 ? '0' + mins : mins;
        console.log(hrs + '  ' + mins);
        return hrs + ':' + mins + ':00.000Z';
    }

    getData() {
        //Call Apex class
        getRecords({ opptyId: this.recordId }).then(result => {
            console.log('In getRecords dynamic--' + this.recordId);
            console.log('In result--' + JSON.stringify(result));

            var allRecs = [];
            if (this.isNotEmpty(result)) {
                this.opportunityId = this.recordId;
                var opportunityLineItemList = result.opportunityLineItemList;
                var account = result.account;
                var equipmentProgramming = result.equipmentProgramming;

                //Set equipmentProgramming values
                if (this.isNotEmpty(equipmentProgramming) && Object.keys(equipmentProgramming).length !== 0) {
                    this.equipmentProgramming.Id = equipmentProgramming.Id;
                    this.equipmentProgramming.AUTO_BATCH__c = equipmentProgramming.AUTO_BATCH__c;

                    if (this.isNotEmpty(equipmentProgramming.Time__c)) {
                        this.equipmentProgramming.Time__c = this.msToTime(equipmentProgramming.Time__c);
                    }

                    this.equipmentProgramming.EBT__c = equipmentProgramming.EBT__c;
                    this.equipmentProgramming.EBTH__c = equipmentProgramming.EBTH__c;
                    console.log('equipmentProgramming.EBT__c---' + equipmentProgramming.EBT__c);
                    console.log('Before equipmentProgramming.Time__c---' + equipmentProgramming.Time__c);
                    console.log('After equipmentProgramming.Time__c---' + this.equipmentProgramming.Time__c);
                    if (equipmentProgramming.EBT__c === true) {
                        this.isRequiredEBT = true;
                    }
                    this.equipmentProgramming.No_Signature__c = equipmentProgramming.No_Signature__c;
                    this.equipmentProgramming.Quick_Close__c = equipmentProgramming.Quick_Close__c;
                    this.equipmentProgramming.Contactless__c = equipmentProgramming.Contactless__c;
                    this.equipmentProgramming.CASHBACK_PIN_DEBIT__c = equipmentProgramming.CASHBACK_PIN_DEBIT__c;
                    this.equipmentProgramming.MAX_CASHBACK__c = equipmentProgramming.MAX_CASHBACK__c;
                    this.equipmentProgramming.Fine_Dining__c = equipmentProgramming.Fine_Dining__c;
                    this.equipmentProgramming.Server_Prompt_CA_Only__c = equipmentProgramming.Server_Prompt_CA_Only__c;
                    this.equipmentProgramming.TIP__c = equipmentProgramming.TIP__c;
                    this.equipmentProgramming.Add_Lodging_Quick_Close_Default__c = equipmentProgramming.Add_Lodging_Quick_Close_Default__c;
                    this.equipmentProgramming.Quick_Stay_US_Only__c = equipmentProgramming.Quick_Stay_US_Only__c;
                    this.equipmentProgramming.Add_Card_Not_Present__c = equipmentProgramming.Add_Card_Not_Present__c;
                    this.equipmentProgramming.TAB__c = equipmentProgramming.TAB__c;
                    this.equipmentProgramming.Retail_Tip__c = equipmentProgramming.Retail_Tip__c;
                } else {
                    this.equipmentProgramming =
                    {
                        AUTO_BATCH__c: false,
                        Time__c: '',
                        EBT__c: false,
                        EBTH__c: '',
                        No_Signature__c: false,
                        Quick_Close__c: false,
                        Contactless__c: true,
                        CASHBACK_PIN_DEBIT__c: false,
                        MAX_CASHBACK__c: '',
                        Fine_Dining__c: false,
                        Server_Prompt_CA_Only__c: false,
                        TIP__c: false,
                        Add_Lodging_Quick_Close_Default__c: false,
                        Quick_Stay_US_Only__c: false,
                        Add_Card_Not_Present__c: false,
                        TAB__c: false,
                        Retail_Tip__c: false,
                        WIRELESS__c: false
                    };
                }

                //Set account' value
                if (this.isNotEmpty(account)) {
                    this.accountRecord.Id = account.Id;
                    this.Card_Present = account.Sales_Percent_Types_Card_Present__c;
                    this.Card_Not_Present = account.Sales_Percent_Types_Card_Not_Present__c;
                    this.Internet = account.Sales_Percent_Types_Internet__c;

                    this.accountRecord.Sales_Percent_Types_Card_Present__c = account.Sales_Percent_Types_Card_Present__c;
                    this.accountRecord.Sales_Percent_Types_Card_Not_Present__c = account.Sales_Percent_Types_Card_Not_Present__c;
                    this.accountRecord.Sales_Percent_Types_Internet__c = account.Sales_Percent_Types_Internet__c;
                    this.Notes = account.Notes__c;
                }

                if (this.isNotEmpty(opportunityLineItemList) && opportunityLineItemList.length > 0) {
                    //Set opportunityLineItem Id
                    let lineItemCount = 1;
                    this.showHideSection();

                    for (var record of opportunityLineItemList) {
                        console.log('record --' + JSON.stringify(record));
                        this.count = lineItemCount - 1;
                        if (this.Internet === 100) {
                            this.EcommerceSetupId = record.Id;
                            this.count = 0;
                        }
                        else if (lineItemCount == 1) {
                            this.equipment1Id = record.Id;
                            this.isShowFirstSection = true;
                            this.count = lineItemCount;
                            this.equipmentSelected = record.Equipment__c;
                            this.ownershipSelected = record.Ownership_Type__c;
                            this.defaultEquipment = this.equipmentSelected;
                            console.log('this.equipmentSelected11--' + this.equipmentSelected);
                            this.isPinpadChecked = record.PINPAD__c;
                            this.isSimCardChecked = record.SIM_Card__c;
                            if(record.Ownership_Type__c == 'Rental')
                            {
                                this.unitMonthString = '/ month'; 
                            } else{
                                this.unitMonthString = '/ unit';  
                            }
                        }
                        else if (lineItemCount == 2) {
                            console.log('lineItemCount 2-- ' + lineItemCount);
                            if (this.isShowThirdSection && record.UnitPrice == 0 && record.ProductCode == undefined) {
                                console.log('test 1- ' + lineItemCount);
                                this.EcommerceSetupId = record.Id;
                                this.isEcommerceSet = true;
                                 //this code added by UK..........
                                 if(record.VAR_Service_Provider__c == 'Auth.Net Existing'){
                                    this.showGatewayIdCheckboxes = true;
                                    }
                                this.count = 0;
                            } else {
                                this.showHideEquipment2();
                                if (this.isShowSecondEquipmentSection) {
                                    console.log('test2- ' + lineItemCount);
                                    this.equipment2Id = record.Id;
                                    //added by UK..........
                                    this.equipment1UnitPrice = record.UnitPrice;
                                } else {
                                    console.log('test3- ' + lineItemCount);
                                    this.count = parseInt(this.count);
                                    var data = this.getDataRow(record);
                                    allRecs.push(data);
                                }
                            }
                            //this.isShowSecondEquipmentSection = true;
                            //this.count = lineItemCount;
                            //this.showHideSection();
                        } else if (lineItemCount == 3) {
                            console.log('lineItemCount 3- ' + lineItemCount);
                            if (this.isShowThirdSection && record.UnitPrice == 0 && this.isEcommerceSet == false) {
                                console.log('test4- ' + lineItemCount);
                                this.EcommerceSetupId = record.Id;
                                this.isEcommerceSet = true;
                                this.count = 1;
                            } else {
                                this.showHideEquipment2();
                                if (this.isShowSecondEquipmentSection && !this.isNotEmpty(this.equipment2Id)) {
                                    console.log('test5- ' + lineItemCount);
                                    this.equipment2Id = record.Id;
                                     //added by UK..........
                                     //this.equipment1UnitPrice = record.UnitPrice;
                                } else {
                                    console.log('test6- ' + lineItemCount);
                                    this.count = parseInt(this.count);
                                    var data = this.getDataRow(record);
                                    allRecs.push(data);
                                }
                            }
                        }
                        else {
                            console.log('test7- ' + lineItemCount);
                            //this.count = parseInt(this.count);
                            var data = this.getDataRow(record);
                            allRecs.push(data);
                        }

                        lineItemCount++;
                    }
                    this.count = lineItemCount - 1;
                } else {
                    var data = this.getDataRow('');
                    //allRecs.push(data);
                    this.isShowFirstSection = true;
                    this.count = 1;
                }

                //this.showHideSection();
            } else {
                var data = this.getDataRow('');
                //allRecs.push(data);
                this.isShowFirstSection = true;
                this.count = 1;
            }

            this.itemList = allRecs;


        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }

    isNotEmpty(value) {
        if (value !== null && value !== '' && value !== undefined)
            return true;
        return false;
    }

    getDataRow(record) {
        let recId = '';
        let equipmentName = 'Equipment ' + parseInt(this.count + 1);
        console.log('record in getDataRow()--' + record);

        if (record != '') {
            recId = record.Id;
            console.log('recId in getDataRow()--' + recId);
            console.log('record.Is_Disabled_Equipment__c--' + record.Is_Disabled_Equipment__c);
            console.log('record.Equipment__c--' + record.Equipment__c);

            if (record.Is_Disabled_Equipment__c == true) {
                if (record.Equipment__c == 'PAX SP30') {
                    console.log('123');
                    equipmentName = 'Equipment ' + parseInt(this.count) + ' : ' + 'PINPAD';
                    //code added by UK..........
                     this.pinpadSimcardUnit = '/ unit';

                } else if (record.Equipment__c == 'SIM Card') {
                    console.log('456');
                    equipmentName = 'Equipment ' + parseInt(this.count) + ' : ' + 'SIM Card';
                    this.pinpadSimcardUnit = '/ month';
                }
            }
        }

        console.log('equipmentName--' + equipmentName);

        let data = { Id: recId, eqCount: equipmentName, index: Math.random() };
        return data;
    }

    addRow(event) {
        let data = this.getDataRow('');

        let checkBoxName = event.detail;
        console.log('checkBoxName--' + checkBoxName);

        if (checkBoxName == 'SimCardChecked') {
            this.wireless = true;
            return;
        }

        if (checkBoxName == 'PINPAD' || checkBoxName == 'SIM Card') {
            //data.eqCount = data.eqCount + ' : ' + checkBoxName;
            data.eqCount = 'Equipment ' + parseInt(this.count) + ' : ' + checkBoxName;
        }

        console.log('data--' + JSON.stringify(data));

        this.itemList.push(data);
        if (checkBoxName != 'PINPAD' && checkBoxName != 'SIM Card') {
            this.count = this.count + 1;
        }

    }

    removeRow(event) {
        var allRecs = [];
        //Add fake data to remove all existing records
        //this.itemList = { Id: '', eqCount: 'EQUIPMENT ' + -1, index: -1 };

        //Add single record
        // this.count = 0;
        // allRecs.push(this.getDataRow(''));
        // this.itemList = allRecs;
        this.getData();
    }

    removeRowFromParent(event) {

        // Get current record Id
        console.log('itemId---' + event.target.dataset.itemId);
        let currentRecordId = event.target.dataset.itemId;

        if (this.isNotEmpty(currentRecordId)) {
            if (confirm('This will delete the selected Line Item Record.\nDo you want to proceed?')) {
                deleteLineItem({ recId: currentRecordId }).then(result => {
                    if (result != 'Success') {
                        alert(result);
                    }
                    this.getData();
                }).catch(error => {
                    console.log(error);
                });
            }
        } else {
            //Reload page
            this.getData();
        }
    }

    addEquipment2(event) {
        /*
        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

        cardPresentPercent = isNaN(cardPresentPercent) ? 0 : cardPresentPercent;
        cardNotPresentPercent = isNaN(cardNotPresentPercent) ? 0 : cardNotPresentPercent;
        internetPercent = isNaN(internetPercent) ? 0 : internetPercent;

        if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100) {
            if ((cardPresentPercent + cardNotPresentPercent) == 100) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
            else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100 && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondSection = true;
                } else {
                    this.isShowSecondSection = false;
                }
            } else if (internetPercent == 100) {

            }
        }*/
    }

    removeEquipment2(event) {
        /*
        this.isShowSecondEquipmentSection = false;

        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

        cardPresentPercent = isNaN(cardPresentPercent) ? 0 : cardPresentPercent;
        cardNotPresentPercent = isNaN(cardNotPresentPercent) ? 0 : cardNotPresentPercent;
        internetPercent = isNaN(internetPercent) ? 0 : internetPercent;

        if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100) {
            if ((cardPresentPercent + cardNotPresentPercent) == 100) {
                this.isShowSecondEquipmentSection = false;
            }
            else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100 && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
                this.isShowSecondSection = false;
            } else if (internetPercent == 100) {

            }
        }
        */
    }

    onSubmitHandler(event) {
        event.preventDefault();

        // Get data from submitted form
        const fields = event.detail.fields;

        console.log('fields--' + JSON.stringify(fields));

        // and set or modify existing fields
        fields.Equipment_Type__c = '2';//VAR Service Provider
        fields.Quantity = 1;
        fields.UnitPrice = 0;

        if (fields.VAR_Service_Provider__c == 'Auth.Net New' || fields.VAR_Service_Provider__c == 'Auth.Net Existing') {
            fields.VAR_Product__c = '19230';
        } else if (fields.VAR_Service_Provider__c == 'V6273') {
            fields.VAR_Product__c = '11198';
        }

        //this.accountRecord.VAR_Service_Provider__c = fields.VAR_Service_Provider__c;
        this.accountRecord.Website = fields.Product_Website__c;
        this.accountRecord.Contact_Us_Email__c = fields.Contact_Us_Email__c;
        this.accountRecord.Customer_Service_Phone__c = fields.Customer_Service_Phone_Number__c;

        console.log('In handleInternetSubmit--' + JSON.stringify(this.accountRecord));

        console.log('fields11--' + JSON.stringify(fields));

        if (parseInt(this.accountRecord.Sales_Percent_Types_Internet__c) == 100) {
            fields.Equipment_Type__c = '2';//VAR Service Provider
            fields.Are_you_using_QIR__c = '0';
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }

        if (this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Present__c)
            && this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c)
            && this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Internet__c)) {
            fields.Terminal_ID_Type__c = 'IN';
        }

        console.log('fields after--' + JSON.stringify(fields));
        //  You need to submit the form after modifications
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            console.log('element.id--' + JSON.stringify(element.id));
            if (element.id.includes('EcommerceSetup2')) {
                console.log('element.id--' + JSON.stringify(element.id));
                element.submit(fields);
            }
        });
    }
    onEquipment1SubmitHandler(event) {
        //event.preventDefault();

        // // Get data from submitted form
        //const fields = event.detail.fields;
        //let selectedProductName = fields.Equipment__c;

        console.log('selectedProductName--' + selectedProductName);
        // console.log('fields--' + JSON.stringify(fields));

        // // and set or modify existing fields
        // fields.Product2Id = this.productNameToIdMap.get(selectedProductName);
        // fields.OpportunityId = '0062i0000060W66AAE';
        // console.log('fields11--' + JSON.stringify(fields));
        // // You need to submit the form after modifications
        // //this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleEquipment2Change(event) {
        this.handlewithoutSave(); //this line added by uk..........

        this.equipmentSelected = event.target.value;
        console.log('this.equipmentSelected2--' + this.equipmentSelected);
        // this.equipment2Product2Id = this.productNameToIdMap[this.equipmentSelected];
        // console.log('this.equipment2Product2Id--' + this.equipment2Product2Id);

        // if (!this.isNotEmpty(this.equipment2Product2Id)) {
        //     let equipmentProduct2IdTemp = this.productNameToIdMap['Pax A80'];
        //     console.log('In this.equipmentProduct2IdTemp--' + equipmentProduct2IdTemp);
        //     this.equipment2Product2Id = equipmentProduct2IdTemp;
        // }

        if (this.productNameToIdMap.hasOwnProperty(this.equipmentSelected)) {
            this.equipment2Product2Id = this.productNameToIdMap[this.equipmentSelected];
            console.log('this.equipment2Product2Id--' + this.equipment2Product2Id);
        } else {
            let equipmentProduct2IdTemp = this.productNameToIdMap['Pax A80'];
            console.log('In this.equipmentProduct2IdTemp22--' + equipmentProduct2IdTemp);
            this.equipment2Product2Id = equipmentProduct2IdTemp;
        }

        //Get Price
        if (this.productNameToPriceMap.hasOwnProperty(this.equipmentSelected)) {
            //this code added by UK..........
            if(this.ownershipSelected === 'Free'){
                this.equipment1UnitPrice = 0;
            } else{
            this.equipment1UnitPrice = this.productNameToPriceMap[this.equipmentSelected];
            console.log('In  this.Equipment1Price--' + this.equipment1UnitPrice);
            }
        } else {
            this.Equipment1Price = null;
        }
    }
    
    //this code added by UK............
    priceHandleByOwnerShiptype(event){
        this.handlewithoutSave(); //this line added by uk..........
        var ownShipSleted = event.target.value;
        if (ownShipSleted === 'Purchase') {
            this.equipment1UnitPrice = this.productNameToPriceMap[this.defaultEquipment2]; 
            this.pinpadSimcardUnit = '/ unit';  
        } else if(ownShipSleted === 'Existing'){
        this.equipment1UnitPrice = this.productNameToPriceMap[this.defaultEquipment2];
        this.pinpadSimcardUnit = '/ unit';
        } else if(ownShipSleted === 'Free'){
            this.equipment1UnitPrice = 0; 
            this.pinpadSimcardUnit = '/ unit'; 
        } else if (ownShipSleted === 'Rental') {
            this.equipment1UnitPrice = this.productNameToPriceMap[this.defaultEquipment2];
            this.pinpadSimcardUnit = '/ month';  
        }
    }

     //this code modified by UK............
    handleOwnershipChange(event) {
        this.handlewithoutSave();
        this.ownrSLTD = event.target.value;
        this.ownershipSelected = event.target.value;
        console.log('this.ownershipSelected--' + this.ownershipSelected);
        if(this.ownershipSelected === 'Existing'){
            this.Equipment1Price = this.productNameToPriceMap[this.prodSelected];
            this.unitMonthString = '/ unit'; 
        } else if(this.ownershipSelected === 'Free'){
            this.Equipment1Price = 0;
            this.unitMonthString = '/ unit'; 
        } else if (this.ownershipSelected === 'Purchase') {
            this.unitMonthString = '/ unit';
            this.Equipment1Price = this.productNameToPriceMap[this.prodSelected]; 
        } else if (this.ownershipSelected === 'Rental') {
            this.unitMonthString = '/ month';
            this.Equipment1Price = this.productNameToPriceMap[this.prodSelected];
        } else {
            this.unitMonthString = '';
        }

        if (this.equipmentSelected == 'Pax A80') {
            this.equipment1Ownership = this.ownershipSelected;
        } else {
            this.equipment1Ownership = 'Rental';
        }
    }

     //this code commented by UK............
    //line number 96 in html  in quantity fields onchange={handleQuanityChange}
    /*
    handleQuanityChange(event) {
        if (this.equipmentSelected == 'Pax A80') {
            this.equipment1Quantity = event.target.value;
        } else {
            this.equipment1Quantity = null;
        }

        //Get Price
        if (this.productNameToPriceMap.hasOwnProperty(this.equipmentSelected)) {
            this.Equipment1Price = this.productNameToPriceMap[this.equipmentSelected];
            console.log('In  this.Equipment1Price--' + this.Equipment1Price);
        } else {
            this.Equipment1Price = null;
        }
    }*/

    handleVarServiceProviderChange(event) {
        this.handlewithoutSave(); //this code added by UK..........

        this.varServiceProviderSelected = event.target.value;
        //this code added by UK..........
        if(this.varServiceProviderSelected === 'Auth.Net Existing')
        {
           this.showGatewayIdCheckboxes =true;
        }
        console.log('this.varServiceProviderSelected--' + this.varServiceProviderSelected);
    }

    handleEquipmentChange(event) {
        this.handlewithoutSave();
        this.equipmentSelected = event.target.value;
        this.prodSelected = event.target.value;
        console.log('this.equipmentSelected--' + this.equipmentSelected);
        //this.equipmentProduct2Id = this.productNameToIdMap[this.equipmentSelected];
        //console.log('this.equipmentProduct2Id--' + this.equipmentProduct2Id);

        if (this.productNameToIdMap.hasOwnProperty(this.equipmentSelected)) {
            this.equipmentProduct2Id = this.productNameToIdMap[this.equipmentSelected];
            console.log('this.equipment2Product2Id--' + this.equipment2Product2Id);
        } else {
            let equipmentProduct2IdTemp = this.productNameToIdMap['Pax A80'];
            console.log('In this.equipmentProduct2IdTemp22--' + equipmentProduct2IdTemp);
            this.equipmentProduct2Id = equipmentProduct2IdTemp;
        }

        //Get Price
        if (this.productNameToPriceMap.hasOwnProperty(this.equipmentSelected)) {
            this.Equipment1Price = this.productNameToPriceMap[this.equipmentSelected];
            console.log('In  this.Equipment1Price--' + this.Equipment1Price);
        } else {
            this.Equipment1Price = null;
        }

        this.showHideEquipment2(event);

        // if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
        //     this.isShowSecondEquipmentSection = true;
        // } else {
        //     this.isShowSecondEquipmentSection = false;
        //     this.isShowSecondSection = false;
        // }

    }

    handlePinpadChange(event) {
        this.handlewithoutSave();
        this.isPinpadChecked = event.target.value;
        console.log('this.isPinpadChecked111--' + this.isPinpadChecked);
        this.showHideEquipment2(event);
        // if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
        //     this.isShowSecondEquipmentSection = true;
        // } else {
        //     this.isShowSecondEquipmentSection = false;
        // }

        if (this.isPinpadChecked) {
            this.count = 2;
        } else {
            this.count = 1;
        }
    }

    handleSimCardChange(event) {
        this.handlewithoutSave();
        this.isSimCardChecked = event.target.value;
        console.log('this.isSimCardChecked--' + this.isSimCardChecked);
        this.showHideEquipment2(event);

        if (this.isSimCardChecked) {
            this.count = 2;
        } else {
            this.count = 1;
        }
    }

    showHideEquipment2(event) {
        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);
        console.log('this.accountRecord.Sales_Percent_Types_Card_Present__c--' + this.accountRecord.Sales_Percent_Types_Card_Present__c);
        console.log('parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c)--' + parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c));
        console.log('this.cardPresentPercent--' + cardPresentPercent);
        console.log('this.cardNotPresentPercent--' + cardNotPresentPercent);
        console.log('this.internetPercent--' + internetPercent);
        console.log('this.equipmentSelected--' + this.equipmentSelected);

        if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && isNaN(internetPercent)) {
            if ((cardPresentPercent + cardNotPresentPercent) == 100
                && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: PINPAD';
                    //this.equipment1UnitPrice = null
                    if (this.isNotEmpty(this.productNameToPriceMap)) {
                        //this code added by UK....................
                       if(this.ownrSLTD === 'Free'){
                        this.equipment1UnitPrice = 0;
                       }else{
                        this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                       }
                    }
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    }

                    //this.equipment1Ownership = '';
                    this.defaultEquipment2 = 'PAX SP30';
                    this.pinpadSimcardUnit = '/ unit';
                } else if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: SIM Card';
                    this.equipment1UnitPrice = 15;
                    this.defaultEquipment2 = 'SIM Card';
                    this.equipment1Ownership = 'Rental';
                    this.pinpadSimcardUnit = '/ month';
                    //this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    }
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
        }
        else if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if ((cardPresentPercent + internetPercent) == 100
                && cardNotPresentPercent == 0 && cardPresentPercent != 0 && internetPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: PINPAD';
                    // this.equipment1UnitPrice = null
                    //this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                    // this.equipment1Ownership = '';
                    this.defaultEquipment2 = 'PAX SP30';
                    this.pinpadSimcardUnit = '/ unit';
                    //this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    if (this.isNotEmpty(this.productNameToPriceMap)) {
                        //this code added by UK....................
                       if(this.ownrSLTD === 'Free'){
                        this.equipment1UnitPrice = 0;
                       }else{
                        this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                       }
                    }
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    }
                } else if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: SIM Card';
                    this.equipment1UnitPrice = 15;
                    this.defaultEquipment2 = 'SIM Card';
                    this.equipment1Ownership = 'Rental';
                    this.pinpadSimcardUnit = '/ month';
                    //this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    }
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
            else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100
                && (cardPresentPercent != 0 && cardNotPresentPercent != 0 && internetPercent != 0)) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: PINPAD';
                    //this.equipment1UnitPrice = null
                    //this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                    //this.equipment1Ownership = '';
                    this.defaultEquipment2 = 'PAX SP30';
                    this.pinpadSimcardUnit = '/ unit';
                    //this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    if (this.isNotEmpty(this.productNameToPriceMap)) {
                        //this code added by UK....................
                       if(this.ownrSLTD === 'Free'){
                        this.equipment1UnitPrice = 0;
                       }else{
                        this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                       }
                    }
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    }
                } else if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: SIM Card';
                    this.equipment1UnitPrice = 15;
                    this.defaultEquipment2 = 'SIM Card';
                    this.equipment1Ownership = 'Rental';
                    this.pinpadSimcardUnit = '/ month';
                    // this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    }
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            } else if (internetPercent == 100) {

            }
        }
        else if (!isNaN(cardPresentPercent) && isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if ((cardPresentPercent + internetPercent) == 100
                && cardPresentPercent != 0 && internetPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: PINPAD';
                    // this.equipment1UnitPrice = null
                    //this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                    // this.equipment1Ownership = '';
                    this.defaultEquipment2 = 'PAX SP30';
                    this.pinpadSimcardUnit = '/ unit';
                    //this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    if (this.isNotEmpty(this.productNameToPriceMap)) {
                        //this code added by UK....................
                       if(this.ownrSLTD === 'Free'){
                        this.equipment1UnitPrice = 0;
                       }else{
                        this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                       }
                    }
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    }
                } else if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: SIM Card';
                    this.equipment1UnitPrice = 15;
                    this.defaultEquipment2 = 'SIM Card';
                    this.equipment1Ownership = 'Rental';
                    this.pinpadSimcardUnit = '/ month';
                    //this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    }
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
            else if ((cardPresentPercent + internetPercent) == 100
                && (cardPresentPercent != 0 && internetPercent != 0)) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: PINPAD';
                    //this.equipment1UnitPrice = null
                    //this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                    //this.equipment1Ownership = '';
                    this.defaultEquipment2 = 'PAX SP30';
                    this.pinpadSimcardUnit = '/ unit';
                    //this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    if (this.isNotEmpty(this.productNameToPriceMap)) {
                        //this code added by UK....................
                       if(this.ownrSLTD === 'Free'){
                        this.equipment1UnitPrice = 0;
                       }else{
                        this.equipment1UnitPrice = this.productNameToPriceMap['PAX SP30'];
                       }
                    }
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['PAX SP30'];
                    }
                } else if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked) {
                    this.isShowSecondEquipmentSection = true;
                    this.equipmentName = 'Equipment 1: SIM Card';
                    this.equipment1UnitPrice = 15;
                    this.defaultEquipment2 = 'SIM Card';
                    this.equipment1Ownership = 'Rental';
                    this.pinpadSimcardUnit = '/ month';
                    //this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    if (this.isNotEmpty(this.productNameToIdMap)) {
                        this.equipment2Product2Id = this.productNameToIdMap['SIM Card'];
                    }
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            } else if (internetPercent == 100) {

            }
        }

        if (this.equipmentSelected == 'Pax A920' && this.isSimCardChecked == true) {
            this.equipment1Ownership = 'Rental';
            this.pinpadSimcardUnit = '/ month';
            console.log(' in iffffff2--' + this.equipment1Ownership);
        }

        console.log(' this.equipment1Ownership--' + this.equipment1Ownership);
    }

    handleEquipmentProgrammingSaveClick() {
        this.isLoading = true;

        var MAX_CASHBACK = parseFloat(this.equipmentProgramming.MAX_CASHBACK__c);
        this.errorValueMaxCashback = false;
        this.MAX_CASHBACKError = '';
        this.errorValue = false;
        this.EBTHError = '';

        if (MAX_CASHBACK > 400) {
            this.errorTextMaxCashback = 'Please enter value less than 400.';
            this.errorValueMaxCashback = true;
            this.MAX_CASHBACKError = 'slds-has-error';
        } else {
            this.errorValueMaxCashback = false;
            this.MAX_CASHBACKError = '';
        }

        var EBTHValue = this.equipmentProgramming.EBTH__c;

        if (this.equipmentProgramming.EBT__c == true && this.isNotEmpty(this.equipmentProgramming.EBTH__c) && (EBTHValue.length > 7 || EBTHValue.length < 7)) {
            this.errorText = 'Please enter value only seven characters.';
            this.errorValue = true;
            this.EBTHError = 'slds-has-error';
            console.log('In if1 --- ' + EBTHValue);
        } else {
            this.errorValue = false;
            this.EBTHError = '';
            console.log('In else 1--- ' + EBTHValue);
        }

        if (this.isRequiredEBT == true && !this.isNotEmpty(this.equipmentProgramming.EBTH__c)) {
            this.isLoading = false;
            this.errorText = 'Please enter value only seven characters.';
            this.errorValue = true;
            this.EBTHError = 'slds-has-error';
        } else if (this.isRequiredEBT == true && this.isNotEmpty(this.equipmentProgramming.EBTH__c)) {
            if (EBTHValue.length > 7 || EBTHValue.length < 7) {
                this.errorText = 'Please enter value only seven characters.';
                this.errorValue = true;
                this.EBTHError = 'slds-has-error';
                console.log('In if2 --- ' + EBTHValue);
            } else {
                this.errorValue = false;
                this.EBTHError = '';
                console.log('In else 2--- ' + EBTHValue);
            }
        }

        let isValid = true;

        if (this.errorValueMaxCashback || this.errorValue) {
            this.isLoading = false;
            isValid = false;
            return;
        }

        if (this.equipmentProgramming.EBT__c == false) {
            this.equipmentProgramming.EBTH__c = null;
        }

        if (this.wireless == true) {
            this.equipmentProgramming.WIRELESS__c = true;
        }

        console.log('this.equipmentProgramming--' + JSON.stringify(this.equipmentProgramming));

        if (isValid == true) {
            createEquipmentProgrammingRecord({ equipmentProgramming: this.equipmentProgramming, opportunityId: this.opportunityId })
                .then(result => {
                    this.response = result;
                    this.error = undefined;
                    this.isLoading = false;
                    if (this.response !== undefined) {

                        if (this.response.isSuccess) {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: this.response.message,
                                    variant: 'success',
                                }),
                            );
                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message: this.response.message,
                                    variant: 'error',
                                }),
                            );
                        }

                    }

                    console.log(JSON.stringify(result));
                    console.log("result", this.response);
                    //Update Account
                    this.accountRecord.Notes__c = this.Notes;
                    this.handleAccountSave();
                })
                .catch(error => {
                    this.isLoading = false;
                    this.response = undefined;
                    this.error = error;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error occured while creating record.',
                            response: error.body.response,
                            variant: 'error',
                        }),
                    );
                    console.log("error", JSON.stringify(this.error));
                });
        }
    }

    changeHandler(event) {
        this.handlewithoutSave();// this line added by uk..............
        let fieldName = event.target.name;
        console.log('this.fieldName--' + JSON.stringify(fieldName));
        console.log('event.target.value--' + JSON.stringify(event.target.value));
        this.isPinpadChecked = false;

        switch (fieldName) {
            case 'Notes':
                this.Notes = event.target.value;
                break;
            case 'AUTO_BATCH':
                this.equipmentProgramming.AUTO_BATCH__c = event.target.checked;
                break;
            case 'TIME':
                this.equipmentProgramming.Time__c = event.target.value;
                break;
            case 'EBT':
                this.equipmentProgramming.EBT__c = event.target.checked;
                if (event.target.checked == true) {
                    this.isRequiredEBT = true;
                } else {
                    this.isRequiredEBT = false;
                    this.errorValue = false;
                    this.EBTHError = '';
                    var EBTHValue = this.equipmentProgramming.EBTH__c;
                    console.log('this.equipmentProgramming.EBTH__c--' + this.equipmentProgramming.EBTH__c);
                    console.log('EBTHValue.length--' + EBTHValue.length);
                    if (EBTHValue && (EBTHValue.length > 7 || EBTHValue.length < 7)) {
                        this.errorText = 'Please enter value only seven characters.';
                        this.errorValue = true;
                        this.EBTHError = 'slds-has-error';
                        console.log('In if22--' + this.equipmentProgramming.EBTH__c);
                    } else {
                        this.errorValue = false;
                        this.EBTHError = '';
                        this.disableField = true;
                    }
                }

                break;
            case 'EBT_H':
                this.equipmentProgramming.EBTH__c = event.target.value;
                this.errorValue = false;
                var EBTHValue = event.detail.value;

                if (EBTHValue.length > 7 || EBTHValue.length < 7) {
                    this.errorText = 'Please enter value only seven characters.';
                    this.errorValue = true;
                    this.EBTHError = 'slds-has-error';
                } else {
                    this.errorValue = false;
                    this.EBTHError = '';
                }
                break;
            case 'NO_SIGNATURE':
                this.equipmentProgramming.No_Signature__c = event.target.checked;
                break;
            case 'QUICK_CLOSE':
                this.equipmentProgramming.Quick_Close__c = event.target.checked;
                break;
            case 'CONTACTLESS':
                this.equipmentProgramming.Contactless__c = event.target.checked;
                break;
            case 'CASHBACK_PIN_DEBIT':
                this.equipmentProgramming.CASHBACK_PIN_DEBIT__c = event.target.checked;
                break;
            case 'MAX_CASHBACK':
                this.equipmentProgramming.MAX_CASHBACK__c = event.target.value;
                this.errorValueMaxCashback = false;
                var MAX_CASHBACK = parseFloat(event.detail.value);

                if (MAX_CASHBACK > 400) {
                    this.errorTextMaxCashback = 'Please enter value less than 400.';
                    this.errorValueMaxCashback = true;
                    this.MAX_CASHBACKError = 'slds-has-error';
                } else {
                    this.errorValueMaxCashback = false;
                    this.MAX_CASHBACKError = '';
                }
                break;
            case 'FINE_DINNING':
                this.equipmentProgramming.Fine_Dining__c = event.target.checked;
                break;
            case 'SERVER_PROMPT':
                this.equipmentProgramming.Server_Prompt_CA_Only__c = event.target.checked;
                break;
            case 'TIP':
                this.equipmentProgramming.TIP__c = event.target.checked;
                break;
            case 'TAB':
                this.equipmentProgramming.TAB__c = event.target.checked;
                break;
            case 'Retail_Tip':
                this.equipmentProgramming.Retail_Tip__c = event.target.checked;
                break;
            case 'ADD_LOADGING':
                this.equipmentProgramming.Add_Lodging_Quick_Close_Default__c = event.target.checked;
                break;
            case 'QUICK_STAY_US_ONLY':
                this.equipmentProgramming.Quick_Stay_US_Only__c = event.target.checked;
                break;
            case 'ADD_CARD_NOT_PRESENT':
                this.equipmentProgramming.Add_Card_Not_Present__c = event.target.checked;
                break;
            case 'Card_Present':
                this.accountRecord.Sales_Percent_Types_Card_Present__c = event.target.value;
                this.showHideSection();
                break;
            case 'Card_Not_Present':
                this.accountRecord.Sales_Percent_Types_Card_Not_Present__c = event.target.value;
                this.showHideSection();
                break;
            case 'Internet':
                this.accountRecord.Sales_Percent_Types_Internet__c = event.target.value;
                this.showHideSection();
                break;
        }
        console.log('this.equipmentProgramming--' + JSON.stringify(this.equipmentProgramming));
    }

    showHideSection() {
        console.log('this.showHideSection--');

        this.isShowFirstSection = false;
        this.isShowSecondSection = false;
        this.isShowThirdSection = false;
        this.isShowSecondEquipmentSection = false;

        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

        console.log('this.cardPresentPercent--' + cardPresentPercent);
        console.log('this.cardNotPresentPercent--' + cardNotPresentPercent);
        console.log('this.internetPercent--' + internetPercent);

        if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && isNaN(internetPercent)) {
            if ((cardPresentPercent + cardNotPresentPercent) == 100
                && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
                this.isShowFirstSection = true;
            }
        } else if (isNaN(cardPresentPercent) && isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if (internetPercent == 100) {
                this.isShowFirstSection = false;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            }
        }
        else if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if ((cardPresentPercent + internetPercent) == 100 && cardNotPresentPercent == 0 && cardPresentPercent != 0) {
                this.isShowFirstSection = true;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            }
            else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100
                && cardPresentPercent != 0 && cardNotPresentPercent != 0 && internetPercent != 0) {
                this.isShowFirstSection = true;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            } else if (cardPresentPercent == 0 && cardNotPresentPercent == 100 && internetPercent == 0) {
                this.isShowFirstSection = true;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            } else if (cardPresentPercent == 100 && cardNotPresentPercent == 0 && internetPercent == 0) {
                this.isShowFirstSection = true;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            } else if (cardPresentPercent == 0 && cardNotPresentPercent == 0 && internetPercent == 100) {
                this.isShowFirstSection = false;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            }
        }
        else if (!isNaN(cardPresentPercent) && isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if ((cardPresentPercent + internetPercent) == 100 && internetPercent != 0 && cardPresentPercent != 0) {
                this.isShowFirstSection = true;
                this.isShowSecondSection = false;
                this.isShowThirdSection = true;
                this.isShowSecondEquipmentSection = false;
            }
        }
    }

    handleSaveFields(event){
        const passEvent = new CustomEvent('secondsave', { detail: { isStepTwoFieldSave : event.detail.isStepTwoFieldSave}});
        this.dispatchEvent(passEvent); //this event added by uk.............

    }

    handleLineItemSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity Line Item has beed created successfully.',
                variant: 'success'
            }),
        );
    }

    handleAccountSave(event) {
        const passEvent = new CustomEvent('secondsave', { detail: { isStepTwoFieldSave :false}});
        this.dispatchEvent(passEvent); //this event added by uk.............
        //Update account
        updateAccountRecord({ account: this.accountRecord })
            .then(result => {
                this.response = result;
                this.error = undefined;
                this.isLoading = false;
                if (this.response !== undefined) {

                    if (this.response.isSuccess) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: this.response.message,
                                variant: 'success',
                            }),
                        );
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: this.response.message,
                                variant: 'error',
                            }),
                        );
                    }

                }

                console.log(JSON.stringify(result));
                console.log("result", this.response);
            })
            .catch(error => {
                this.isLoading = false;
                this.response = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error occured while updating account record.',
                        response: error.body.response,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }
}