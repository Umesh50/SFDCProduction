/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-21-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-21-2021   Umesh Kumar   Initial Version
**/

trigger RSI_CaseTrigger on Case (after insert) {
    
    Boolean triggerActive = (Boolean)[SELECT Active__c FROM Trigger_Setting__mdt WHERE DeveloperName = 'RSI_CaseTrigger' LIMIT 1].Active__c;
    if (triggerActive) {
        if(Trigger.isAfter && Trigger.isInsert) {
            //get custom addressid from custom meta data.............
            String customAddId = [SELECT CustomAddressId__c FROM RSI_Shipment__mdt WHERE DeveloperName = 'CustomAddressId' LIMIT 1].CustomAddressId__c;
            //Class for After Insert
            for(Case caseObj :trigger.new){
                //call shipment call for every case..........
                List<zkmulti.InvocableShipmentCreate.CreateShipmentParameter> objList =new List<zkmulti.InvocableShipmentCreate.CreateShipmentParameter>();
                zkmulti.InvocableShipmentCreate.CreateShipmentParameter zkObj =new zkmulti.InvocableShipmentCreate.CreateShipmentParameter();
                zkObj.customAddressId = customAddId;
                zkObj.recordId = caseObj.Id;
                objList.add(zkObj);
                zkmulti.InvocableShipmentCreate.createShipment(objList);   
            }   
        }
    }

}