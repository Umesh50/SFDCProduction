import { LightningElement , track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LOGO_IMG from '@salesforce/resourceUrl/PaytreeHeaderLogo';
export default class RsiApplicationHome extends NavigationMixin(LightningElement) {

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
    @track isStepOneFieldNull=false;
    @track isStepTwoFieldNull=false;
    @track isStepThreeFieldNull=false;
    @track isStepFourFieldNull=false;
    @track isStepFiveFieldNull=false;
    @track isStepSixFieldNull=false;
    @track isStepSevenFieldNull=false;
   // @track isNullField=false;
    @track steps = [];
           currStep = 1;
           maxSteps = 8;
           logoImage = LOGO_IMG;

    @api goToStepTwo() {
        this.showStepOne=true;
        this.showStepTwo=true;
        //this.isNullField=this.isStepOneFieldNull;
       this.advanceStep(2,this.isStepOneFieldNull);
    }

    @api goToStepThree() {
        this.showStepTwo = false;
        this.showStepThree =true;
        this.advanceStep(3,this.isStepTwoFieldNull); 
    }

    goBackToStepOne() {
        this.showStepOne= false;
        this.showStepTwo= false;
        this.advanceStep(1,this.isStepOneFieldNull);   
    }

    goToStepFour(){
        this.showStepThree =false;
        this.showStepFour = true;
        this.advanceStep(4,this.isStepFourFieldNull);  
    }
   
    goBackToStepTwo(){
        this.showStepThree =false;
        this.showStepTwo = true;
        this.advanceStep(2,this.isStepTwoFieldNull); 
    }

    goToStepFive(){
        this.showStepFour = false;
        this.showStepFive = true;
        this.advanceStep(5,this.isStepFiveFieldNull); 
    }
   
    goBackToStepThree(){
        this.showStepFour = false;
        this.showStepThree =true;
        this.advanceStep(3,this.isStepThreeFieldNull); 
    }

    goToStepSix(){
        this.showStepFive = false; 
        this.showStepSix = true;
        this.advanceStep(6,this.isStepSixFieldNull);  
    }

    goBackToStepFive(){
        this.showStepSix = false;
        this.showStepFive = true;
        this.advanceStep(5,this.isStepFiveFieldNull); 
    }

    goToStepSeven(){
        this.showStepSix = false;
        this.showStepSeven=true;
        this.advanceStep(7,this.isStepSevenFieldNull);  
    }
     
    goBackToStepSix(){
        this.showStepSix =true;
        this.showStepSeven=false;
        this.advanceStep(6,this.isStepSixFieldNull);   
    }

    goBackToStepFour(){
        this.showStepFive = false;
        this.showStepFour = true;
        this.advanceStep(4,this.isStepFourFieldNull);  
    }

    goToSubmit(){
        alert('your form has been submited');
        this.submitDetails();
        this.navigateToViewOpportunityPage();
    }

     closeModal() {
         this.isModalOpen = true;
         this.navigateToOpportunityListView();
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
        this.isStepOneFieldNull=event.detail.isStepOneFieldNull;

    }

    connectedCallback () {
        if( this.isStepOneFieldNull == true ){
        this.setupSteps (this.isStepOneFieldNull);
        }
        if( this.isStepTwoFieldNull == true ){
         this.setupSteps (this.isStepTwoFieldNull);
         }
        if( this.isStepThreeFieldNull == true ){
         this.setupSteps (this.isStepThreeFieldNull);
         }
         if( this.isStepFourFieldNull == true ){
        this.setupSteps (this.isStepFourFieldNull);
        }
         if( this.isStepFiveFieldNull == true ){
        this.setupSteps (this.isStepFiveFieldNull == true);
         }
        if( this.isStepSixFieldNull == true ){
         this.setupSteps (this.isStepSixFieldNull);
         }
        if( this.isStepSevenFieldNull == true ){
        this.setupSteps (this.isStepSevenFieldNull );
        }else{
         this.setupSteps (false);  
        } 
    }
    setupSteps (isNullField) {
        var locsteps = []
        for (let index = 1; index < this.maxSteps; index++) {
            var currVal = index == this.currStep ? true : false;
           // var isNullField=true;
           /* var icon;
            if( this.isStepOneFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
                isNullField=true;
               }
               if( this.isStepTwoFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
              
               }
               if( this.isStepThreeFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepFourFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepFiveFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepSixFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepSevenFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }else{} */
              var icon = index < this.currStep ? (isNullField ==true ? 'utility:warning' :'utility:success'): 'utility:routing_offline';
               
           // var icon = index < this.currStep ?  'utility:success' : 'utility:routing_offline';  
            var step = {key: index, status : currVal, icon : icon, showTree : currVal};
            locsteps.push (step);
        }
        this.steps = locsteps;
        console.log (this.steps);
    }

    advanceStep (currentStepParam,isNullField) {
        if (this.currStep < this.maxSteps) {
            this.currStep =parseInt(currentStepParam);
        } else {
            this.currStep = 1;
        }
        for (let index = 1; index < this.maxSteps; index++) {
            var currVal = index == this.currStep ? true : false;
           // var isNullField=true;
           /* var icon;
            var nty;
            if( this.isStepOneFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
                isNullField=true;
               }
               if( this.isStepTwoFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               
               }
               if( this.isStepThreeFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepFourFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepFiveFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepSixFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }
               if( this.isStepSevenFieldNull == true ){
                icon = index < this.currStep ?  'utility:error' : 'utility:routing_offline';
               }else{}*/
              var icon = index < this.currStep ? (isNullField ==true ? 'utility:warning' :'utility:success'): 'utility:routing_offline';
               
            this.steps [index - 1].status = currVal;
            this.steps [index - 1].showTree = currVal;
            this.steps [index - 1].icon = icon;
        }
        this.template.querySelector("c-rsi-custom-path").refreshUI();
    }  

}