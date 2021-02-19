/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 01-04-2021
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-01-2021   Tanmay Jain   Initial Version
**/
trigger RSI_AssetTrigger on Asset (after insert, after update,before update,before insert) {

    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_AssetTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(Trigger.isAfter && Trigger.isInsert) {
            //Class for After Insert
            RSI_AssetTriggerHandler.onAfterInsert(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isUpdate) {
            //Class for After Insert
            RSI_AssetTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}