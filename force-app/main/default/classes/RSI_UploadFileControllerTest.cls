/****************************************************************************************************************
 * Name...................: RSI_UploadFileControllerTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 02/01/2021
 * Description............: This test class of RSI_SignatureHelper.
 *******************************************************************************************************************/

@isTest
public class RSI_UploadFileControllerTest {
    
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
        newObj.Merchant_Application_No__c=42554;
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        insert newObj;
    }
    
     @isTest
    private static void testDocumentLink() {
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'CertificateOfCompletion';
        Blob bodyBlob  = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'CertificateOfCompletion.pdf';
        cv.VersionData = bodyBlob;
        cv.IsMajorVersion = true;
        Insert cv;
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = oppObj.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Test.startTest();
        RSI_UploadFileController.updateFileRecord(conDocId,'Business License',oppObj.Id);
        RSI_UploadFileController.updateFileRecord(conDocId,'Business Photos',oppObj.Id);
        RSI_UploadFileController.updateFileRecord(conDocId,'Corporate Docs',oppObj.Id);
        RSI_UploadFileController.updateFileRecord(conDocId,'Drivers License',oppObj.Id);
        RSI_UploadFileController.updateFileRecord(conDocId,'Voided Check Or Bank Letter',oppObj.Id);
        RSI_UploadFileController.updateFileRecord(conDocId,'Processing Statement (3 Months)',oppObj.Id);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Legal: Certified Articles of Incorporation',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Business Photos',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Corporate Docs',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Drivers License',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Processing Statement (3 Months)',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Voided Check Or Bank Letter',true);
         RSI_UploadFileController.getAppStatus(oppObj.Id,'Business License',true);
        Test.stopTest();
    }

}