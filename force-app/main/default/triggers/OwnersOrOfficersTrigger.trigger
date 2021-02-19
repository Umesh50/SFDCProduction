/****************************************************************************************************************
 * Name...................: OwnersOrOfficersTrigger
 * Created By.............: Umesh Kumar
 * Created Date...........: 09/10/2020
 * Description............: This trigger use to maintain the primary Owners Or Officers.
 *******************************************************************************************************************/
trigger OwnersOrOfficersTrigger on Owners_Or_Officers__c (before insert,before update,after insert,after update, after delete) {

     Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'OwnersOrOfficersTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        //Call the helper classes for each individual method
        if(Trigger.isBefore && Trigger.isInsert) {
            //Class for Before Insert
        }
        if(Trigger.isAfter && Trigger.isInsert) {
            //Class for After Insert
            RSI_OwnersOrOfficersTriggerHelper.handlePrimaryOwner(Trigger.New);
            RSI_OwnersOrOfficersTriggerHelper.afterHandler(Trigger.new, null);
            RSI_OwnersOrOfficersTriggerHelper.updateAccSSN(Trigger.New,null);
        }
        if(Trigger.isBefore && Trigger.isUpdate) {
            //Class for Before Update
        }
        if(Trigger.isAfter && Trigger.isUpdate) {
            //Class for After Update
            RSI_OwnersOrOfficersTriggerHelper.handlePrimaryOwner(Trigger.New);
            RSI_OwnersOrOfficersTriggerHelper.afterHandler(Trigger.new, Trigger.oldMap);
            RSI_OwnersOrOfficersTriggerHelper.updateAccSSN(Trigger.New,Trigger.oldMap);
        }
        if (Trigger.isAfter && Trigger.isDelete) {
            RSI_OwnersOrOfficersTriggerHelper.afterHandler(Trigger.old, null);
        }
    }
}