/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-28-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-28-2021   Umesh Kumar   Initial Version
**/

@isTest
public class RSI_OpportunityLineItemTest {
    
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
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity obj=new Opportunity();
        obj.CloseDate=varDate;
        obj.StageName ='New';
        obj.Name='TestAPP';
        obj.DBA_Address_1__c ='XYZ';
        obj.City__c ='ABC';
        obj.State__c ='AL';
        obj.Zip_Code__c ='20320';
        insert obj;
        
        Equipment_Programming__c eqObj =new Equipment_Programming__c();
        eqObj.Application__c =obj.id;
        insert eqObj; 
        
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
        itm.Quantity=1;
        itm.TotalPrice=100;
        itm.Product2Id=p.Id;
        itm.SIM_Card__c = false;
        itm.PricebookEntryId=pbe.Id;
        insert itm;
    }
    
    @isTest
    private static void testOppLineTrigg() {
        Opportunity oppObj = [Select Id,Name From Opportunity where Name ='TestAPP' limit 1];
        OpportunityLineItem oppLineObj = [Select Id,Quantity,SIM_Card__c From OpportunityLineItem where OpportunityId =:oppObj.Id limit 1];
        Test.startTest();
        oppLineObj.Quantity = 2;
        oppLineObj.SIM_Card__c =true;
        oppLineObj.Ownership_Type__c ='Purchase';
        oppLineObj.UnitPrice =100;
        oppLineObj.Shipping_Method__c ='Ground';
        update oppLineObj;
        Test.stopTest();
    }  

}