/****************************************************************************************************************
 * Name...................: RSI_ApplicationNotesBatchTest 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2021
 * Description............: This test class of RSI_ApplicationNotesBatch.
 *******************************************************************************************************************/


@isTest
public class RSI_ApplicationNotesBatchTest {
    
    @testsetup private static void setup(){
        //RSI_StopRecursion.setDoNotRunTrigger();
        Account acc = new Account();
        acc.Name='Test';
        acc.Address__c='noida';
        acc.Monthly_Fee__c=123;
        acc.Country__c='USA';
        acc.Phone='9876543210';
        acc.Partner_Code__c ='R-01';
        insert acc; 
        
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='New';
        newObj.Name='TestExp';
        newObj.Business_Type__c='1';
        newObj.Beneficial_Owner_Exemption_Status__c ='FGB';
        newObj.ForecastCategoryName='Pipeline';
        newObj.Merchant_Application_No__c=42554;
        newObj.Annual_Fee_Start_Date__c = system.today();
        newObj.AccountId=acc.Id;
        insert newObj;
        
    }
    @isTest
    private static void testNotes() {
        Test.setMock(HttpCalloutMock.class, new RSI_AppNotesBatchMock());
        Test.startTest();
        Database.executeBatch(new RSI_ApplicationNotesBatch());
        Test.stopTest();   
    }

    public class RSI_AppNotesBatchMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications/42554/notes');
            HTTPResponse response = new HttpResponse();
            String jsonresponse='{"SUCCESS": true,"DATA": {"DATA": [[36605,"tanmay.jain@rsystems.com_Tanmay Jain  ","Testing.......","1/15/2021 5:12 AM","https://demo.msppulsepoint.com/Components/Obj/user.cfc?method=getAvatarBinary&username=Tanmay Jain  ","January, 15 2021 13:12:05"]],"COLUMNS": ["NotesNo","useradded","Note","DateAdded","Avatar","DateAddedNotModified"]},"RECORDCOUNT": 1}';
            response.setHeader('content-type','application/json');
            response.setBody(jsonresponse);
            response.setStatusCode(200);
            return response;
        } 
    }    
}