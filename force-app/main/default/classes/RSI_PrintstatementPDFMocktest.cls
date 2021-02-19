@isTest

public class RSI_PrintstatementPDFMocktest  implements HttpCalloutMock {

    
       public HTTPResponse respond(HTTPRequest req) {
    
   
           req.setEndpoint('https://api.msppulsepoint.com/nexusdatalink/v1/merchants/8036749748/printstatements/OD_djcxMjYtNTIxNi01MjE3LTUyMjItUkJBNi0xNTEyNkZBQUtBLTYyMTA4MS0yNzI4OS01MTg5NDU1LTEwODUxNi03OC03OS01MzktNzcwLTAtXgEwMDAwMDA4MDM2NzQ5NzQ4AU1FUiBCSUxMATAwMDE3ATQzNzU4ATAwMDAwATAwMDAwATgwMzY3NDk3NDgBTkVYVVMgREFUQUxJTksBQkVSS0VMRVkBMTg2MjgBTVBTU1RNVFAgICAgICAgIA==_Disk_A_MPSSTMTP_MERCH_DATE|||12^31^2020_ACCOUNT|||0000008036749748?appkey=152E9C551A7AE89DD48AFC8816D0FF0B41659D0703F3B5EFD5512568DE28BFB9D');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{{"SUCCESS": true,"newStatus": "Approved"}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
    
}
}