@isTest

public class RSI_PromoteDemoteMockTest2  implements HttpCalloutMock {   
    public HTTPResponse respond(HTTPRequest req) {       
        HTTPResponse response = new HttpResponse();
        String jsonresponse='{"SUCCESS": false,"ERROR": "noerror"}';
        response.setHeader('content-type','application/json');
        response.setBody(jsonresponse);
        response.setStatusCode(200);
        return response;   
    }
}