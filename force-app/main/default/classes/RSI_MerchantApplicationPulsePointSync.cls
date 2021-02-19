/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-03-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-02-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_MerchantApplicationPulsePointSync {

    public static Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams = new Map <String, List <RSI_PulsePointParam__mdt>>();

    @AuraEnabled
    public static Opportunity initComponent(Id opptyId){
        return [SELECT Id, Merchant_Application_No__c, Merchant_Application_Document_No__c FROM Opportunity WHERE Id = :opptyId];
    }

    @AuraEnabled
    public static Opportunity createApplication (Id opptyId) {
        //get application Params from RSI_IntegrationUtils class.......
        mapObjNameToParams = RSI_UtilityClass.getApplicationParams();
        // get dynamic query.......
        String query = getDynamicQuery(mapObjNameToParams,opptyId);
        //The below will always be a single record
        List <Opportunity> opptyRecs = Database.query(query);
        //Now we perform the HTTP Request
        Opportunity opptyToUpd = createAppInPPoint(opptyRecs[0]);
        update opptyToUpd;
        return opptyToUpd;
    }

    private static String getDynamicQuery(Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams, Id opptyId) {
        // set of opportunity fields
        Set <String> setFields = new Set <String> ();
        for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get('Opportunity')) {
            if(objParam.SF_Data_Type__c == 'CreateApp'){
                setFields.add(objParam.SalesForce_Field_API_Name__c);
            }
        }
        // comma seperated fields.........
        String commaSepratedFields = String.join(new List <String> (setFields), ',');
        // dynamic query....
        String query = 'SELECT Merchant_Application_No__c,' + commaSepratedFields + ' FROM Opportunity WHERE Id =: opptyId ';
        return query;
    }

    private static Opportunity createAppInPPoint (Opportunity opptyObj) {
        Opportunity opptyToUpd = new Opportunity(Id = opptyObj.Id);
        /**
         * This part is to create the Application in Pulse Point. We get a Merchant Application # as a return parameter for which we do another call to get the Application Form #
         */
        //Get the request JSON
        String requestJson = getRequestJson(opptyObj);
        //system.debug('request json--'+requestJson);
        //get end point url of pulse point... for the request........
        String appCreationUrl =  RSI_UtilityClass.getApplicationEndPointURL();
        // method type...
        String method = 'POST';
        // content type......
        String ContentType = 'application/json';
        //send the request and get response..........
        HttpResponse response= RSI_UtilityClass.getMakeHttpRequest(requestJson, appCreationUrl, method, ContentType);
        if (response.getStatusCode()==200) {
            System.debug('Passed # 1');
            /**
             * This Part is to fetch the Application Form Number from Pulse Point
             */
            //again request to get application document number..
            Map<String,Object> result=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            //system.debug('app Result--'+result);
            //get application number....
            Integer merchantAppNo = (Integer.valueOf(result.get('MERCHANTAPPLICATIONNO')));
            //assign application number to the opportunity...
            opptyToUpd.Merchant_Application_No__c = merchantAppNo;
            if(merchantAppNo!= null){
                //get appkey from custom meta data using RSI_UtilityClass class
                Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
                // get app key to make a url...
                String appKey=mapOfConnection.get('APPKEY');
                // get end point url to get document number.....
                String getDocumentNoUrl =  RSI_UtilityClass.getApplicationEndPointURL();
                getDocumentNoUrl = getDocumentNoUrl + merchantAppNo + '/forms?';
                getDocumentNoUrl = getDocumentNoUrl + 'appkey=' + appKey;
                //Now do a GET Request
                HttpResponse docNoResponse = RSI_UtilityClass.getMakeHttpRequest('', getDocumentNoUrl, 'GET', 'application/json');
                if (docNoResponse.getStatusCode()==200) {
                    System.debug('Passed # 2');
                    // get respone to get document number....
                    Map<String,Object> docResult=(Map<String,Object>)JSON.deserializeUntyped(docNoResponse.getBody());
                    system.debug('document result :'+docResult);
                    Map<String, Object> mapOfData = (Map<String,Object>)docResult.get('DATA');
                    List<Object> mapOfDataOfData = (List<Object>)mapOfData.get('DATA');
                    String arrayofdata=mapOfDataOfData[0].toString();
                    List<String> docno=arrayofdata.split(',');
                    system.debug('document no:'+docno[1]);
                    opptyToUpd.Merchant_Application_Document_No__c = Integer.valueOf(docno[1].trim());
                }else {return null;}
            }
        } else {return null;}
        return opptyToUpd;
    }


    // call for dynamic json.......
    private static String getRequestJson(Opportunity opptyObj) {
        // map to store pulsepoint fields and value............
        Map <String, String> mapPPFieldNametoValue = new Map <String, String> ();
        //Get the list of fields for the Opportunity Object and assign sf value to pulse point fieldss
        for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get('Opportunity')) {
            String sfValue;
            // fields type...
            String sfDataType = objParam.SF_Data_Type__c;
            // pulse point fields.....
            String ppFieldName = objParam.Pulse_Point_Field_Name__c;
            // salesforce fields.....
            String sfFieldName = objParam.SalesForce_Field_API_Name__c;
            //it is use to get the value from opportunity object.......
            if(sfDataType == 'CreateApp'){
                sfValue = getConvertNullToZero(RSI_UtilityClass.getFieldValue(opptyObj, sfFieldName));
                //assign the salesforce fields value to the pulse point fields.........
                mapPPFieldNametoValue.put(ppFieldName , sfValue );
            }
        }
        //get appkey from custom meta data using RSI_UtilityClass class
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        String appKey=mapOfConnection.get('APPKEY');
        //start json-->preparing dynamic json....
        String commaSepJSON;
        for(String fieldName : mapPPFieldNametoValue.keySet()){
            if(commaSepJSON == null){
                commaSepJSON ='"'+fieldName+'":"'+mapPPFieldNametoValue.get(fieldName)+'"'; }
            else{ commaSepJSON =commaSepJSON+',"'+fieldName+'":"'+mapPPFieldNametoValue.get(fieldName)+'"'; }
        }
        // final json....
        String requestJson ='{"appkey":"'+ appKey+'",'+commaSepJSON+'}';
        return requestJson;
    }
    
    //it is use to convert null value with 0 formate and it help to create the application in pulse point.....
    private static String getConvertNullToZero (String valueToConvert) {
        String valueToReturn;
        //convert null to 0
        if(valueToConvert ==''){
            valueToReturn = String.valueOf(0);
        }else{
            valueToReturn = valueToConvert;
        }
        return valueToReturn;
    } 
}