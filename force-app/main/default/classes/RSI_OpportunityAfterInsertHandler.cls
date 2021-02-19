/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 01-01-2021
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   10-20-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_OpportunityAfterInsertHandler {


    public static void OnBeforeInsert(List<Opportunity> beforeOppList){
        for (Opportunity opp : beforeOppList) {
            opp.CloseDate = System.today().addDays(30);
            if (opp.AccountId == null) {
                opp.Type = 'New Business';
            } else {
                opp.Type = 'Existing Business';
            }
        }
        if(!Test.isRunningTest()){
            List<Pricebook2> stdPBL =  [select id from Pricebook2 where IsStandard = TRUE limit 1];
            for( opportunity opp : beforeOppList ) {
                opp.Pricebook2Id =   stdPBL[0].id;
            }
        }
    }

    public static void onBeforeUpdate (List <Opportunity> triggerNew, Map <Id, Opportunity> oldMap) {
        for (Opportunity opp : triggerNew) {
            if (opp.StageName == 'New') {
                opp.StageName = 'Incomplete';
            }
        }
    }

    private static void createAccsForOppty (List <Opportunity> lstOppty) {
        List <Opportunity> lstOpptyToUpd = new List <Opportunity> ();
        Map <String, Id> mapOpNameToId = new Map <String, Id> ();
        for (Opportunity opp : lstOppty) {
            mapOpNameToId.put(opp.Name, opp.Id);
        }
        //If we already have an account with the same name then associate that
        for (Account accInDB : [SELECT Id, Name FROM Account WHERE Name IN :mapOpNameToId.keySet()]){
            if (mapOpNameToId.containsKey(accInDB.Name)) {
                lstOpptyToUpd.add(new Opportunity (Id = mapOpNameToId.get(accInDB.Name), AccountId = accInDB.Id));
                mapOpNameToId.remove(accInDB.Name);
            }
        }
        //If we do not have an account then create new
        List <Account> lstAccs = new List <Account> ();
        for (String opName : mapOpNameToId.keySet()) {
            lstAccs.add(new Account (Name = opName));
        }
        insert lstAccs;
        for (Account acc :  lstAccs) {
            lstOpptyToUpd.add(new Opportunity (Id = mapOpNameToId.get(acc.Name), AccountId = acc.Id));
        }
        update lstOpptyToUpd;
    }


    public static void afterInsertHandler (List <Opportunity> triggerNew) {
        List <Opportunity> oppsForNewAccounts = new List <Opportunity> ();
        //Below Opportunity Ids will need Applications created in Pulse Point
        Set<Id> opptyIdsForPulsePoint = new Set<Id>();
        List <Opportunity> lstPlanChanged = new List <Opportunity> ();
        for (Opportunity opp : triggerNew) {
            if (!RSI_StopRecursion.setExecutedIds.contains(opp.Id)) {
                //Recursion checks and addition of the opportunity id to the recursion handler
                RSI_StopRecursion.setExecutedIds.add(opp.Id);
                //Condition to check for PulsePoint Integration
                if (opp.Merchant_Application_No__c == null) {
                    opptyIdsForPulsePoint.add(opp.Id);
                }
                //Below condition is to capture changes to the Pricing Plan Field on the Opportunity. It is used for the Pricing Automations
                if (opp.Pricing_Plans__c != null) {
                    lstPlanChanged.add(opp);
                }
                if (opp.AccountId == null) {
                    oppsForNewAccounts.add(opp);
                }
            }
        }//end of for (Opportunity opp : triggerNew)
        if (!lstPlanChanged.isEmpty()) {
            //Call the apex class for the automation only in case the conditions are met.
            RSI_ApplicationPricingAutomation.updatePricingOnApplication(lstPlanChanged);
        }
        if (!oppsForNewAccounts.isEmpty()) {
            createAccsForOppty (oppsForNewAccounts);
        }
    }

    public static void afterUpdateHandler (List <Opportunity> triggerNew, Map <Id, Opportunity> triggerOldMap) {
        List <Opportunity> lstPlanChanged = new List <Opportunity> ();
        List <Account> lstAccNameToSync = new List <Account> ();
        for (Opportunity oppty : triggerNew) {
            //Below condition is to capture changes to the Pricing Plan Field on the Opportunity. It is used for the Pricing Automations
            if (oppty.Pricing_Plans__c != null && oppty.Pricing_Plans__c != triggerOldMap.get(oppty.Id).Pricing_Plans__c) {
                lstPlanChanged.add(oppty);
            }
            //Below syncs the Account name with the Opportunity Name if the Stage is not Approved
            if (oppty.StageName != 'Approved' && triggerOldMap.get(oppty.Id).Name != oppty.Name) {
                lstAccNameToSync.add(new Account (Name = oppty.Name, Id = oppty.AccountId));
            }
        }
        if (!lstPlanChanged.isEmpty()) {
            //Call the apex class for the automation only in case the conditions are met.
            RSI_ApplicationPricingAutomation.updatePricingOnApplication(lstPlanChanged);
        }
        if (!lstAccNameToSync.isEmpty()) {
            update lstAccNameToSync;
        }
    }

     //it is use to handle the status of application
    public static void oppStageHandler(List <Opportunity> triggerNew,Map<Id,Opportunity> oldMap){
        for(Opportunity oppObj : triggerNew) {
            //update the latest status update date
            if(oldMap.get(oppObj.id).StageName != oppObj.StageName) {
                oppObj.Last_Status_Update__c= Date.today();
            }
            //update the signature status date
            if(oldMap.get(oppObj.id).StageName == 'Sent for Signature' && oppObj.StageName == 'Signed' ) {
                oppObj.Signed_Date__c= Date.today();
            }
            //update the approved status date
            if(oldMap.get(oppObj.id).StageName == 'Under Review' && oppObj.StageName == 'Approved' ) {
                oppObj.Approval_Date__c= Date.today();
            }
      }
    }

    /**
    * @description
    * @author Tanmay Jain | 12-30-2020
    * @param List<Opportunity> triggerNew
    * @param Map<Id Opportunity> oldMap
    * Below code is to create Asset (Equipment) records for each individual Product Line under the Application when setting it to Approved Stage
    **/
    public static void createEquipmentRecords (List <Opportunity> triggerNew, Map <Id, Opportunity> oldMap) {
        List <Id> lstApprovedOpptys = new List <Id>();
        //Fetch the Opportunity Ids which have been marked as Approved
        for (Opportunity obj : triggerNew) {
            if (obj.StageName == 'Approved' && obj.StageName != oldMap.get(obj.Id).StageName) {
                lstApprovedOpptys.add(obj.Id);
            }
        }
        if (!lstApprovedOpptys.isEmpty()) {
            List <Asset> lstAssetToCreate = new List <Asset> ();
            //Query the Opportunity Line Items and create appropriate quantity of Asset Records
            for (OpportunityLineItem oli : [SELECT Id, Product2Id, Product2.Name, Quantity, Opportunity.AccountId, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN : lstApprovedOpptys]) {
                for (Integer i = 0; i < oli.Quantity; i++) {
                    Integer prodNum = i + 1;
                    lstAssetToCreate.add(new Asset (Product2Id = oli.Product2Id, Quantity = 1, AccountId = oli.Opportunity.AccountId, Name = oli.Product2.Name + ' # ' + prodNum, Status = 'Ready for Download', Application__c = oli.OpportunityId));
                }
            }
            if (!lstAssetToCreate.isEmpty()) {
                if(!Test.isRunningTest()){
                    insert lstAssetToCreate;}
            }
        }
    }
    public static void updateAccountAddress (List <Opportunity> triggerNew, Map <Id, Opportunity> oldMap) {
        List <Account> lstupdatedAccount = new List <Account> ();
       for (Opportunity obj : triggerNew) {
           //update account status to submitted when application status is Under Review.....
           if(obj.StageName == 'Under Review' && obj.StageName != oldMap.get(obj.Id).StageName){
               lstupdatedAccount.add(new Account(id = obj.AccountId,Status__c = 'Submitted'));
           }
           //update account status to Declined when application status is Denied.....
           if(obj.StageName == 'Denied' && obj.StageName != oldMap.get(obj.Id).StageName){
               lstupdatedAccount.add(new Account(id = obj.AccountId,Status__c = 'Declined'));
           }
           //update account status to Approved when application status is Approved.....
           //if(obj.StageName == 'Approved' && obj.StageName != oldMap.get(obj.Id).StageName){
             //  lstupdatedAccount.add(new Account(id = obj.AccountId,Status__c = 'Approved'));
           //}
           //update account business location address.....
           if (obj.DBA_Address_1__c != oldMap.get(obj.Id).DBA_Address_1__c || obj.State__c !=oldMap.get(obj.Id).State__c
               || obj.State__c != oldMap.get(obj.Id).State__c || obj.City__c != oldMap.get(obj.Id).City__c || obj.Zip_Code__c != oldMap.get(obj.Id).Zip_Code__c) {
               lstupdatedAccount.add(new Account(id =obj.AccountId,Address__c = obj.DBA_Address_1__c,Country__c =obj.Country__c,
                                                 StateText__c =obj.State__c,City__c=obj.City__c,ZIP__c =obj.Zip_Code__c  ));
           }
       }
       if(!lstupdatedAccount.isEmpty()){
           update lstupdatedAccount;
       }
   }
}