import { LightningElement,track ,api,wire} from 'lwc';
import getMerchantInfo from '@salesforce/apex/RSI_PPMerchantVolume.getVolumeList';
import getTransList from '@salesforce/apex/RSI_PPMerchantVolume.getTransList';
/*
const columns = [
   // { label: 'MID', fieldName: 'MID__c' , type: 'Text', sortable: true },
    { label: 'TIDNUM', fieldName: 'TIDNUM__c', type: 'text', sortable: true },
    { label: 'DATECREATED', fieldName: 'DATECREATED__c' , type: 'date', sortable: true },
    { label: 'TOTALNETAMT', fieldName: 'TOTALNETAMT__c' , type: 'currency', sortable: true ,typeAttributes: { currencyCode: "USD"}},
    { label: 'TOTALTRANSNUM', fieldName: 'TOTALTRANSNUM__c' , type: 'text', sortable: true },
    { label: 'BATCHNUM', fieldName: 'BATCHNUM__c' , type: 'text', sortable: true },
    { label: 'AMTPURCHASE', fieldName: 'AMTPURCHASE__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"} },
    { label: 'NUMPURCHASE', fieldName: 'NUMPURCHASE__c' , type: 'text', sortable: true },
    { label: 'AMTRETURN', fieldName: 'AMTRETURN__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
    { label: 'NUMRETURN', fieldName: 'NUMRETURN__c' , type: 'text', sortable: true},
    { label: 'APPLICATIONNO', fieldName: 'APPLICATIONNO__c' , type: 'text', sortable: true },
    { label: 'MERCHANTBATCHNO', fieldName: 'MERCHANTBATCHNO__c' ,type:'text', sortable: true},
    { label: 'AVERAGETICKET', fieldName: 'AVERAGETICKET__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
   // { label: 'ROW', fieldName: 'ROW__c' , type: 'Text', sortable: true }
]; */

const columnTrans = [
    { label: 'TOTALNETAMT', fieldName: 'TOTALNETAMT__c', type: 'currency', sortable: true ,typeAttributes: { currencyCode: "USD"} },
    { label: 'DATECREATED', fieldName: 'DATECREATED__c' , type: 'Date', sortable: true },
    { label: 'BATCHNUM', fieldName: 'BATCHNUM__c' , type: 'text', sortable: true},
    { label: 'CARDTYPE', fieldName: 'CARDTYPE__c' , type: 'text', sortable: true },
    { label: 'SECNUM', fieldName: 'SECNUM__c' , type: 'text', sortable: true },
    { label: 'TRANSDATE', fieldName: 'TRANSDATE__c' , type: 'Date', sortable: true,},
    { label: 'TRANSAMT1', fieldName: 'TRANSAMT1__c' ,type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
    { label: 'TRANSAMT1', fieldName: 'TRANSAMT2__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
    { label: 'CARDTYPEID', fieldName: 'CARDTYPEID__c' , type: 'text', sortable: true},
    { label: 'CARDIDMETHOD', fieldName: 'CARDIDMETHOD__c' , type: 'text', sortable: true },
    { label: 'VOIDINDICATOR', fieldName: 'VOIDINDICATOR__c' ,type:'text', sortable: true},
    { label: 'TRANSCODE', fieldName: 'TRANSCODE__c' , type: 'text', sortable: true},
    { label: 'AUTHAMOUNT', fieldName: 'AUTHAMOUNT__c' , type: 'currency', sortable: true,typeAttributes: { currencyCode: "USD"}},
]; 
export default class RsiMerchantVolume extends LightningElement {

   @api recordId ;
  // @track column = columns;
   @track error;
   @track volumeList ;
   @track transList;
   columnsTrans =columnTrans;
   @track refreshView = true;

/*
   async connectedCallback() {
    this.getInit();
}*/

    @wire(getMerchantInfo,{accId : '$recordId'})
    wiredVolume({error, data }) {
        if (data) {
            this.volumeList = data;
        } else if (error) {
            this.error = error;
        }
    }

    AuditcardBUtton(event) {
        this.refreshView = true;
        var batNo = event.currentTarget.dataset.value;
        if(batNo){
        this.getTranData(batNo);
    }
    }

    getTranData(batNo){
        getTransList({ batchNo : batNo }).then(result => {
            if(result){
            this.transList = result;
            this.refreshView = false;
            }
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });

    }
/*
    getInit() {
        getMerchantInfo({ accId : this.recordId }).then(result => {
            var allRecs =[]
            for(record of result){
                alert('inside method '+result);
                allRecs.push(record);
                this.refreshView1 = true;
            }

            // var obj = { Id :id,TIDNUM : d[1], DATECREATED : d2, TOTALNETAMT:'$ '+parseFloat(d[4]).toFixed(2), TOTALTRANSNUM : d[5],
               // BATCHNUM : d[6],AMTPURCHASE :'$ '+parseFloat(d[7]).toFixed(2),NUMPURCHASE:d[8],AMTRETURN:'$ '+parseFloat(d[9]).toFixed(2),
               // NUMRETURN: d[10],APPLICATIONNO: d[11],
               // MERCHANTBATCHNO :d[12],AVERAGETICKET:'$ '+parseFloat(d[13]).toFixed(2)};
                //allRecs.push(data);
                // MID: d[0],ROW:d[14]
           //}
          
         this.volumeList = allRecs;
        }).catch(error => {
            console.log('Encountered errors: ', error);
        });
    } */

    //FOR HANDLING THE HORIZONTAL SCROLL OF TABLE MANUALLY
    tableOuterDivScrolled(event) {
        this._tableViewInnerDiv = this.template.querySelector(".tableViewInnerDiv");
        if (this._tableViewInnerDiv) {
            if (!this._tableViewInnerDivOffsetWidth || this._tableViewInnerDivOffsetWidth === 0) {
                this._tableViewInnerDivOffsetWidth = this._tableViewInnerDiv.offsetWidth;
            }
            this._tableViewInnerDiv.style = 'width:' + (event.currentTarget.scrollLeft + this._tableViewInnerDivOffsetWidth) + "px;" + this.tableBodyStyle;
        }
        this.tableScrolled(event);
    }
 
    tableScrolled(event) {
        if (this.enableInfiniteScrolling) {
            if ((event.target.scrollTop + event.target.offsetHeight) >= event.target.scrollHeight) {
                this.dispatchEvent(new CustomEvent('showmorerecords', {
                    bubbles: true
                }));
            }
        }
        if (this.enableBatchLoading) {
            if ((event.target.scrollTop + event.target.offsetHeight) >= event.target.scrollHeight) {
                this.dispatchEvent(new CustomEvent('shownextbatch', {
                    bubbles: true
                }));
            }
        }
    }

 
    //#region ***************** RESIZABLE COLUMNS *************************************/
    handlemouseup(e) {
        this._tableThColumn = undefined;
        this._tableThInnerDiv = undefined;
        this._pageX = undefined;
        this._tableThWidth = undefined;
    }
 
    handlemousedown(e) {
        if (!this._initWidths) {
            this._initWidths = [];
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                this._initWidths.push(th.style.width);
            });
        }
 
        this._tableThColumn = e.target.parentElement;
        this._tableThInnerDiv = e.target.parentElement;
        while (this._tableThColumn.tagName !== "TH") {
            this._tableThColumn = this._tableThColumn.parentNode;
        }
        while (!this._tableThInnerDiv.className.includes("slds-cell-fixed")) {
            this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
        }
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
        this._pageX = e.pageX;
 
        this._padding = this.paddingDiff(this._tableThColumn);
 
        this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
    }

    handlemousemove(e) {
        console.log("mousemove this._tableThColumn => ", this._tableThColumn);
        if (this._tableThColumn && this._tableThColumn.tagName === "TH") {
            this._diffX = e.pageX - this._pageX;
 
            this.template.querySelector("table").style.width = (this.template.querySelector("table") - (this._diffX)) + 'px';
 
            this._tableThColumn.style.width = (this._tableThWidth + this._diffX) + 'px';
            this._tableThInnerDiv.style.width = this._tableThColumn.style.width;
 
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            let tableBodyTds = this.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }
 
    handledblclickresizable() {
        let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = this.template.querySelectorAll("table tbody tr");
        tableThs.forEach((th, ind) => {
            th.style.width = this._initWidths[ind];
            th.querySelector(".slds-cell-fixed").style.width = this._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
            let rowTds = row.querySelectorAll(".dv-dynamic-width");
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = this._initWidths[ind];
            });
        });
    }

    paddingDiff(col) {
 
        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }
 
        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padLeft, 10) + parseInt(this._padRight, 10));
 
    }
 
    getStyleVal(elm, css) {
        return (window.getComputedStyle(elm, null).getPropertyValue(css))
    }

}