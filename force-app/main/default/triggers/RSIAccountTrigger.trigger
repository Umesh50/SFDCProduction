/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 12-11-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   12-11-2020   Tanmay Jain   Initial Version
**/
trigger RSIAccountTrigger on Account (after update) {
    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_AccountTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(Trigger.isAfter && Trigger.isUpdate) {
            RSI_AccountTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}