/****************************************************************************************************************
 * Name...................: RSI_PPTransactionDataTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/19/2021
 * Description............: This class use to generate fake response for RSI_PPTransactionData class.
 *******************************************************************************************************************/
@isTest
public class RSI_PPTransactionDataTest {
    
    @testsetup private static void setup(){
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.MERCHANT_ID__c ='40005';
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.Partner_Code__c ='R-01';
        insert acc; 
        
        Volume__c v = new Volume__c();
        v.Account__c = acc.Id;
        v.MID__c ='345643';
        v.BATCHNUM__c ='34567';
        v.TIDNUM__c = '67798574';
        //v.DATECREATED__c =System.today().adddays(-8);
        insert v;
        
        Transaction_Data__c t = new Transaction_Data__c();
        t.Account__c = acc.Id;
        t.Volume__c =v.Id;
        t.DATECREATED__c = System.today().adddays(-8);
        t.BATCHNUM__c ='34567';
        insert t;
        
    }
    
    @isTest
    private static void testTrans() {
        Test.setMock(HttpCalloutMock.class, new RSI_PPTransactionMock());
        Test.startTest();
        Database.executeBatch(new RSI_PPTransactionData(),1);
        Test.stopTest();    
    }
    
    public class RSI_PPTransactionMock implements HttpCalloutMock{ 
    public HTTPResponse respond(HTTPRequest req) {
        //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/merchants/40005/volume/34567');
        HTTPResponse response = new HttpResponse();
        String jsonresponse='{"COLUMNS":["TOTALNETAMT","DATECREATED","BATCHNUM","CARDTYPE","SECNUM","TRANSDATE","TRANSAMT1","TRANSAMT1","CARDTYPEID","CARDIDMETHOD","VOIDINDICATOR","TRANSCODE","AUTHAMOUNT"],"DATA":[[2000.00,"January, 18 2021 00:00:00",14,"Discover","601101******3024","December, 21 2020 00:00:00",2000.00,2000.00,12,"D740308255","N","01",66694224.00]]}';
        response.setHeader('content-type','application/json');
        response.setBody(jsonresponse);
        response.setStatusCode(200);
        return response;
    } 
}
}