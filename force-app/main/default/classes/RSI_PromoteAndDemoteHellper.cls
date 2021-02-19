public without sharing class RSI_PromoteAndDemoteHellper{
    @AuraEnabled
    public static String promoteAndDemote(Id oppId,String keyName){
        String method = 'POST';
        String ContentType = 'application/json';
        
        //Get the Merchant Application Number
        Opportunity oppty = [SELECT Merchant_Application_No__c,isPromote__c FROM Opportunity WHERE Id =: oppId LIMIT 1];
        String merchAppNum = String.valueOf(oppty.Merchant_Application_No__c);
        
        //Setup the Endpoint URL
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        String baseEndpoint = mapOfConnection.get('Connection') + '/' + mapOfConnection.get('APPID') + '/v1/applications/';
        baseEndpoint += merchAppNum + '/'+keyName+'?appkey=' + mapOfConnection.get('APPKEY');
        system.debug('baseEndpoint---------'+baseEndpoint);
        HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',baseEndpoint,method,ContentType);
        system.debug('response---------'+response);
        if(response.getStatusCode() == 200){
            oppty.isPromote__c = (keyName == 'promote')?true:false;
            update oppty;
        }
        return String.valueOf(response.getStatusCode());
    }
    @AuraEnabled
    public static String submitApp(Id oppId){
        List<Integer> listDocList = new List<Integer>();
        List<String> listMpaDoc = new List<String>();
        Set<Id> documentIds = new Set<Id>();
        
        Opportunity oppty = [SELECT Merchant_Application_No__c,isPromote__c,StageName FROM Opportunity WHERE Id =: oppId LIMIT 1];
        String merchAppNum = String.valueOf(oppty.Merchant_Application_No__c);
        
        for(ContentDocumentLink cdLink:[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: oppId]){
            documentIds.add(cdLink.ContentDocumentId);
        }
        for(ContentDocument obj :[SELECT Id, Title, Description, LatestPublishedVersionId FROM ContentDocument WHERE Id IN: documentIds AND Description != null]){
            if(obj.Description != null)
                listDocList.add(Integer.valueOf(obj.Description));
            if((obj.Title).contains('Signature'))
                listMpaDoc.add(obj.Description);
        }
        if(!listMpaDoc.isEmpty()){
            String method = 'POST';
            String ContentType = 'application/json';
            //Setup the Endpoint URL
            Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
            String domain=mapOfConnection.get('Connection');
            String appKey=mapOfConnection.get('APPKEY');
            String requestEndPointUrl=domain;
            requestEndPointUrl+= '/'+mapOfConnection.get('APPID');
            //requestEndPointUrl+='/appkey='+appKey;
            requestEndPointUrl+='/v1/applications/'+merchAppNum+'/submit?appkey='+appKey;
            //requestEndPointUrl+='/v1/applications/submit';
     
            system.debug('requestEndPointUrl------'+requestEndPointUrl);
            String requestJson = '{"override": "false","documentList":"'+JSON.serialize(listDocList)+'","mpaDocumentPage": "2","mpaDocument":'+listMpaDoc[0]+'}';
            requestJson = requestJson.replace('[','{').replace(']','}');
            system.debug('requestJson--------'+requestJson);
            HttpResponse response= RSI_UtilityClass.getMakeHttpRequest(requestJson, requestEndPointUrl, method, ContentType);
            system.debug('------------'+response.getBody());
            ResponseWrapper resp = (ResponseWrapper) System.JSON.deserialize(response.getBody(), ResponseWrapper.class);
            if(resp.SUCCESS)
                return 'Success';
            else{
                oppty.StageName = 'Validation Error';
                update oppty;
                Note note = new Note();
                    note.ParentId = oppty.Id;
                    note.Body = resp.ERROR;
                    note.Title = 'Validation Error';
                Insert note;
                return resp.ERROR;
            }
        }else 
            return 'Signature records not found';
        
    }
    public class ResponseWrapper{
        public boolean SUCCESS;
        public String ERROR;
    }
}