@isTest
public class RSI_repeatConTest {
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


        Owners_Or_Officers__c ownr=new Owners_Or_Officers__c();
            ownr.Country_of_Citizenship_1__c='USA';
            ownr.Country_Of_Citizenship_2__c='USA';
            // ownr.Country_Of_Issuance__c='USA';
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
            ownr1.Owner_Type__c = '2';
            ownr1.Application__c=newObj.Id;
        Insert ownr1;

        signature__Signature__c sg = new signature__Signature__c();
          sg.Owners_Or_Officers__c = ownr1.Id;
        Insert sg;

        
         
        PageReference pageRef = Page.RSI_Signaturepage;
            pageRef.getparameters().put('appId', newObj.id);  
            pageRef.getparameters().put('parentId', ownr1.id); 
        Test.setCurrentPage(pageRef);

        Apexpages.StandardController sc = new Apexpages.StandardController(newObj);
        RSI_repeatCon ext = new  RSI_repeatCon(sc);         
        ext.getStrings();  
    }
    static testMethod void ownerofficer2(){

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


        Owners_Or_Officers__c ownr=new Owners_Or_Officers__c();
            ownr.Country_of_Citizenship_1__c='USA';
            ownr.Country_Of_Citizenship_2__c='USA';
            // ownr.Country_Of_Issuance__c='USA';
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
            ownr.Owner_Type__c = '2';
        Insert ownr;
        signature__Signature__c sg1 = new signature__Signature__c();
          sg1.Owners_Or_Officers__c = ownr.Id;
        Insert sg1;

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
            ownr1.Owner_Type__c = '2';
            ownr1.Application__c=newObj.Id;
        Insert ownr1;

        signature__Signature__c sg = new signature__Signature__c();
          sg.Owners_Or_Officers__c = ownr1.Id;
        Insert sg;
         
        PageReference pageRef = Page.RSI_Signaturepage;
            pageRef.getparameters().put('appId', newObj.id);  
            pageRef.getparameters().put('parentId', ownr1.id); 
        Test.setCurrentPage(pageRef);

        Apexpages.StandardController sc = new Apexpages.StandardController(newObj);
        RSI_repeatCon ext = new  RSI_repeatCon(sc);         
        ext.getStrings();  
    }
}