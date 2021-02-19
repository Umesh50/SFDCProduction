/*
*	Description: Test class for RSI_DynamicAddRemoveRow class.
*	Created Date: 20 Nov, 2020
*/
@isTest
public class RSI_DynamicAddRemoveRowTest {
    
    /*
    *	Purpose: Create test records which are used to testing the functionality.
    */
    @testsetup
    static void setupTestData() {
        //Create Account records
        Account account = new Account(
            Name = 'Test_Account_' + 1
        );
        
        INSERT account;
        
        Opportunity opportunity = new Opportunity();
        
        opportunity.AccountId = account.Id;
        opportunity.Name = 'Testing';
        opportunity.StageName = 'New';
        opportunity.CloseDate = System.today()+15;
        opportunity.Type = 'New Business';
        opportunity.Beneficial_Owner_Exemption_Status__c='';
        
        INSERT opportunity;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create product
        Product2 product = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        
        INSERT product;
        
        //Create pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        
        INSERT pbEntry;
        
        //create opportunity line item
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(
            OpportunityId = opportunity.Id,
            Quantity = 5,
            Shipping_Method__c = 'Overnight',
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 2 * pbEntry.UnitPrice
        );
        
        INSERT opportunityLineItem;
        
        Equipment_Programming__c equipmentProgramming = new Equipment_Programming__c(Application__c = opportunity.Id);
        
        insert equipmentProgramming;
    }
    
    /*
	 *	Purpose: Test the functionality of all methods.
	 */
    public static testMethod void myUnitTests() {
        //Get all records
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        List<OpportunityLineItem> listofitm = new List<OpportunityLineItem>();
        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =:opportunity.Id LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
               
         listofitm.add(opportunityLineItem);
        //String s = JSON.serializePretty(listofitm);        
        Test.startTest();
        
        RSI_DynamicAddRemoveRow.ResponseWrapper response = RSI_DynamicAddRemoveRow.getRecords(opportunity.Id);
        System.assertNotEquals(NULL, response);
        
        List<OpportunityLineItem> res = RSI_DynamicAddRemoveRow.getOppLineItemWithShipping(opportunity.Id);
        System.assertNotEquals(NULL, res);
        
        String message = RSI_DynamicAddRemoveRow.deleteLineItem(opportunityLineItem.Id);
        System.assertNotEquals(NULL, message);
        
        RSI_Response responseData = RSI_DynamicAddRemoveRow.updateAccountRecord(account);
        System.assertNotEquals(NULL, responseData);
        
        Equipment_Programming__c equipmentProgramming = new Equipment_Programming__c(Application__c = opportunity.Id);
        
        responseData = RSI_DynamicAddRemoveRow.createEquipmentProgrammingRecord(equipmentProgramming, opportunity.Id);
        System.assertNotEquals(NULL, responseData);
        
        //Negative testing
        response = RSI_DynamicAddRemoveRow.getRecords('');
        
        RSI_DynamicAddRemoveRow.getProducts(opportunity.Id);
        
        RSI_DynamicAddRemoveRow.getOpportunityLineItem(opportunity.Id);
        
        RSI_DynamicAddRemoveRow.getProductsWithPrice(opportunity.Id);
       RSI_DynamicAddRemoveRow.updateLineItems(JSON.serialize(listofitm));
        
        Test.stopTest();
    }    
}