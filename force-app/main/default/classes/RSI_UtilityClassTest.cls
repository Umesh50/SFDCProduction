/****************************************************************************************************************
 * Name...................: RSI_UtilityClassTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_UtilityClass.
 *******************************************************************************************************************/
@isTest
public class RSI_UtilityClassTest {
    
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
    private static void testUtility() {
        
        Test.setMock(HttpCalloutMock.class, new RSI_HttpCalloutMockTest()); //RSI_MerchantUpdateHttpC
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestExp' Limit 1];
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        Blob bodyBlob  = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'TestDocument.pdf';
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
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        RSI_UtilityClass.getApplicationParams();
        RSI_UtilityClass.getFieldValue(oppObj, 'Name');
        RSI_UtilityClass.getFieldSets('Opportunity');
        RSI_UtilityClass.promoteApplication('42554');
        RSI_UtilityClass.getFieldSetMembers ('Pricing_Information__c','Fixed');
        String d= RSI_UtilityClass.uploadFile (bodyBlob,'Test Document' ,RSI_UtilityClass.getApplicationEndPointURL()+'42554/documents?appkey='+mapOfConnection.get('APPKEY'),conDocId);
        system.assertEquals('44000', d);
        Test.stopTest();   
    }   
    
    public class RSI_HttpCalloutMockTest implements HttpCalloutMock {
    
       public HTTPResponse respond(HTTPRequest req) {
           Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
           // get app key to make a url...
           String appKey=mapOfConnection.get('APPKEY');
           if (req.getEndpoint().endsWith('promote?appkey='+appKey)) {
           //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42554/forms/44054');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"SUCCESS": true,"newStatus": "Submitted"}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
           }else if (req.getEndpoint().endsWith('documents?appkey='+appKey)) {   
           //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42554/promote');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"SUCCESS": true,"RESULT": {"DOCID": 44000}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;   
           }else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
       }
}

}