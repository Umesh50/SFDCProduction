@isTest
public class RSI_VARSheetDetailTest {
    
     @testsetup private static void setup(){
        //RSI_StopRecursion.setDoNotRunTrigger();
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.MERCHANT_ID__c ='40005';
        acc.Partner_Code__c ='R-01';
        insert acc; 
     }
    
    @isTest
    private static void testVAR() {
        Test.setMock(HttpCalloutMock.class, new RSI_VARSheetMock());
        List<Account> a =[select id,Name from Account where Name ='Test'];
        List<Id> accIds=new List<Id>();
        for(Account ac : a){
            accIds.add(ac.Id);
        }
        Test.startTest();
        System.enqueueJob(new RSI_VARSheetDetail(accIds));
        Test.stopTest();   
    } 
    
    public class RSI_VARSheetMock implements HttpCalloutMock{
    
     public HTTPResponse respond(HTTPRequest req) {
            Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
           // get app key to make a url...
           String appKey=mapOfConnection.get('APPKEY');
           if(req.getEndpoint().endsWith('coding?appkey='+appKey)) {
           //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/merchants/40005/coding');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"SUCCESS": true,"DATA": [["","",12,"","NEXUS DATALINK",40005,"","X","Vendor Distributed"]],"COLUMNS": [ "APPLICATIONNUM","CHECK_READER_TYPE","CODE_ID","DOWNLOADNUM","MERCHANT_NAME","MERCH_ID","PINPADTYPE","PRINTERTYPE","TERMINALTYPE"]}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
           }else if(req.getEndpoint().endsWith('coding/12?appkey='+appKey)){   
           //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/merchants/40005/coding/12');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"AMEX": "","CODE_ID": 12,"CREATED_DATE": "October, 26 2020 00:00:00","DISCOVER": "","CHECK_READER_TYPE": "","WIRELESSMAN": "","PINPADTYPE":"","TERMINALIDNUM": "0008036749748607","BANKID": "","MERCHANTHELPDESKNUM": "1-800-741-3737","TRACKINGPROVIDER": "","MERCHSERVICETYPE": "","TERMINALAPPNUM": "","TERMINALTYPE": "Vendor Distributed","WIRELESSESN": "","NOVAMERCHANTHELPDESK": "1-800-972-4608","NOVAMSPHELPDESK": "1-800-741-3737","GATEWAYPASSWORD": "","TRACKINGNUMBER": "","LEASECOMPANYNAME": "","CREATED_BY": "MerchWire","VERIFICATIONPHONENUM": "","PRINTERTYPE": "X","JCB": "","LEASENUM": "","GATEWAYLOGIN": "","EQUIPMENTTID": "","APPLICATIONNUM": "","PHONEINAPPROVALNUM": "1-800-972-4608","CREDITDECISION": "","DOWNLOADNUM": "","DINERSCLUB": "","LADCOAPPLICATIONNUM": ""}';
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