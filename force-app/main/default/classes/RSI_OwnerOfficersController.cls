/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-09-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-08-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_OwnerOfficersController {

    @AuraEnabled
    public static List <Owners_Or_Officers__c> getOwnerList(String opptyId){
        List <Owners_Or_Officers__c> ownerRecs = new List <Owners_Or_Officers__c> ();
        for (Owners_Or_Officers__c obj : [SELECT Id, Owner_Type__c, Primary_Owner_Or_Officer__c, Ownership_Percentage__c, Responsible_Party__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC]) {
            ownerRecs.add(obj);
        }
        return ownerRecs;
    }
    
     @AuraEnabled
    public static List <Owners_Or_Officers__c> getPGuarantorOwnerList(String opptyId){
        List <Owners_Or_Officers__c> ownerPGRecs = new List <Owners_Or_Officers__c> ();
        for (Owners_Or_Officers__c obj : [SELECT Id, Owner_Type__c, Primary_Owner_Or_Officer__c, Ownership_Percentage__c, Responsible_Party__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC]) {
            ownerPGRecs.add(obj);
        }
        return ownerPGRecs;
    }
    
    
     //to get all product of related application
    @AuraEnabled
    public static List <OpportunityLineItem> getProductList(String opptyId){
        List <OpportunityLineItem> lineItemRecs = new List <OpportunityLineItem> ();
        for (OpportunityLineItem obj : [select Id,Product2.Name,Ownership_Type__c,Quantity,UnitPrice,Product_Website__c from OpportunityLineItem where OpportunityId =: opptyId]) {
            lineItemRecs.add(obj);
        }
        return lineItemRecs;
    }

    @AuraEnabled
    public static List<Equipment_Programming__c> getEquipmentProg(String opptyId){
        List <Equipment_Programming__c> eqipProgList = new List <Equipment_Programming__c> ();
        for (Equipment_Programming__c obj : [select Id,AUTO_BATCH__c,Time__c from Equipment_Programming__c where Application__c =: opptyId]){
            eqipProgList.add(obj);
        }
        return eqipProgList;
           
    }

    @AuraEnabled
    public static List<Opportunity> getOppDBAPhone(String opptyId){
        List <Opportunity> oppList = new List <Opportunity> ();
        for (Opportunity obj : [select Id,DBA_Phone__c from Opportunity where id =: opptyId]){
            oppList.add(obj);
        }
        return oppList;
           
    }


    @AuraEnabled
    public static string deleteOwnerOfficer(String recId){
        try {
            delete [SELECT Id FROM Owners_Or_Officers__c WHERE Id =: recId];
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}