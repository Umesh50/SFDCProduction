/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-15-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-15-2021   Umesh Kumar   Initial Version
**/

@isTest
public class RSI_UpdateApplicationStatusTest {
    
    @isTest static void testInsert() {
        Account acc=new Account();
        acc.Name='TestAccount';
        acc.Shipping_Address__c= 'ship';
        acc.Shipping_Country__c='BHS'; 
        acc.Shipping_State__c ='AL' ;
        acc.Shipping_City__c='Noida';
        acc.Shipping_Zip__c='45647';
        acc.Shipping_Phone__c='45364353';
        acc.Mailing_Address__c='noida';
        acc.Mailing_Country__c='BHS';
        acc.Mailing_State__c='AL';
        acc.Mailing_City__c='Noida';
        acc.Mailing_Zip__c='54634';
        acc.Mailing_Phone__c='3456374';
        acc.DDA_Account__c='3453';
        acc.DDA_Account2_No__c='34333'; 
        acc.Previous_Processor_Name__c='pre';
        acc.Industry_MCC_Code__c='7922 - Advanced ticket sales';
        acc.Copy_Industry_Standards__c=true;
        acc.Total_Monthly_Sales__c=10;
        acc.Average_Ticket__c=30 ;
        acc.Highest_Ticket_Amount__c=20; 
        acc.Highest_Ticket_Frequency__c=10;
        acc.Pricing_Plans__c='Volume =< $25K'; 
        acc.Annual_Revenue__c=300; 
        acc.Description_Of_Products_Or_Services__c='sold';
        acc.Describe_When_Product_Is_Received__c='recv'; 
        acc.No_of_Days__c=0 ;
        acc.Seasonal__c ='No'; 
        acc.Website ='website' ;
        acc.Customer_Service_Phone__c ='457658474';
        acc.Sales_Percent_Types_Card_Present__c=10; 
        insert acc;
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity obj=new Opportunity();
        obj.CloseDate=varDate;
        obj.StageName='New';
        obj.Name='TestOpp';
        obj.ForecastCategoryName='Pipeline';
        obj.AccountId=acc.Id;
        obj.Business_Contact_First_Name__c ='a';
        obj.Business_Contact_Last_Name__c ='b';
        obj.Contact_Email_Address__c ='up@gmail.com';
        obj.Business_Type__c ='';
        obj.Contact_Phone_Number__c='7654372';
        obj.Business_Type__c= '1';
        obj.DBA_Name__c= 'dba' ;
        obj.Legal_Name_As_DBA__c='0';
        obj.Corporate_Name__c= 'corp'; 
        obj.Employer_Identification_Number__c= '3423';
        obj.DBA_Phone__c='768574';
        obj.DBA_Fax__c='45434'; 
        obj.Email_Address__c= 'up@gmail.com' ;
        obj.Mobile_Phone__c='564743';
        obj.Year_Established__c='2';
        obj.DBA_Address_1__c= 'add'; 
        obj.DBA_Address_2__c='db2';
        obj.State__c='AL';
        obj.City__c= 'noida';
        obj.Zip_Code__c ='45345'; 
        
        Test.startTest();
        insert obj;
        RSI_UpdateApplicationStatus.updateAppStatus(obj.Id);
        System.assertNotEquals(null,obj.id);
        Test.stopTest();     
    }
}