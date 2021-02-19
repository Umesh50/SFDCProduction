@isTest
public class RSI_TrackShipmentFromRSI_FedexWsdlTest {
    
    @testsetup private static void setup(){
        Account account = new Account();
        account.Name='test';
        account.Partner_Code__c ='R-01';
        account.Tracking_Number__c ='797806677146';
        account.Shipping_Status__c ='Shipped';
        account.Current_Location__c ='International shipment release';
        insert account;
        
        Fedex__c fedex = new Fedex__c();
        fedex.Name = 'Fedex_info';
        fedex.authKey__c = 'Etyl74UgYRzxc7aD';
        fedex.authKey__c = 'y8E57mEZfoMd4LcjOZ1UEUKPX';
        insert fedex;
    }
    
  public class WebServiceMock1Impl implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               RSI_FedexWsdlToApex.SendNotificationsReply respElement = new RSI_FedexWsdlToApex.SendNotificationsReply();
               //respElement.CompletedTrackDetails = new List<RSI_FedexWsdlToApex.CompletedTrackDetail>();
               response.put('response_x', respElement);
   }
}
    
 public class WebServiceMock2Impl implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               RSI_FedexWsdlToApex.GetTrackingDocumentsReply respElement = new  RSI_FedexWsdlToApex.GetTrackingDocumentsReply();
               //respElement.CompletedTrackDetails = new List<RSI_FedexWsdlToApex.CompletedTrackDetail>();
               response.put('response_x', respElement);
   }
}    
    
    
    
public class WebServiceMockImpl implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               RSI_FedexWsdlToApex.TrackReply respElement = new RSI_FedexWsdlToApex.TrackReply();
               respElement.CompletedTrackDetails = new List<RSI_FedexWsdlToApex.CompletedTrackDetail>();
               response.put('response_x', respElement);
   }
}
   @isTest
    private static void testRSI_TrackShipmentFrom2() {
       Fedex__c FedexInfoObj = Fedex__c.getValues('Fedex_info');
        //web authentication credential key and password
        RSI_FedexWsdlToApex.WebAuthenticationCredential webAuthCredentialObj=new RSI_FedexWsdlToApex.WebAuthenticationCredential();
        webAuthCredentialObj.Key=FedexInfoObj.authKey__c;
        webAuthCredentialObj.Password= FedexInfoObj.authPassword__c; 
        
        //Localization
        RSI_FedexWsdlToApex.Localization localizationObj=new RSI_FedexWsdlToApex.Localization();
        localizationObj.LanguageCode=FedexInfoObj.LanguageCode__c;
        localizationObj.LocaleCode= FedexInfoObj.LocaleCode__c; 
        
        //transaction detail and set localization
        RSI_FedexWsdlToApex.TransactionDetail transactionDetailObj=new RSI_FedexWsdlToApex.TransactionDetail();
        transactionDetailObj.CustomerTransactionId=FedexInfoObj.CustomerTransactionId__c;
        transactionDetailObj.Localization=localizationObj;
        
        //Client details and set localization          
        RSI_FedexWsdlToApex.ClientDetail clientDetailObj=new RSI_FedexWsdlToApex.ClientDetail();
        clientDetailObj.AccountNumber= FedexInfoObj.FedEx_Shipping_Account_Number__c;
        clientDetailObj.MeterNumber=FedexInfoObj.FedEx_Meter_Number__c;
        //clientDetailObj.IntegratorId='123'; 
        clientDetailObj.Localization=localizationObj;
        
        //Version information
        RSI_FedexWsdlToApex.VersionId versionIdObj=new RSI_FedexWsdlToApex.VersionId();
        versionIdObj.Intermediate=Integer.valueOf(FedexInfoObj.Version_Intermediate__c);
        versionIdObj.Major=Integer.valueOf(FedexInfoObj.Version_Major__c);
        versionIdObj.Minor=Integer.valueOf(FedexInfoObj.Version_Minor__c);
        versionIdObj.ServiceId=FedexInfoObj.Version_ServiceId__c;
        List<String> setOfTrakNumb=new List<String>();
        setOfTrakNumb.add('797806677146');
         //selection details list or we can track up to 30 number in a single traction
        List<RSI_FedexWsdlToApex.TrackSelectionDetail> trackSelectionDetailObjList=new List<RSI_FedexWsdlToApex.TrackSelectionDetail>();
        RSI_FedexWsdlToApex.TrackPackageIdentifier trackPackageIdentifierObj;
        RSI_FedexWsdlToApex.TrackSelectionDetail trackSelectionDetailObj;
        for(String trackingNumber:setOfTrakNumb)
        {
            
            //packege identifier--- set tracking number details
            trackPackageIdentifierObj=new RSI_FedexWsdlToApex.TrackPackageIdentifier();
            trackPackageIdentifierObj.Type_x=FedexInfoObj.Package_Identifier_Type__c;
            trackPackageIdentifierObj.Value=trackingNumber; 
            
            //selection details ,set tracking number and add to sd list
            trackSelectionDetailObj=new RSI_FedexWsdlToApex.TrackSelectionDetail();
            // trackSelectionDetailObj.CarrierCode='FDXE';
            //trackSelectionDetailObj.ShipmentAccountNumber='510088000';
            trackSelectionDetailObj.PackageIdentifier=trackPackageIdentifierObj;
            trackSelectionDetailObjList.add(trackSelectionDetailObj);
        }
        
        
        
        //web auth details
        RSI_FedexWsdlToApex.WebAuthenticationDetail webAuthenticationDetailObj=new RSI_FedexWsdlToApex.WebAuthenticationDetail();
        //webAuthenticationDetailObj.ParentCredential=webAuthCredentialObj;
        webAuthenticationDetailObj.UserCredential=webAuthCredentialObj;
        //processingobj
        RSI_FedexWsdlToApex.ShipmentEventNotificationDetail NotificationDetail=new RSI_FedexWsdlToApex.ShipmentEventNotificationDetail();
       RSI_FedexWsdlToApex.TrackingDocumentSpecification  trkdoc=new RSI_FedexWsdlToApex.TrackingDocumentSpecification();
        Test.setMock(WebServiceMock.class, new WebServiceMock2Impl());
        Test.startTest();
        RSI_FedexWsdlToApex.Commodity t=new RSI_FedexWsdlToApex.Commodity();
        t.NaftaDetail =new RSI_FedexWsdlToApex.NaftaCommodityDetail();
        new RSI_FedexWsdlToApex.TrackNotificationPackage();
        new RSI_FedexWsdlToApex.ShipmentEventNotificationSpecification();
        new RSI_FedexWsdlToApex.Measure();
        new  RSI_FedexWsdlToApex.TrackingDocumentDispositionDetail();
        new RSI_FedexWsdlToApex.EdtExciseCondition();
        new RSI_FedexWsdlToApex.AppointmentTimeDetail();
        new RSI_FedexWsdlToApex.TrackingSignatureProofOfDeliveryDetail();
        new RSI_FedexWsdlToApex.TrackEvent();
        new RSI_FedexWsdlToApex.TrackingBillOfLadingDocumentDetail();
        new RSI_FedexWsdlToApex.TrackingDocument();
        new RSI_FedexWsdlToApex.DocumentPart();
        new RSI_FedexWsdlToApex.LocalTimeRange();
        new RSI_FedexWsdlToApex.TrackChargeDetail();
        new RSI_FedexWsdlToApex.NotificationParameter();
        new RSI_FedexWsdlToApex.AppointmentDetail();
        new RSI_FedexWsdlToApex.SpecialInstructionStatusDetail();
        new RSI_FedexWsdlToApex.TrackingFreightBillingDocumentDetail();
        new RSI_FedexWsdlToApex.TrackNotificationRecipientDetail();
        new RSI_FedexWsdlToApex.Money();
        new RSI_FedexWsdlToApex.DateRange();
        new RSI_FedexWsdlToApex.NotificationDetail();
        new RSI_FedexWsdlToApex.ShipmentNotificationFormatSpecification();
        new RSI_FedexWsdlToApex.PagingDetail();
        new RSI_FedexWsdlToApex.FaxDetail();
        new RSI_FedexWsdlToApex.CompletedTrackDetail();
        new RSI_FedexWsdlToApex.TrackingDocumentFormat();
        new RSI_FedexWsdlToApex.TrackingDocumentEmailDetail();
        new RSI_FedexWsdlToApex.EMailDetail();
        new RSI_FedexWsdlToApex.TrackStatusAncillaryDetail(); 
        RSI_FedexWsdlToApex.TrackServicePort trackServicePortObj=new RSI_FedexWsdlToApex.TrackServicePort();
        trackServicePortObj.getTrackingDocuments(webAuthenticationDetailObj,clientDetailObj,transactionDetailObj,versionIdObj,trackSelectionDetailObjList,trkdoc);
        Test.StopTest();
         
    }  
     
     @isTest
    private static void testRSI_TrackShipmentFrom1() {
       Fedex__c FedexInfoObj = Fedex__c.getValues('Fedex_info');
        //web authentication credential key and password
        RSI_FedexWsdlToApex.WebAuthenticationCredential webAuthCredentialObj=new RSI_FedexWsdlToApex.WebAuthenticationCredential();
        webAuthCredentialObj.Key=FedexInfoObj.authKey__c;
        webAuthCredentialObj.Password= FedexInfoObj.authPassword__c; 
        
        //Localization
        RSI_FedexWsdlToApex.Localization localizationObj=new RSI_FedexWsdlToApex.Localization();
        localizationObj.LanguageCode=FedexInfoObj.LanguageCode__c;
        localizationObj.LocaleCode= FedexInfoObj.LocaleCode__c; 
        
        //transaction detail and set localization
        RSI_FedexWsdlToApex.TransactionDetail transactionDetailObj=new RSI_FedexWsdlToApex.TransactionDetail();
        transactionDetailObj.CustomerTransactionId=FedexInfoObj.CustomerTransactionId__c;
        transactionDetailObj.Localization=localizationObj;
        
        //Client details and set localization          
        RSI_FedexWsdlToApex.ClientDetail clientDetailObj=new RSI_FedexWsdlToApex.ClientDetail();
        clientDetailObj.AccountNumber= FedexInfoObj.FedEx_Shipping_Account_Number__c;
        clientDetailObj.MeterNumber=FedexInfoObj.FedEx_Meter_Number__c;
        //clientDetailObj.IntegratorId='123'; 
        clientDetailObj.Localization=localizationObj;
        
        //Version information
        RSI_FedexWsdlToApex.VersionId versionIdObj=new RSI_FedexWsdlToApex.VersionId();
        versionIdObj.Intermediate=Integer.valueOf(FedexInfoObj.Version_Intermediate__c);
        versionIdObj.Major=Integer.valueOf(FedexInfoObj.Version_Major__c);
        versionIdObj.Minor=Integer.valueOf(FedexInfoObj.Version_Minor__c);
        versionIdObj.ServiceId=FedexInfoObj.Version_ServiceId__c;
        //web auth details
        RSI_FedexWsdlToApex.WebAuthenticationDetail webAuthenticationDetailObj=new RSI_FedexWsdlToApex.WebAuthenticationDetail();
        //webAuthenticationDetailObj.ParentCredential=webAuthCredentialObj;
        webAuthenticationDetailObj.UserCredential=webAuthCredentialObj;
        //processingobj
        List<String> processingOptionsObj=new List<String>();
        //track service port obj
        String TrackingNumber ='797806677146';
        Boolean MultiPiece = true;
        String PagingToken;
        String TrackingNumberUniqueId;
        Date ShipDateRangeBegin;
        Date ShipDateRangeEnd;
        String SenderEMailAddress;
        String SenderContactName;
        RSI_FedexWsdlToApex.ShipmentEventNotificationDetail NotificationDetail=new RSI_FedexWsdlToApex.ShipmentEventNotificationDetail();
        Test.setMock(WebServiceMock.class, new WebServiceMock1Impl());
        Test.startTest();
        RSI_FedexWsdlToApex.TrackDetail t=new RSI_FedexWsdlToApex.TrackDetail();
        t.ActualDeliveryAddress = new RSI_FedexWsdlToApex.Address();
        t.Barcode =new RSI_FedexWsdlToApex.StringBarcode();
        t.StatusDetail =new RSI_FedexWsdlToApex.TrackStatusDetail();
        new RSI_FedexWsdlToApex.TrackInformationNoteDetail();
        new RSI_FedexWsdlToApex.CustomerExceptionRequestDetail();
        t.Reconciliation =new RSI_FedexWsdlToApex.TrackReconciliation();
        t.ProductionLocationContactAndAddress =new RSI_FedexWsdlToApex.ContactAndAddress();
        new RSI_FedexWsdlToApex.TrackOtherIdentifierDetail();
        t.Service =new RSI_FedexWsdlToApex.TrackServiceDescriptionDetail();
        t.PackageWeight =new RSI_FedexWsdlToApex.Weight();
        t.PackageDimensions =new RSI_FedexWsdlToApex.Dimensions();
        t.Packaging =new RSI_FedexWsdlToApex.TrackPackagingDescriptionDetail();
        new RSI_FedexWsdlToApex.ContentRecord();
        t.ReturnDetail =new RSI_FedexWsdlToApex.TrackReturnDetail();
        new RSI_FedexWsdlToApex.CustomsOptionDetail();
        t.AdvanceNotificationDetail =new RSI_FedexWsdlToApex.TrackAdvanceNotificationDetail();
        new RSI_FedexWsdlToApex.TrackSpecialHandling();
        new RSI_FedexWsdlToApex.TrackPayment();
        t.Shipper =new RSI_FedexWsdlToApex.Contact();
        new RSI_FedexWsdlToApex.TrackingDateOrTimestamp();
        t.TotalTransitDistance =new RSI_FedexWsdlToApex.Distance();
        new RSI_FedexWsdlToApex.TrackSpecialInstruction();
        new RSI_FedexWsdlToApex.PieceCountVerificationDetail();
        new RSI_FedexWsdlToApex.AvailableImagesDetail();
        t.Signature =new RSI_FedexWsdlToApex.SignatureImageDetail();
        new RSI_FedexWsdlToApex.TrackSplitShipmentPart();
        new RSI_FedexWsdlToApex.DeliveryOptionEligibilityDetail();
        t.Notification =new  RSI_FedexWsdlToApex.Notification();
        RSI_FedexWsdlToApex.TrackServicePort trackServicePortObj=new RSI_FedexWsdlToApex.TrackServicePort();
        trackServicePortObj.sendNotifications(webAuthenticationDetailObj,clientDetailObj,transactionDetailObj,versionIdObj, TrackingNumber, MultiPiece, PagingToken, TrackingNumberUniqueId, ShipDateRangeBegin, ShipDateRangeEnd, SenderEMailAddress, SenderContactName,NotificationDetail);
       Test.StopTest();
         
    }
     
     @isTest
    private static void testRSI_TrackShipmentFrom() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        RSI_TrackShipmentFromRSI_FedexWsdlToApex s=new RSI_TrackShipmentFromRSI_FedexWsdlToApex();
        Test.startTest();
		s.execute (null) ;
        Test.StopTest();
        
    }
}