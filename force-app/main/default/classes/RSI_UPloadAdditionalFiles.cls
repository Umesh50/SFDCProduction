public without sharing class RSI_UPloadAdditionalFiles {
    
  @AuraEnabled
  public static List<ContentDocument> getFiles(String recordId){
    List<ContentDocument> documentList = new List<ContentDocument>();
    Set<Id> documentIds = new Set<Id>();
    List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId AND ContentDocument.Description=null];
    for(ContentDocumentLink cdLink:cdl){
      documentIds.add(cdLink.ContentDocumentId);
    }
    documentList = [SELECT Id, Title, FileType, ContentSize, Description, LatestPublishedVersionId, LatestPublishedVersion.Document_Type__c FROM ContentDocument WHERE Id IN: documentIds];
    return documentList;  // Return list of files on parent record
  }
    
   @AuraEnabled 
    public static List<ContentDocument>  uploadSelectedFile(String recId,List<String> cdId){
        List<ContentDocument> listConDoc = new List<ContentDocument>();
        //Get the Merchant Application Number
        Opportunity oppty = [SELECT Merchant_Application_No__c FROM Opportunity WHERE Id =: recId LIMIT 1];
        String merchAppNum = String.valueOf(oppty.Merchant_Application_No__c);
        //Setup the Endpoint URL
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        String baseEndpoint = mapOfConnection.get('Connection') + '/' + mapOfConnection.get('APPID') + '/v1/applications/';
        baseEndpoint += merchAppNum + '/documents?appkey=' + mapOfConnection.get('APPKEY');
        system.debug('baseEndpoint---------'+baseEndpoint);
        if(!cdId.isEmpty()){
            for(ContentVersion obj : [SELECT Id,ContentDocumentId,Title,PathOnClient,VersionData FROM ContentVersion WHERE ContentDocumentId IN : cdId]){
                system.debug('obj------'+obj);
                String docId = RSI_UtilityClass.uploadFile(obj.VersionData, obj.PathOnClient, baseEndpoint, obj.ContentDocumentId);
                if(docId != null){
                    system.debug('----Inside docId----');
                    ContentDocument doc = new ContentDocument();
                    doc.Id = obj.ContentDocumentId;
                    doc.Description = docId;
                    listConDoc.add(doc);
                }
            }
            if(!listConDoc.isEmpty())
                update listConDoc;
            system.debug('listConDoc----uploaded-----'+listConDoc);
        } 
        return listConDoc;
    }
}