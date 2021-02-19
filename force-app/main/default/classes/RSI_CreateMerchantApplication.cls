/****************************************************************************************************************
 * Name...................: RSI_CreateMerchantApplication 
 * Created By.............: Umesh Kumar
 * Created Date...........: 09/09/2020
 * Description............: This class use to create the application under the msppulsepoint.
 *******************************************************************************************************************/

public class RSI_CreateMerchantApplication implements Queueable , Database.AllowsCallouts {
    //set opportunity ids
    public Set<Id> setOfOpportunityIds;
    //constructor to Initialize the set of opportunity ids
    public RSI_CreateMerchantApplication(Set<Id> setOfOpportunityId) {
        this.setOfOpportunityIds=setOfOpportunityId;  
    }
    //execute the code
    public void execute(QueueableContext context){
        //get application Params from RSI_IntegrationUtils class.......
        Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams = RSI_UtilityClass.getApplicationParams();
        // get dynamic query.......
        String query = getDynamicQuery(mapObjNameToParams,setOfOpportunityIds);
         system.debug('query--'+query);
        // execute query.........
        List<Opportunity> opprtyRecords = Database.query(query);
        // list of updated Application with application number and document number....
        List<Opportunity> listOfUpdatedOpportunity=new List<Opportunity>();
        //iteration of the opportunity...........
        for(Opportunity opptyObj:opprtyRecords){
            //variable to hold application number.........
            Integer merchantAppNo;
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
                    sfValue =getConvertNullToZero(RSI_UtilityClass.getFieldValue(opptyObj, sfFieldName));
                    //assign the salesforce fields value to the pulse point fields.........
                    mapPPFieldNametoValue.put(ppFieldName , sfValue );
                }
            } 
            //get request json for create the application under pulse point....   
            String  requestJson = getRequestJson(mapPPFieldNametoValue);
            system.debug('json---'+requestJson);
            //get end point url of pulse point... for the request........  
            String appCreationUrl =  RSI_UtilityClass.getApplicationEndPointURL();
            system.debug('end point url----'+appCreationUrl);
            // method type...
            String method = 'POST';
            // content type......
            String ContentType = 'application/json';
            //send the request and get response..........
            HttpResponse response= RSI_UtilityClass.getMakeHttpRequest(requestJson, appCreationUrl, method, ContentType);
            if (response.getStatusCode()==200) {
                //again request to get application document number..
                Map<String,Object> result=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                system.debug('>>>>>>>>>>'+result.get('MERCHANTAPPLICATIONNO'));
                //get application number....
                merchantAppNo=(Integer.valueOf(result.get('MERCHANTAPPLICATIONNO')));
                //assign application number to the opportunity...
                opptyObj.Merchant_Application_No__c=merchantAppNo;
                if(merchantAppNo!= null){
                    //get appkey from custom meta data using RSI_UtilityClass class
                    Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
                    // get app key to make a url...
                    String appKey=mapOfConnection.get('APPKEY');  
                    // get end point url to get document number.....
                    String getDocumentNoUrl =  RSI_UtilityClass.getApplicationEndPointURL();   
                    getDocumentNoUrl = getDocumentNoUrl+merchantAppNo+'/forms?'; 
                    getDocumentNoUrl = getDocumentNoUrl+'appkey='+appKey;
                    //http object use to sent the request
                    Http htp=new Http();
                    //http request object
                    HttpRequest request=new HttpRequest();
                    //set session time out
                    request.setTimeout(20000); 
                    //request end point url
                    request.setEndpoint(getDocumentNoUrl);
                    //request method
                    request.setMethod('GET'); // 'POST'  
                    //request header
                    request.setHeader('Content-Type','application/json');
                    //return request object
                    HttpResponse docNoResponse = htp.send(request);
                    if (docNoResponse.getStatusCode()==200) {
                        // get respone to get document number....
                        Map<String,Object> docResult=(Map<String,Object>)JSON.deserializeUntyped(docNoResponse.getBody());
                        Map<String, Object> mapOfData = (Map<String,Object>)docResult.get('DATA');
                        List<Object> mapOfDataOfData = (List<Object>)mapOfData.get('DATA');
                        String arrayofdata=mapOfDataOfData[0].toString();
                        List<String> docno=arrayofdata.split(',');
                        system.debug('document no:'+docno[1]);
                        opptyObj.Merchant_Application_Document_No__c=Integer.valueOf(docno[1].trim());
                    }else {  System.debug('Document number does not exist !'); }    
                }
                // add update opportunity in the list....
                listOfUpdatedOpportunity.add(opptyObj);   
            } else { System.debug('Application not created because '+response.getStatus()); }     
        }
        // update opportunity with application number and document number....
        update listOfUpdatedOpportunity;
    }
    // call for dynamic query.........
    private static String getDynamicQuery(Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams,
       Set<Id> setOfOpportunityIds) {
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
           String query = 'select Merchant_Application_No__c,' 
               + commaSepratedFields + ' from Opportunity where id IN: setOfOpportunityIds ';
           return query;
    }  
    // call for dynamic json.......
    private static String getRequestJson(Map<String,String> mapPPFieldNametoValue ) {
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
    public static String getConvertNullToZero (String valueToConvert) {
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