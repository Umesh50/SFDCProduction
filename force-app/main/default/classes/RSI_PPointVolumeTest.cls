/****************************************************************************************************************
 * Name...................: RSI_PPointVolumeTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_PPointVolumeTest.
 *******************************************************************************************************************/

@isTest
public class RSI_PPointVolumeTest {
    
    @testsetup private static void setup(){
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.MERCHANT_ID__c ='40005';
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.Status__c ='Approved';
        acc.Partner_Code__c ='R-01';
        insert acc; 
        
        Volume__c v = new Volume__c();
        v.Account__c = acc.Id;
        v.MID__c ='345643';
        v.TIDNUM__c = '67798574';
        v.DATECREATED__c =System.today().adddays(-8);
        insert v;
        
    }
    
    @isTest
    private static void testVolume() {
        Test.setMock(HttpCalloutMock.class, new RSI_PVolumeMock());
        Test.startTest();
        Database.executeBatch(new RSI_PPointVolume(),1);
        Test.stopTest();    
    }
    
    public class RSI_PVolumeMock implements HttpCalloutMock{
     public HTTPResponse respond(HTTPRequest req) {
       // req.setEndpoint('https://api.msppulsepoint.com/demo/v1/merchants/40005/volume');
        HTTPResponse response = new HttpResponse();
         String jsonresponse='{"COLUMNS":["MID","TIDNUM","DATECREATED","TOTALNETAMT","TOTALTRANSNUM","BATCHNUM","AMTPURCHASE","NUMPURCHASE","AMTRETURN","NUMRETURN","APPLICATIONNO","MERCHANTBATCHNO","AVERAGETICKET","ROW"],"DATA":[[8036874876,"0075420008036874876515","January, 11 2021 00:00:00",7500.00,3,14,7500.00,3,0.00,0,"TZK603RC",245611972,2500.000000,0]]}';
        response.setHeader('content-type','application/json');
        response.setBody(jsonresponse);
        response.setStatusCode(200);
        return response;
    } 
}

}