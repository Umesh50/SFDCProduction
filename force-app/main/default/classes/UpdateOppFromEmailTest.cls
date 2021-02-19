@isTest(SeeAllData=true)
public class UpdateOppFromEmailTest{
    public static testMethod void EmailAttachmentTester(){
        
        // setup controller object
        UpdateOppFromEmail objconfirm = new UpdateOppFromEmail();
        System.debug('Im starting a method');
        
        //Create an Account for the opportunity to be created
        Account acc = new Account();
        acc.Name = 'M.Choudhury';
        acc.MID__c = '';
        insert acc;
        
        
        //create a new opportunity with email subject as job reference number
        Opportunity Opp = new Opportunity();
        Opp.Name = 'tasty test';
        Opp.Accountid = acc.id;
        Opp.StageName = 'Pre Qualification';
        Opp.closedate = Date.Today()+2;
        insert Opp;
        
        Opportunity testop1 = [select id ,Name,StageName from Opportunity where id = :Opp.id];
       testop1.Name = 'Merchant10232020rrrrrrr';
        testop1.StageName = 'Approved';
        testop1.Last_Status_Update__c = system.today();
        Account testac = [select id ,Name,MID__c from Account where id =:acc.id];
        testac.MID__c = '8036879925';
        Test.setMock(HttpCalloutMock.class, new RSI_PPMerchent_IDMockTest());
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'AppStatus -  Merchant10232020rrrrrrr';
        email.plainTextBody = 'Approved Old we have Status MID: 4567857 The';
        
        envelope.fromAddress = 'test@test.com';
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
        
        update testop1;
        
        Opportunity testop = [select id, Name from Opportunity where id = :testop1.id];
        
        List<Attachment> att = [Select id, name from Attachment where parentid = :testop.id and name = :'test.pdf'];
    
    }
    
}