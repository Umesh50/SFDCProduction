/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-21-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-21-2021   Umesh Kumar   Initial Version
**/


trigger RSI_ShipmentTrigger on zkmulti__MCShipment__c (after insert) {
    
    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_ShipmentTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(Trigger.isAfter && Trigger.isInsert) {
            //Class for After Insert
            RSI_ShipmentTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}