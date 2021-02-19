/****************************************************************************************************************
 * Name...................: RSI_ApplicationPricingAutomationTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 02/01/2021
 * Description............: This test class of RSI_ApplicationPricingAutomation.
 *******************************************************************************************************************/


@isTest
public class RSI_ApplicationPricingAutomationTest {
    
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
        List<Opportunity> listOpp =new List<Opportunity>();
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='New';
        newObj.Name='TestExp';
        newObj.Pricing_Plans__c ='Volume =< $25K';
        newObj.Business_Type__c='1';
        newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
        newObj.ForecastCategoryName='Pipeline';
        newObj.Merchant_Application_No__c=42554;
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        listOpp.add(newObj);
        
        Opportunity newObj1=new Opportunity();
        newObj1.CloseDate=varDate;
        newObj1.StageName='New';
        newObj1.Name='TestExp1';
        newObj1.Pricing_Plans__c ='FIXED RATE - API';
        listOpp.add(newObj1);
        insert listOpp;   
    }
    
    @isTest
    private static void testPriceAutomation() {
        List<Opportunity> opp =[select id,name,Pricing_Plans__c from Opportunity where name = 'TestExp'];
        Test.startTest();
        RSI_ApplicationPricingAutomation.updatePricingOnApplication(opp);
        Opportunity oppObj =[select id,name,Pricing_Plans__c from Opportunity where name = 'TestExp' Limit 1];
        System.assertNotEquals(null,oppObj.Id);
        Test.stopTest();   
    }

}