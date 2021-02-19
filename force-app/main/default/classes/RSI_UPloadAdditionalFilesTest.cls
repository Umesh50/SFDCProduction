/****************************************************************************************************************
 * Name...................: RSI_UPloadAdditionalFilesTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_UPloadAdditionalFilesTest.
 *******************************************************************************************************************/

@isTest
public class RSI_UPloadAdditionalFilesTest {
    
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
        cv.Title = 'Company Prem and Cer 5';
        Blob bodyBlob  = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'Company Prem and Cer 5.pdf';
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
    private static void testAdditionalFile() {
        Test.setMock(HttpCalloutMock.class, new RSI_UploadFileMock());
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
        List<ContentDocumentLink> cdlinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: oppObj.Id];
        List<String> cdIds =new List<String>();
        for(ContentDocumentLink cdl :cdlinks){
            cdIds.add(cdl.ContentDocumentId);
        }
        Test.startTest();
        List<ContentDocument> cd = RSI_UPloadAdditionalFiles.getFiles(oppObj.id);
        System.assertNotEquals(null,cd);
        List<ContentDocument> cdlist =RSI_UPloadAdditionalFiles.uploadSelectedFile(oppObj.id,cdIds);
        System.assertNotEquals(null,cdlist);
        Test.stopTest();    
    }
    
    public class RSI_UploadFileMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42554/notes');
            HTTPResponse response = new HttpResponse();
            String jsonresponse='{"SUCCESS":true,"RESULT":{"DOCID":44484,"SUCCESS":true,"FILENAME":"Company Prem and Cer 5.pdf"}}';
            response.setHeader('content-type','application/json');
            response.setBody(jsonresponse);
            response.setStatusCode(200);
            return response;
        } 
    }
    
}