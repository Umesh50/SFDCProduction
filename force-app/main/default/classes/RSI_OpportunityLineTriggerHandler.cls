/**
* @description       :
* @author            : Tanmay Jain
* @group             :
* @last modified on  : 01-28-2021
* @last modified by  : Tanmay Jain
* Modifications Log
* Ver   Date         Author        Modification
* 1.0   01-02-2021   Tanmay Jain   Initial Version
**/
public without sharing class RSI_OpportunityLineTriggerHandler {
    /**
    * @description This method encapsulates all the code to be executed in the After Insert Context
    * @author Tanmay Jain | 01-02-2021
    * @param List<OpportunityLineItem> triggerNew
    **/
    public static void afterInsertHandler(List <OpportunityLineItem> triggerNew) {
        Set <String> setOpptysForFeeSetup = new Set <String> ();
        for (OpportunityLineItem oli : triggerNew) {
            setOpptysForFeeSetup.add(oli.OpportunityId);
        }
        wirelesscheckbox (triggerNew);
        setupEquipmentFeesOnApplication(setOpptysForFeeSetup);
    }

    public static void beforeUpdateHandler (List <OpportunityLineItem> triggerNew, Map <Id, OpportunityLineItem> oldMap) {
        //No changes
    }

    /**
    * @description This method encapsulates all the code to be executed in the After Update Context
    * @author Tanmay Jain | 01-02-2021
    * @param List<OpportunityLineItem> triggerNew
    * @param Map<Id OpportunityLineItem> oldMap
    **/
    public static void afterUpdateHandler(List <OpportunityLineItem> triggerNew, Map <Id, OpportunityLineItem> oldMap) {
        List <OpportunityLineItem> lstWirelessUpd = new List <OpportunityLineItem> ();
        List <OpportunityLineItem> lstUnitPriceUpd = new List <OpportunityLineItem> ();
        Set <String> setOpptysForFeeSetup = new Set <String> ();
        Map <Id, String> opptyIdForShipMethod = new Map <Id, String> ();
        for (OpportunityLineItem oli : triggerNew) {
            if (oli.SIM_Card__c != oldMap.get(oli.Id).SIM_Card__c) {
                lstWirelessUpd.add(oli);
            }
            if (oli.Ownership_Type__c != oldMap.get(oli.Id).Ownership_Type__c || oli.Quantity != oldMap.get(oli.Id).Quantity) {
                setOpptysForFeeSetup.add(oli.OpportunityId);
            }
            if ((oli.UnitPrice != oldMap.get(oli.Id).UnitPrice || oli.Quantity != oldMap.get(oli.Id).Quantity) && oldMap.get(oli.Id).UnitPrice != 0 && oli.UnitPrice != 0) {
                lstUnitPriceUpd.add(oli);
            }
            if (oli.Shipping_Method__c != oldMap.get(oli.Id).Shipping_Method__c) {
                opptyIdForShipMethod.put(oli.OpportunityId, oli.Shipping_Method__c);
            }
        }

        if (!lstWirelessUpd.isEmpty()) {
            wirelesscheckbox (lstWirelessUpd);
        }
        if (!setOpptysForFeeSetup.isEmpty()) {
            setupEquipmentFeesOnApplication (setOpptysForFeeSetup);
        }
        if (!lstUnitPriceUpd.isEmpty()) {
           updateOLIUnitPrice(lstUnitPriceUpd);
        }
        if (!opptyIdForShipMethod.isEmpty()) {
            List <Opportunity> lstOppty = new List <Opportunity> ();
            for (Id opptyId : opptyIdForShipMethod.keySet()) {
                lstOppty.add(new Opportunity (Id = opptyId, Shipping_Method__c = opptyIdForShipMethod.get (opptyId)));
            }
            update lstOppty;
        }
    }

    /**
    * @description This method Checks / Unchecks the Wireless check box on the Equipment Programming records
    * @author Tanmay Jain | 01-02-2021
    * @param List<OpportunityLineItem> listObj
    **/
    private static void wirelesscheckbox(List<OpportunityLineItem > listObj){
        Map <Id, Boolean> mapOppToSIM = new Map <Id, Boolean> ();
        for(OpportunityLineItem obj : listObj){
            mapOppToSIM.put(obj.OpportunityId, false);
        }
        if (!mapOppToSIM.isEmpty()) {
            for (OpportunityLineItem oli : [SELECT Id, OpportunityId, SIM_Card__c FROM OpportunityLineItem WHERE OpportunityId IN: mapOppToSIM.keySet()]) {
                if (mapOppToSIM.get(oli.OpportunityId) == false && oli.SIM_Card__c == true) {
                    mapOppToSIM.put(oli.OpportunityId, true);
                }
            }
            List <Equipment_Programming__c> lstToUpd = new List <Equipment_Programming__c> ();
            for (Equipment_Programming__c obj : [SELECT Id, Application__c FROM Equipment_Programming__c WHERE Application__c IN : mapOppToSIM.keySet()]) {
                obj.WIRELESS__c = mapOppToSIM.get(obj.Application__c);
                lstToUpd.add(obj);
            }
            if(!lstToUpd.isEmpty()){
                update lstToUpd;
            }
        }
    }

    private static void updateOLIUnitPrice (List <OpportunityLineItem> lstUnitPriceUpd) {
        List <OpportunityLineItem> lstOLI = new List <OpportunityLineItem> ();
        for (OpportunityLineItem oli : lstUnitPriceUpd) {
            if (!RSI_StopRecursion.setExecutedIds.contains(oli.Id)) {
                lstOLI.add(new OpportunityLineItem (Id = oli.Id, UnitPrice = oli.ListPrice));
                RSI_StopRecursion.setExecutedIds.add(oli.Id);
            }
        }
        if (!lstOLI.isEmpty()) {
            update lstOLI;
        }
    }

    @future
    public static void setupEquipmentFeesOnApplication (Set <String> setOpptysForFeeSetup) {
        List <String> inpIds = new List <String> (setOpptysForFeeSetup);
        RSI_SetupEquipmentFees.setupEquipmentFees(inpIds);
    }
}