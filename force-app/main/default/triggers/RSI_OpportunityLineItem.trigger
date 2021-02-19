/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 01-22-2021
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-02-2021   Tanmay Jain   Initial Version
**/
trigger RSI_OpportunityLineItem  on OpportunityLineItem (before update, after insert,after update,after delete) {

    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_OpportunityLineItem' LIMIT 1].Active__c;
    if (triggerActive) {
        //Call the helper classes for each individual method
        if(Trigger.isBefore && Trigger.isInsert) {
            //Class for Before Insert
        }
        if(Trigger.isAfter && Trigger.isInsert) {
            //Class for After Insert
            RSI_OpportunityLineTriggerHandler.afterInsertHandler(Trigger.new);
            RSI_OpplineItemTriggerHandler.afterInsert(trigger.new);
        }
        if(Trigger.isBefore && Trigger.isUpdate) {
            //Class for Before Update
            RSI_OpportunityLineTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isAfter && Trigger.isUpdate) {
            //Class for After Update
            RSI_OpportunityLineTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
            RSI_OpplineItemTriggerHandler.afterUpdate(trigger.new,trigger.oldMap);
        }
        if(trigger.isAfter && trigger.isDelete){
            RSI_OpplineItemTriggerHandler.afterDelete(trigger.old);
        }
    }
}