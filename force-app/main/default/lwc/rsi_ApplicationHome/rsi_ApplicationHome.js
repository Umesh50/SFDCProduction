import { LightningElement , track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LOGO_IMG from '@salesforce/resourceUrl/PaytreeHeaderLogo';
import Pdf from '@salesforce/apex/RSI_PDFGenerater.savePdf';
import PdfRental from '@salesforce/apex/RSI_PDFRental.savePdfRental';
//import getNavigateUrl from '@salesforce/apex/RSI_DOCUSIGNGEN.getNavigateUrl';


export default class Rsi_ApplicationHome extends NavigationMixin(LightningElement) {

    @api recordId;
    @api objectApiName ="Opportunity";
    @track showStepOne = false;
    @track showStepTwo = false;
    @track showStepThree = false;
    @track showStepFour = false;
    @track showStepFive = false;
    @track showStepSix = false;
    @track showStepSeven =false;
    @track isModalOpen = false;
    @api selectedAccountId;    
    @api readStatusOnly;
    @track isStepOneFieldSave=false;
    @track isStepTwoFieldSave=false;
    @track isStepThreeFieldSave=false;
    @track isStepFourFieldSave=false;
    @track isStepFiveFieldSave=false;
    @track isStepSixFieldSave=false;
    @track isStepSevenFieldSave=false;
    @track nxtShow =false;
    @track steps = [];
    baseUrl;
           currStep = 1;
           maxSteps = 8;
           logoImage = LOGO_IMG;

           renderedCallback() {
            this.baseUrl = window.location.origin;
        }

           @api moveToStepOne(){
            console.log('Inside step 1');
            this.showStepOne= false;
            this.showStepTwo= false;
            this.showStepThree= false;
            this.showStepFour= false;
            this.showStepFive= false;
            this.showStepSix= false;
            this.showStepSeven= false;
            this.advanceStep(1); 
        }
        
        @api moveToStepTwo(){
            console.log('Inside step 2');
            this.showStepOne= true;
            this.showStepTwo= true;
            this.showStepThree= false;
            this.showStepFour= false;
            this.showStepFive= false;
            this.showStepSix= false;
            this.showStepSeven= false;
            this.advanceStep(2);  
        }
        @api moveToStepThree(){
            console.log('Inside step 3');
            this.showStepOne= true;
            this.showStepTwo= false;
            this.showStepThree= true;
            this.showStepFour= false;
            this.showStepFive= false;
            this.showStepSix= false;
            this.showStepSeven= false;
            this.advanceStep(3);  
        }
        @api moveToStepFour(){
            this.showStepOne= true;
            this.showStepTwo= false;
            this.showStepThree= false;
            this.showStepFour= true;
            this.showStepFive= false;
            this.showStepSix= false;
            this.showStepSeven= false;
            this.advanceStep(4);  
        }
        @api moveToStepFive(){
            this.showStepOne= true;
            this.showStepTwo= false;
            this.showStepThree= false;
            this.showStepFour= false;
            this.showStepFive= true;
            this.showStepSix= false;
            this.showStepSeven= false;
            this.advanceStep(5);  
        }
        @api moveToStepSix(){
            this.showStepOne= true;
            this.showStepTwo= false;
            this.showStepThree= false;
            this.showStepFour= false;
            this.showStepFive= false;
            this.showStepSix= true;
            this.showStepSeven= false;
            this.advanceStep(6);  
        }
        @api moveToStepSeven(){
            this.showStepOne= true;
            this.showStepTwo= false;
            this.showStepThree= false;
            this.showStepFour= false;
            this.showStepFive= false;
            this.showStepSix= false;
            this.showStepSeven= true;
            this.advanceStep(7);  
        }

        goToStepTwo() { 
            if(this.isStepOneFieldSave){
            this.nextConfirm();
            if(this.nxtShow){
            this.showStepOne=true;
            this.showStepTwo=true;
            this.advanceStep(2);
            }
            }else{  
            this.showStepOne=true;
            this.showStepTwo=true;
            this.advanceStep(2);

            }
        }
        

    goToStepThree() {

        if(this.isStepTwoFieldSave){
            this.nextConfirm();
            if(this.nxtShow){
        this.showStepTwo = false;
        this.showStepThree =true;
        this.advanceStep(3);
     }
     }else{  
        this.showStepTwo = false;
        this.showStepThree =true;
        this.advanceStep(3);
          }
    }

    goBackToStepOne() {
        this.showStepOne= false;
        this.showStepTwo= false;
        this.advanceStep(1);   
    }

    goToStepFour(){
        if(this.isStepThreeFieldSave){
            this.nextConfirm();
            if(this.nxtShow){
            this.showStepThree =false;
            this.showStepFour = true;
            this.advanceStep(4); 
            }
        }else{
        this.showStepThree =false;
        this.showStepFour = true;
        this.advanceStep(4); 
        } 
    }
   
    goBackToStepTwo(){
        this.showStepThree =false;
        this.showStepTwo = true;
        this.advanceStep(2); 
    }

    goToStepFive(){
        if(this.isStepFourFieldSave){
            this.nextConfirm();
            if(this.nxtShow){
        this.showStepFour = false;
        this.showStepFive = true;
        this.advanceStep(5);
            }
        }else{
        this.showStepFour = false;
        this.showStepFive = true;
        this.advanceStep(5);

        }    
    }
   
    goBackToStepThree(){
        this.showStepFour = false;
        this.showStepThree =true;
        this.advanceStep(3); 
    }

    goToStepSix(){
        if(this.isStepFiveFieldSave){
            this.nextConfirm();
            if(this.nxtShow){
        this.showStepFive = false; 
        this.showStepSix = true;
        this.advanceStep(6);
            }
    } else{
        this.showStepFive = false; 
        this.showStepSix = true;
        this.advanceStep(6);

    }
    }

    goBackToStepFive(){
        this.showStepSix = false;
        this.showStepFive = true;
        this.advanceStep(5); 
    }

    goToStepSeven(){
        this.showStepSix = false;
        this.showStepSeven=true;
        this.advanceStep(7);   
    }
     
    goBackToStepSix(){
        this.showStepSix =true;
        this.showStepSeven=false;
        this.advanceStep(6);   
    }

    goBackToStepFour(){
        this.showStepFive = false;
        this.showStepFour = true;
        this.advanceStep(4);  
    }

    goToSubmit(){
        alert('your form has been submited');
        this.submitDetails();
        this.navigateToViewOpportunityPage();
        this.savePdf();
        this.savePdfRental();
     //this.navigateToDocPage();
    }

     closeModal() {
         this.isModalOpen = true;
         //this.navigateToOpportunityListView();
         window.location.href = this.baseUrl+'/lightning/o/Opportunity/list?filterName=AllOpportunities';
     }


     submitDetails() {
         this.isModalOpen = true;
     }

    // Navigate to View Opportunity Page
    navigateToViewOpportunityPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            },
        });
    }
    /*navigateToDocPage() 
    {  
    let appId = this.recordId;   
     const urlWithParameters = '/apex/dfsle__onlineeditordocumentgenerator?appId='+appId+'templateId = '+a163K000000MThgQAG;
    console.log('urlWithParameters...'+urlWithParameters);
    this[NavigationMixin.Navigate]
    ({type: 'standard__webPage',
    attributes: {url: urlWithParameters}},
    false);    
     }
    navigateToDocPage() {
        getNavigateUrl({oppId :this.recordId}).then(result =>{
            const urlWithParameters = result;
            console.log('urlWithParameters...'+urlWithParameters);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: urlWithParameters
                }
            }, false); 
        });
    }*/
     // Navigation to Opportunity List view(AllOpportunities)
     navigateToOpportunityListView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'list'
            },
            state: {
                filterName: 'AllOpportunities'
            },
        });
    }
    handleApplicationId(event){
        this.recordId = event.detail.recordId;
        this.selectedAccountId = event.detail.selectedAccountId;
        this.isStepOneFieldSave=event.detail.isStepOneFieldSave;

    }

    handleSecondScreenSave(event){
        this.isStepTwoFieldSave = event.detail.isStepTwoFieldSave;
    }
   
    handleThirdScreenSave(event){
        this.isStepThreeFieldSave = event.detail.isStepThreeFieldSave;
    }
    handleFourScreenSave(event){
        this.isStepFourFieldSave = event.detail.isStepFourFieldSave;
    }
    handleFiveScreenSave(event){
        this.isStepFiveFieldSave = event.detail.isStepFiveFieldSave;
    }

    connectedCallback () {
         this.setupSteps ();  
    }
    setupSteps () {
        var locsteps = []
        for (let index = 1; index < this.maxSteps; index++) {
            var currVal = index == this.currStep ? true : false; 
            var icon = index < this.currStep ?  'utility:success' : 'utility:routing_offline';  
            var step = {key: index, status : currVal, icon : icon, showTree : currVal};
            locsteps.push (step);
        }
        this.steps = locsteps;
        console.log (this.steps);
    }

    advanceStep (currentStepParam) {
        if (this.currStep < this.maxSteps) {
            this.currStep =parseInt(currentStepParam);
        } else {
            this.currStep = 1;
        }
        for (let index = 1; index < this.maxSteps; index++) {
            var currVal = index == this.currStep ? true : false;
            var icon = index < this.currStep ? 'utility:success': 'utility:routing_offline';   
            this.steps [index - 1].status = currVal;
            this.steps [index - 1].showTree = currVal;
            this.steps [index - 1].icon = icon;
        }
        this.template.querySelector("c-rsi-custom-path").refreshUI();
    }  

    nextConfirm(){
      // alert('Do you save detail before proceed');  
      if (confirm("Do you want to proceed without saving?") == true) {
          this.nxtShow =true;
          this.isStepTwoFieldSave =false;
          this.isStepOneFieldSave=false;
          this.isStepThreeFieldSave =false;
          this.isStepFourFieldSave=false;
          this.isStepFiveFieldSave =false;
        }else{
            this.nxtShow=false;
        }
    }
	
	savePdf(){
        //alert('Do you save detail before proceed');

        //this.oppId = Event.detail.recordId;
        Pdf ({oppId: this.recordId}) .then (result => {
            if(result == 'Success')
            this.oppId = Event.detail.recordId
            //this.showToastMessage ('success', 'Record Submitted successfully');
            else
            console.log('result---------'+result);
            
       }).catch (error => {
        console.log('result---------'+error);
    });
   }
   savePdfRental(){
    //alert('Do you save detail before proceed');

    //this.oppId = Event.detail.recordId;
    PdfRental ({oppId: this.recordId}) .then (result => {
        if(result == 'Success')
        this.oppId = Event.detail.recordId
        //this.showToastMessage ('success', 'Record Submitted successfully');
        else
        console.log('result---------'+result);
        
   }).catch (error => {
    console.log('result---------'+error);
});
}
   
}