/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-17-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-13-2020   Tanmay Jain   Initial Version
**/
import { LightningElement, track, api } from 'lwc';

//Import the logo to move around the screen
import LOGO_IMG from '@salesforce/resourceUrl/StepLogo';

export default class RsiCustomPath extends LightningElement {
    currentStepNum = 0;
    totalStepNums = 5;
    logoImage = LOGO_IMG;

    @api stepsArray = [];
    @track currentPercent = 0;

    connectedCallback () {
        this.refreshUI ();
    }

    @api refreshUI () {
        for (var step of this.stepsArray) {
            if (step.showTree) {
                this.currentStepNum = step.key;
            }
        }
        this.totalStepNums = this.stepsArray.length;
        if (this.currentStepNum == 0) {
            this.currentStepNum = 1;
        }
        this.currentPercent = ((this.currentStepNum - 1) * 100) / (this.totalStepNums - 1);
    }
    changeStep(event){
        const keyValue = event.target.value;
        console.log('keyValue--------hi--------'+keyValue);
        const custEvent = new CustomEvent('callstep'+keyValue);
            this.dispatchEvent(custEvent); 
        /*
        let stepNumber;
        if(keyValue == 1){
            const custEvent = new CustomEvent('callstep1');
            this.dispatchEvent(custEvent); 
        }
        if(keyValue == 2){
            const custEvent = new CustomEvent('callstep2');
            this.dispatchEvent(custEvent);
        }
        if(keyValue == 3){
            const custEvent = new CustomEvent('callstep3');
            this.dispatchEvent(custEvent); 
        }
        if(keyValue == 4){
            const custEvent = new CustomEvent('callstep4');
            this.dispatchEvent(custEvent); 
        }
        if(keyValue == 5){
            const custEvent = new CustomEvent('callstep5');
            this.dispatchEvent(custEvent); 
        }
        if(keyValue == 6){
            const custEvent = new CustomEvent('callstep6');
            this.dispatchEvent(custEvent); 
        }  
        if(keyValue == 7){
            const custEvent = new CustomEvent('oncallstep7');
            this.dispatchEvent(custEvent);
            
        }
        */
        
    }
}