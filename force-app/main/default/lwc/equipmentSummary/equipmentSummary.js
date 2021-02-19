import { LightningElement, api, track,wire } from 'lwc';
import RSI_ProductLogo from '@salesforce/resourceUrl/RSI_ProductLogo';
import getOpportunityLineItem from '@salesforce/apex/RSI_DynamicAddRemoveRow.getOpportunityLineItem';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateLineItems from '@salesforce/apex/RSI_DynamicAddRemoveRow.updateLineItems';
import lineItemsWithNetRate from '@salesforce/apex/RSI_DynamicAddRemoveRow.getOppLineItemWithShipping';

export default class EquipmentSummary extends LightningElement {

    logo1 = RSI_ProductLogo + '/Images/GATEWAYS.png';
    logo2 = RSI_ProductLogo + '/Images/PAX1.png';
    logo3 = RSI_ProductLogo + '/Images/PAX2.png';
    logo4 = RSI_ProductLogo + '/Images/Internet.png';
    logo5 = RSI_ProductLogo + '/Images/SimCard.png';

    @track equipmentList;
    @api recordId;
    @api shipingMethod;
    equipmentWithIcon = [];
    @track totalAmount;
    @track totalTaxAmount;
    @track shippingCharges;
    @track taxs ;
    @track subTotals;
    @track selectedShippingMethod;
    @track options = [
        {
            label: 'Overnight',
            value: 'Overnight'
        },
        {
            label: '2 Day',
            value: '2 Day'
        },
        {
            label: 'Ground',
            value: 'Ground'
        },
        {
            label: 'Free',
            value: 'Free'
        },
        {
            label: 'Drop Off',
            value: 'Drop Off'
        },
        {
            label: 'Pick Up',
            value: 'Pick Up'
        }
    ];

    /*
    @wire(lineItemsWithNetRate,{ opptyId : '$recordId'})
    wiredLineItem({ error, data }) {
        if (data) {
            var result = data;
            if (result != '' || result != undefined || result != null) {
            var totalship =0;
            for(var obj of result){
                if(obj.Rate_Net_Charge__c)
                totalship+= parseFloat(obj.Rate_Net_Charge__c);   
            }
            this.shippingCharges = '$'+totalship.toFixed(2);
            if(this.shippingCharges == '$0.00'){
                this.shippingCharges = ' FREE' ;
            }
        }
        } else if (error) {
            this.error = error;
            alert('error');
        }
    }
    */







    async connectedCallback() {
        //Fetch data
        console.log('recordId--' + this.recordId);
        this.getData();
        this.getNetRate();
    }

    @api
    getData() {
        //Call Apex class 
        getOpportunityLineItem({ opptyId: this.recordId }).then(result => {
            console.log('In getRecords--' + this.recordId);
            console.log('In result--' + JSON.stringify(result));

            if (this.isNotEmpty(result)) {
                var equipments = [];
                var type1List = ['Pax A920', 'Pax A80', 'PAX SP30', 'Poynt V2'];
                var type2List = ['Pax E500', 'Pax E700'];
                var type3List = ['ONLY FOR 100% INTERNET SALES', 'GATEWAYS'];
               // var total = 0;
                var subTotal =0;
                var taxAmount =0;
               // var totalNetRateChargs =0;

                this.equipmentList = result;

                for (var equipment of this.equipmentList) {
                    this.selectedShippingMethod = equipment.Shipping_Method__c;

                    var icon = '';

                    if ((equipment.Product2.Name).includes('Gatway')){
                        icon = this.logo4;
                    }
                        if (type1List.includes(equipment.Product2.Name)) {
                            icon = this.logo2;
                        }

                        if (type2List.includes(equipment.Product2.Name)) {
                            icon = this.logo3;
                        }

                        if (type3List.includes(equipment.Product2.Name)) {
                            icon = this.logo1;
                        }
                    

                    var data = { key: equipment.Id, value: equipment.Product2.Name, iconName: icon };

                    if (equipment.Product2.Name == 'SIM Card') {
                        //icon = this.logo5;
                        data.isShowIcon = false;
                    } else {
                        data.isShowIcon = true;
                    }

                    equipments.push(data);
                    console.log('equipment.TotalPrice --', equipment.TotalPrice);
                   // total += parseFloat(equipment.Total_Price_With_Tax__c);//parseInt(equipment.Total_Price_With_Tax__c); // TotalPrice
                    subTotal+= parseFloat(equipment.TotalPrice);
                    taxAmount+= parseFloat(equipment.Tax_Amount__c);
                   // if(equipment.Rate_Net_Charge__c){
                      //  totalNetRateChargs+=  parseFloat(equipment.Rate_Net_Charge__c);
                   // }
                   // console.log('total --', total);

                    if (equipment.Ownership_Type__c === '0' || equipment.Ownership_Type__c === 'Purchase') {
                        equipment.unitMonthString = '/ unit';
                    } else if (equipment.Ownership_Type__c === 'Rental') {
                        equipment.unitMonthString = '/ month';
                    } else {
                        equipment.unitMonthString = '';
                    }

                    let unitPrice = equipment.UnitPrice;
                    let totalPrice = equipment.TotalPrice;
                    let tax = equipment.Tax__c;
                    equipment.UnitPrice = unitPrice.toFixed(2);
                    equipment.TotalPrice = totalPrice.toFixed(2);
                    this.taxs = tax.toFixed(2);

                }

               // this.totalAmount = (total + totalNetRateChargs).toFixed(2);
                this.totalTaxAmount = taxAmount.toFixed(2);
                this.subTotals = subTotal.toFixed(2);
                this.equipmentWithIcon = equipments;
                console.log('this.equipmentWithIcon: ', JSON.stringify(this.equipmentWithIcon));
            }
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }

    isNotEmpty(value) {
        if (value !== null && value !== '' && value !== undefined)
            return true;
        return false;
    }

    handleTypeChange(event) {
        this.shipingMethod = event.detail.value;

        for (var equipment of this.equipmentList) {
            equipment.Shipping_Method__c = this.shipingMethod;
        }

        console.log('equipmentList---: ', JSON.stringify(this.equipmentList));

        updateLineItems({ lineItems: JSON.stringify(this.equipmentList) })
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
                       var progress = 3000;
                       this._interval = setInterval(() => {  
                        progress = parseInt(progress) + 5000;  
                        this.getNetRate(); 
                        if ( progress === 23000 ) {  
                            clearInterval(this._interval);  
                        }  
                    }, progress);  
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

    handleEquipmentEditClick(event) {
        console.log('In handleEquipmentEditClick');
        const custEvent = new CustomEvent("callsteptwo");
        this.dispatchEvent(custEvent);
    }

    getNetRate(){
        lineItemsWithNetRate({ opptyId: this.recordId }).then(result => {
         
            if (result != '' || result != undefined || result != null) {
                var totalship =0;
                var total = 0;
                for(var obj of result){
                    if(obj.Rate_Net_Charge__c){
                    totalship+= parseFloat(obj.Rate_Net_Charge__c);
                    }
                    if(obj.Total_Price_With_Tax__c){
                    total += parseFloat(obj.Total_Price_With_Tax__c);  
                    } 
                }

                this.totalAmount = (total + totalship).toFixed(2);
                this.shippingCharges = '$'+totalship.toFixed(2);
                if(this.shippingCharges == '$0.00'){
                    this.shippingCharges = ' FREE' ;
                }
            }
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    }

}