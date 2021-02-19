/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 02-01-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   02-01-2021   Umesh Kumar   Initial Version
**/

public without sharing class RSI_ShipmentTriggerHandler {
    
    public static void onAfterInsert (List <zkmulti__MCShipment__c> triggerNew) {
        Map<Id,String> mapCaseIdWithTrkNumber = new Map<Id,String>();
        Map<Id,Id> mapOfAccIdandCaseId = new Map<Id,Id>();
        List<Account> updatedAccounts =new List<Account>();
        for(zkmulti__MCShipment__c zmcsObj : triggerNew){
            if(zmcsObj.Service_Ticket__c !=null){
                mapCaseIdWithTrkNumber.put(zmcsObj.Service_Ticket__c,zmcsObj.zkmulti__Tracking_Number__c);
            }   
        }
        if(!mapCaseIdWithTrkNumber.isEmpty()){ 
            for(Case  obj : [SELECT Id,AccountId FROM Case  WHERE Id IN : mapCaseIdWithTrkNumber.keySet()]){
                if(obj.AccountId != null){
                    mapOfAccIdandCaseId.put(obj.AccountId,obj.Id);
                }
            }
            if(!mapOfAccIdandCaseId.isEmpty()){
                for(Account objAcc : [SELECT Id,Tracking_Number__c FROM Account WHERE Id IN : mapOfAccIdandCaseId.keySet()]){
                    updatedAccounts.add(new Account(id = objAcc.id,Tracking_Number__c = mapCaseIdWithTrkNumber.get(mapOfAccIdandCaseId.get(objAcc.Id))));  
                }
                
            }
            if(!updatedAccounts.isEmpty()) {
                update updatedAccounts;
            }  
        }
        
    } 
}