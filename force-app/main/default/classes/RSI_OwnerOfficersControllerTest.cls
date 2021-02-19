/****************************************************************************************************************
 * Name...................: RSI_OwnerOfficersControllerTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2020
 * Description............: This class use to test the functionality of RSI_OwnerOfficersController
 *******************************************************************************************************************/


@isTest
public class RSI_OwnerOfficersControllerTest {
    
    
     @testsetup private static void setup(){
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
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.DBA_Phone__c ='5678945650';
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
        List <Owners_Or_Officers__c> ownrlist=new List <Owners_Or_Officers__c>(); 
        Owners_Or_Officers__c ownr=new Owners_Or_Officers__c();
        ownr.First_Name__c ='ownrFN';
        ownr.Last_Name__c ='ownrLN';
        ownr.Country_of_Citizenship_1__c='USA';
        ownr.Country_Of_Citizenship_2__c='USA';
        ownr.Primary_Owner_Or_Officer__c=true;
        ownr.City__c='Noida';
        ownr.City1__c='Noida';
        ownr.DOBText__c='12202001';
        ownr.Owner_Type__c = '2';
        ownr.Additional_Owner_Or_25_Ownership__c='YES';
        ownr.Application__c=newObj.Id;
        ownrlist.add(ownr);
         
        Owners_Or_Officers__c ownr1=new Owners_Or_Officers__c();
        ownr1.First_Name__c ='ownrFN1';
        ownr1.Last_Name__c ='ownrLN1';
        ownr1.Country_of_Citizenship_1__c='USA';
        ownr1.Country_Of_Citizenship_2__c='USA';
        ownr1.City__c='Noida';
        ownr1.City1__c='Noida';
        ownr1.DOBText__c='12202001';
        ownr1.Owner_Type__c = '2';
        ownr1.Additional_Owner_Or_25_Ownership__c='YES';
        ownr1.Application__c=newObj.Id;
        ownrlist.add(ownr1);
        insert ownrlist;
         
         Equipment_Programming__c eqObj =new Equipment_Programming__c();
         eqObj.AUTO_BATCH__c =true;
         eqObj.Application__c = newObj.Id;
         insert eqObj;
         
     }
    
     @isTest
    private static void testOwnController() {
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
     
        Test.startTest();
        List<Owners_Or_Officers__c> ownrs = RSI_OwnerOfficersController.getOwnerList(oppObj.Id);
        system.assertNotEquals(null,ownrs);
        List<Owners_Or_Officers__c> ownrslist = RSI_OwnerOfficersController.getPGuarantorOwnerList(oppObj.Id);
        system.assertNotEquals(null,ownrslist);
        List <OpportunityLineItem> linsitm = RSI_OwnerOfficersController.getProductList(oppObj.Id);
        system.assertNotEquals(null,linsitm);
        List<Equipment_Programming__c>  eqlist =RSI_OwnerOfficersController.getEquipmentProg(oppObj.Id);
        system.assertNotEquals(null,eqlist);
        List<Opportunity> getDBA =RSI_OwnerOfficersController.getOppDBAPhone(oppObj.Id);
        system.assertNotEquals(null,getDBA);
        string s= RSI_OwnerOfficersController.deleteOwnerOfficer(oppObj.Id);
        system.assertEquals('Success', s);
        Test.stopTest();   
    }  

}