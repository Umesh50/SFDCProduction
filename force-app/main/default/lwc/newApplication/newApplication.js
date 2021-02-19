import { LightningElement,track,api } from 'lwc';
import LOGO_IMG from '@salesforce/resourceUrl/PaytreeHeaderLogo';
export default class NewApplication extends LightningElement {

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
    @track steps = [];
           currStep = 1;
           maxSteps = 8;
           logoImage = LOGO_IMG;

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
        this.showStepOne=true;
        this.showStepTwo=true;
       this.advanceStep(2);
    }

    goToStepThree() {
        console.log('i am in step 3');
        this.showStepTwo = false;
        this.showStepThree =true;
        this.advanceStep(3); 
    }

    goBackToStepOne() {
        this.showStepOne= false;
        this.showStepTwo= false;
        this.advanceStep(1);   
    }

    goToStepFour(){
        this.showStepThree =false;
        this.showStepFour = true;
        this.advanceStep(4);  
    }
   
    goBackToStepTwo(){
        this.showStepThree =false;
        this.showStepTwo = true;
        this.advanceStep(2); 
    }

    goToStepFive(){
        this.showStepFour = false;
        this.showStepFive = true;
        this.advanceStep(5); 
    }
   
    goBackToStepThree(){
        this.showStepFour = false;
        this.showStepThree =true;
        this.advanceStep(3); 
    }

    goToStepSix(){
        this.showStepFive = false; 
        this.showStepSix = true;
        this.advanceStep(6);  
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
    }


    handleApplicationId(event){
        this.recordId = event.detail.recordId;
        this.selectedAccountId = event.detail.selectedAccountId;
    }

    
    connectedCallback () {
        this.setupSteps ();
    }
    setupSteps () {
        var locsteps = []
        for (let index = 1; index < this.maxSteps; index++) {
            var currVal = index == this.currStep ? true : false;
            var icon = index < this.currStep ? 'utility:success' : 'utility:routing_offline';
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
            var icon = index < this.currStep ? 'utility:success' : 'utility:routing_offline';
            this.steps [index - 1].status = currVal;
            this.steps [index - 1].showTree = currVal;
            this.steps [index - 1].icon = icon;
        }
        this.template.querySelector("c-rsi-custom-path").refreshUI();
    }

}