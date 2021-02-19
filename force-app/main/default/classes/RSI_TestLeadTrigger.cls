/****************************************************************************************************************
 * Name...................: RSI_TestLeadTrigger
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class use to test the functionality or code coverage of RSI_LeadTrigger trigger
 *******************************************************************************************************************/

@isTest
public class RSI_TestLeadTrigger {
    @testSetup static void setup()
    {
        Id rid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
        List<Account> listAccount=new List<Account>();
        Account acc=new Account();
        acc.Name='TestAccount';
        acc.Partner_Code__c='T-0002';
        acc.RecordTypeId=rid;
        listAccount.add(acc);
        Account acc1=new Account();
        acc1.Name='TestAccount1';
        acc1.Partner_Code__c='T-0003';
        acc1.RecordTypeId=rid;
        listAccount.add(acc1);
        insert listAccount;
        
        Lead newLeadObj=new Lead();
        newLeadObj.Partner_Code__c = 'T-0002';
        newLeadObj.Status='New';
        newLeadObj.LastName='TestLead';
        newLeadObj.Company='TestBusinessName';
        insert newLeadObj;
        
    }
    
    @isTest static void testUpdatePartner()
    {
        Lead leadObj=[select id,LastName,Partner_Code__c from Lead where LastName='TestLead' limit 1];
        leadObj.Partner_Code__c='T-0003';
        update leadObj;
        Lead lObj=[select id,Partner_Name__r.Name from Lead where id=:leadObj.id limit 1];
        System.assertEquals('TestAccount1',lObj.Partner_Name__r.Name);
    }  
}