/****************************************************************************************************************
 * Name...................: RSI_SignatureHelperTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_SignatureHelper.
 *******************************************************************************************************************/


@isTest
public class RSI_SignatureHelperTest {
    
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
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Signature';
        Blob bodyBlob  = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'Signature.pdf';
        cv.VersionData = bodyBlob;
        cv.IsMajorVersion = true;
        Insert cv;
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = newObj.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
    }
    
    @isTest
    private static void testSignatureHelper() {
        Test.setMock(HttpCalloutMock.class, new RSI_UploadFileMockTest());
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
       //Company Prem and Cer 5   
        Test.startTest();
        RSI_SignatureHelper.uploadSignaturePage(oppObj.id);
        Test.stopTest();    
    }
   
    
    public class RSI_UploadFileMockTest implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse response = new HttpResponse();
            String jsonresponse='{"SUCCESS":true,"RESULT":{"DOCID":44484,"SUCCESS":true,"FILENAME":"Signature.pdf"}}';
            response.setHeader('content-type','application/json');
            response.setBody(jsonresponse);
            response.setStatusCode(200);
            return response;
        } 
    }
}