/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-03-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   10-31-2020   Tanmay Jain   Initial Version
**/
public with sharing class RSI_SignatureHelper {
    
   
    @AuraEnabled
    public static void uploadSignaturePage (String recId) {
        List<Id> listContentVersionId = new List<Id>();
        List<ContentDocument> listConDoc = new List<ContentDocument>();
        //Commented by ajay
        /*
        //Fetch the Signature PDF File
        ContentDocumentLink cdlSign = [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =:recId AND ContentDocument.Title LIKE 'Signature%pdf' LIMIT 1];
        System.debug(cdlSign);
        Id cvId = cdlSign.ContentDocument.LatestPublishedVersionId;
        Id cdId = cdlSign.ContentDocumentId;
        String file_Name = cdlSign.ContentDocument.Title;
        //Fetch the File Content
        ContentVersion cvRec = [SELECT VersionData, IsLatest FROM ContentVersion WHERE Id =:cvId LIMIT 1];
        Blob file_Data = cvRec.VersionData;
        */
        //Get the Merchant Application Number
        Opportunity oppty = [SELECT Merchant_Application_No__c FROM Opportunity WHERE Id =: recId LIMIT 1];
        String merchAppNum = String.valueOf(oppty.Merchant_Application_No__c);
        //Setup the Endpoint URL
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        String baseEndpoint = mapOfConnection.get('Connection') + '/' + mapOfConnection.get('APPID') + '/v1/applications/';
        baseEndpoint += merchAppNum + '/documents?appkey=' + mapOfConnection.get('APPKEY');
        system.debug('baseEndpoint---------'+baseEndpoint);
        //Now send the data
        //RSI_UtilityClass.uploadFile(file_Data, file_name, baseEndpoint, cdId);
        
        //-------Ajay multifile uplaod start---------
        for(ContentDocumentLink obj : [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =:recId AND ContentDocument.Description=null]){
            listContentVersionId.add(obj.ContentDocument.LatestPublishedVersionId);
         }
         system.debug('listContentVersionId---------'+listContentVersionId);
         if(!listContentVersionId.isEmpty()){
            Set<String> fuzzyMatches = new Set<String> { '%Signature%', '%legal%'};
            for(ContentVersion obj : [SELECT Id,ContentDocumentId,Title,PathOnClient,VersionData FROM ContentVersion WHERE Id IN : listContentVersionId AND Title LIKE : fuzzyMatches]){
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
            system.debug('listConDoc---------'+listConDoc);
         }
         //----Ajay----multifile upload End--------
    }
}