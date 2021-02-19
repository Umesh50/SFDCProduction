import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccountRecord from '@salesforce/apex/RSI_DynamicAddRemoveRow.updateAccountRecord';
import getRecords from '@salesforce/apex/RSI_DynamicAddRemoveRow.getRecords';
import getProducts from '@salesforce/apex/RSI_DynamicAddRemoveRow.getProducts';

export default class EquipmentDetails extends LightningElement {
    @api recordId;
    @track selectedAccountId;
    @track itemList = [];
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
    @track defaultEquipment = 'Pax A80';
    @track equipmentSelected = 'Pax A80';
    @track isPinpadChecked = false;
    @track equipmentProduct2Id;
    @track equipment2Product2Id;
    @track opptyId = '0062i000005VsF5AAK';
    @track internetProductId;
    @track internetQuantity = 1;
    @track internetPrice = 0;

    async connectedCallback() {
        //Fetch the current data
        console.log('recordId--' + this.recordId);
        // let data = this.getDataRow();
        // this.itemList.push(data);
        this.getData();
        this.getProducts();
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

    getProducts() {
        getProducts({ opptyId: this.recordId }).then(result => {
            console.log('In getProducts--');
            console.log('In result--' + JSON.stringify(result));

            if (this.isNotEmpty(result)) {
                this.productNameToIdMap = result;
                this.equipmentProduct2Id = this.productNameToIdMap['Pax A80'];
                console.log('In this.equipmentProduct2Id--' + this.equipmentProduct2Id);
                this.internetProductId = this.productNameToIdMap['Gatway Processing Services'];
                console.log('In this.internetProductId--' + this.internetProductId);
            } else {

            }


        }).catch(error => {
            console.log('Encountered errors in getProducts() method:- ', error);
        });
    }

    getData() {
        //Call Apex class 
        getRecords({ opptyId: this.recordId }).then(result => {
            console.log('In getRecords--' + this.recordId);
            console.log('In result--' + JSON.stringify(result));

            var allRecs = [];
            if (this.isNotEmpty(result)) {
                this.opportunityId = this.recordId;
                var opportunityLineItemList = result.opportunityLineItemList;
                var account = result.account;

                //Set account' value
                if (this.isNotEmpty(account)) {
                    this.accountRecord.Id = account.Id;
                    this.Card_Present = account.Sales_Percent_Types_Card_Present__c;
                    this.Card_Not_Present = account.Sales_Percent_Types_Card_Not_Present__c;
                    this.Internet = account.Sales_Percent_Types_Internet__c;
                }

                if (this.isNotEmpty(opportunityLineItemList) && opportunityLineItemList.length > 0) {
                    //Set opportunityLineItem Id
                    for (var record of opportunityLineItemList) {
                        console.log('record --' + JSON.stringify(record));
                        var data = this.getDataRow(record);
                        this.count = this.count + 1;
                        allRecs.push(data);
                    }
                } else {
                    var data = this.getDataRow('');
                    allRecs.push(data);
                }
            } else {
                var data = this.getDataRow('');
                allRecs.push(data);
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

        if (record != '') {
            recId = record.Id;
        }

        let data = { Id: recId, eqCount: 'EQUIPMENT ' + parseInt(this.count + 1), index: Math.random() };
        return data;
    }

    addRow(event) {
        this.count = this.count + 1;
        let data = this.getDataRow('');
        this.itemList.push(data);
    }

    removeRow(event) {
        var allRecs = [];
        //Add fake data to remove all existing records
        //this.itemList = { Id: '', eqCount: 'EQUIPMENT ' + -1, index: -1 };

        //Add single record
        this.count = 0;
        allRecs.push(this.getDataRow(''));
        this.itemList = allRecs;
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
        fields.Equipment_Type__c = 'VAR Service Provider';
        fields.Quantity = 1;
        fields.UnitPrice = 0;

        if (fields.Gateway__c = 'Network Merchants, Inc') {
            fields.VAR_Product__c = '11198';
        } else if (fields.Gateway__c = 'Auth.Net Existing Setup') {
            fields.VAR_Product__c = '19230';
        }

        console.log('fields11--' + JSON.stringify(fields));
        //  You need to submit the form after modifications
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            console.log('element.id--' + JSON.stringify(element.id));
            if (!element.id.includes('EcommerceSetup1')) {
                console.log('element.id--' + JSON.stringify(element.id));
                element.submit();
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
        this.equipmentSelected = event.target.value;
        console.log('this.equipmentSelected2--' + this.equipmentSelected);
        this.equipment2Product2Id = this.productNameToIdMap[this.equipmentSelected];
        console.log('this.equipment2Product2Id--' + this.equipment2Product2Id);
    }

    handleEquipmentChange(event) {
        this.equipmentSelected = event.target.value;
        console.log('this.equipmentSelected--' + this.equipmentSelected);
        this.equipmentProduct2Id = this.productNameToIdMap[this.equipmentSelected];
        console.log('this.equipmentProduct2Id--' + this.equipmentProduct2Id);
        this.showHideSections();
        // if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
        //     this.isShowSecondEquipmentSection = true;
        // } else {
        //     this.isShowSecondEquipmentSection = false;
        //     this.isShowSecondSection = false;
        // }

    }

    handlePinpadChange(event) {
        this.isPinpadChecked = event.target.value;
        console.log('this.isPinpadChecked111--' + this.isPinpadChecked);
        this.showHideSections();
        // if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
        //     this.isShowSecondEquipmentSection = true;
        // } else {
        //     this.isShowSecondEquipmentSection = false;
        // }
    }

    showHideSections(event) {
        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

        // cardPresentPercent = isNaN(cardPresentPercent) ? 0 : cardPresentPercent;
        // cardNotPresentPercent = isNaN(cardNotPresentPercent) ? 0 : cardNotPresentPercent;
        // internetPercent = isNaN(internetPercent) ? 0 : internetPercent;
        if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && isNaN(internetPercent)) {
            if ((cardPresentPercent + cardNotPresentPercent) == 100
                && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
        }
        else if (!isNaN(cardPresentPercent) && !isNaN(cardNotPresentPercent) && !isNaN(internetPercent)) {
            if ((cardPresentPercent + internetPercent) == 100 && cardNotPresentPercent == 0 && cardPresentPercent != 0 && internetPercent != 0) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            }
            else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100
                && (cardPresentPercent != 0 && cardNotPresentPercent != 0 && internetPercent != 0)) {
                if (this.equipmentSelected == 'Pax A80' && this.isPinpadChecked) {
                    this.isShowSecondEquipmentSection = true;
                } else {
                    this.isShowSecondEquipmentSection = false;
                }
            } else if (internetPercent == 100) {

            }
        }
    }

    changeHandler(event) {
        let fieldName = event.target.name;
        console.log('this.fieldName--' + JSON.stringify(fieldName));
        console.log('event.target.value--' + JSON.stringify(event.target.value));
        this.isPinpadChecked = false;

        switch (fieldName) {
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
        // var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        // var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        // var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

        // console.log('this.cardPresentPercent--' + cardPresentPercent);
        // console.log('this.cardNotPresentPercent--' + cardNotPresentPercent);
        // console.log('this.internetPercent--' + internetPercent);

        // this.isShowFirstSection = false;
        // this.isShowSecondSection = false;
        // this.isShowThirdSection = false;
        // this.isShowSecondEquipmentSection = false;

        // cardPresentPercent = isNaN(cardPresentPercent) ? 0 : cardPresentPercent;
        // cardNotPresentPercent = isNaN(cardNotPresentPercent) ? 0 : cardNotPresentPercent;
        // internetPercent = isNaN(internetPercent) ? 0 : internetPercent;

        // console.log('this.cardPresentPercent--' + cardPresentPercent);
        // console.log('this.cardNotPresentPercent--' + cardNotPresentPercent);
        // console.log('this.internetPercent--' + internetPercent);

        // if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100) {
        //     if ((cardPresentPercent + cardNotPresentPercent) == 100) {
        //         this.isShowFirstSection = true;
        //         this.isShowSecondSection = false;
        //         this.isShowThirdSection = false;
        //         this.isShowSecondEquipmentSection = false;
        //     }
        //     else if ((cardPresentPercent + cardNotPresentPercent + internetPercent) == 100 && cardPresentPercent != 0 && cardNotPresentPercent != 0) {
        //         this.isShowFirstSection = true;
        //         this.isShowSecondSection = false;
        //         this.isShowThirdSection = false;
        //         this.isShowSecondEquipmentSection = false;
        //     } else if (internetPercent == 100) {
        //         this.isShowFirstSection = false;
        //         this.isShowSecondSection = false;
        //         this.isShowThirdSection = true;
        //         this.isShowSecondEquipmentSection = false;
        //     }
        // }

        this.isShowFirstSection = false;
        this.isShowSecondSection = false;
        this.isShowThirdSection = false;
        this.isShowSecondEquipmentSection = false;

        var cardPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Present__c);
        var cardNotPresentPercent = parseInt(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c);
        var internetPercent = parseInt(this.accountRecord.Sales_Percent_Types_Internet__c);

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
        let testAccId = '0012i00000OUhd9AAD';
        this.accountRecord.Id = testAccId;
        //this.accountRecord
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