/**
 * @description       : This apex class will update the Progress Indicators on the Opportunity object. It will be called from all the child objects post insert / update operations
 * @author            : Tanmay Jain
 * @group             : 
 * @last modified on  : 10-23-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-23-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_SetOpportunityProgressIndicators {

    //The below Lists store the fields from the individual objects
    public static List <String> opptyFields         = new List <String> ();
    public static List <String> oliFields           = new List <String> ();
    public static List <String> addInfoFields       = new List <String> ();
    public static List <String> authFields          = new List <String> ();
    public static List <String> dbtNetFields        = new List <String> ();
    public static List <String> ecsFields           = new List <String> ();
    public static List <String> eqProgFields        = new List <String> ();
    public static List <String> feeFields           = new List <String> ();
    public static List <String> gCardFields         = new List <String> ();
    public static List <String> mpaFields           = new List <String> ();
    public static List <String> vasFields           = new List <String> ();
    public static List <String> ownOfficerFields    = new List <String> ();
    public static List <String> prcIndoFields       = new List <String> ();

    public static void updateProgressIndicators (Set <String> setOpptyIds) {
        initFieldList();
        String query = setupQueryString(setOpptyIds);
        System.debug(query);
    }

    /**
    * @description This method initializes the fields list
    * @author Tanmay Jain | 10-23-2020 
    **/
    private static void initFieldList (){
        //Opportunity
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
        opptyFields = new List<String>(objectFields.keySet());
        //OpportunityLineItems
        objectFields = Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap();
        oliFields = new List<String>(objectFields.keySet());
        //Additional_Information__c
        objectFields = Schema.getGlobalDescribe().get('Additional_Information__c').getDescribe().fields.getMap();
        addInfoFields = new List<String>(objectFields.keySet());
        //Authorization__c
        objectFields = Schema.getGlobalDescribe().get('Authorization__c').getDescribe().fields.getMap();
        authFields = new List<String>(objectFields.keySet());
        //Debit_Network__c
        objectFields = Schema.getGlobalDescribe().get('Debit_Network__c').getDescribe().fields.getMap();
        dbtNetFields = new List<String>(objectFields.keySet());
        //Electronic_Check_Service__c
        objectFields = Schema.getGlobalDescribe().get('Electronic_Check_Service__c').getDescribe().fields.getMap();
        ecsFields = new List<String>(objectFields.keySet());
        //Equipment_Programming__c
        objectFields = Schema.getGlobalDescribe().get('Equipment_Programming__c').getDescribe().fields.getMap();
        eqProgFields = new List<String>(objectFields.keySet());
        //Fee__c
        objectFields = Schema.getGlobalDescribe().get('Fee__c').getDescribe().fields.getMap();
        feeFields = new List<String>(objectFields.keySet());
        //Gift_Card__c
        objectFields = Schema.getGlobalDescribe().get('Gift_Card__c').getDescribe().fields.getMap();
        gCardFields = new List<String>(objectFields.keySet());
        //MPA_Section__c
        objectFields = Schema.getGlobalDescribe().get('MPA_Section__c').getDescribe().fields.getMap();
        mpaFields = new List<String>(objectFields.keySet());
        //Other_Card_Types_VAS__c
        objectFields = Schema.getGlobalDescribe().get('Other_Card_Types_VAS__c').getDescribe().fields.getMap();
        vasFields = new List<String>(objectFields.keySet());
        //Owners_Or_Officers__c
        objectFields = Schema.getGlobalDescribe().get('Owners_Or_Officers__c').getDescribe().fields.getMap();
        ownOfficerFields = new List<String>(objectFields.keySet());
        //Pricing_Information__c
        objectFields = Schema.getGlobalDescribe().get('Pricing_Information__c').getDescribe().fields.getMap();
        prcIndoFields = new List<String>(objectFields.keySet());
    }

    /**
    * @description This method generates and returns a query string to execute on the Opportunity Object
    * @author Tanmay Jain | 10-23-2020 
    * @param setOpptyIds 
    * @return String 
    **/
    private static String setupQueryString (Set <String> setOpptyIds) {
        String query = 'SELECT ' + String.join(opptyFields, ', ');
        query += ', (SELECT ' + String.join(oliFields, ', ')          + ' FROM OpportunityLineItems)';
        query += ', (SELECT ' + String.join(addInfoFields, ', ')      + ' FROM Additional_Information__r)';
        query += ', (SELECT ' + String.join(authFields, ', ')         + ' FROM Authorization__r)';
        query += ', (SELECT ' + String.join(dbtNetFields, ', ')       + ' FROM Debit_Networks__r)';
        query += ', (SELECT ' + String.join(ecsFields, ', ')          + ' FROM Electronic_Check_Services__r)';
        query += ', (SELECT ' + String.join(eqProgFields, ', ')       + ' FROM Equipment_Programming__r)';
        query += ', (SELECT ' + String.join(feeFields, ', ')          + ' FROM Fees__r)';
        query += ', (SELECT ' + String.join(gCardFields, ', ')        + ' FROM Gift_Cards__r)';
        query += ', (SELECT ' + String.join(mpaFields, ', ')          + ' FROM MPA_Section__r)';
        query += ', (SELECT ' + String.join(vasFields, ', ')          + ' FROM Other_Card_Types_VAS__r)';
        query += ', (SELECT ' + String.join(ownOfficerFields, ', ')   + ' FROM Owners_Or_Officers__r)';
        query += ', (SELECT ' + String.join(prcIndoFields, ', ')      + ' FROM Pricing_Information__r)';
        query = query.replace('isdeleted,', '').replace('ownerid,', '').replace('createddate,', '').replace('createdbyid,', '').replace('lastmodifieddate,', '').replace('lastmodifiedbyid,', '').replace('systemmodstamp,', '');
        query += ' FROM Opportunity WHERE Id IN (\'' + String.join(new List <String> (setOpptyIds), '\', \'') + '\')';
        return query;
    }
}