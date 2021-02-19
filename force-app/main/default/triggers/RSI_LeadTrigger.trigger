/****************************************************************************************************************
 * Name...................: RSI_LeadTrigger
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This trigger use to update partner name whenever we insert or update the partner code
 *******************************************************************************************************************/

trigger RSI_LeadTrigger on Lead (before insert,before update) {
    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_LeadTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(Trigger.isInsert && Trigger.isBefore){
            // call insert helper method
            RSI_LeadTriggerHandler.onBeforeInsert(trigger.new);
        } 
        // call when update perform ,trigger.Old
        if(Trigger.isUpdate && Trigger.isBefore){
            RSI_LeadTriggerHandler.onBeforeUpdate(trigger.new,trigger.OldMap);
        }
    }
}