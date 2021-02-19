/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 02-02-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   02-02-2021   Umesh Kumar   Initial Version
**/

@isTest
public class RSI_SetupEquipmentFeesTest {
    
     @testSetup static void setup(){
       ABA_Routing__c abaobj1=new ABA_Routing__c();
       abaobj1.Name='00001';
       insert abaobj1;
       
       ABA_Routing__c abaobj2=new ABA_Routing__c();
       abaobj2.Name='00002';
       insert abaobj2;
       
        Account acc=new Account();
        acc.Name='TestAccount';
        acc.Annual_Revenue__c = 200;
        acc.ABA_Routing2__c = abaobj1.Id;
        insert acc;
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='Qualification';
        newObj.Name='TestOpp';
        newObj.ForecastCategoryName='Pipeline';
        newObj.AccountId=acc.Id;
        insert newObj;
        //Fee__c f = new Fee__c (Application__c = newObj.Id,MiscEquipment_Fees__c ='92087',Frequency__c ='A',Fee_Amount__c ='30',Quantity__c = 4);
        //insert f;
       
        Id pricebookId = Test.getStandardPricebookId();
        //Create product
        Product2 product = new Product2(Name = 'Poynt V2',ProductCode = 'Pro-X',isActive = true);
        INSERT product;
        
        //Create pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = product.Id,UnitPrice = 100.00,IsActive = true);
        INSERT pbEntry;
        
        //create opportunity line item
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(OpportunityId = newObj.Id,Quantity = 5,PricebookEntryId = pbEntry.Id,
        TotalPrice = 2 * pbEntry.UnitPrice,Ownership_Type__c ='0');
        INSERT opportunityLineItem;  
    } 
    
    @isTest 
    private static void testSetupFee() {
        List<String> listAccIds =new List<String>();
        List<Account> accList= [select id,Name from Account];
        for(Account obj :accList){
           listAccIds.add(obj.Id);
        }
        Test.startTest();
         RSI_SetupEquipmentFees.setupEquipmentFees(listAccIds);
        Test.stopTest();
         
    }

}