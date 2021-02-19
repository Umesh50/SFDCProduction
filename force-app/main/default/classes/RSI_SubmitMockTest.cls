@isTest

public class RSI_SubmitMockTest  implements HttpCalloutMock {

    
       public HTTPResponse respond(HTTPRequest req) {
    
   
           req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42756/submit?appkey=B44817685E7EA4B7E91FDAB63DC980C2423FE2A33A28BC4249FB205195A71F5D');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{{"SUCCESS":false,"DATA":{},"ERROR":"Applications status is not ready to be submitted. Current status is New."}}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(401);
           return response;
    
}
}