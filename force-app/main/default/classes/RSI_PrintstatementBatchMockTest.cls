@isTest
public class RSI_PrintstatementBatchMockTest  implements HttpCalloutMock {

    
       public HTTPResponse respond(HTTPRequest req) {
    
   
           req.setEndpoint('https://api.msppulsepoint.com/nexusdatalink/v1/merchants/8036749748/printstatements.json?appkey=152E9C551A7AE89DD48AFC8816D0FF0B41659D0703F3B5EFD5512568DE28BFB9');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"MESSAGE":"","SUCCESS":true,"STATEMENTS":4.0,"STATEMENTLIST":{"COLUMNS":["STATEMENTKEY","MERCHANTNO","BATCHNO","DATEADDED","STATEMENTTYPE"],"DATA":[["OD_djcxMjYtNTIxNi01MjE3LTUyMjItUkJBNi0xNTI1NEZBQUpBLTIxMjI4My0xMDIzMC05NDM1Mjk2LTExMjMwMC03OC03OS01MzktNzcwLTAtXgEwMDAwMDA4MDM2NzQ5NzQ4AU1FUiBCSUxMATAwMDE3ATQzNzU4ATAwMDAwATAwMDAwATgwMzY3NDk3NDgBTkVYVVMgREFUQUxJTksBQkVSS0VMRVkBMTg2NTkBTVBTU1RNVFAgICAgICAgIA==_Disk_A_MPSSTMTP_MERCH_DATE|||01^31^2021_ACCOUNT|||0000008036749748","8036749748","202101","01/31/2021","Merchant Billing Statement"]]}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
    
}
}