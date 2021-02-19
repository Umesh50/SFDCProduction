/****************************************************************************************************************
 * Name...................: RSI_IntegrationUtils
 * Created By.............: Umesh Kumar
 * Created Date...........: 16/10/2020
 * Description............: helper class of RSI_UpdateMerchantAppInformation
 *******************************************************************************************************************/

public class RSI_IntegrationUtils {


    //it is use to convert checkbox value(true or false) into 0 or 1 formate for pulse point
    public static String getCheckBoxConversion (String valueToConvert) {
        String valueToReturn = valueToConvert=='true' ? '1' :'0';
        return valueToReturn;
    }

    //it is use to add space both side in value of picklist for pulse point
    public static String getAddSpace (String valueToConvert) {
        String valueToReturn ='';
        if(valueToConvert !=''){
            valueToReturn = ' '+valueToConvert+' ';
        }
        return valueToReturn;
    }

    //it is use to make date formate as a mmyyyy formate for pulse point
    public static String getMonthYear (String valueToConvert) {
        String valueToReturn ='';
        if(valueToConvert !=''){
            //convert string into date formate
            Date dt = date.valueOf(valueToConvert);
            //convert datetime formate
            DateTime d=DateTime.newInstance(dt.year(), dt.month(), dt.day());
            //convert mm/yyyy formate
            valueToReturn = d.format('MM/yyyy');
        }
        return valueToReturn;
    }

     //it is use to convert date formate in mm/dd/yyyy formate for pulse point
    public static String getDateConversion (String valueToConvert) {
        String valueToReturn ='';
        if(valueToConvert !=''){
            //convert string into date formate
            Date dt = date.valueOf(valueToConvert);
            //convert datetime formate
            DateTime d=DateTime.newInstance(dt.year(), dt.month(), dt.day());
            //convert mm/yyyy formate
            valueToReturn = d.format('MM/dd/yyyy');
        }
        return valueToReturn;
    }

    //it is use to convert decimal formate into number formate for pulse point
    public static String getNumberConversion (String valueToConvert) {
        String valueToReturn='';
        if(valueToConvert !=''){
            Integer num= Integer.valueOf(valueToConvert);
            valueToReturn = String.valueOf(num);
        }
        return valueToReturn;
    }

    //it is use to convert null value with 0 formate and it help to create the application in pulse point.....
   /* public static String getConvertNullToZero (String valueToConvert) {
        String valueToReturn;
        //convert null to 0
        if(valueToConvert ==''){
            valueToReturn = String.valueOf(0);
        }else{
            valueToReturn = valueToConvert;
        }
        return valueToReturn;
    } */

    //get dynamic query
    public static String getDynamicQuery (Map <String,List <RSI_PulsePointParam__mdt>> mapObjNameToParams,Id opptyIds){
        //Now building dynamic query. For this we will loop through the Map and identify the objects.
        // Opportunity will be the primary object followed by the rest
        String query = 'SELECT id,Merchant_Application_No__c,Merchant_Application_Document_No__c,';
        //Add Opportunity fields
        Set <String> setFields = new Set <String> ();
        for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get('Opportunity')) {
            if(objParam.SF_Data_Type__c!= 'CreateApp'){
            setFields.add(objParam.SalesForce_Field_API_Name__c);
            }
        }

        //Setup the Opportunity fields that we are going to query
        String innerQuery ;
        query = query + String.join(new List <String> (setFields), ', ');
        //query = SELECT Contact__r.FirstName, Contact__r.LastName, ..... Name
        for (String key : mapObjNameToParams.keySet()) {
            //key will be the Object that we will query as an inner query on the Opportunity object
            if (key != 'Opportunity') {
                //Reusing the set
                setFields.clear();
                for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get(key)) {
                    setFields.add(objParam.SalesForce_Field_API_Name__c);
                }

                //Setting up the Inner Query
                if(key == 'Owners_Or_Officers__r'){
                   innerQuery = ' , (SELECT Primary_Owner_Or_Officer__c,' + String.join(new List <String> (setFields), ', ') + ' FROM ' + key + ' ORDER BY Primary_Owner_Or_Officer__c DESC,CreatedDate ASC )';
                }else{
                    innerQuery = ' , (SELECT ' + String.join(new List <String> (setFields), ', ') + ' FROM ' + key + ')';
                }
                //Adding to the query String generated above to add the inner query to the end
                query = query + innerQuery;
            }
        }
        //Finish the query statement by adding the Opportunity condition
        query = query + ' FROM Opportunity WHERE Id = \'' + opptyIds + '\'';
        //return query string
        return query;
 }

    //create json string for end point request
    public static String getJsonString(Map <String, String> mapPPFieldNametoValue ) {
        //get appkey from custom meta data using RSI_UtilityClass class
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        String appKey=mapOfConnection.get('APPKEY');
        String requestJSON;
        //generate dunamic json
        for(String fieldName : mapPPFieldNametoValue.keySet()){
            if(requestJSON == null){
                requestJSON ='{\\"'+fieldName+'\\":\\"'+mapPPFieldNametoValue.get(fieldName)+'\\"';
            }else{ requestJSON =requestJSON+',\\"'+fieldName+'\\":\\"'+mapPPFieldNametoValue.get(fieldName)+'\\"';}
        }

       // build a final json string
        String JSONString ='{"appkey":"'+ appKey+'","FormFields":"'+requestJSON+'}"}';
        return JSONString;
    }

 //get child object value and assign to pulse point fields
 public static Map <String, String> getAllChildRecords (Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams,
  Opportunity oppRecord) {
   //bulid a make and assign sf value to pp fields
    Map <String, String> mapPPFieldNametoValue = new Map <String, String> ();
       //iterate all object and get related value...
        for (String key : mapObjNameToParams.keySet()) {
            //define for loop size
            Integer maxSize;
           // Integer minSize;
            //key will be the Object that we will query as an inner query on the Opportunity object
            if (key != 'Opportunity') {
                // get opportunity lineitems product  value  and assign to pulse point fields
                if(key == 'OpportunityLineItems'){
                    maxSize = 6;
                   // minSize =1;
                    Map <String, String> mapPPFieldValue = getChildRecordByObject(key, mapObjNameToParams ,oppRecord ,maxSize);
                    mapPPFieldNametoValue.putAll(mapPPFieldValue);
               // get fee object value  and assign to pulse point fields
                }else if(key == 'Fees__r'){
                    maxSize = 8;
                   // minSize =1;
                    Map <String, String> mapPPFieldtoValue = getChildRecordByObject(key,mapObjNameToParams ,oppRecord ,maxSize);
                    mapPPFieldNametoValue.putAll(mapPPFieldtoValue);
                // get owner or officer object  value  and assign to pulse point fields
                }else if(key == 'Owners_Or_Officers__r'){
                    maxSize = 5;
                   // minSize =2;
                    Map <String, String> mapPPField = getChildRecordByObject(key,mapObjNameToParams ,oppRecord ,maxSize);
                    mapPPFieldNametoValue.putAll(mapPPField);
               // get other object value  and assign to pulse point fields
                }else{
                    maxSize = 1;
                    // minSize = 1;
                    Map <String, String> mapPPFieldtoValue = getChildRecordByObject(key , mapObjNameToParams ,oppRecord ,maxSize);
                    mapPPFieldNametoValue.putAll(mapPPFieldtoValue);
                }

            }
        }

    return mapPPFieldNametoValue;
 }

// get object value by object name
 private static Map <String, String> getChildRecordByObject(String key ,
   Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams, Opportunity oppRecord , Integer maxSize) {
    // build a map
     Map <String, String> mapPPFieldNametoValue = new Map <String, String> ();
     //list of child record...
     List <SObject> listOfChildRecord=(List <SObject>)oppRecord.getSObjects(key) ==null ? null
       : (List <SObject>)oppRecord.getSObjects(key);
       Integer count;
       if(key == 'Fees__r'){
        count = 2;  
       } else {count = 1;}  
         if(listOfChildRecord!=null){
             //iterate the child record...
          for (SObject childObj :listOfChildRecord) {
               // under this loop assign sf fields value to pulse point fields....
             for (RSI_PulsePointParam__mdt objParam : mapObjNameToParams.get(key)) {
                 String sfValue;
                 String ppFieldName;
                 String sfDataType = objParam.SF_Data_Type__c;
                 String sfFieldName = objParam.SalesForce_Field_API_Name__c;
                 //get multiple record  pulse point fields name...
                 if(count!=1){ ppFieldName = getMultiRecordPPFields(key,objParam,count);}
                 //get single record pulse point fields.....
                 else{ ppFieldName = getOneRecordPPFields(key,objParam,count); }
                 //map the data of salesforce fields into pulse point fields.....
                 mapPPFieldNametoValue.put(ppFieldName,getCheckValueType(childObj, sfFieldName,sfDataType));
             }
             count++;
         }

         //  map blank value to the pulse point fields.....
         Map <String, String> mapOfNullValue = setNullValToPPFields(key, mapObjNameToParams,count,maxSize );
         mapPPFieldNametoValue.putAll(mapOfNullValue);
       }else {
          //  map blank value to the pulse point fields.....
         Map <String, String> mapOfNullValue = setNullValToPPFields(key, mapObjNameToParams,count,maxSize );
         mapPPFieldNametoValue.putAll(mapOfNullValue);
     }
     return mapPPFieldNametoValue;
    }
    // create blank value for pulse point fields....
     private static Map <String, String> setNullValToPPFields(String key,
        Map <String, List <RSI_PulsePointParam__mdt>> mapObjNameToParams,Integer count,Integer maxSize ){
            //build a map...
            Map <String, String> mapPPFieldNametoValue = new Map <String, String> ();
            //iterate the loop with respect to size
            for (integer i = count ; i<= maxSize ; i++) {
                // iterate the child object fields....
                for (RSI_PulsePointParam__mdt objParamNull : mapObjNameToParams.get(key)) {
                    String ppFieldNull;
                    String temp = '';
                    //create multi record fields for pulse point
                    if(i!=1){  ppFieldNull = getMultiRecordPPFields(key,objParamNull, i); }
                     //create single record fields for pulse point
                    else{  ppFieldNull = getOneRecordPPFields(key,objParamNull,i);  }
                    mapPPFieldNametoValue.put(ppFieldNull , temp );
                }
            }
            return mapPPFieldNametoValue;
    }
     //create multi record fields for pulse point
  private static String getMultiRecordPPFields(String key,RSI_PulsePointParam__mdt objParam ,Integer count){
      // add _ and number with pulse point fields...
        String tempvar= '_'+String.valueOf(count);
      // filter the respect fields of pulse point...
        String  ppFieldName = key == 'OpportunityLineItems' ? objParam.Pulse_Point_Field_Name__c
            +String.valueOf(count) : key== 'Fees__r' ? objParam.Pulse_Point_Field_Name__c
                +tempvar : key=='Owners_Or_Officers__r' ? objParam.Pulse_Point_Field_Name__c
                    +tempvar : objParam.Pulse_Point_Field_Name__c;
        return  ppFieldName;
    }
     //create single record fields for pulse point
    private static String getOneRecordPPFields(String key ,RSI_PulsePointParam__mdt objParam ,Integer count){
        String ppField = objParam.Pulse_Point_Field_Name__c;
        // filter the respect fields of pulse point...
        String ppFieldName = key == 'OpportunityLineItems' ?(ppField == 'VARVendor' ? 'VARVendor'
                                                             :ppField == 'VARGateway' ? 'VARGateway'
                                                             :ppField == 'VARProduct' ? 'VARProduct'
                                                             :ppField == 'VARTIDNumber' ? 'VARTIDNumber'
                                                             :ppField == 'VARServiceProvider' ? 'VARServiceProvider'
                                                             :ppField + String.valueOf(count))
            : key == 'Owners_Or_Officers__r'? (ppField == 'ForeignIdType' ? 'ForeignIdType_1'
                                               :ppField == 'GovernmentIdName' ? 'GovernmentIdName_1'
                                               :ppField == 'ForeignIdNumber' ? 'ForeignIdNumber_1'
                                               :ppField == 'CountryofIssuance' ? 'CountryofIssuance_1'
                                               :ppField == 'IdType' ? 'IdType_1'
                                               :ppField == 'AdditionalOwnerswithmore25perc' ? 'AdditionalOwnerswithmore25perc_1'
                                               :ppField) : ppField;

        return  ppFieldName;
    }

   //convert the value with respect to data type
   public static String getCheckValueType(SObject childObj,String sfFieldName,String sfDataType){
       String sfValue;
       if(sfDataType == 'Checkbox'){
           //convert checkbox value (true,false) into 0 or 1 formate
           sfValue = getCheckBoxConversion(RSI_UtilityClass.getFieldValue(childObj, sfFieldName));
       } else if(sfDataType == 'AddSpace'){
            //add both side space in a picklist value
           sfValue =getAddSpace(RSI_UtilityClass.getFieldValue(childObj, sfFieldName));
       } else if(sfDataType == 'Date'){
           //convert date formate into mm/dd/yyyy formate
           sfValue = getDateConversion(RSI_UtilityClass.getFieldValue(childObj, sfFieldName));
       }else if(sfDataType == 'MMYYYY'){
           //convert date formate into mm/yyyy formate
           sfValue = getMonthYear(RSI_UtilityClass.getFieldValue(childObj, sfFieldName));
       } else if(sfDataType == 'Number'){
           //convert decimal value into number formate
           sfValue = getNumberConversion(RSI_UtilityClass.getFieldValue(childObj, sfFieldName));
       } else {
           //other case
           sfValue = RSI_UtilityClass.getFieldValue(childObj, sfFieldName);
       }
      return sfValue;
  }
}