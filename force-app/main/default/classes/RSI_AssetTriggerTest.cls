/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-04-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-04-2021   Umesh Kumar   Initial Version
**/

@isTest
public class RSI_AssetTriggerTest {
    
     @testsetup private static void setup(){
        Account acc = new Account();
        acc.Name='Test';
        acc.Monthly_Fee__c=123;
        acc.Business_Number__c ='612-304-6073';
        acc.Phone='612-304-6073';
        acc.Partner_Code__c ='R-01';
        acc.Address__c ='5500 W Sunset Blvd';
        acc.Street__c ='5500 W Sunset Blvd';
        acc.City__c ='Los Angeles';
        acc.Country__c ='USA';
        acc.StateText__c = 'California';
        acc.ZIP__c = '90028' ;       
        insert acc; 
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='new';
        newObj.Name='TestExp';
        newObj.Business_Type__c='1';
        newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
        newObj.ForecastCategoryName='Pipeline';
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        insert newObj;
         
        Pricebook2 standardPricebook = new Pricebook2(); 
        standardPricebook.Id = Test.getStandardPricebookId();
        standardPricebook.IsActive = true;
        Update standardPricebook;
         
        Product2 p = new Product2();
        p.Name = 'Pax A80';
        p.Description = 'This is the Product description.';
        p.ProductCode = 'PA80';
        p.StockKeepingUnit = 'EX5678';
        p.Family = 'Equipment';
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
        itm.OpportunityId=newObj.Id;
        itm.Quantity =1;
        itm.TotalPrice=100;
        itm.Product2Id=p.Id;
        itm.PricebookEntryId=pbe.Id;
        insert itm; 
         
         Asset a=new Asset();
         a.Name ='Pax A80 # 3';
         a.AccountId=acc.id;
         a.Status ='Ready for Download';
         a.Product2Id =p.id;
         a.Application__c = newObj.Id;
         insert a;
        
             
     }
    
     @isTest
    private static void testAssetTrigg() {
        Test.startTest();
        Asset oppObj = [Select Id,Name,Status From Asset where Name = 'Pax A80 # 3' Limit 1];
        oppObj.Status ='Shipped';
        update oppObj;
        Test.stopTest();
        Asset oppObj1 = [Select Id,Name,Status From Asset where Name = 'Pax A80 # 3' Limit 1];
       system.assertEquals('Shipped', oppObj1.Status);
        
    }

}