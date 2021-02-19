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
public without sharing class RSI_SetupEquipmentFees {

      public static List <RSI_EquipmentFeeSetup__mdt> lstSetup = new List <RSI_EquipmentFeeSetup__mdt>();
      public static void setupEquipmentFees (List <String> inpIds) {
        //Get the setup
        lstSetup = [SELECT Id, Annual_Revenue__c, Equipment__c, Fee_Amount__c, Frequency__c, Misc_Equipment_Fee__c, Ownership_Type__c, Security_Program__c, Revenue_Comparison__c FROM RSI_EquipmentFeeSetup__mdt];
        //Setup a query for fetching the Opportunity Data
        String query = 'SELECT Id, AccountId, Account.Annual_Revenue__c, (SELECT Id, Product2.Name, Ownership_Type__c, Quantity FROM OpportunityLineItems) FROM Opportunity WHERE ';
        if (inpIds[0].left(3) == '001') {
            //This signifies that the operation has been initiated from the Account Object
            //Fetch all the Opportunities under the Account in this scenario
            query += 'AccountId IN: inpIds';
        } else {
            //This is the Opportunity Id scenario
            query += 'Id IN: inpIds';
        }
        query += ' AND StageName NOT IN (\'Approved\', \'Denied\')';

        List <Opportunity> lstOpptyToUpd = new List <Opportunity> ();
        //This Set ensures that the same opportunity is not updated twice even if there are multiple qualifying products underneath it
        Set <Id> setOppIdsToUpd = new Set <Id> ();
        List <Fee__c> lstOpptyFee = new List <Fee__c> ();
        for (Opportunity opp : Database.query(query)) {
            Double accRev = opp.Account.Annual_Revenue__c;
            System.debug('Account Revenue: ' + accRev);
            for (OpportunityLineItem oli : opp.OpportunityLineItems) {
                String prodName = oli.Product2.Name;
                String ownType = oli.Ownership_Type__c == null ? '0' : oli.Ownership_Type__c;
                System.debug('Product Name: ' + prodName);
                System.debug('Ownership Type: ' + ownType);
                //Loop through the Metadata
                for (RSI_EquipmentFeeSetup__mdt setup : lstSetup) {
                    if (setup.Equipment__c == prodName && setup.Ownership_Type__c == ownType) {
                        System.debug('Metadata Record Id: ' + setup.Id);
                        //Setup the Security Program on the Opportunity
                       //This code added by UK........... on 04/02/2021........
                        if((accRev <= setup.Annual_Revenue__c && setup.Revenue_Comparison__c == '<=') || (accRev > setup.Annual_Revenue__c && setup.Revenue_Comparison__c == '>')) { 
                                System.debug('Metadata Equipment Fees: ' + setup.Misc_Equipment_Fee__c);
                              
                       //if (!setOppIdsToUpd.contains(opp.Id) && (setup.Annual_Revenue__c == 0 || (accRev <= setup.Annual_Revenue__c && setup.Revenue_Comparison__c == '<=') || (accRev > setup.Annual_Revenue__c && setup.Revenue_Comparison__c == '>'))) {
                            System.debug('Metadata Annual Revenue: ' + setup.Annual_Revenue__c);
                            if (!setOppIdsToUpd.contains(opp.Id)){
                            lstOpptyToUpd.add(new Opportunity (Id = opp.Id, Security_Program__c = setup.Security_Program__c));
                            setOppIdsToUpd.add(opp.Id);
                            }
                            if (setup.Misc_Equipment_Fee__c != null) {
                                System.debug('Metadata Equipment Fees: ' + setup.Misc_Equipment_Fee__c);
                                //This is the scenario where we will create the Fee Records
                                lstOpptyFee.add(new Fee__c (Application__c = opp.Id,
                                                            MiscEquipment_Fees__c = String.valueOf(setup.Misc_Equipment_Fee__c),
                                                            Frequency__c = setup.Frequency__c,
                                                            Fee_Amount__c = String.valueOf(setup.Fee_Amount__c),
                                                            Quantity__c = oli.Quantity));
                            }
                        }
                    }
                }// end of for (RSI_EquipmentFeeSetup__mdt setup : lstSetup)
            }
        }// end of for (Opportunity opp : Database.query(query))
        //Update the Opportunity Record, then delete the existing Fee records followed by Inserting the new ones
        if (!lstOpptyToUpd.isEmpty()) {
            update lstOpptyToUpd;
        }
        if (!lstOpptyFee.isEmpty()) {
           delete [SELECT Id FROM Fee__c WHERE Application__c IN : setOppIdsToUpd];
            insert lstOpptyFee;
        }
    }
}