@isTest 
public class OwnerOrOfficerHelperTest {
    static testMethod void ownerofficer(){

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

        Pricebook2 standardPricebook = new Pricebook2(); 
            standardPricebook.Id = Test.getStandardPricebookId();
            standardPricebook.IsActive = true;
        Update standardPricebook;

        Product2 p = new Product2();
            p.Name = 'Pax E500';
            p.Description = 'This is the Product description.';
            p.ProductCode = 'EX1234';
            p.StockKeepingUnit = 'EX5678';
            p.Family = 'Example Product Family';
            p.QuantityUnitOfMeasure = 'inches';
            p.DisplayUrl = 'https://www.example.com/';
            p.ExternalId = 'ID #1234';
            p.IsActive = true;
        Insert p;  

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
            ownr.Primary_Owner_Or_Officer__c=true;
            ownr.City__c='Noida';
            ownr.City1__c='Noida';
            ownr.I_Agree__c = True;
            ownr.Personal_Guarantee__c = True;
            ownr.Last_Name__c = 'test';
            ownr.Signature__c = 'ajay';
            ownr.Principal_Title__c ='AM';
            ownr.DOB__c=Date.newInstance(1990,07,01);
            ownr.Additional_Owner_Or_25_Ownership__c='YES';
            ownr.Application__c=newObj.Id;
        Insert ownr;

        Owners_Or_Officers__c ownr1=new Owners_Or_Officers__c();
            ownr1.Country_of_Citizenship_1__c='USA';
            ownr1.Country_Of_Citizenship_2__c='USA';
            ownr1.Primary_Owner_Or_Officer__c=true;
            ownr1.City__c='Noida';
            ownr1.City1__c='Noida';
            ownr1.Responsible_Party__c=True;
            ownr1.Last_Name__c = 'test';
            ownr1.Signature__c = 'ajay';
            ownr1.Principal_Title__c ='AM';
            ownr1.DOB__c=Date.newInstance(1990,07,01);
            ownr1.Additional_Owner_Or_25_Ownership__c='YES';
            ownr1.Application__c=newObj.Id;
        Insert ownr1;
        
        Test.startTest();
            PageReference pageRef = Page.RSI_RENTAL;
                Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',newObj.Id);
            OwnerOrOfficerHelper oHelp = new OwnerOrOfficerHelper();
                oHelp.getData();
            OwnerOrOfficerHelper.getOwnerOffList(newObj.Id);
            OwnerOrOfficerHelper.getOwnerCheckOffList(newObj.Id) ;  
            OwnerOrOfficerHelper.getOwnershipType(newObj.Id);
            OwnerOrOfficerHelper.getOwnerFirstOffList(newObj.Id);
            OwnerOrOfficerHelper.updateOwnerOffCheckBox(ownr1.Id,true);
            RSI_NavigateToUrlGen.getNavigateUrl(newObj.Id);
            RSI_OwnerOfficersController.getOwnerList(newObj.Id);
            RSI_OwnerOfficersController.getProductList(newObj.Id);
            RSI_OwnerOfficersController.getEquipmentProg(newObj.Id);
            RSI_OwnerOfficersController.getOppDBAPhone(newObj.Id);
        Test.stopTest();
    }
}