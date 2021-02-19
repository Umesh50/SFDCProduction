/****************************************************************************************************************
 * Name...................: RSI_TestUpdateMerchantAppInformation 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2020
 * Description............: This class use to test the functionality of RSI_UpdateMerchantAppInformation,RSI_IntegrationUtils
 *                           and RSI_UtilityClass class.
 *******************************************************************************************************************/

@isTest
public class RSI_TestUpdateMerchantAppInformation {
    
    @testsetup private static void setup(){
        //RSI_StopRecursion.setDoNotRunTrigger();
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.Partner_Code__c ='R-01';
        insert acc; 
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='New';
        newObj.Name='TestExp';
        newObj.Business_Type__c='1';
        newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
        newObj.ForecastCategoryName='Pipeline';
        newObj.Merchant_Application_No__c=42554;
        newObj.Merchant_Application_Document_No__c=44054;
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        insert newObj;
        
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
        
        Fee__c fe=new Fee__c();
        fe.Quantity__c =2;
        fe.Application__c= newObj.id;
        insert fe;
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
        itm.Quantity=4;
        itm.TotalPrice=100;
        itm.Product2Id=p.Id;
        itm.PricebookEntryId=pbe.Id;
        insert itm; 
    
        Owners_Or_Officers__c ownr=new Owners_Or_Officers__c();
        ownr.Country_of_Citizenship_1__c='USA';
        ownr.Country_Of_Citizenship_2__c='USA';
        // ownr.Country_Of_Issuance__c='USA';
        ownr.Primary_Owner_Or_Officer__c=true;
        ownr.City__c='Noida';
        ownr.City1__c='Noida';
        ownr.DOBText__c='12202001';
        ownr.Additional_Owner_Or_25_Ownership__c='YES';
        ownr.Application__c=newObj.Id;
        insert ownr;
        
        Authorization__c ath=new Authorization__c();
        ath.American_Express__c=10;
        ath.Dial_Communication__c=20;
        ath.Discover__c=30;
        ath.Union_Pay__c=40;
        ath.Application__c=newObj.Id;
        insert ath;
    }
    
    @isTest
    private static void testMerchantUpdate() {
        
        Test.setMock(HttpCalloutMock.class, new RSI_HttpCalloutMockTest()); //RSI_MerchantUpdateHttpCalloutMockTest
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
     
        Test.startTest();
        String s = RSI_UpdateMerchantAppInformation.executeIntegration(oppObj.Id);
        system.assertEquals('SUCCESS', s);
        Test.stopTest();   
    }   
    
    public class RSI_HttpCalloutMockTest implements HttpCalloutMock {
    
       public HTTPResponse respond(HTTPRequest req) {
           if (req.getEndpoint().endsWith('44054')) {
           req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42554/forms/44054');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"SUCCESS": true,"DATA": {"SUBMISSIONNO": 42617}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
           }else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
       }
}
}