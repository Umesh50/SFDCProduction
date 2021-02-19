/****************************************************************************************************************
 * Name...................: RSI_ContentDocumentLinkTriggerTest
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/11/2021
 * Description............: test class of RSI_ContentDocumentLinkTrigger........
 *******************************************************************************************************************/


@isTest
public class RSI_ContentDocumentLinkTriggerTest {
    
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
        Test.startTest();
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
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title ='CertificateOfCompletion'];
        System.assertEquals(documents.size(), 1);
        System.assertEquals(documents[0].Id, conDocId);
        Opportunity oppObj1 = [Select Id,Name,StageName From Opportunity where Name='TestExp' Limit 1];
        System.assertEquals('Signed',oppObj1.StageName);
        Test.stopTest();
    }
}