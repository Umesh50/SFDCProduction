/****************************************************************************************************************
 * Name...................: RSI_ContentDocumentLinkTrigger
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/08/2021
 * Description............: trigger to update application status to signed
 *******************************************************************************************************************/
trigger RSI_ContentDocumentLinkTrigger on ContentDocumentLink(After insert) {
    
    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_ContentDocumentLinkTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(trigger.isAfter && trigger.isInsert) {
            //Class for After Insert
            RSI_ContentDocumentLinkTriggerHandler.onAfterInsert(trigger.new);
            
        }
    }
}