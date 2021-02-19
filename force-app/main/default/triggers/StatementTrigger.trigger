trigger StatementTrigger on Statement__c (After Insert) {
    RSI_StatementFileUpload uploadFile = new RSI_StatementFileUpload (trigger.new);
    ID jobID = System.enqueueJob(uploadFile);
}