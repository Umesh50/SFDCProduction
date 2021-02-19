/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-29-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-29-2021   Umesh Kumar   Initial Version
**/

@isTest
public class RSI_TestOpportunityTrigger {
    
     @testsetup private static void setup(){
        Account acc=new Account();
        acc.Name='TestAccount';
        acc.Business_Number__c ='612-304-6073';
        acc.Phone='612-304-6073';
        acc.Address__c ='5500 W Sunset Blvd';
        acc.Street__c ='5500 W Sunset Blvd';
        acc.City__c ='Los Angeles';
        acc.Country__c ='USA';
        acc.StateText__c = 'California';
        acc.ZIP__c = '90028' ;  
        insert acc;
         
        List<Opportunity> listOfOpp =new List<Opportunity>();
        Date varDate = Date.newInstance(2020,10,9);
         
        Opportunity obj1=new Opportunity();
        obj1.CloseDate=varDate;
        obj1.StageName ='New';
        obj1.Name='TestAccount1';
        //obj1.AccountId = acc.id;
        listOfOpp.add(obj1);
        Opportunity obj2=new Opportunity();
        obj2.CloseDate=varDate;
        obj2.StageName ='New';
        obj2.Name='TestAccount2';
        obj2.AccountId = acc.id;
        listOfOpp.add(obj2);
 
        Opportunity obj=new Opportunity();
        obj.CloseDate=varDate;
        obj.StageName ='New';
        obj.Name='TestAccount';
        obj.Pricing_Plans__c ='Volume =< $25K';
        listOfOpp.add(obj);
        insert listOfOpp;
         
        Pricebook2 standardPricebook = new Pricebook2(); 
        standardPricebook.Id = Test.getStandardPricebookId();
        standardPricebook.IsActive = true;
        Update standardPricebook;
        
        Product2 p = new Product2();
        p.Name = 'Example Product';
        p.Description = 'This is the Product description.';
        p.ProductCode = 'EX1234';
        p.StockKeepingUnit = 'EX5678';
        p.Family = 'Example Product Family';
        p.QuantityUnitOfMeasure = 'inches';
        p.DisplayUrl = 'https://www.example.com/';
        p.ExternalId = 'ID #1234';
        p.IsActive = true;
        insert p;
         
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = standardPricebook.Id;
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 1020;
        pbe.IsActive = true;
        Insert pbe;
        
        OpportunityLineItem itm=new OpportunityLineItem();
        itm.Access_Number__c=17;
        itm.Capture_Method__c='HOST';
        itm.Close_Method__c='AUTO';
        itm.Equipment_Type__c='0';
        itm.OpportunityId=obj.Id;
        itm.Quantity=4;
        itm.TotalPrice=100;
        itm.Product2Id=p.Id;
        itm.PricebookEntryId=pbe.Id;
        insert itm; 
      
        
    }
    @isTest
    private static void testOppTrigg() {
        Opportunity oppObj = [Select Id,Name From Opportunity where Name ='TestAccount' limit 1];
        oppObj.StageName = 'Approved';
        oppObj.Pricing_Plans__c = 'Volume up to $75,000';
        oppObj.DBA_Address_1__c ='XYZ';
        oppObj.City__c ='ABC';
        oppObj.State__c ='AL';
        oppObj.Zip_Code__c ='20320';
        
       // oppObj.StageName = 'Under Review'; 
        Test.startTest();
        update oppObj;
        Opportunity opp = [Select Id,Name,StageName From Opportunity where Name ='TestAccount' limit 1];
        system.assertEquals('Approved',opp.StageName);
        Test.stopTest();
    }  

}