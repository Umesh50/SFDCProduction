/****************************************************************************************************************
 * Name...................: RSI_TestMerchantAppPulsePointSync 
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/20/2020
 * Description............: This class use to test the functionality of RSI_MerchantApplicationPulsePointSync class.
 *******************************************************************************************************************/

@isTest
public class RSI_TestMerchantAppPulsePointSync {
    
     @testsetup private static void setup(){
        Account acc=new Account();
        acc.Name='TestAccount';
        acc.Partner_Code__c='T-0002';
        insert acc;
         
        Date varDate = Date.newInstance(2020,10,9);
        Opportunity newObj=new Opportunity();
        newObj.CloseDate=varDate;
        newObj.StageName='Qualification';
         newObj.Name='TestOpp';
         newObj.Business_Type__c='1';
         newObj.Beneficial_Owner_Exemption_Status__c='FGB';
         newObj.ApplyOrder__c=0;
         newObj.SaveAsTemplate__c=0;
         newObj.MerchantApplicationTypeNo__c=4;
         newObj.ReferralNo__c=0;
         newObj.TemplateMerchantApplicationNo__c=0;
         newObj.AccountId=acc.Id;
         insert newObj;    
    }
    
    @isTest
    private static void testSyncMerchant() {
        Test.setMock(HttpCalloutMock.class, new RSI_CreateHttpCallOutMock());
        Opportunity oppObj = [Select Id,Name From Opportunity where Name='TestOpp' limit 1];
        
        Test.startTest();
        Opportunity opptyToUpd = RSI_MerchantApplicationPulsePointSync.createApplication(oppObj.id);
        system.assertEquals(42730,opptyToUpd.Merchant_Application_No__c);
        system.assertEquals(44357,opptyToUpd.Merchant_Application_Document_No__c);
        RSI_MerchantApplicationPulsePointSync.initComponent(oppObj.id);
        Test.stopTest();
    }  
    
    public class RSI_CreateHttpCallOutMock  implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            //get appkey from custom meta data using RSI_UtilityClass class
            Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
            // get app key to make a url...
            String appKey=mapOfConnection.get('APPKEY');
            if (req.getEndpoint().endsWith('forms?appkey='+appKey)) {
                HTTPResponse response = new HttpResponse();
                String jsonresponse='{"DATA" : {"COLUMNS" : ["merchantapplicationno", "merchantapplicationdocumentno", "name", "description", "status", "percentcomplete"], "DATA" : [[42730, 44357, 10011, "Merchant Application Form", "Elavon US Merchant Application", "New", 11]]}, "RECORDCOUNT" : 1, "SUCCESS" : true}';
                response.setHeader('content-type','application/json');
                response.setbody(jsonresponse);
                response.setstatuscode(200);
                return response;   
            }else if (req.getEndpoint().endsWith('applications/')) {
                //req.setEndpoint('https://api.msppulsepoint.com/demo/v1/applications');
                HTTPResponse response = new HttpResponse();
                String jsonresponse='{"MERCHANTAPPLICATIONNO" : 42730, "success" :true}';
                response.setHeader('content-type','application/json');
                response.setbody(jsonresponse);
                response.setstatuscode(200);
                return response;
            }else{
                 System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null; 
            }
            
        }
    }
}