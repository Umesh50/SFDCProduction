/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 01-28-2021
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-01-2021   Tanmay Jain   Initial Version
**/
public without sharing class RSI_AssetTriggerHandler {

    public static void onAfterInsert (List <Asset> triggerNew) {
        Set <Id> setOppIds = new Set <Id> ();
        for (Asset obj : triggerNew) {
            if (obj.Application__c != null) {
                setOppIds.add(obj.Application__c);
            }
        }
        if (!setOppIds.isEmpty()) {
            //Call the Opportunity Status Update Logic
            updateOpportunityStatus(setOppIds);
        }
        createCaseTickets(triggerNew);
    }

    public static void onAfterUpdate (List <Asset> triggerNew, Map <Id, Asset> oldMap) {
        Set <Id> setOppIds = new Set <Id> ();
        for (Asset obj : triggerNew) {
            if (obj.Application__c != null && obj.Status != oldMap.get(obj.Id).Status) {
                setOppIds.add(obj.Application__c);
            }
        }
        if (!setOppIds.isEmpty()) {
            //Call the Opportunity Status Update Logic
            updateOpportunityStatus(setOppIds);
        }
    }
    @future
    private static void updateOpportunityStatus (Set <Id> setOppIds) {
        /*
        The transitions will be in below sequence:
        - Ready for Download
        - Ready for Install
        - Shipped
        - Delivered
        */
        Map <Id, Opportunity> mapOpptyToUpd = new Map <Id, Opportunity> ();
        for (AggregateResult aggr : [SELECT Application__c, Status, COUNT(Id) FROM Asset WHERE Application__c IN :setOppIds GROUP BY Application__c, Status]) {
            if (!mapOpptyToUpd.containsKey((Id)aggr.get('Application__c'))) {
                mapOpptyToUpd.put((Id)aggr.get('Application__c'), new Opportunity (Id = (Id)aggr.get('Application__c'), StageName = (String)aggr.get('Status')));
            }
        }
        if (!mapOpptyToUpd.isEmpty()) {
            update mapOpptyToUpd.values();
        }
    }

    /**
    * @description Create Service Tickets for the Newly Created Assets
    * @author Tanmay Jain | 01-03-2021
    * @param List<Asset> triggerNew
    **/
    private static void createCaseTickets (List <Asset> triggerNew) {
        List <Case> lstCases = new List <Case> ();
        Map<Id,Asset> mapAsset = new Map<Id,Asset>();
        Map <Id, Integer> mapProdQty = new Map <Id, Integer> ();
        Set <Id> setAccIds = new Set <Id> ();
        Map <Id, String> mapAccIdToShip = new Map <Id, String> ();
        for(Asset obj : [SELECT Id,AccountId,Product2.Family, Product2Id, Application__r.Shipping_Method__c FROM Asset WHERE Product2Id != null AND Id IN : triggerNew]){
            mapAsset.put(obj.Id,obj);
            setAccIds.add(obj.AccountId);
            mapAccIdToShip.put(obj.AccountId, obj.Application__r.Shipping_Method__c);
            if (obj.Product2.Family != 'VAR Service Provider') {
                if (!mapProdQty.containsKey(obj.Product2Id)) {
                    mapProdQty.put(obj.Product2Id, 0);
                }
                mapProdQty.put(obj.Product2Id, (mapProdQty.get(obj.Product2Id) + 1));
            }
        }
        id pid;
        Map <Id, Id> mapAccIdTopCaseId = new Map <Id, Id> ();
        List <Case> lstPCase = new List <Case> ();
        List <Account> lstAccs = new List <Account> ();
        for (Id accId : setAccIds) {
            Case pCase = new Case();
            pCase.Subject = 'New Account Download';
            pCase.OwnerId = System.Label.DeploymentQueueId;
            pCase.AccountId = accId;
            pCase.Shipping_Method__c = mapAccIdToShip.get(accId);
            lstPCase.add(pCase);
            lstAccs.add (new Account(id = accId, Status__c ='Deployment'));
        }
        insert lstPCase;
        update lstAccs;
        Integer count = 0;
        for (Id accId : setAccIds) {
            mapAccIdTopCaseId.put(accId, lstPCase[count].Id);
            count++;
        }

        List <Service_Ticket_Line__c> lstCaseLines = new List <Service_Ticket_Line__c> ();
        for (Case obj : lstPCase) {
            for (Id prodId : mapProdQty.keySet()) {
                lstCaseLines.add (new Service_Ticket_Line__c (Service_Ticket__c = obj.Id, Product__c = prodId, Quantity__c = mapProdQty.get(prodId)));
            }
        }
        if (!lstCaseLines.isEmpty()) {
            insert lstCaseLines;
        }

        for (Asset obj : triggerNew) {
            Case cs = new Case();
            cs.Subject = 'New Account Download';
            cs.OwnerId = System.Label.DeploymentQueueId;
            cs.Equipment__c = obj.Id;
            cs.AccountId = obj.AccountId;
            cs.ParentId = mapAccIdTopCaseId.get(obj.AccountId);
            //Added by Ajay
                if(mapAsset.containsKey(obj.Id)){
                    if(mapAsset.get(obj.Id).Product2.Family == 'Equipment' || mapAsset.get(obj.Id).Product2.Family == 'VAR Vendor Distributed' || mapAsset.get(obj.Id).Product2.Family == 'PINPAD')
                        cs.Type = 'Terminal/Pinpad';
                    else if(mapAsset.get(obj.Id).Product2.Family == 'VAR Service Provider')
                        cs.Type = 'API/Gateway';
                    else
                        cs.Type = 'Other';
                }
            lstCases.add(cs);
        }
        if(!lstCases.isEmpty()){
            if (!Test.isRunningTest()) {
                Insert lstCases;
            }
        }
    }
}