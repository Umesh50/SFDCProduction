@isTest

public class RSI_PromoteDemoteMockTest  implements HttpCalloutMock {

    
       public HTTPResponse respond(HTTPRequest req) {
    
   
           req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42642/promote?appkey=B44817685E7EA4B7E91FDAB63DC980C2423FE2A33A28BC4249FB205195A71F5D');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{{"SUCCESS": true,"newStatus": "Approved"}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
    
}
}