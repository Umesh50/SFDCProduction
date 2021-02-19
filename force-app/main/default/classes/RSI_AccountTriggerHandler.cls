/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 12-12-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   12-11-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_AccountTriggerHandler {
    public static void onAfterUpdate (List <Account> triggerNew, Map <Id, Account> oldMap) {
        List <Account> lstAccForABASync = new List <Account> ();
        List <String> lstAccIdsForFees = new List <String> ();
        List<Id> listAccId = new List<Id>();
        Map<Id,String> mapAccIds = new Map<Id,String>();
        List<Id> accIds =new List<Id>();
        for (Account acc : triggerNew) {
            //added by UK
            if(acc.Pricing_Plans__c != oldMap.get(acc.Id).Pricing_Plans__c){
             mapAccIds.put(acc.Id,acc.Pricing_Plans__c);
            }
            if(acc.MERCHANT_ID__c != null && acc.MERCHANT_ID__c != oldMap.get(acc.Id).MERCHANT_ID__c){
             accIds.add(acc.Id);
            }
            if (acc.ABA_RoutingLookup2__c != oldMap.get(acc.Id).ABA_RoutingLookup2__c) {
                lstAccForABASync.add (new Account (Id = acc.Id, ABA_RoutingLookup__c = acc.ABA_RoutingLookup2__c));
            }
            if (acc.Annual_Revenue__c != oldMap.get(acc.Id).Annual_Revenue__c) {
                lstAccIdsForFees.add(acc.Id);
            }
            //Added by ajay
            if(acc.MID__c != null && acc.MID__c != oldMap.get(acc.Id).MID__c){
                listAccId.add(acc.Id);
            }
        }
        //added by UK
        if(!mapAccIds.isEmpty()){
            List<Opportunity> oppList=new List<Opportunity>();
            for(Opportunity oppObj :[SELECT id,AccountId FROM Opportunity where AccountId IN : mapAccIds.keySet()]){
                oppList.add(new Opportunity(id = oppObj.Id,Pricing_Plans__c = mapAccIds.get(oppObj.AccountId)));
                
            }
            if (!oppList.isEmpty()) {
                update oppList;}
        }
        if (!accIds.isEmpty()) {
           System.enqueueJob(new RSI_VARSheetDetail(accIds));
        }
        
        if (!lstAccForABASync.isEmpty()) {
            update lstAccForABASync;
        }
        if (!lstAccIdsForFees.isEmpty()) {
            RSI_SetupEquipmentFees.setupEquipmentFees(lstAccIdsForFees);
        }
        //Added by ajay
        if(!listAccId.isEmpty())
            RSI_PPMerchent_ID.pulsepointmerchent(listAccId);
    }
}