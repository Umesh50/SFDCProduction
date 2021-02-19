/****************************************************************************************************************
 * Name...................: RSI_OpportunityTrigger
 * Created By.............: Umesh Kumar
 * Created Date...........: 15/10/2020
 * Description............: trigger
 *******************************************************************************************************************/

trigger RSI_OpportunityTrigger on Opportunity (after insert, after update,before update,before insert) {

    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_OpportunityTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        //Call the helper classes for each individual method
        if(trigger.isBefore && trigger.isInsert) {
            //Class for Before Insert
            RSI_OpportunityAfterInsertHandler.OnBeforeInsert(Trigger.new);
        }

        if(trigger.isAfter && trigger.isInsert) {
            //Class for After Insert
            RSI_OpportunityAfterInsertHandler.afterInsertHandler(trigger.New);
            RSI_OppTriggerHandler.createVisa1(trigger.New,trigger.newMap);
        }
        if(trigger.isBefore && trigger.isUpdate) {
            //Class for Before Update
            RSI_OpportunityAfterInsertHandler.onBeforeUpdate(trigger.New, trigger.oldMap);
            RSI_OpportunityAfterInsertHandler.oppStageHandler(trigger.New, trigger.oldMap);
            RSI_OpportunityAfterInsertHandler.createEquipmentRecords(trigger.New, trigger.oldMap);
        }
        if(trigger.isAfter && trigger.isUpdate) {
            //Class for After Update
            RSI_OpportunityAfterInsertHandler.afterUpdateHandler(trigger.New, trigger.oldMap);
             //System.enqueueJob(new RSI_PPointApplicationNotes(trigger.New));
             RSI_OpportunityAfterInsertHandler.updateAccountAddress(trigger.New, trigger.oldMap);
             RSI_OppTriggerHandler.createVisa(trigger.New,trigger.oldMap);
        }
    }
}