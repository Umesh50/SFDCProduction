@isTest

public class RSI_PPMerchent_IDMockTest  implements HttpCalloutMock {

    
       public HTTPResponse respond(HTTPRequest req) {
    
   
           req.setEndpoint('https://api.msppulsepoint.com/demo/v1/merchants?appkey=152E9C551A7AE89DD48AFC8816D0FF0B41659D0703F3B5EFD5512568DE28BFB9&search=8036874876');
           HTTPResponse response = new HttpResponse();
           String jsonresponse='{"SUCCESS":true,"DATA":[["November, 28 2020 17:43:00","Main",4190474,"MOHMUDULLAH SALEMI","BAY LUXURY AUTO INC",42366,8036874876,"Elavon","",56843,"Approved"]],"COLUMNS":["DATEADDED","DIVISION","ELAVONAPPID","MERCHANT_CONTACT","MERCHANT_NAME","MERCH_ID","MERCH_NOVAID","MERCH_TYPE","REF_SOURCE","REP_ID","STATUS"]}';
           response.setHeader('content-type','application/json');
           response.setBody(jsonresponse);
           response.setStatusCode(200);
           return response;
    
}
}