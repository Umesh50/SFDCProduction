/**
 * @description       : 
 * @author            : Tanmay Jain
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-24-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_ApplicationEditForm {

    public class ApplicationUISection {

        @AuraEnabled
        public List <SObject>            uiData {get; set;}
        @AuraEnabled
        public List <SectionSetup>       uiLayout {get; set;}
    }

    public class SectionSetup {
        @AuraEnabled
        public String            fieldDataType {get; set;}       //This parameter defines the Field's Data Type
        @AuraEnabled
        public Integer           fieldWidth {get; set;}          //This controls whether the fields takes up the entire space
        @AuraEnabled
        public String            fullFieldPath {get; set;}       //This stores the Object Name + '@' + Field API Name for the field being shown
        @AuraEnabled
        public Map <String, String>     pickValues {get; set;}   //This stores the list of options for when the Data Type is Picklist
        @AuraEnabled
        public String            fieldLabel {get; set;}          //This stores the Label to show for the field

        public SectionSetup (String fieldDataType, Integer fieldWidth, String fullFieldPath, Map <String, String> pickValues, String fieldLabel) {
            this.fieldDataType  = fieldDataType;
            this.fieldWidth = fieldWidth;
            this.fullFieldPath  = fullFieldPath;
            this.pickValues     = pickValues;
            this.fieldLabel     = fieldLabel;
        }
    }

    public static String opportunityId = '';
    /**
    * @description This is the main method invoked from the LWC Component. It will accept input parameters of Section Name along with the Opportunity Id and fetch the details to show on the UI.
    * @author Tanmay Jain | 10-24-2020 
    * @param sectionName 
    * @param opptyId 
    * @return List<SectionSetup> 
    **/
    @AuraEnabled
    public static List<SectionSetup> getSectionData (String sectionName, String opptyId) {
        opportunityId = opptyId;
        //Below is the Section Value that is part of the return value
        List <SectionSetup> lstSetup = new List <SectionSetup> ();
        //Below map holds the mapping of the Section setup to the Metadata setup. We will be plugging in the fields values later.
        Map <String, SectionSetup> mapFieldKeyToSetup = new Map <String, SectionSetup> ();
        //Below Map holds all the Objects to be queried for the section along with the relevant fields
        Map <String, List <String>> mapObjToLstFields = new Map <String, List <String>>();
        //Below Map holds all the Picklist option values for the relevant Picklist fields
        Map <String, Map <String, String>> mapPickFieldstoValues = new Map <String, Map <String, String>> ();
        //Below Map holds all the Lookup fields
        Map <String, List <String>> mapLookupFields = new Map <String, List <String>>();

        //Fetch data from the setup object
        for (RSI_ApplicationEditField__mdt setup : [SELECT Field_Data_Type__c, Full_Width__c, Target_Field_API_Name__c, Target_Object_API_Name__c, Field_Label__c FROM RSI_ApplicationEditField__mdt WHERE Pulsepoint_Section__c = :sectionName ORDER BY Sequence__c ASC]) {
            String key = '';
            //For sections there will not be any data to query
            if (setup.Field_Data_Type__c == 'Section') {
                key = '--Section--' + String.valueOf(mapFieldKeyToSetup.keySet().size());
                mapFieldKeyToSetup.put(key, new SectionSetup (setup.Field_Data_Type__c, 12, key, new Map <String, String> (), setup.Field_Label__c));
            } else {
                key = setup.Target_Object_API_Name__c + '@' + setup.Target_Field_API_Name__c;
                Integer width = setup.Full_Width__c ? 12 : 6;
                mapFieldKeyToSetup.put(key, new SectionSetup (setup.Field_Data_Type__c, width, key, new Map <String, String>(), setup.Field_Label__c));
                if (setup.Field_Data_Type__c == 'Picklist') {
                    mapPickFieldstoValues.put(key, new Map <String, String>());
                }
                setupMaps(setup, mapObjToLstFields, mapLookupFields);
            }
        }
        //Fetch the Pick List Values
        Map <String, Map <String, String>> pickListValues = getPickValues(mapPickFieldstoValues);
        for (String key : mapFieldKeyToSetup.keySet()) {
            SectionSetup setup = mapFieldKeyToSetup.get(key);
            setup.pickValues = pickListValues.get(key);
            mapFieldKeyToSetup.put(key, setup);
        }
        return mapFieldKeyToSetup.values();
        //Now fill in the empty spaces for the Setup
    }

    /**
    * @description This method will instantiate the mapObjToLstFields & mapLookupFields
    * @author Tanmay Jain | 10-24-2020 
    * @param setup 
    * @param mapObjToLstFields 
    * @param mapLookupFields 
    **/
    private static void setupMaps (RSI_ApplicationEditField__mdt setup, Map <String, List <String>> mapObjToLstFields, Map <String, List <String>> mapLookupFields) {
        if (!mapObjToLstFields.containsKey(setup.Target_Object_API_Name__c)) {
            mapObjToLstFields.put(setup.Target_Object_API_Name__c, new List <String> ());
        }
        mapObjToLstFields.get(setup.Target_Object_API_Name__c).add(setup.Target_Field_API_Name__c);
        if (setup.Field_Data_Type__c == 'Lookup') {
            String nameField = setup.Target_Field_API_Name__c.right(3) == '__c' ? setup.Target_Field_API_Name__c.replace('__c', '__r') + '.Name' : setup.Target_Field_API_Name__c + 'Id.Name';
            mapObjToLstFields.get(setup.Target_Object_API_Name__c).add(nameField);
            if (!mapLookupFields.containsKey(setup.Target_Object_API_Name__c)) {
                mapLookupFields.put(setup.Target_Object_API_Name__c, new List <String> ());
            }
            mapLookupFields.get(setup.Target_Object_API_Name__c).add(setup.Target_Field_API_Name__c);
        }
    }

    /**
    * @description This method returns the field value fetched for the query fields. The return is a map where the key is Object Name + '@' + Field API Name. The key is same as the one used in the mapFieldKeyToSetup
    * @author Tanmay Jain | 10-24-2020 
    * @param mapObjToLstFields 
    * @param mapLookupFields 
    * @return Map<String, String> 
    **/
    private static List <SObject> getFieldValues (Map <String, List <String>> mapObjToLstFields, Map <String, List <String>> mapLookupFields) {
        //We will be performing a query inside a loop as part of this functionality. This is being done on purpose.
        List <SObject> retDataList = new List <SObject> ();
        //The Setup is dynamic and we will not know the number of objects under a section.
        for (String objName : mapObjToLstFields.keySet()) {
            //Setup the Where Clause for the Dynamic SOQL
            String whereClause = objName == 'Opportunity' ? ' WHERE Id = \'' + opportunityId + '\'' : ' WHERE Application__c = \'' + opportunityId + '\' ORDER BY CreatedDate ASC';
            //Setup the query parameter
            String query = 'SELECT Id, ' + String.join(mapObjToLstFields.get(objName), ', ') + ' FROM ' + objName + whereClause;
            //Perform query and get the data for this object
            try {
                //This logic is enclosed under try catch for the scenario where we do not have any record for the specified object. Here we will return an empty record
                List <SObject> queryRes = Database.query(query);
                retDataList.addAll(queryRes);
            } catch (Exception ex) {
                SObject obj = Schema.getGlobalDescribe().get(objName).newSObject();
                retDataList.add (obj);
            }
        }
        return retDataList;
    }

    /**
    * @description This method gets the field values for the UI
    * @author Tanmay Jain | 10-24-2020 
    * @param fieldData 
    * @param objName 
    * @param objFields 
    * @param lookupFields 
    * @param queryRes 
    **/
    /*private static void setFieldData (Map <String, Map <String, String>> fieldData, String objName, List <String> objFields, List <String> lookupFields, List <SObject> queryRes) {
        //Loop through all the SObject records
        for (SObject obj : queryRes) {
            //Initialize the data for the above SObject using the Object's Id
            String objId = String.valueOf(obj.get('Id'));
            fieldData.put(objId, new Map <String, String>());
            //Now loop through all the fields in the list of the fields and set the field values
            for (String fld : objFields) {
                String fieldValue = RSI_UtilityClass.getFieldValue(queryRes, fld);
                //Check if the field is setup as a Lookup. In this case, we need to fetch the Name field
                Boolean lookup = lookupFields.contains(fld);
                //Establish the Name field hierarchy
                String nameField = fld.right(3) == '__c' ? fld.replace('__c', '__r') + '.Name' : fld + 'Id.Name';
                //Fetch the Name field value
                String lookupVal = lookup ? RSI_UtilityClass.getFieldValue(queryRes, nameField) : '';
                //Identify the final value to be stored in the map
                fieldValue = lookup ? fieldValue + '--@@--' + lookupVal : fieldValue;
                fieldData.get(objId).put(objName + '@' + fld, fieldValue);
            }
        }
    }*/

    /**
    * @description This method fetches the Pick List setup for the provided list of fields
    * @author Tanmay Jain | 10-25-2020 
    * @param mapPickFieldstoValues 
    * @return Map<String, Map<String, String>> 
    **/
    private static Map <String, Map <String, String>> getPickValues (Map <String, Map <String, String>> mapPickFieldstoValues) {
        //Below Map's key is Object Name + '@' + Field Name along with the Map of Pick list values
        Map <String, Map <String, String>> pickValues = new Map <String, Map <String, String>>();
        //Loop through the input mapPickFieldstoValues and fetch the Pick List values
        for (String key : mapPickFieldstoValues.keySet()) {
            pickValues.put(key, new Map <String, String>());
            String fullFldPath = key.replace('.', '@');
            List <String> splitList = fullFldPath.split('@');
            //The last element in the above list is our field name and the second to last element is the Object name
            String objName = splitList[splitList.size() - 2];
            String fieldName = splitList[splitList.size() - 1];
            //Get the Field Metadata setup from the Object Name
            System.debug(objName + '>>' + fieldName);
            Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe();
            //Get the Picklist values
            for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
                pickValues.get(key).put(ple.getValue(), ple.getLabel());
            }
        }
        return pickValues;
    }

    private static void finalizeSection (Map <String, SectionSetup> mapFieldKeyToSetup, Map <String, Map <String, String>> fieldValues, Map <String, Map <String, String>> pickValues) {
        
    }
}