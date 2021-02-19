/**
 * @description       :
 * @author            : Ajay Kumar
 * @group             :
 * @last modified on  : 4-12-2020
 * @last modified by  : Ajay Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0  5-1-2021  Ajay Kumar   Initial Version
**/
public with sharing class OwnerOrOfficerHelper{
    public List <Owners_Or_Officers__c> listPersonalGua{get;set;}
    public List <Owners_Or_Officers__c> listResParty{get;set;}
    public List <Owners_Or_Officers__c> listOwnerOff{get;set;}
    public Boolean isRental {get;set;}
    public void getData(){
        isRental = false;
        listResParty = new List <Owners_Or_Officers__c>();
        listPersonalGua = new List <Owners_Or_Officers__c>();
        listOwnerOff = new List<Owners_Or_Officers__c>();
        String opptyId = apexpages.currentpage().getparameters().get('id');
        for(Owners_Or_Officers__c obj : [SELECT Id,Signature__c,Principal_Title__c,Principal_TitleF__c,FullName__c,Personal_Guarantee__c,Responsible_Party__c,Application__c,Sign_Date__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC LIMIT 2]){
            if(obj.Responsible_Party__c)
                listResParty.add(obj);
            if(obj.Personal_Guarantee__c)
                listPersonalGua.add(obj);
        }
        //listoppitem = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listOppLineItem = [SELECT Id, OpportunityId,Product2.Name, Ownership_Type__c FROM OpportunityLineItem WHERE OpportunityId=:opptyId AND Ownership_Type__c = 'Rental' AND (Product2.Name='Pax E500' OR Product2.Name='Pax E700' OR Product2.Name = 'Poynt V2')];
        if(!listOppLineItem.isEmpty())
             isRental = true; 
           listOwnerOff = [SELECT Id,Principal_Title__c,FullName__c,Signature__c,I_Agree__c,Principal_TitleF__c,Sign_Date__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC];

    }
    @AuraEnabled
    public static List <Owners_Or_Officers__c> getOwnerOffList(String opptyId){
        return [SELECT Id,Principal_Title__c,FullName__c,Signature__c,Application__c,Principal_TitleF__c,I_Agree__c,Sign_Date__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId AND Personal_Guarantee__c=true ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC LIMIT 2];
    } 
    @AuraEnabled
    public static List <Owners_Or_Officers__c> getOwnerCheckOffList(String opptyId){
        return [SELECT Id,Principal_Title__c,FullName__c,Signature__c,Application__c,Sign_Date__c,I_Agree__c, Principal_TitleF__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId AND Responsible_Party__c=true ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC LIMIT 2];
    } 
    @AuraEnabled
    public static Boolean getOwnershipType(String opptyId){
        List<OpportunityLineItem> listOppLineItem = [SELECT Id, OpportunityId,Product2.Name, Ownership_Type__c FROM OpportunityLineItem WHERE OpportunityId=:opptyId AND Ownership_Type__c = 'Rental' AND (Product2.Name='Pax E500' OR Product2.Name='Pax E700' OR Product2.Name = 'Poynt V2')];

                                                      
        if(!listOppLineItem.isEmpty())
        return true;
        else 
        return false;
    }
    @AuraEnabled
    public static List <Owners_Or_Officers__c> getOwnerFirstOffList(String opptyId){
        return [SELECT Id,Principal_Title__c,FullName__c,Signature__c,I_Agree__c,Principal_TitleF__c,Sign_Date__c FROM Owners_Or_Officers__c WHERE Application__c =: opptyId  ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC];
    } 
    @AuraEnabled
    public static string updateOwnerOffCheckBox(String owfId,Boolean checkBoxValue){
       Owners_Or_Officers__c obj = new Owners_Or_Officers__c();
           obj.Id =  owfId;
           obj.I_Agree__c = checkBoxValue;
       update obj;
        return 'record updated';
    }
}