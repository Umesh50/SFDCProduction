/**
 * @description       : This Class helps with the Automation of the Pricing, Fees, Authorization Fees and Debit Network section of Pulse Point
 * @author            : Tanmay Jain
 * @group             : R Systems
 * @last modified on  : 10-23-2020
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   10-19-2020   Tanmay Jain                          Initial Version
**/

public without sharing class RSI_ApplicationPricingAutomation {

    private static Map <String, RSI_PricingStructure__mdt> pricingMap = new Map <String, RSI_PricingStructure__mdt> ();
    private static Id currOpptyId;
    public static void updatePricingOnApplication (List <Opportunity> lstOppty) {
        initPricingMetadata();
        //The logic will be executed in the After Update / Insert trigger condition
        //Build a set of Opportunity Ids. We have to query the Child objects of Authorizations, Debit Network and Pricing Information
        Set <Id> opptyIDs = new Set <Id> ();
        for (Opportunity oppty : lstOppty) {
            if (pricingMap.containsKey(oppty.Pricing_Plans__c)) {
                opptyIDs.add(oppty.Id);
            }
        }
        List <Opportunity> lstOpptyToUpd            = new List <Opportunity> ();
        List <Authorization__c> lstAuthToUps        = new List <Authorization__c> ();
        List <Debit_Network__c> lstDebitToUps       = new List <Debit_Network__c> ();
        List <Pricing_Information__c> lstPIToUps    = new List <Pricing_Information__c> ();
        //Fetching the Field Sets for the Pricing Information and the Debit Network objects.
        Map <String, Schema.FieldSet> prcInfoFSets  = RSI_UtilityClass.getFieldSets('Pricing_Information__c');
        Map <String, Schema.FieldSet> dbtNetsFSets  = RSI_UtilityClass.getFieldSets('Debit_Network__c');
        for (Opportunity oppty : [SELECT Id, Pricing_Plans__c, (SELECT Id FROM Authorization__r), (SELECT Id FROM Debit_Networks__r), (SELECT Id FROM Pricing_Information__r) FROM Opportunity WHERE Id IN : opptyIDs]) {
            currOpptyId = oppty.Id;
            //Set the Opportunity Pricing Fields
            lstOpptyToUpd.add(setOpptyPricingFields(oppty, pricingMap.get(oppty.Pricing_Plans__c)));
            //Set the Authorizations
            if (oppty.Authorization__r.size() > 0) {lstAuthToUps.add(setAuthorization (new Authorization__c (Id = oppty.Authorization__r[0].Id), pricingMap.get(oppty.Pricing_Plans__c)));} else {lstAuthToUps.add(setAuthorization (new Authorization__c (), pricingMap.get(oppty.Pricing_Plans__c)));}
            //Set the Debit Network
            if (oppty.Debit_Networks__r.size() > 0) {lstDebitToUps.add(setDebitNetwork (new Debit_Network__c (Id = oppty.Debit_Networks__r[0].Id), pricingMap.get(oppty.Pricing_Plans__c), dbtNetsFSets));} else {lstDebitToUps.add(setDebitNetwork (new Debit_Network__c (), pricingMap.get(oppty.Pricing_Plans__c), dbtNetsFSets));}
            //Set the Pricing Information
            List <Schema.FieldSetMember> lstPIFields = getPricingFieldSetName(oppty.Pricing_Plans__c, prcInfoFSets);
            switch on pricingMap.get(oppty.Pricing_Plans__c).Pricing_Program__c {
                when 'Pass-Thru IC Plus' {
                    Pricing_Information__c piRec = oppty.Pricing_Information__r.size() > 0 ? new Pricing_Information__c (Id = oppty.Pricing_Information__r[0].Id) : new Pricing_Information__c ();
                    lstPIToUps.add (setPassThroughPricingInfo(piRec, pricingMap.get(oppty.Pricing_Plans__c), lstPIFields));
                }
                when 'Fixed' {
                    Pricing_Information__c piRec = oppty.Pricing_Information__r.size() > 0 ? new Pricing_Information__c (Id = oppty.Pricing_Information__r[0].Id) : new Pricing_Information__c ();
                    lstPIToUps.add (setFixedPricingInfo(piRec, pricingMap.get(oppty.Pricing_Plans__c), lstPIFields));
                }
            }
        }
        //Now we will upsert the Pricing Information, Debit Networks, Authorizations and Opportunity Records
        if (!lstPIToUps.isEmpty()) {
            upsert lstPIToUps;
        }
        if (!lstDebitToUps.isEmpty()) {
            upsert lstDebitToUps;
        }
        if (!lstAuthToUps.isEmpty()) {
            upsert lstAuthToUps;
        }
        if (!lstOpptyToUpd.isEmpty()) {
            update lstOpptyToUpd;
        }
    }

    /**
    * @description This method initializes the Pricing Structure data from the RSI_PricingStructure__mdt object
    * @author Tanmay Jain | 10-19-2020
    **/
    private static void initPricingMetadata () {
        for (RSI_PricingStructure__mdt obj : [SELECT ACCT_MAINT_FEE__c, AMEX__c, Annual_Fee__c, APPLICATION_FEE__c, Authorization__c, Chargeback_Fee_Per_Occurrence__c,Debit_Auth_Processing__c, Debit_Network__c,
                                              Debit_Network_Debit_Pricing__c, Dial_Communication__c, Discover__c, Installation_Fee__c, International_Card_Holding__c, Master_Card__c, Monthly_Compliance_Association_Fee__c,
                                              Monthly_Minimum_Fee__c, Monthly_Service_Fee__c, Pass_Thru_Discount__c, Pass_Thru_Per_Item__c, Per_Item__c, Plan_Name__c, Pricing_Program__c, Rate__c, Return_Item_Fee__c,
                                              UNIONPay__c, VISA__c, Voice_Auth_Touch_Tone__c, Voice_Bank_Referral__c, Voice_Operator_Assister__c, Voice_with_AVS__c, WEX__c, Id FROM RSI_PricingStructure__mdt]) {
            pricingMap.put (obj.Plan_Name__c, obj);
        }
    }

    /**
    * @description This method takes an input of Opportunity Record along with the Metadata Setup and returns the final Opportunity to update
    * @author Tanmay Jain | 10-19-2020
    * @param opptyRecord
    * @param setup
    * @return Opportunity
    **/
    private static Opportunity setOpptyPricingFields (Opportunity opptyRecord, RSI_PricingStructure__mdt setup) {
        Opportunity obj = new Opportunity (Id = opptyRecord.Id);
        obj.Application_Fee__c                      = setup.APPLICATION_FEE__c;
        obj.Account_Maintenance_Fee__c              = setup.ACCT_MAINT_FEE__c;
        obj.Chargeback_Fee__c                       = setup.Chargeback_Fee_Per_Occurrence__c;
        obj.Annual_Fee__c                           = setup.Annual_Fee__c;
        obj.Monthly_Service_Fee__c                  = setup.Monthly_Service_Fee__c;
        obj.Installation_Fee__c                     = setup.Installation_Fee__c;
        obj.Return_Item_Fee__c                      = setup.Return_Item_Fee__c;
        obj.Monthly_Minimum_Fee__c                  = setup.Monthly_Minimum_Fee__c;
        obj.Monthly_Association_Compliance_Fee__c   = setup.Monthly_Compliance_Association_Fee__c;
        return obj;
    }

    /**
    * @description This method takes an input of Authorization__c Record along with the Metadata Setup and returns the final Authorization__c to update
    * @author Tanmay Jain | 10-19-2020
    * @param authRec
    * @param setup
    * @return Authorization__c
    **/
    private static Authorization__c setAuthorization (Authorization__c authRec, RSI_PricingStructure__mdt setup) {
        authRec.VISA__c                     = setup.VISA__c;
        authRec.American_Express__c         = setup.AMEX__c;
        authRec.Union_Pay__c                = setup.UNIONPay__c;
        authRec.Voice_Auth_Touch_Tone__c    = setup.Voice_Auth_Touch_Tone__c;
        authRec.Voice_With_AVS__c           = setup.Voice_with_AVS__c;
        authRec.Dial_Communication__c       = setup.Dial_Communication__c;
        authRec.Mastercard__c               = setup.Master_Card__c;
        authRec.Discover__c                 = setup.Discover__c;
        authRec.WEX__c                      = setup.WEX__c;
        authRec.Voice_Operator_Assisted__c  = setup.Voice_Operator_Assister__c;
        authRec.Voice_Bank_Referral__c      = setup.Voice_Bank_Referral__c;
        authRec.Application__c              = currOpptyId;
        return authRec;
    }

    /**
    * @description Setup the Debit Network object record
    * @author Tanmay Jain | 10-20-2020
    * @param dbtRec
    * @param setup
    * @param dbtNetsFSets
    * @return Debit_Network__c
    **/
    private static Debit_Network__c setDebitNetwork (Debit_Network__c dbtRec, RSI_PricingStructure__mdt setup, Map <String, Schema.FieldSet> dbtNetsFSets) {
        for (String key : dbtNetsFSets.keySet()) {
            //Loop through the Debit Network Field Map and setup the fields
            //Below are the Setup fields to be referred to in case of specific Field Sets
            String setupFName = key == 'AmountFields' ? 'Per_Item__c' : key == 'AuthAmtFields' ? 'Authorization__c' : key == 'RateFields' ? 'Rate__c' : 'NA';
            if (key != 'NA') {
                //This condition ensures that we do not do erroneous processing for unknown field sets
                //Get all the fields in the Field Set
                List<Schema.FieldSetMember> lstFields = dbtNetsFSets.get(key).getFields();
                //Loop through all the fields and set their respective values
                for (Schema.FieldSetMember fld : lstFields) {
                    Decimal fVal = setup.get(setupFName) == null ? 0 : (Decimal)setup.get(setupFName);
                    dbtRec.put(fld.getFieldPath(), fVal);
                }
            }//end of if (key != 'NA')
        }
        dbtRec.Use_Debit_Network__c             = setup.Debit_Network__c;
        dbtRec.Debit_Network_Debit_Pricing__c   = setup.Debit_Network_Debit_Pricing__c;
        dbtRec.Debit_Auth_Processing__c         = setup.Debit_Auth_Processing__c;
        dbtRec.Application__c                   = currOpptyId;
        return dbtRec;
    }

    /**
    * @description This method constructs the Pricing Information's Field Set Name and then returns it's fields
    * @author Tanmay Jain | 10-20-2020 
    * @param pricingPlan 
    * @param prcInfoFSets 
    * @return List <Schema.FieldSetMember> 
    **/
    private static List <Schema.FieldSetMember> getPricingFieldSetName (String pricingPlan, Map <String, Schema.FieldSet> prcInfoFSets) {
        RSI_PricingStructure__mdt setup = pricingMap.get(pricingPlan);
        String fsName = setup.Pricing_Program__c;
        fsName = fsName.replace('-', '_').replace(' ', '_').toLowerCase();
        List <Schema.FieldSetMember> lstFields = prcInfoFSets.get(fsName).getFields();
        return lstFields;
    }

    /**
    * @description Setup the fields for the Pass Through Pricing IC Plus Program
    * @author Tanmay Jain | 10-20-2020 
    * @param piRec 
    * @param setup 
    * @param lstFields 
    * @return Pricing_Information__c 
    **/
    private static Pricing_Information__c setPassThroughPricingInfo (Pricing_Information__c piRec, RSI_PricingStructure__mdt setup, List <Schema.FieldSetMember> lstFields) {
        piRec.Apply_Rate_to_All_Cards__c        = setup.Pricing_Program__c;
        piRec.International_Card_Handling__c    = setup.International_Card_Holding__c;
        piRec.Application__c                    = currOpptyId;
        for (Schema.FieldSetMember fld : lstFields) {
            if (fld.getType() == Schema.DisplayType.PERCENT) {
                piRec.put(fld.getFieldPath(), setup.Pass_Thru_Discount__c);
            }
            if (fld.getType() == Schema.DisplayType.CURRENCY) {
                piRec.put(fld.getFieldPath(), setup.Pass_Thru_Per_Item__c);
            }
        }
        return piRec;
    }

    /**
    * @description Setup the fields for the Fixed Program
    * @author Tanmay Jain | 10-20-2020 
    * @param piRec 
    * @param setup 
    * @param lstFields 
    * @return Pricing_Information__c 
    **/
    private static Pricing_Information__c setFixedPricingInfo (Pricing_Information__c piRec, RSI_PricingStructure__mdt setup, List <Schema.FieldSetMember> lstFields) {
        piRec.Apply_Rate_to_All_Cards__c        = setup.Pricing_Program__c;
        piRec.International_Card_Handling__c    = setup.International_Card_Holding__c;
        piRec.Application__c                    = currOpptyId;
        for (Schema.FieldSetMember fld : lstFields) {
            if (fld.getType() == Schema.DisplayType.PERCENT) {
                piRec.put(fld.getFieldPath(), setup.Pass_Thru_Discount__c);
            }
            if (fld.getType() == Schema.DisplayType.CURRENCY) {
                piRec.put(fld.getFieldPath(), setup.Pass_Thru_Per_Item__c);
            }
        }
        return piRec;
    }
}