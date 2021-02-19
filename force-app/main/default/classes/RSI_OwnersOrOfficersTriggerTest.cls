/****************************************************************************************************************
 * Name...................: RSI_OwnersOrOfficersTriggerTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/28/2021
 * Description............: This class use to test the functionality of OwnersOrOfficersTrigger Trigger........
 *******************************************************************************************************************/


@isTest
public class RSI_OwnersOrOfficersTriggerTest {
    @testSetup static void setup(){
        Account acc=new Account();
        acc.Name='TestAccount';
        insert acc;
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='New';
        newObj.Name='TestOpp';
        newObj.Business_Type__c = '0';
        newObj.ForecastCategoryName='Pipeline';
        newObj.AccountId=acc.Id;
        insert newObj;
        
    }
    
    @isTest static void testOwnTrigg(){
        Opportunity newObj=[select id,Name from Opportunity where Name='TestOpp' limit 1];
        List<Owners_Or_Officers__c> ownList=new List<Owners_Or_Officers__c>();
        Owners_Or_Officers__c ownObj=new Owners_Or_Officers__c();
        ownObj.First_Name__c='TestOwner';
        ownObj.Last_Name__c ='LSName';
        ownObj.Country_of_Citizenship_1__c ='USA';
        ownObj.ID_Type__c ='SSN';
        ownObj.ID_Number__c ='12345';
        ownObj.Ownership_Percentage__c =100;
        ownObj.Primary_Owner_Or_Officer__c=true;
        ownObj.Application__c=newObj.id;
        ownList.add(ownObj);
        
        Owners_Or_Officers__c ownObj1=new Owners_Or_Officers__c();
        ownObj1.First_Name__c='TestOwner1';
        ownObj1.Last_Name__c ='Owner1';
        ownObj1.Application__c=newObj.id;
        ownList.add(ownObj1);
        insert ownList;
        
        Owners_Or_Officers__c ownObj3=[select id,Primary_Owner_Or_Officer__c from Owners_Or_Officers__c where First_Name__c='TestOwner1' limit 1];
        Test.startTest();
        ownObj3.Primary_Owner_Or_Officer__c=true;
        ownObj3.Country_of_Citizenship_1__c ='USA';
        ownObj3.ID_Type__c ='SSN';
        ownObj3.ID_Number__c ='123459';
        ownObj3.Ownership_Percentage__c =100;
        update ownObj3;
        Owners_Or_Officers__c ownObj2=[select id,Primary_Owner_Or_Officer__c from Owners_Or_Officers__c where First_Name__c='TestOwner1' limit 1];
        System.assertEquals(true,ownObj2.Primary_Owner_Or_Officer__c);
        Test.stopTest();
    }  
}