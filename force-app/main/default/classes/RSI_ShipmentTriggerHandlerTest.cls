/****************************************************************************************************************
 * Name...................: RSI_ShipmentTriggerHandlerTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_ShipmentTrigger.
 *******************************************************************************************************************/

@isTest
public class RSI_ShipmentTriggerHandlerTest {
    
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
        
        Case cObj =new case();
        cObj.AccountId = acc.id;
        cObj.Status ='New';
        insert cObj;
        
        
        
    }
    @isTest
    private static void testShipmentTrigg() {
        Account accObj=[select id,Name from Account where name ='Test' Limit 1];
        Case caseObj=[select id,AccountId from Case where AccountId =:accObj.Id Limit 1];
   
        zkmulti__MCShipment__c zkObj=new zkmulti__MCShipment__c();
        zkObj.zkmulti__Carrier__c ='FedEx';
        zkObj.zkmulti__Recipient_Account__c = accObj.id;
        zkObj.zkmulti__Recipient_Name__c = 'Test';
        zkObj.zkmulti__Recipient_Phone__c ='612-304-6073';
        zkObj.zkmulti__Recipient_State_Province__c ='CA';
        zkObj.zkmulti__Recipient_Street__c ='5500 W Sunset Blvd';
        zkObj.zkmulti__Recipient_Zip_Postal_Code__c = '90028';
        zkObj.Service_Ticket__c = caseObj.id;
        Test.startTest();
        insert zkObj;
        zkmulti__MCShipment__c obj =[select id,zkmulti__Recipient_Name__c from zkmulti__MCShipment__c where zkmulti__Recipient_Name__c='Test' Limit 1];
        System.assertNotEquals(null,obj.Id);
        Test.stopTest();   
    }

}