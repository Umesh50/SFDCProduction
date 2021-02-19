/****************************************************************************************************************
 * Name...................: RSI_UpdateMerchantAppInformation
 * Created By.............: Umesh Kumar
 * Created Date...........: 17/09/2020
 * Description............: This class use to update the merchant application information under the msppulsepoint.
 *******************************************************************************************************************/

public without sharing class RSI_UpdateMerchantAppInformation {
      
    
   @AuraEnabled
    public static String executeIntegration(Id oppId){
        String responseToReturn;
        //get application Params from RSI_IntegrationUtils class
        Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams = RSI_UtilityClass.getApplicationParams();
        
        //it is use to get dynamic query from RSI_IntegrationUtils class
        String query = RSI_IntegrationUtils.getDynamicQuery( mapObjNameToParams, oppId);
        
        //Code to execute query
        Opportunity oppRecord = Database.query(query);
        //system.debug('oppRecord'+oppRecord);
        
        
        //Below map will store the values to be sent to Pulse Point application
        Map <String, String> mapPPFieldNametoValue = new Map <String, String> ();
        
        //Get the list of fields for the Opportunity Object and assign sf value to pulse point fieldss
        for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get('Opportunity')) {
            String sfValue;
            String sfDataType = objParam.SF_Data_Type__c;
            String ppFieldName = objParam.Pulse_Point_Field_Name__c;
            String sfFieldName = objParam.SalesForce_Field_API_Name__c;
            //it is use to get the value from opportunity object
            if(sfDataType!= 'CreateApp'){
            sfValue = RSI_IntegrationUtils.getCheckValueType(oppRecord ,sfFieldName ,sfDataType);
            //assign the salesforce fields value to the pulse point fields
            mapPPFieldNametoValue.put(ppFieldName , sfValue );
            }
        } 
        
        //get all the value of child object of opportunity and assign to pulse point fields
        Map <String, String> mapOfAllChildValue = RSI_IntegrationUtils.getAllChildRecords(mapObjNameToParams, oppRecord );
        //add childs object value map in opportunity map(mapPPFieldNametoValue)
        mapPPFieldNametoValue.putAll(mapOfAllChildValue);
        
        //it is use to get final json string
        String requestJson = RSI_IntegrationUtils.getJsonString(mapPPFieldNametoValue);
       system.debug('jsonString '+requestJson);
        
        //check merchant application no and document number not null
        if(oppRecord.Merchant_Application_No__c!=null && oppRecord.Merchant_Application_Document_No__c!=null){
            //final request end point url
            String requestEndPointUrl =  RSI_UtilityClass.getApplicationEndPointURL();
            requestEndPointUrl =requestEndPointUrl+oppRecord.Merchant_Application_No__c+'/forms/'+oppRecord.Merchant_Application_Document_No__c;
            String method = 'POST';
            String ContentType = 'application/json';
            //send the request and get response
            HttpResponse response= RSI_UtilityClass.getMakeHttpRequest(requestJson, requestEndPointUrl, method, ContentType);
            if (response.getStatusCode()==200) {
                Map<String,Object> result=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                Map<String,Object> submissionNo=(Map<String,Object>)result.get('DATA');
                system.debug('Application Updated->>>>>>>>>>'+submissionNo.get('SUBMISSIONNO'));
                if(result.get('SUCCESS')==true){
                    responseToReturn ='SUCCESS'; 
                }else{ responseToReturn = String.valueOf(result.get('ERROR')); }
             }else {
                responseToReturn =response.getStatus();
                System.debug('Application not Updated'); 
            }    
        } 
        return  responseToReturn;
    }  
}