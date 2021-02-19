@isTest 
public class RSI_OppTrigerHandlerTest {
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
            newObj.Pricing_Plans__c = 'Volume =< $25K';
            newObj.AccountId=acc.Id;
        Insert newObj;

        newObj.Pricing_Plans__c = 'Volume up to $75,000';
        Update newObj;
    }
}