@isTest
private class RSI_PromoteAndDemoteHellperTest {
    @testSetup static void setup() {
        Date varDate = Date.newInstance(2020,10,9);
        Account acc = new Account();
            acc.Name='Test';
            acc.Address__c='noida';
            acc.Monthly_Fee__c=123;
            acc.Country__c='USA';
            acc.Phone='9876543210';
            acc.Partner_Code__c ='R-01';
        Insert acc; 
        
        Opportunity newObj=new Opportunity();
            newObj.CloseDate=varDate;
            newObj.StageName='Qualification';
            newObj.Name='TestExp';
            newObj.Business_Type__c='1';
            newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
            newObj.ForecastCategoryName='Pipeline';
            newObj.Merchant_Application_No__c=42554;
            newObj.Merchant_Application_Document_No__c=44054;
            newObj.Annual_Fee_Start_Date__c = system.today();
            newObj.AccountId=acc.Id;
        Insert newObj;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
         
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocument cd = new ContentDocument();
            cd.Id = conDocId;
            cd.Description = '42554';
            cd.Title = 'Signature';
        Update cd;
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = newObj.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        /*
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
        Insert p;  
        */
       /* Fee__c fe=new Fee__c();
            fe.Quantity__c =2;
            fe.Application__c= newObj.id;
        Insert fe;
        */
        /*
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
        Insert itm; 
                
        Owners_Or_Officers__c ownr=new Owners_Or_Officers__c();
            ownr.Country_of_Citizenship_1__c='USA';
            ownr.Country_Of_Citizenship_2__c='USA';
            // ownr.Country_Of_Issuance__c='USA';
            ownr.Primary_Owner_Or_Officer__c=true;
            ownr.City__c='Noida';
            ownr.City1__c='Noida';     
            ownr.Personal_Guarantee__c = True;
            ownr.Last_Name__c = 'test';
            ownr.Signature__c = 'ajay';
            ownr.Principal_Title__c ='AM';       
            ownr.DOB__c=Date.newInstance(1990,07,01);
            ownr.Additional_Owner_Or_25_Ownership__c='YES';
            ownr.Application__c=newObj.Id;
        Insert ownr;
        */
        /*
        Contact cn = new Contact();
            cn.LastName = 'test';
            cn.Email ='test@gmail.com';
        Insert cn;
        
        Authorization__c ath=new Authorization__c();
            ath.American_Express__c=10;
            ath.Dial_Communication__c=20;
            ath.Discover__c=30;
            ath.Union_Pay__c=40;
            ath.Application__c=newObj.Id;
        Insert ath;
        */                              
    }        
    @isTest
    private static  void myTest() {        
        Test.setMock(HttpCalloutMock.class, new RSI_PromoteDemoteMockTest());
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
        
        Test.startTest();        
            String p = RSI_PromoteAndDemoteHellper.promoteAndDemote(oppObj.Id,'promote');
        Test.stopTest();
    }
    @isTest
    private static  void submitAppTest() {        
        Test.setMock(HttpCalloutMock.class, new RSI_PromoteDemoteMockTest2());
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
        
        Test.startTest();        
            String p = RSI_PromoteAndDemoteHellper.submitApp(oppObj.Id);
        Test.stopTest();
    }     
}