import { LightningElement, api, track } from 'lwc';
import deleteLineItem from '@salesforce/apex/RSI_DynamicAddRemoveRow.deleteLineItem';

export default class LineItemEditForm extends LightningElement {

    @api opptyId;
    @api recordId;
    @api index;
    @api equipment2Product2Id;
    @api productMap;
    @track defaultEquipment2 = 'PAX SP30';
    @track selectedEquipment2 = 'Pax SP30';
    @track prodSelected;
    @track ownershipSelected;
    @track unitMonthString = '/ unit';
    @track Equipment1Price;
    @api priceMap;
    @track isPinpadChecked = false;
    @track isSimCardChecked = false;
    @track isAddedRecord = false;
    @track defaultEquipment;
    @api defaultHeader;
    @api disabledEquipment;
    @api accountRecord;
    @api readStatusOnly;
    status=false;



    handlewithoutSave(event) {
        //custom event to pass Account Id and Opportunity Id to parent component
        const passEvent = new CustomEvent('secondsave', {  detail: { isStepTwoFieldSave :true}});
        this.dispatchEvent(passEvent);
      }

    async connectedCallback() {
        
            if(this.readStatusOnly == 'true'){
                this.status = true;
            }else{ this.status = false;}

        if (this.isNotEmpty(this.defaultHeader) && this.defaultHeader.includes('SIM')) {
            this.defaultEquipment = 'SIM Card';
            this.unitMonthString = '/ month';
            if (this.isNotEmpty(this.priceMap) && this.priceMap.hasOwnProperty('SIM Card')) {
                this.Equipment1Price = this.priceMap['SIM Card'];
                //console.log('In  this.Equipment1Price--' + this.Equipment1Price);
            } else {
                this.Equipment1Price = null;
            }
        } else if (this.isNotEmpty(this.defaultHeader) && this.defaultHeader.includes('PINPAD')) {
            this.defaultEquipment = 'PAX SP30';
            if (this.isNotEmpty(this.priceMap) && this.priceMap.hasOwnProperty('PAX SP30')) {
                this.Equipment1Price = this.priceMap['PAX SP30'];
                //console.log('In  this.Equipment1Price--' + this.Equipment1Price);
            } else {
                this.Equipment1Price = null;
            }
        }
        console.log('In  this.defaultHeader--' + this.defaultHeader);
        console.log('In  this.defaultEquipment--' + this.defaultEquipment);
        console.log('In  this.isNotEmpty(this.defaultEquipment)--' + this.isNotEmpty(this.defaultEquipment));
        console.log('In (this.defaultEquipment)--' + typeof this.defaultEquipment);
    }

    @api
    get showButtons() {
        return true;
    }

    @api
    get showPinpadSectionForE1() {
        return this.selectedEquipment2 === 'Pax A80' ? true : false;
    }

    @api
    get showRentalCheckboxes() {
        return this.ownershipSelected === 'Rental' ? true : false;
    }

    @api
    get isDisableEquipment() {
            return this.isNotEmpty(this.defaultEquipment) === true ? true : false;   
    }

    @api
    get showSimCardForE1() {
        return this.selectedEquipment2 === 'Pax A920' ? true : false;
    }

    @api
    get showPurchaseCheckboxes() {
        return this.ownershipSelected === 'Purchase' ? true : false;
    }

    handleOwnershipChange(event) {
        this.handlewithoutSave();

        this.ownershipSelected = event.target.value;
        // //console.log('this.ownershipSelected--' + this.ownershipSelected);
        if(this.ownershipSelected === 'Existing'){
            this.Equipment1Price = this.priceMap[this.prodSelected];
            this.unitMonthString = '/ unit';
        } else if(this.ownershipSelected === 'Free'){
            this.Equipment1Price = 0;
            this.unitMonthString = '/ unit';
        } else if (this.ownershipSelected === 'Purchase') {
            this.Equipment1Price = this.priceMap[this.prodSelected];
            this.unitMonthString = '/ unit';
        } else if (this.ownershipSelected === 'Rental') {
            this.Equipment1Price = this.priceMap[this.prodSelected];
            this.unitMonthString = '/ month';
        } else {
            this.unitMonthString = '';
        }
    }

    isNotEmpty(value) {
        if (value !== null && value !== '' && value !== undefined)
            return true;
        return false;
    }

    isEmpty(value) {
        if (value == null || value == '' || typeof this.value == 'undefined')
            return true;
        return false;
    }

    handleEquipment2Change(event) {
        
        this.handlewithoutSave();
        let equipmentSelected = event.target.value;
        this.selectedEquipment2 = equipmentSelected;
        this.prodSelected = event.target.value;
        ////console.log('this.equipmentSelected2--' + equipmentSelected);

        if (this.isNotEmpty(this.productMap) && this.productMap.hasOwnProperty(equipmentSelected)) {
            this.equipment2Product2Id = this.productMap[equipmentSelected];
            //console.log('this.equipment2Product2Id111--' + this.equipment2Product2Id);
        } else {
            let equipmentProduct2IdTemp = this.productMap['Pax A80'];
            //console.log('In this.equipmentProduct2IdTemp22--' + equipmentProduct2IdTemp);
            this.equipment2Product2Id = equipmentProduct2IdTemp;
        }

        //console.log('this.equipment2Product2Id--' + this.equipment2Product2Id);

        if (this.isNotEmpty(this.priceMap) && this.priceMap.hasOwnProperty(equipmentSelected)) {
            this.Equipment1Price = this.priceMap[equipmentSelected];
            //console.log('In  this.Equipment1Price--' + this.Equipment1Price);
        } else {
            this.Equipment1Price = null;
        }
    }

    addRow() {
        const eventAdd = new CustomEvent("additem", { detail: 'Normal' });
        this.dispatchEvent(eventAdd);
    }

    addRowOnPinpadCheck(event) {

        this.handlewithoutSave();
        let isChecked = event.target.value;
        //console.log('isChecked--' + isChecked);

        if (isChecked == true && this.isPinpadChecked == false && this.isAddedRecord == false) {
            this.isPinpadChecked = true;
            this.isAddedRecord = true;
            const eventAdd = new CustomEvent("additem", { detail: 'PINPAD' });
            this.dispatchEvent(eventAdd);
        }
    }

    addRowOnSimCardCheck(event) {
        this.handlewithoutSave();
        let isChecked = event.target.value;

        if (isChecked == true && this.isSimCardChecked == false && this.isAddedRecord == false) {
            this.isSimCardChecked = true;
            this.isAddedRecord = true;
            const eventAdd = new CustomEvent("additem", { detail: 'SIM Card' });
            this.dispatchEvent(eventAdd);
        }
    }

    removeRow(event) {
        if (confirm('This will delete the selected Line Item Record.\nDo you want to proceed?')) {
            deleteLineItem({ recId: this.recordId }).then(result => {
                if (result != 'Success') {
                    alert(result);
                }
                const eventRemove = new CustomEvent("removeitem");
                this.dispatchEvent(eventRemove);
            }).catch(error => {
                //console.log(error);
            });
        }
    }

    handleSuccess(event) {
        this.recordId = event.detail.id;
        const eventShowSuccess = new CustomEvent("showsuccess");
        this.dispatchEvent(eventShowSuccess);

         //custom event to pass Account Id and Opportunity Id to parent component
         const passEvent = new CustomEvent('secondsave', {  detail: { isStepTwoFieldSave :false}});
         this.dispatchEvent(passEvent);
    }

    onSubmitHandlerEquipment(event) {
        event.preventDefault();
        // Get data from submitted form
        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        // and set or modify existing fields
        let selectedEquipment = fields.Equipment__c;
        //console.log('selectedEquipment--' + selectedEquipment);
        //console.log('selectedEquipment.includes("PAX")--' + selectedEquipment.includes("PAX"));
        if (selectedEquipment.includes("Pax")) {
            fields.Equipment_Type__c = '0' ;      //'Software/Equipment';
        } else if (selectedEquipment.includes("Poynt")) {
            fields.Equipment_Type__c = '1' ;          //'VAR Vendor Distributed';
        }

        //All Poynt Machines
        if (fields.Equipment__c.includes('Poynt')) {
            fields.Equipment_Type__c = '0'  ;    //'Software/Equipment';
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }

        if (fields.Equipment__c.includes('Pax') || fields.Equipment__c.includes('PAX')) {
            fields.Equipment_Type__c = '1' ;        //'VAR Vendor Distributed';
            fields.Are_you_using_QIR__c = '0';
            fields.VAR_Vendor__c = 'V7080';
            fields.Capture_Method__c = 'HYBRD';
            fields.VAR_Product__c = '13231';
            fields.Close_Method__c = 'TAUTO';
        }

        if (this.defaultEquipment == 'SIM Card' || this.defaultEquipment == 'Pax A80') {
            fields.Is_Disabled_Equipment__c = true;
        }

        if (this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Present__c)
            && this.isNotEmpty(this.accountRecord.Sales_Percent_Types_Card_Not_Present__c)) {
            fields.Terminal_ID_Type__c = 'CNP';
        }
        /*
        if (parseInt(this.accountRecord.Sales_Percent_Types_Internet__c) == 100) {
            fields.Equipment_Type__c = 'VAR Service Provider';
            fields.Are_you_using_QIR__c = '0';
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }
*/
        console.log('fields--' + JSON.stringify(fields));

        // You need to submit the form after modifications
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    onSubmitHandler(event) {
        event.preventDefault();
        // Get data from submitted form
        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        // and set or modify existing fields
        let selectedEquipment = fields.Equipment__c;
        //console.log(' fields--' + JSON.stringify(fields));
        if (this.isNotEmpty(this.productMap) && this.productMap.hasOwnProperty(selectedEquipment)) {
            fields.Product2Id = this.productMap[selectedEquipment];
            //console.log(' fields.Product2Id111' + fields.Product2Id);
        } else {
            fields.Product2Id = this.productMap['Pax A80'];
            //console.log(' fields.Product2Id11122' + fields.Product2Id);
            alert('Selected product not found, taking Pax A80 product');
        }

        if (fields.SIM_Card__c == true) {
            const eventAdd = new CustomEvent("additem", { detail: 'SimCardChecked' });
            this.dispatchEvent(eventAdd);
        }

        //All Poynt Machines
        if (fields.Equipment__c.includes('Poynt')) {
            fields.Equipment_Type__c = '0' ;         //'Software/Equipment';
            fields.Close_Method__c = 'TAUTO';
            fields.Training_Method__c = 'NO';
            fields.Connection_Type__c = 'IP';
            fields.Capture_Method__c = 'HYBRD';
        }

        if (fields.Equipment__c.includes('Pax') || fields.Equipment__c.includes('PAX')) {
            fields.Equipment_Type__c = '1' ;    //'VAR Vendor Distributed';
            fields.Are_you_using_QIR__c = '0';
            fields.VAR_Vendor__c = 'V7080';
            fields.Capture_Method__c = 'HYBRD';
            fields.VAR_Product__c = '13231';
            fields.Close_Method__c = 'TAUTO';
        }

        if (this.defaultEquipment == 'SIM Card' || this.defaultEquipment == 'PAX SP30') {
            fields.Is_Disabled_Equipment__c = true;
        }

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

}