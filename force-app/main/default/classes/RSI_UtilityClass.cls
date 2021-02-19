/****************************************************************************************************************
* Name...................: RSI_UtilityClass
* Created By.............: Umesh Kumar
* Created Date...........: 15/10/2020
* Description............: helper class of RSI_UpdateMerchantAppInformation
*******************************************************************************************************************/

public class RSI_UtilityClass {
    //Add all utility and common methods here

    //get connection param from custom meta data
    public static Map<String,String> getApplicationConnection () {
        //build a map of connection
        Map<String,String> mapOfConnection=new Map<String,String>();
        //Query the connection parameters
        List<RSI_IntegrationParam__mdt>  listOfConnection = [SELECT Parameter__c,Value__c FROM RSI_IntegrationParam__mdt];
        //Loop to set the parameters in mapOfConnection
        for(RSI_IntegrationParam__mdt mspObj:listOfConnection){
            mapOfConnection.put(mspObj.Parameter__c,mspObj.Value__c);}
        //return map of connection
        return mapOfConnection;
    }

     //make a request end point url for pulse point application
     public static String getApplicationEndPointURL () {
        //get connection param from RSI_UtilityClass by calling getApplicationConnection method...
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        //get domain from mapOfConnection
        String domain=mapOfConnection.get('Connection');
        //get app id from mapOfConnection
        String appId=mapOfConnection.get('APPID');
        //get app Key from mapOfConnection
        String appKey=mapOfConnection.get('APPKEY');
        //make a end point base url
        String requestEndPointUrl=domain;
        requestEndPointUrl+='/'+appId;
        requestEndPointUrl+='/v1/applications/';
        //return base url
        return requestEndPointUrl;
    }

     //get application params from custom meta data
     public static Map <String, List <RSI_PulsePointParam__mdt>> getApplicationParams () {
        //Query the Parameters List from custom meta data
        List <RSI_PulsePointParam__mdt> listParamSetup = [SELECT Id, Pulse_Point_Field_Name__c,
                                                          SalesForce_Field_API_Name__c, Source_Object__c,
                                                          SF_Data_Type__c FROM RSI_PulsePointParam__mdt];
        //Build a map of Object Name to the Parameters
        Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams = new Map <String, List <RSI_PulsePointParam__mdt>>();
        for (RSI_PulsePointParam__mdt objParam : listParamSetup) {
            //Loop through the records and setup the mapObjNameToParams map
            String objName = objParam.Source_Object__c;
            if (!mapObjNameToParams.containsKey(objName)) {
                mapObjNameToParams.put(objName, new List <RSI_PulsePointParam__mdt>());
            }
            mapObjNameToParams.get(objName).add(objParam);
        }
        //return params
        return mapObjNameToParams;
    }
        //get field value from specific object
    public static String getFieldValue (SObject obj, String fieldName) {
        String valueToReturn ='';
        //Build a list to traverse. We have to do a replace '.' with '@@' as Split with '.' does not work and errors out
        List<String> objRelList = fieldName.replace('.', '@@').split('@@');
        //Initialize a temporary SObject. This will be used to traverse the List
        SObject tempObj = obj;
        //Loop through all but one element that are part of the objRelList to get to the child SObject
        for (Integer k = 0; k < objRelList.size() - 1; k++) {
            tempObj = tempObj.getSObject(objRelList[k]);
        }
        //Proceed further only if we do not run into a null condition
        if(tempObj != null && objRelList != null && objRelList.size() > 0 ){
            if (tempObj.get(objRelList[objRelList.size()-1]) != null) {
                valueToReturn = String.valueOf(tempObj.get (objRelList[objRelList.size()-1]));
            }
        }
        //return field value
        return valueToReturn;
    }

    //make a request for callout
    public static HttpResponse getMakeHttpRequest (String JSONString ,String requestEndPointUrl, String method,String conType ) {
        //http object use to sent the request
        Http htp=new Http();
        //http request object
        HttpRequest request=new HttpRequest();
        //set session time out
        request.setTimeout(120000);
        //request body
        if (JSONString != '')request.setBody(JSONString);
        //request end point url
        request.setEndpoint(requestEndPointUrl);
        //request method
        request.setMethod(method); // 'POST'
        //request header
        request.setHeader('Content-Type',conType);// 'application/json'
        //return request object
        HttpResponse response = htp.send(request);
        System.debug(response.getBody());
        return response;
    }

    public static string uploadFile (Blob file_body, String file_name, String reqEndPoint, Id cdId){
        string contentType = FormData.GetContentType();
        string form64 = '';
        //adding documents metadata or properties
        //form64 += FormData.append('formFile','=');
        //form64 += FormData.append('key','value');
        //file_name = file_name.replace(':', '-');
        //adding documents body with file parameter
        blob formBlob= FormData.makeBlobWithFile('formFile',file_body,file_name,form64);
        string contentLength = string.valueOf(formBlob.size());
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setBodyAsBlob(formBlob);
        //httpRequest.setBody('{FORMFILE:'+EncodingUtil.base64Encode(formBlob)+'}');
        //httpRequest.setBody(EncodingUtil.base64Encode(formBlob));
        httpRequest.setHeader('Connection', 'keep-alive');
        httpRequest.setHeader('Content-Length', contentLength);
        httpRequest.setHeader('cache-control', 'no-cache');
        httpRequest.setHeader('accept-encoding', 'gzip, deflate, br');
        httpRequest.setHeader('Content-Type', contentType);
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setHeader('Accept', '*/*');
        //httpRequest.setHeader('Authorization',' ');
        System.debug(reqEndPoint);
        httpRequest.setEndpoint(reqEndPoint);
        //httpRequest.setEndpoint('https://httpbin.org/post');
        Http http = new Http();
        HttpResponse res = http.send(httpRequest);

        System.debug('status code '+res.getStatusCode());
        System.debug('response body '+res.getBody());
        String docNum;
        if (res.getStatusCode() == 200) {
            Map<String,Object> docResult=(Map<String,Object>)JSON.deserializeUntyped (res.getBody());
            Map <String, Object> result = (Map <String, Object>)docResult.get('RESULT');
            System.debug('response result '+docResult);
            docNum = String.valueOf((Integer)result.get('DOCID'));
            System.debug('response docNum '+docNum);
            //ContentDocument cdToUpd = new ContentDocument (Id = cdId, Description = docNum);
            //update cdToUpd;
        }
        return docNum;
    }

    /**
    * @description: Get the Field Set Members for the specified Object Name and the Field Set Name
    * @author Tanmay Jain | 10-19-2020
    * @param objectName
    * @param fieldSetName
    * @return List<Schema.FieldSetMember>
    **/
    public static List<Schema.FieldSetMember> getFieldSetMembers (String objectName, String fieldSetName) {
        //Get the global map of all SObjects
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        //Get the Desired SObject
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        //Describe the SObject
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        //Get the Fields Set
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        //Return the Field Set Members
        return fieldSetObj.getFields();
    }

    /**
    * @description: Get the Field Set Members for the specified Object Name and the Field Set Name
    * @author Tanmay Jain | 10-19-2020
    * @param objectName
    * @return Map<String, Schema.FieldSet>
    **/
    public static Map<String, Schema.FieldSet> getFieldSets (String objectName) {
        //Get the global map of all SObjects
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        //Get the Desired SObject
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        //Describe the SObject
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        //Return the Field Sets
        return describeSObjectResultObj.FieldSets.getMap();
    }

    public static String promoteApplication (String merchantAppNum) {
        String status = '';
        //Setup the Request End Point URL
        Map<String,String> mapOfConnection = getApplicationConnection();
        String baseEndpoint = mapOfConnection.get('Connection') + '/' + mapOfConnection.get('APPID') + '/v1/applications/';
        baseEndpoint += merchantAppNum + '/promote?appkey=';
        baseEndpoint += mapOfConnection.get('APPKEY');
        HttpResponse resp = getMakeHttpRequest('', baseEndpoint, 'POST', 'application/json;charset=utf-8');
        if (resp.getStatusCode() == 200) {
            Map<String,Object> docResult=(Map<String,Object>)JSON.deserializeUntyped (resp.getBody());
            status = (String)docResult.get('newStatus');
        }
        return status;
    }
}