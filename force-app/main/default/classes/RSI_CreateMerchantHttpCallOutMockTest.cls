@isTest
public class RSI_CreateMerchantHttpCallOutMockTest  implements HttpCalloutMock {
 public HTTPResponse respond(HTTPRequest req) {
           req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"MERCHANTAPPLICATIONNO":21657,"success": true}';
           response.setHeader('content-type','application/json');
           response.setbody(jsonresponse);
           response.setstatuscode(200);
           return response;
       }
}