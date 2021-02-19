@isTest
private class RSI_PPMerchent_IDTest {
    @testSetup static void setup() {
        Account acc = new Account();
            acc.Name='Test';
            acc.Address__c='noida';
            acc.Monthly_Fee__c=123;
            acc.Country__c='USA';
            acc.Phone='9876543210';
            acc.MERCHANT_ID__c ='40005';
            acc.MID__c = '8036749748';
            acc.Partner_Code__c ='R-01';
        insert acc;                  
    }        
    @isTest
    private static  void myTest() {        
        Test.setMock(HttpCalloutMock.class, new RSI_PPMerchent_IDMockTest());
        List<Id> listAccId = new List<Id>();
        for(Account obj : [SELECT Id FROM Account]){
            listAccId.add(obj.Id);
        }
        Test.startTest();
                        
           RSI_PPMerchent_ID.pulsepointmerchent(listAccId);
           Test.setMock(HttpCalloutMock.class, new RSI_VARSheetMock());   
              
        Test.stopTest();
    }
    public class RSI_VARSheetMock implements HttpCalloutMock{
    
     public HTTPResponse respond(HTTPRequest req) {           
          
           HTTPResponse response = new HttpResponse();
               String jsonresponse='{"SUCCESS": true,"DATA": [["","",12,"","NEXUS DATALINK",40005,"","X","Vendor Distributed"]],"COLUMNS": [ "APPLICATIONNUM","CHECK_READER_TYPE","CODE_ID","DOWNLOADNUM","MERCHANT_NAME","MERCH_ID","PINPADTYPE","PRINTERTYPE","TERMINALTYPE"]}';
               response.setHeader('content-type','application/json');
               response.setBody(jsonresponse);
               response.setStatusCode(200);
           return response;
           
     }
}   
}