/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-20-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-20-2021   Umesh Kumar   Initial Version
**/


@isTest
public class RSI_UpdateMPASectionTest {
    
    @isTest
    private static void testMthd() {
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.Address_Type__c='BSA';
        acc.Partner_Code__c ='R-01';
        insert acc; 
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='New';
        newObj.Name='TestExp';
        newObj.City__c ='noida';
        newObj.State__c ='AL';
        newObj.Country__c ='USA';
        newObj.Zip_Code__c ='34342';
        newObj.Business_Type__c='1';
        newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
        newObj.ForecastCategoryName='Pipeline';
        newObj.Corporate_Name__c ='corp';
        newObj.DBA_Address_1__c ='dba';
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        insert newObj;
        List<Owners_Or_Officers__c> lstOwnr=new List<Owners_Or_Officers__c>();
        Owners_Or_Officers__c ownr = new Owners_Or_Officers__c();
        ownr.Country_of_Citizenship_1__c='USA';
        ownr.Country_Of_Citizenship_2__c='USA';
       // ownr.Country_Of_Issuance__c='USA';
        ownr.Primary_Owner_Or_Officer__c=true;
        ownr.City__c='Noida';
        ownr.Last_Name__c ='ajay2';
        ownr.Owner_Type__c ='2';
        ownr.City1__c='Noida';
        ownr.DOBText__c='12202001';
        ownr.Principal_Title__c ='AM';
        ownr.Additional_Owner_Or_25_Ownership__c='YES';
        ownr.Application__c=newObj.Id;
        lstOwnr.add(ownr);
        Owners_Or_Officers__c ownr1 = new Owners_Or_Officers__c();
        ownr1.Country_of_Citizenship_1__c='USA';
        ownr1.Country_Of_Citizenship_2__c='USA';
        ownr1.Owner_Type__c ='2';
        ownr1.Last_Name__c ='ajay1';
         ownr1.Principal_Title__c ='AS';
        ownr1.City__c='Noida';
        ownr1.City1__c='Noida';
        ownr1.DOBText__c='12202002';
        ownr1.Application__c=newObj.Id;
        lstOwnr.add(ownr1);
        insert lstOwnr;
        MPA_Section__c mpa =new MPA_Section__c();
        mpa.Application__c = newObj.Id;
        mpa.Date__c = system.today();
        mpa.Date2__c =system.today();
        mpa.Date3__c = system.today();
        mpa.Date4__c = system.today();
        mpa.Rep_Signature_Date__c = system.today();
        insert mpa;
        
        Test.startTest();
        RSI_UpdateMPASection.getUpdateMPASection(newObj.Id);
        MPA_Section__c m=[select id,Title__c from MPA_Section__c where Application__c = :newObj.Id limit 1];
        System.assertEquals('AM', m.Title__c);
        Test.stopTest();
        
    }     
    }