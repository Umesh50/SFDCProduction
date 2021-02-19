/*********************************************************************************************************************
 * Name...................: RSI_FedexWsdlToApex
 * Created By.............: Umesh Kumar
 * Created Date...........: 31/08/2020
 * Description............: This class use for authentication and track shipments from fedex site using tracking number.
 ************************************************************************************************************************/

public class RSI_FedexWsdlToApex {
    public class TrackSplitShipmentPart {
        public Integer PieceCount;
        public DateTime Timestamp;
        public String StatusCode;
        public String StatusDescription;
        private String[] PieceCount_type_info = new String[]{'PieceCount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusDescription_type_info = new String[]{'StatusDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PieceCount','Timestamp','StatusCode','StatusDescription'};
    }
    public class TrackNotificationPackage {
        public String TrackingNumber;
        public String TrackingNumberUniqueIdentifiers;
        public String CarrierCode;
        public Date ShipDate;
        public RSI_FedexWsdlToApex.Address Destination;
        public RSI_FedexWsdlToApex.TrackNotificationRecipientDetail[] RecipientDetails;
        private String[] TrackingNumber_type_info = new String[]{'TrackingNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumberUniqueIdentifiers_type_info = new String[]{'TrackingNumberUniqueIdentifiers','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CarrierCode_type_info = new String[]{'CarrierCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipDate_type_info = new String[]{'ShipDate','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Destination_type_info = new String[]{'Destination','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] RecipientDetails_type_info = new String[]{'RecipientDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'TrackingNumber','TrackingNumberUniqueIdentifiers','CarrierCode','ShipDate','Destination','RecipientDetails'};
    }
    public class CustomerExceptionRequestDetail {
        public String Id;
        public String StatusCode;
        public String StatusDescription;
        public DateTime CreateTime;
        private String[] Id_type_info = new String[]{'Id','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusDescription_type_info = new String[]{'StatusDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CreateTime_type_info = new String[]{'CreateTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Id','StatusCode','StatusDescription','CreateTime'};
    }
    public class Address {
        public String[] StreetLines;
        public String City;
        public String StateOrProvinceCode;
        public String PostalCode;
        public String UrbanizationCode;
        public String CountryCode;
        public String CountryName;
        public Boolean Residential;
        public String GeographicCoordinates;
        private String[] StreetLines_type_info = new String[]{'StreetLines','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] City_type_info = new String[]{'City','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StateOrProvinceCode_type_info = new String[]{'StateOrProvinceCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] UrbanizationCode_type_info = new String[]{'UrbanizationCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CountryCode_type_info = new String[]{'CountryCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CountryName_type_info = new String[]{'CountryName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Residential_type_info = new String[]{'Residential','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] GeographicCoordinates_type_info = new String[]{'GeographicCoordinates','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'StreetLines','City','StateOrProvinceCode','PostalCode','UrbanizationCode','CountryCode','CountryName','Residential','GeographicCoordinates'};
    }
    public class TrackPayment {
        public String Classification;
        public String Type_x;
        public String Description;
        private String[] Classification_type_info = new String[]{'Classification','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Classification','Type_x','Description'};
    }
    public class ShipmentEventNotificationSpecification {
        public String Role;
        public String[] Events;
        public RSI_FedexWsdlToApex.NotificationDetail NotificationDetail;
        public RSI_FedexWsdlToApex.ShipmentNotificationFormatSpecification FormatSpecification;
        private String[] Role_type_info = new String[]{'Role','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Events_type_info = new String[]{'Events','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] NotificationDetail_type_info = new String[]{'NotificationDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] FormatSpecification_type_info = new String[]{'FormatSpecification','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Role','Events','NotificationDetail','FormatSpecification'};
    }
    public class DeliveryOptionEligibilityDetail {
        public String Option;
        public String Eligibility;
        private String[] Option_type_info = new String[]{'Option','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Eligibility_type_info = new String[]{'Eligibility','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Option','Eligibility'};
    }
    public class ContentRecord {
        public String PartNumber;
        public String ItemNumber;
        public Integer ReceivedQuantity;
        public String Description;
        private String[] PartNumber_type_info = new String[]{'PartNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ItemNumber_type_info = new String[]{'ItemNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ReceivedQuantity_type_info = new String[]{'ReceivedQuantity','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PartNumber','ItemNumber','ReceivedQuantity','Description'};
    }
    public class TrackDetail {
        public RSI_FedexWsdlToApex.Notification Notification;
        public String TrackingNumber;
        public RSI_FedexWsdlToApex.StringBarcode Barcode;
        public String TrackingNumberUniqueIdentifier;
        public RSI_FedexWsdlToApex.TrackStatusDetail StatusDetail;
        public RSI_FedexWsdlToApex.TrackInformationNoteDetail[] InformationNotes;
        public RSI_FedexWsdlToApex.CustomerExceptionRequestDetail[] CustomerExceptionRequests;
        public RSI_FedexWsdlToApex.TrackReconciliation Reconciliation;
        public String ServiceCommitMessage;
        public String DestinationServiceArea;
        public String DestinationServiceAreaDescription;
        public String CarrierCode;
        public String OperatingCompany;
        public String OperatingCompanyOrCarrierDescription;
        public String CartageAgentCompanyName;
        public RSI_FedexWsdlToApex.ContactAndAddress ProductionLocationContactAndAddress;
        public RSI_FedexWsdlToApex.TrackOtherIdentifierDetail[] OtherIdentifiers;
        public String FormId;
        public RSI_FedexWsdlToApex.TrackServiceDescriptionDetail Service;
        public RSI_FedexWsdlToApex.Weight PackageWeight;
        public RSI_FedexWsdlToApex.Dimensions PackageDimensions;
        public RSI_FedexWsdlToApex.Weight PackageDimensionalWeight;
        public RSI_FedexWsdlToApex.Weight ShipmentWeight;
        public RSI_FedexWsdlToApex.TrackPackagingDescriptionDetail Packaging;
        public String PhysicalPackagingType;
        public Integer PackageSequenceNumber;
        public Integer PackageCount;
        public Integer ShipmentContentPieceCount;
        public Integer PackageContentPieceCount;
        public String CreatorSoftwareId;
        public RSI_FedexWsdlToApex.TrackChargeDetail[] Charges;
        public String NickName;
        public String Notes;
        public String[] Attributes;
        public RSI_FedexWsdlToApex.ContentRecord[] ShipmentContents;
        public String[] PackageContents;
        public String ClearanceLocationCode;
        public String ClearanceBrokerage;
        public RSI_FedexWsdlToApex.Commodity[] Commodities;
        public RSI_FedexWsdlToApex.TrackReturnDetail ReturnDetail;
        public RSI_FedexWsdlToApex.CustomsOptionDetail[] CustomsOptionDetails;
        public RSI_FedexWsdlToApex.TrackAdvanceNotificationDetail AdvanceNotificationDetail;
        public RSI_FedexWsdlToApex.TrackSpecialHandling[] SpecialHandlings;
        public RSI_FedexWsdlToApex.TrackPayment[] Payments;
        public RSI_FedexWsdlToApex.Contact Shipper;
        public String PossessionStatus;
        public RSI_FedexWsdlToApex.Address ShipperAddress;
        public RSI_FedexWsdlToApex.Address OriginLocationAddress;
        public String OriginStationId;
        public RSI_FedexWsdlToApex.TrackingDateOrTimestamp[] DatesOrTimes;
        public RSI_FedexWsdlToApex.Distance TotalTransitDistance;
        public RSI_FedexWsdlToApex.Distance DistanceToDestination;
        public RSI_FedexWsdlToApex.TrackSpecialInstruction[] SpecialInstructions;
        public RSI_FedexWsdlToApex.Contact Recipient;
        public RSI_FedexWsdlToApex.Address LastUpdatedDestinationAddress;
        public RSI_FedexWsdlToApex.Address DestinationAddress;
        public RSI_FedexWsdlToApex.Contact HoldAtLocationContact;
        public RSI_FedexWsdlToApex.Address HoldAtLocationAddress;
        public String DestinationStationId;
        public RSI_FedexWsdlToApex.Address DestinationLocationAddress;
        public String DestinationLocationType;
        public String DestinationLocationTimeZoneOffset;
        public RSI_FedexWsdlToApex.Address ActualDeliveryAddress;
        public String OfficeOrderDeliveryMethod;
        public String DeliveryLocationType;
        public String DeliveryLocationDescription;
        public Integer DeliveryAttempts;
        public String DeliverySignatureName;
        public RSI_FedexWsdlToApex.PieceCountVerificationDetail[] PieceCountVerificationDetails;
        public Integer TotalUniqueAddressCountInConsolidation;
        public RSI_FedexWsdlToApex.AvailableImagesDetail[] AvailableImages;
        public RSI_FedexWsdlToApex.SignatureImageDetail Signature;
        public String[] NotificationEventsAvailable;
        public RSI_FedexWsdlToApex.TrackSplitShipmentPart[] SplitShipmentParts;
        public RSI_FedexWsdlToApex.DeliveryOptionEligibilityDetail[] DeliveryOptionEligibilityDetails;
        public RSI_FedexWsdlToApex.TrackEvent[] Events;
        private String[] Notification_type_info = new String[]{'Notification','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumber_type_info = new String[]{'TrackingNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Barcode_type_info = new String[]{'Barcode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumberUniqueIdentifier_type_info = new String[]{'TrackingNumberUniqueIdentifier','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusDetail_type_info = new String[]{'StatusDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] InformationNotes_type_info = new String[]{'InformationNotes','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] CustomerExceptionRequests_type_info = new String[]{'CustomerExceptionRequests','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Reconciliation_type_info = new String[]{'Reconciliation','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ServiceCommitMessage_type_info = new String[]{'ServiceCommitMessage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationServiceArea_type_info = new String[]{'DestinationServiceArea','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationServiceAreaDescription_type_info = new String[]{'DestinationServiceAreaDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CarrierCode_type_info = new String[]{'CarrierCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OperatingCompany_type_info = new String[]{'OperatingCompany','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OperatingCompanyOrCarrierDescription_type_info = new String[]{'OperatingCompanyOrCarrierDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CartageAgentCompanyName_type_info = new String[]{'CartageAgentCompanyName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ProductionLocationContactAndAddress_type_info = new String[]{'ProductionLocationContactAndAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OtherIdentifiers_type_info = new String[]{'OtherIdentifiers','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] FormId_type_info = new String[]{'FormId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Service_type_info = new String[]{'Service','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageWeight_type_info = new String[]{'PackageWeight','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageDimensions_type_info = new String[]{'PackageDimensions','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageDimensionalWeight_type_info = new String[]{'PackageDimensionalWeight','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipmentWeight_type_info = new String[]{'ShipmentWeight','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Packaging_type_info = new String[]{'Packaging','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PhysicalPackagingType_type_info = new String[]{'PhysicalPackagingType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageSequenceNumber_type_info = new String[]{'PackageSequenceNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageCount_type_info = new String[]{'PackageCount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipmentContentPieceCount_type_info = new String[]{'ShipmentContentPieceCount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageContentPieceCount_type_info = new String[]{'PackageContentPieceCount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CreatorSoftwareId_type_info = new String[]{'CreatorSoftwareId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Charges_type_info = new String[]{'Charges','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] NickName_type_info = new String[]{'NickName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Notes_type_info = new String[]{'Notes','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Attributes_type_info = new String[]{'Attributes','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] ShipmentContents_type_info = new String[]{'ShipmentContents','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] PackageContents_type_info = new String[]{'PackageContents','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] ClearanceLocationCode_type_info = new String[]{'ClearanceLocationCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ClearanceBrokerage_type_info = new String[]{'ClearanceBrokerage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Commodities_type_info = new String[]{'Commodities','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] ReturnDetail_type_info = new String[]{'ReturnDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CustomsOptionDetails_type_info = new String[]{'CustomsOptionDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] AdvanceNotificationDetail_type_info = new String[]{'AdvanceNotificationDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SpecialHandlings_type_info = new String[]{'SpecialHandlings','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Payments_type_info = new String[]{'Payments','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Shipper_type_info = new String[]{'Shipper','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PossessionStatus_type_info = new String[]{'PossessionStatus','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipperAddress_type_info = new String[]{'ShipperAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OriginLocationAddress_type_info = new String[]{'OriginLocationAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OriginStationId_type_info = new String[]{'OriginStationId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DatesOrTimes_type_info = new String[]{'DatesOrTimes','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] TotalTransitDistance_type_info = new String[]{'TotalTransitDistance','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DistanceToDestination_type_info = new String[]{'DistanceToDestination','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SpecialInstructions_type_info = new String[]{'SpecialInstructions','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Recipient_type_info = new String[]{'Recipient','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] LastUpdatedDestinationAddress_type_info = new String[]{'LastUpdatedDestinationAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationAddress_type_info = new String[]{'DestinationAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] HoldAtLocationContact_type_info = new String[]{'HoldAtLocationContact','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] HoldAtLocationAddress_type_info = new String[]{'HoldAtLocationAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationStationId_type_info = new String[]{'DestinationStationId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationLocationAddress_type_info = new String[]{'DestinationLocationAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationLocationType_type_info = new String[]{'DestinationLocationType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DestinationLocationTimeZoneOffset_type_info = new String[]{'DestinationLocationTimeZoneOffset','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ActualDeliveryAddress_type_info = new String[]{'ActualDeliveryAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OfficeOrderDeliveryMethod_type_info = new String[]{'OfficeOrderDeliveryMethod','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DeliveryLocationType_type_info = new String[]{'DeliveryLocationType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DeliveryLocationDescription_type_info = new String[]{'DeliveryLocationDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DeliveryAttempts_type_info = new String[]{'DeliveryAttempts','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DeliverySignatureName_type_info = new String[]{'DeliverySignatureName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PieceCountVerificationDetails_type_info = new String[]{'PieceCountVerificationDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] TotalUniqueAddressCountInConsolidation_type_info = new String[]{'TotalUniqueAddressCountInConsolidation','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] AvailableImages_type_info = new String[]{'AvailableImages','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NotificationEventsAvailable_type_info = new String[]{'NotificationEventsAvailable','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] SplitShipmentParts_type_info = new String[]{'SplitShipmentParts','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] DeliveryOptionEligibilityDetails_type_info = new String[]{'DeliveryOptionEligibilityDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Events_type_info = new String[]{'Events','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Notification','TrackingNumber','Barcode','TrackingNumberUniqueIdentifier','StatusDetail','InformationNotes','CustomerExceptionRequests','Reconciliation','ServiceCommitMessage','DestinationServiceArea','DestinationServiceAreaDescription','CarrierCode','OperatingCompany','OperatingCompanyOrCarrierDescription','CartageAgentCompanyName','ProductionLocationContactAndAddress','OtherIdentifiers','FormId','Service','PackageWeight','PackageDimensions','PackageDimensionalWeight','ShipmentWeight','Packaging','PhysicalPackagingType','PackageSequenceNumber','PackageCount','ShipmentContentPieceCount','PackageContentPieceCount','CreatorSoftwareId','Charges','NickName','Notes','Attributes','ShipmentContents','PackageContents','ClearanceLocationCode','ClearanceBrokerage','Commodities','ReturnDetail','CustomsOptionDetails','AdvanceNotificationDetail','SpecialHandlings','Payments','Shipper','PossessionStatus','ShipperAddress','OriginLocationAddress','OriginStationId','DatesOrTimes','TotalTransitDistance','DistanceToDestination','SpecialInstructions','Recipient','LastUpdatedDestinationAddress','DestinationAddress','HoldAtLocationContact','HoldAtLocationAddress','DestinationStationId','DestinationLocationAddress','DestinationLocationType','DestinationLocationTimeZoneOffset','ActualDeliveryAddress','OfficeOrderDeliveryMethod','DeliveryLocationType','DeliveryLocationDescription','DeliveryAttempts','DeliverySignatureName','PieceCountVerificationDetails','TotalUniqueAddressCountInConsolidation','AvailableImages','Signature','NotificationEventsAvailable','SplitShipmentParts','DeliveryOptionEligibilityDetails','Events'};
    }
    public class Measure {
        public Decimal Quantity;
        public String Units;
        private String[] Quantity_type_info = new String[]{'Quantity','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Units_type_info = new String[]{'Units','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Quantity','Units'};
    }
    public class TrackingDocumentDispositionDetail {
        public String DispositionType;
        public RSI_FedexWsdlToApex.TrackingDocumentEmailDetail EMailDetail;
        public RSI_FedexWsdlToApex.FaxDetail[] FaxDetails;
        private String[] DispositionType_type_info = new String[]{'DispositionType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EMailDetail_type_info = new String[]{'EMailDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] FaxDetails_type_info = new String[]{'FaxDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'DispositionType','EMailDetail','FaxDetails'};
    }
    public class Distance {
        public Decimal Value;
        public String Units;
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Units_type_info = new String[]{'Units','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Value','Units'};
    }
    public class TrackingDocumentSpecification {
        public String[] DocumentTypes;
        public RSI_FedexWsdlToApex.TrackingBillOfLadingDocumentDetail BillOfLadingDocumentDetail;
        public RSI_FedexWsdlToApex.TrackingFreightBillingDocumentDetail FreightBillingDocumentDetail;
        public RSI_FedexWsdlToApex.TrackingSignatureProofOfDeliveryDetail SignatureProofOfDeliveryDetail;
        private String[] DocumentTypes_type_info = new String[]{'DocumentTypes','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] BillOfLadingDocumentDetail_type_info = new String[]{'BillOfLadingDocumentDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] FreightBillingDocumentDetail_type_info = new String[]{'FreightBillingDocumentDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SignatureProofOfDeliveryDetail_type_info = new String[]{'SignatureProofOfDeliveryDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'DocumentTypes','BillOfLadingDocumentDetail','FreightBillingDocumentDetail','SignatureProofOfDeliveryDetail'};
    }
    public class EdtExciseCondition {
        public String Category;
        public String Value;
        private String[] Category_type_info = new String[]{'Category','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Category','Value'};
    }
    public class AppointmentTimeDetail {
        public String Type_x;
        public RSI_FedexWsdlToApex.LocalTimeRange Window;
        public String Description;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Window_type_info = new String[]{'Window','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Window','Description'};
    }
    public class TrackingSignatureProofOfDeliveryDetail {
        public RSI_FedexWsdlToApex.TrackingDocumentFormat DocumentFormat;
        private String[] DocumentFormat_type_info = new String[]{'DocumentFormat','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'DocumentFormat'};
    }
    public class TrackEvent {
        public DateTime Timestamp;
        public String EventType;
        public String EventDescription;
        public String StatusExceptionCode;
        public String StatusExceptionDescription;
        public String BarcodeEntryType;
        public RSI_FedexWsdlToApex.Address Address;
        public String StationId;
        public String ArrivalLocation;
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EventType_type_info = new String[]{'EventType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EventDescription_type_info = new String[]{'EventDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusExceptionCode_type_info = new String[]{'StatusExceptionCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusExceptionDescription_type_info = new String[]{'StatusExceptionDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] BarcodeEntryType_type_info = new String[]{'BarcodeEntryType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StationId_type_info = new String[]{'StationId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ArrivalLocation_type_info = new String[]{'ArrivalLocation','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Timestamp','EventType','EventDescription','StatusExceptionCode','StatusExceptionDescription','BarcodeEntryType','Address','StationId','ArrivalLocation'};
    }
    public class TrackInformationNoteDetail {
        public String Code;
        public String Description;
        private String[] Code_type_info = new String[]{'Code','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Code','Description'};
    }
    public class TrackSpecialInstruction {
        public String Description;
        public String DeliveryOption;
        public RSI_FedexWsdlToApex.SpecialInstructionStatusDetail StatusDetail;
        public DateTime OriginalEstimatedDeliveryTimestamp;
        public DateTime OriginalRequestTime;
        public RSI_FedexWsdlToApex.AppointmentDetail RequestedAppointmentTime;
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DeliveryOption_type_info = new String[]{'DeliveryOption','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusDetail_type_info = new String[]{'StatusDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OriginalEstimatedDeliveryTimestamp_type_info = new String[]{'OriginalEstimatedDeliveryTimestamp','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OriginalRequestTime_type_info = new String[]{'OriginalRequestTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] RequestedAppointmentTime_type_info = new String[]{'RequestedAppointmentTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Description','DeliveryOption','StatusDetail','OriginalEstimatedDeliveryTimestamp','OriginalRequestTime','RequestedAppointmentTime'};
    }
    public class TrackingBillOfLadingDocumentDetail {
        public RSI_FedexWsdlToApex.TrackingDocumentFormat DocumentFormat;
        private String[] DocumentFormat_type_info = new String[]{'DocumentFormat','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'DocumentFormat'};
    }
    public class TrackServiceDescriptionDetail {
        public String Type_x;
        public String Description;
        public String ShortDescription;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShortDescription_type_info = new String[]{'ShortDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Description','ShortDescription'};
    }
    public class Weight {
        public String Units;
        public Decimal Value;
        private String[] Units_type_info = new String[]{'Units','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Units','Value'};
    }
    public class TrackingDocument {
        public String Type_x;
        public RSI_FedexWsdlToApex.Localization[] Localizations;
        public String ImageType;
        public Integer Resolution;
        public RSI_FedexWsdlToApex.DocumentPart[] Parts;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localizations_type_info = new String[]{'Localizations','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] ImageType_type_info = new String[]{'ImageType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Resolution_type_info = new String[]{'Resolution','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Parts_type_info = new String[]{'Parts','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Localizations','ImageType','Resolution','Parts'};
    }
    public class DocumentPart {
        public Integer SequenceNumber;
        public String Content;
        private String[] SequenceNumber_type_info = new String[]{'SequenceNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Content_type_info = new String[]{'Content','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'SequenceNumber','Content'};
    }
    public class LocalTimeRange {
        public String Begins;
        public String Ends;
        private String[] Begins_type_info = new String[]{'Begins','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Ends_type_info = new String[]{'Ends','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Begins','Ends'};
    }
    public class ShipmentEventNotificationDetail {
        public String AggregationType;
        public String PersonalMessage;
        public RSI_FedexWsdlToApex.ShipmentEventNotificationSpecification[] EventNotifications;
        private String[] AggregationType_type_info = new String[]{'AggregationType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PersonalMessage_type_info = new String[]{'PersonalMessage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EventNotifications_type_info = new String[]{'EventNotifications','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'AggregationType','PersonalMessage','EventNotifications'};
    }
    public class TrackStatusDetail {
        public DateTime CreationTime;
        public String Code;
        public String Description;
        public RSI_FedexWsdlToApex.Address Location;
        public RSI_FedexWsdlToApex.TrackStatusAncillaryDetail[] AncillaryDetails;
        private String[] CreationTime_type_info = new String[]{'CreationTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Code_type_info = new String[]{'Code','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Location_type_info = new String[]{'Location','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] AncillaryDetails_type_info = new String[]{'AncillaryDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'CreationTime','Code','Description','Location','AncillaryDetails'};
    }
    public class TrackAdvanceNotificationDetail {
        public DateTime EstimatedTimeOfArrival;
        public String Reason;
        public String Status;
        public String StatusDescription;
        public DateTime StatusTime;
        private String[] EstimatedTimeOfArrival_type_info = new String[]{'EstimatedTimeOfArrival','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Reason_type_info = new String[]{'Reason','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusDescription_type_info = new String[]{'StatusDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusTime_type_info = new String[]{'StatusTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'EstimatedTimeOfArrival','Reason','Status','StatusDescription','StatusTime'};
    }
    public class TrackChargeDetail {
        public String Type_x;
        public RSI_FedexWsdlToApex.Money ChargeAmount;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ChargeAmount_type_info = new String[]{'ChargeAmount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','ChargeAmount'};
    }
    public class TrackReconciliation {
        public String Status;
        public String Description;
        private String[] Status_type_info = new String[]{'Status','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Status','Description'};
    }
    public class TrackSelectionDetail {
        public String CarrierCode;
        public String OperatingCompany;
        public RSI_FedexWsdlToApex.TrackPackageIdentifier PackageIdentifier;
        public String TrackingNumberUniqueIdentifier;
        public Date ShipDateRangeBegin;
        public Date ShipDateRangeEnd;
        public String ShipmentAccountNumber;
        public String SecureSpodAccount;
        public RSI_FedexWsdlToApex.Address Destination;
        public RSI_FedexWsdlToApex.PagingDetail PagingDetail;
        public Integer CustomerSpecifiedTimeOutValueInMilliseconds;
        private String[] CarrierCode_type_info = new String[]{'CarrierCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] OperatingCompany_type_info = new String[]{'OperatingCompany','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PackageIdentifier_type_info = new String[]{'PackageIdentifier','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumberUniqueIdentifier_type_info = new String[]{'TrackingNumberUniqueIdentifier','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipDateRangeBegin_type_info = new String[]{'ShipDateRangeBegin','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipDateRangeEnd_type_info = new String[]{'ShipDateRangeEnd','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipmentAccountNumber_type_info = new String[]{'ShipmentAccountNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SecureSpodAccount_type_info = new String[]{'SecureSpodAccount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Destination_type_info = new String[]{'Destination','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PagingDetail_type_info = new String[]{'PagingDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CustomerSpecifiedTimeOutValueInMilliseconds_type_info = new String[]{'CustomerSpecifiedTimeOutValueInMilliseconds','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'CarrierCode','OperatingCompany','PackageIdentifier','TrackingNumberUniqueIdentifier','ShipDateRangeBegin','ShipDateRangeEnd','ShipmentAccountNumber','SecureSpodAccount','Destination','PagingDetail','CustomerSpecifiedTimeOutValueInMilliseconds'};
    }
    public class NotificationParameter {
        public String Id;
        public String Value;
        private String[] Id_type_info = new String[]{'Id','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Id','Value'};
    }
    public class AppointmentDetail {
        public Date Date_x;
        public RSI_FedexWsdlToApex.AppointmentTimeDetail[] WindowDetails;
        private String[] Date_x_type_info = new String[]{'Date','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] WindowDetails_type_info = new String[]{'WindowDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Date_x','WindowDetails'};
    }
    public class SpecialInstructionStatusDetail {
        public String Status;
        public DateTime StatusCreateTime;
        private String[] Status_type_info = new String[]{'Status','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] StatusCreateTime_type_info = new String[]{'StatusCreateTime','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Status','StatusCreateTime'};
    }
    public class StringBarcode {
        public String Type_x;
        public String Value;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Value'};
    }
    public class TrackingFreightBillingDocumentDetail {
        public RSI_FedexWsdlToApex.TrackingDocumentFormat DocumentFormat;
        private String[] DocumentFormat_type_info = new String[]{'DocumentFormat','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'DocumentFormat'};
    }
    public class TrackOtherIdentifierDetail {
        public RSI_FedexWsdlToApex.TrackPackageIdentifier PackageIdentifier;
        public String TrackingNumberUniqueIdentifier;
        public String CarrierCode;
        private String[] PackageIdentifier_type_info = new String[]{'PackageIdentifier','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumberUniqueIdentifier_type_info = new String[]{'TrackingNumberUniqueIdentifier','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CarrierCode_type_info = new String[]{'CarrierCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PackageIdentifier','TrackingNumberUniqueIdentifier','CarrierCode'};
    }
    public class TrackReply {
        public String HighestSeverity;
        public RSI_FedexWsdlToApex.Notification[] Notifications;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public RSI_FedexWsdlToApex.CompletedTrackDetail[] CompletedTrackDetails;
        private String[] HighestSeverity_type_info = new String[]{'HighestSeverity','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Notifications_type_info = new String[]{'Notifications','http://fedex.com/ws/track/v19',null,'1','-1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] CompletedTrackDetails_type_info = new String[]{'CompletedTrackDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'HighestSeverity','Notifications','TransactionDetail','Version','CompletedTrackDetails'};
    }
    public class AvailableImagesDetail {
        public String Type_x;
        public String Size;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Size_type_info = new String[]{'Size','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Size'};
    }
    public class NaftaCommodityDetail {
        public String PreferenceCriterion;
        public String ProducerDetermination;
        public String ProducerId;
        public String NetCostMethod;
        public RSI_FedexWsdlToApex.DateRange NetCostDateRange;
        private String[] PreferenceCriterion_type_info = new String[]{'PreferenceCriterion','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ProducerDetermination_type_info = new String[]{'ProducerDetermination','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ProducerId_type_info = new String[]{'ProducerId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NetCostMethod_type_info = new String[]{'NetCostMethod','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NetCostDateRange_type_info = new String[]{'NetCostDateRange','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PreferenceCriterion','ProducerDetermination','ProducerId','NetCostMethod','NetCostDateRange'};
    }
    public class TrackNotificationRecipientDetail {
        public String[] NotificationEventsAvailable;
        private String[] NotificationEventsAvailable_type_info = new String[]{'NotificationEventsAvailable','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'NotificationEventsAvailable'};
    }
    public class Notification {
        public String Severity;
        public String Source;
        public String Code;
        public String Message;
        public String LocalizedMessage;
        public RSI_FedexWsdlToApex.NotificationParameter[] MessageParameters;
        private String[] Severity_type_info = new String[]{'Severity','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Source_type_info = new String[]{'Source','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Code_type_info = new String[]{'Code','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] LocalizedMessage_type_info = new String[]{'LocalizedMessage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] MessageParameters_type_info = new String[]{'MessageParameters','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Severity','Source','Code','Message','LocalizedMessage','MessageParameters'};
    }
    public class SendNotificationsRequest {
        public RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail;
        public RSI_FedexWsdlToApex.ClientDetail ClientDetail;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public String TrackingNumber;
        public Boolean MultiPiece;
        public String PagingToken;
        public String TrackingNumberUniqueId;
        public Date ShipDateRangeBegin;
        public Date ShipDateRangeEnd;
        public String SenderEMailAddress;
        public String SenderContactName;
        public RSI_FedexWsdlToApex.ShipmentEventNotificationDetail EventNotificationDetail;
        private String[] WebAuthenticationDetail_type_info = new String[]{'WebAuthenticationDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] ClientDetail_type_info = new String[]{'ClientDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] TrackingNumber_type_info = new String[]{'TrackingNumber','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] MultiPiece_type_info = new String[]{'MultiPiece','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PagingToken_type_info = new String[]{'PagingToken','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackingNumberUniqueId_type_info = new String[]{'TrackingNumberUniqueId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipDateRangeBegin_type_info = new String[]{'ShipDateRangeBegin','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ShipDateRangeEnd_type_info = new String[]{'ShipDateRangeEnd','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SenderEMailAddress_type_info = new String[]{'SenderEMailAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] SenderContactName_type_info = new String[]{'SenderContactName','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] EventNotificationDetail_type_info = new String[]{'EventNotificationDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'WebAuthenticationDetail','ClientDetail','TransactionDetail','Version','TrackingNumber','MultiPiece','PagingToken','TrackingNumberUniqueId','ShipDateRangeBegin','ShipDateRangeEnd','SenderEMailAddress','SenderContactName','EventNotificationDetail'};
    }
    public class Money {
        public String Currency_x;
        public Decimal Amount;
        private String[] Currency_x_type_info = new String[]{'Currency','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Amount_type_info = new String[]{'Amount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Currency_x','Amount'};
    }
    public class DateRange {
        public Date Begins;
        public Date Ends;
        private String[] Begins_type_info = new String[]{'Begins','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Ends_type_info = new String[]{'Ends','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Begins','Ends'};
    }
    public class Commodity {
        public String CommodityId;
        public String Name;
        public Integer NumberOfPieces;
        public String Description;
        public String Purpose;
        public String CountryOfManufacture;
        public String HarmonizedCode;
        public RSI_FedexWsdlToApex.Weight Weight;
        public Decimal Quantity;
        public String QuantityUnits;
        public RSI_FedexWsdlToApex.Measure[] AdditionalMeasures;
        public RSI_FedexWsdlToApex.Money UnitPrice;
        public RSI_FedexWsdlToApex.Money CustomsValue;
        public RSI_FedexWsdlToApex.EdtExciseCondition[] ExciseConditions;
        public String ExportLicenseNumber;
        public Date ExportLicenseExpirationDate;
        public String CIMarksAndNumbers;
        public String PartNumber;
        public RSI_FedexWsdlToApex.NaftaCommodityDetail NaftaDetail;
        private String[] CommodityId_type_info = new String[]{'CommodityId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NumberOfPieces_type_info = new String[]{'NumberOfPieces','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Purpose_type_info = new String[]{'Purpose','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CountryOfManufacture_type_info = new String[]{'CountryOfManufacture','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] HarmonizedCode_type_info = new String[]{'HarmonizedCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Weight_type_info = new String[]{'Weight','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Quantity_type_info = new String[]{'Quantity','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] QuantityUnits_type_info = new String[]{'QuantityUnits','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] AdditionalMeasures_type_info = new String[]{'AdditionalMeasures','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] UnitPrice_type_info = new String[]{'UnitPrice','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CustomsValue_type_info = new String[]{'CustomsValue','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ExciseConditions_type_info = new String[]{'ExciseConditions','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] ExportLicenseNumber_type_info = new String[]{'ExportLicenseNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ExportLicenseExpirationDate_type_info = new String[]{'ExportLicenseExpirationDate','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CIMarksAndNumbers_type_info = new String[]{'CIMarksAndNumbers','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PartNumber_type_info = new String[]{'PartNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NaftaDetail_type_info = new String[]{'NaftaDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'CommodityId','Name','NumberOfPieces','Description','Purpose','CountryOfManufacture','HarmonizedCode','Weight','Quantity','QuantityUnits','AdditionalMeasures','UnitPrice','CustomsValue','ExciseConditions','ExportLicenseNumber','ExportLicenseExpirationDate','CIMarksAndNumbers','PartNumber','NaftaDetail'};
    }
    public class WebAuthenticationCredential {
        public String Key;
        public String Password;
        private String[] Key_type_info = new String[]{'Key','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Key','Password'};
    }
    public class GetTrackingDocumentsRequest {
        public RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail;
        public RSI_FedexWsdlToApex.ClientDetail ClientDetail;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public RSI_FedexWsdlToApex.TrackSelectionDetail[] SelectionDetails;
        public RSI_FedexWsdlToApex.TrackingDocumentSpecification TrackingDocumentSpecification;
        private String[] WebAuthenticationDetail_type_info = new String[]{'WebAuthenticationDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] ClientDetail_type_info = new String[]{'ClientDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] SelectionDetails_type_info = new String[]{'SelectionDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] TrackingDocumentSpecification_type_info = new String[]{'TrackingDocumentSpecification','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'WebAuthenticationDetail','ClientDetail','TransactionDetail','Version','SelectionDetails','TrackingDocumentSpecification'};
    }
    public class TransactionDetail {
        public String CustomerTransactionId;
        public RSI_FedexWsdlToApex.Localization Localization;
        private String[] CustomerTransactionId_type_info = new String[]{'CustomerTransactionId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localization_type_info = new String[]{'Localization','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'CustomerTransactionId','Localization'};
    }
    public class Localization {
        public String LanguageCode;
        public String LocaleCode;
        private String[] LanguageCode_type_info = new String[]{'LanguageCode','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] LocaleCode_type_info = new String[]{'LocaleCode','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'LanguageCode','LocaleCode'};
    }
    public class WebAuthenticationDetail {
        public RSI_FedexWsdlToApex.WebAuthenticationCredential ParentCredential;
        public RSI_FedexWsdlToApex.WebAuthenticationCredential UserCredential;
        private String[] ParentCredential_type_info = new String[]{'ParentCredential','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] UserCredential_type_info = new String[]{'UserCredential','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'ParentCredential','UserCredential'};
    }
    public class ClientDetail {
        public String AccountNumber;
        public String MeterNumber;
        public String IntegratorId;
        public RSI_FedexWsdlToApex.Localization Localization;
        private String[] AccountNumber_type_info = new String[]{'AccountNumber','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] MeterNumber_type_info = new String[]{'MeterNumber','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] IntegratorId_type_info = new String[]{'IntegratorId','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localization_type_info = new String[]{'Localization','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'AccountNumber','MeterNumber','IntegratorId','Localization'};
    }
    public class TrackSpecialHandling {
        public String Type_x;
        public String Description;
        public String PaymentType;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PaymentType_type_info = new String[]{'PaymentType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Description','PaymentType'};
    }
    public class VersionId {
        public String ServiceId;
        public Integer Major;
        public Integer Intermediate;
        public Integer Minor;
        private String[] ServiceId_type_info = new String[]{'ServiceId','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Major_type_info = new String[]{'Major','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Intermediate_type_info = new String[]{'Intermediate','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Minor_type_info = new String[]{'Minor','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'ServiceId','Major','Intermediate','Minor'};
    }
    public class NotificationDetail {
        public String NotificationType;
        public RSI_FedexWsdlToApex.EMailDetail EmailDetail;
        public RSI_FedexWsdlToApex.Localization Localization;
        private String[] NotificationType_type_info = new String[]{'NotificationType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EmailDetail_type_info = new String[]{'EmailDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localization_type_info = new String[]{'Localization','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'NotificationType','EmailDetail','Localization'};
    }
    public class TrackReturnDetail {
        public String MovementStatus;
        public String LabelType;
        public String Description;
        public String AuthorizationName;
        private String[] MovementStatus_type_info = new String[]{'MovementStatus','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] LabelType_type_info = new String[]{'LabelType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] AuthorizationName_type_info = new String[]{'AuthorizationName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'MovementStatus','LabelType','Description','AuthorizationName'};
    }
    public class ShipmentNotificationFormatSpecification {
        public String Type_x;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x'};
    }
    public class PagingDetail {
        public String PagingToken;
        public Integer NumberOfResultsPerPage;
        private String[] PagingToken_type_info = new String[]{'PagingToken','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] NumberOfResultsPerPage_type_info = new String[]{'NumberOfResultsPerPage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PagingToken','NumberOfResultsPerPage'};
    }
    public class SendNotificationsReply {
        public String HighestSeverity;
        public RSI_FedexWsdlToApex.Notification[] Notifications;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public Boolean DuplicateWaybill;
        public Boolean MoreDataAvailable;
        public String PagingToken;
        public RSI_FedexWsdlToApex.TrackNotificationPackage[] Packages;
        private String[] HighestSeverity_type_info = new String[]{'HighestSeverity','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Notifications_type_info = new String[]{'Notifications','http://fedex.com/ws/track/v19',null,'1','-1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] DuplicateWaybill_type_info = new String[]{'DuplicateWaybill','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] MoreDataAvailable_type_info = new String[]{'MoreDataAvailable','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PagingToken_type_info = new String[]{'PagingToken','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Packages_type_info = new String[]{'Packages','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'HighestSeverity','Notifications','TransactionDetail','Version','DuplicateWaybill','MoreDataAvailable','PagingToken','Packages'};
    }
    public class Dimensions {
        public Integer Length;
        public Integer Width;
        public Integer Height;
        public String Units;
        private String[] Length_type_info = new String[]{'Length','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Width_type_info = new String[]{'Width','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Height_type_info = new String[]{'Height','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Units_type_info = new String[]{'Units','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Length','Width','Height','Units'};
    }
    public class PieceCountVerificationDetail {
        public String CountLocationType;
        public Integer Count;
        public String Description;
        private String[] CountLocationType_type_info = new String[]{'CountLocationType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Count_type_info = new String[]{'Count','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'CountLocationType','Count','Description'};
    }
    public class TrackingDateOrTimestamp {
        public String Type_x;
        public String DateOrTimestamp;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] DateOrTimestamp_type_info = new String[]{'DateOrTimestamp','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','DateOrTimestamp'};
    }
    public class FaxDetail {
        public String PhoneNumber;
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PhoneNumber'};
    }
    public class TrackPackageIdentifier {
        public String Type_x;
        public String Value;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Value'};
    }
    public class Contact {
        public String PersonName;
        public String Title;
        public String CompanyName;
        public String PhoneNumber;
        public String PhoneExtension;
        public String TollFreePhoneNumber;
        public String PagerNumber;
        public String FaxNumber;
        public String EMailAddress;
        private String[] PersonName_type_info = new String[]{'PersonName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Title_type_info = new String[]{'Title','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PhoneExtension_type_info = new String[]{'PhoneExtension','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TollFreePhoneNumber_type_info = new String[]{'TollFreePhoneNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PagerNumber_type_info = new String[]{'PagerNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] FaxNumber_type_info = new String[]{'FaxNumber','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] EMailAddress_type_info = new String[]{'EMailAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'PersonName','Title','CompanyName','PhoneNumber','PhoneExtension','TollFreePhoneNumber','PagerNumber','FaxNumber','EMailAddress'};
    }
    public class CompletedTrackDetail {
        public String HighestSeverity;
        public RSI_FedexWsdlToApex.Notification[] Notifications;
        public Boolean DuplicateWaybill;
        public Boolean MoreData;
        public String PagingToken;
        public Integer TrackDetailsCount;
        public RSI_FedexWsdlToApex.TrackDetail[] TrackDetails;
        private String[] HighestSeverity_type_info = new String[]{'HighestSeverity','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Notifications_type_info = new String[]{'Notifications','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] DuplicateWaybill_type_info = new String[]{'DuplicateWaybill','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] MoreData_type_info = new String[]{'MoreData','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PagingToken_type_info = new String[]{'PagingToken','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackDetailsCount_type_info = new String[]{'TrackDetailsCount','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] TrackDetails_type_info = new String[]{'TrackDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'HighestSeverity','Notifications','DuplicateWaybill','MoreData','PagingToken','TrackDetailsCount','TrackDetails'};
    }
    public class TrackRequest {
        public RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail;
        public RSI_FedexWsdlToApex.ClientDetail ClientDetail;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public RSI_FedexWsdlToApex.TrackSelectionDetail[] SelectionDetails;
        public Integer TransactionTimeOutValueInMilliseconds;
        public String[] ProcessingOptions;
        private String[] WebAuthenticationDetail_type_info = new String[]{'WebAuthenticationDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] ClientDetail_type_info = new String[]{'ClientDetail','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] SelectionDetails_type_info = new String[]{'SelectionDetails','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] TransactionTimeOutValueInMilliseconds_type_info = new String[]{'TransactionTimeOutValueInMilliseconds','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ProcessingOptions_type_info = new String[]{'ProcessingOptions','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'WebAuthenticationDetail','ClientDetail','TransactionDetail','Version','SelectionDetails','TransactionTimeOutValueInMilliseconds','ProcessingOptions'};
    }
    public class TrackingDocumentFormat {
        public RSI_FedexWsdlToApex.TrackingDocumentDispositionDetail[] Dispositions;
        public String Grouping;
        public String ImageType;
        public RSI_FedexWsdlToApex.Localization Localization;
        private String[] Dispositions_type_info = new String[]{'Dispositions','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Grouping_type_info = new String[]{'Grouping','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ImageType_type_info = new String[]{'ImageType','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localization_type_info = new String[]{'Localization','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Dispositions','Grouping','ImageType','Localization'};
    }
    public class TrackingDocumentEmailDetail {
        public RSI_FedexWsdlToApex.EMailDetail[] Recipients;
        public RSI_FedexWsdlToApex.EMailDetail Sender;
        public RSI_FedexWsdlToApex.Localization Localization;
        public String PersonalMessage;
        private String[] Recipients_type_info = new String[]{'Recipients','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] Sender_type_info = new String[]{'Sender','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Localization_type_info = new String[]{'Localization','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] PersonalMessage_type_info = new String[]{'PersonalMessage','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Recipients','Sender','Localization','PersonalMessage'};
    }
    public class CustomsOptionDetail {
        public String Type_x;
        public String Description;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Description'};
    }
    public class EMailDetail {
        public String EmailAddress;
        public String Name;
        private String[] EmailAddress_type_info = new String[]{'EmailAddress','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'EmailAddress','Name'};
    }
    public class GetTrackingDocumentsReply {
        public String HighestSeverity;
        public RSI_FedexWsdlToApex.Notification[] Notifications;
        public RSI_FedexWsdlToApex.TransactionDetail TransactionDetail;
        public RSI_FedexWsdlToApex.VersionId Version;
        public RSI_FedexWsdlToApex.TrackingDocument[] Documents;
        private String[] HighestSeverity_type_info = new String[]{'HighestSeverity','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Notifications_type_info = new String[]{'Notifications','http://fedex.com/ws/track/v19',null,'1','-1','false'};
        private String[] TransactionDetail_type_info = new String[]{'TransactionDetail','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Version_type_info = new String[]{'Version','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Documents_type_info = new String[]{'Documents','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'HighestSeverity','Notifications','TransactionDetail','Version','Documents'};
    }
    public class TrackPackagingDescriptionDetail {
        public String Type_x;
        public String Description;
        private String[] Type_x_type_info = new String[]{'Type','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Description'};
    }
    public class ContactAndAddress {
        public RSI_FedexWsdlToApex.Contact Contact;
        public RSI_FedexWsdlToApex.Address Address;
        private String[] Contact_type_info = new String[]{'Contact','http://fedex.com/ws/track/v19',null,'1','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Contact','Address'};
    }
    public class SignatureImageDetail {
        public String Image;
        public RSI_FedexWsdlToApex.Notification[] Notifications;
        private String[] Image_type_info = new String[]{'Image','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Notifications_type_info = new String[]{'Notifications','http://fedex.com/ws/track/v19',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Image','Notifications'};
    }
    public class TrackStatusAncillaryDetail {
        public String Reason;
        public String ReasonDescription;
        public String Action;
        public String ActionDescription;
        private String[] Reason_type_info = new String[]{'Reason','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ReasonDescription_type_info = new String[]{'ReasonDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] Action_type_info = new String[]{'Action','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] ActionDescription_type_info = new String[]{'ActionDescription','http://fedex.com/ws/track/v19',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fedex.com/ws/track/v19','true','true'};
        private String[] field_order_type_info = new String[]{'Reason','ReasonDescription','Action','ActionDescription'};
    }
    public class TrackServicePort {
        public String endpoint_x = 'https://wsbeta.fedex.com:443/web-services/track';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://fedex.com/ws/track/v19', 'RSI_FedexWsdlToApex'};
        public RSI_FedexWsdlToApex.GetTrackingDocumentsReply getTrackingDocuments(RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail,RSI_FedexWsdlToApex.ClientDetail ClientDetail,RSI_FedexWsdlToApex.TransactionDetail TransactionDetail,RSI_FedexWsdlToApex.VersionId Version,RSI_FedexWsdlToApex.TrackSelectionDetail[] SelectionDetails,RSI_FedexWsdlToApex.TrackingDocumentSpecification TrackingDocumentSpecification) {
            RSI_FedexWsdlToApex.GetTrackingDocumentsRequest request_x = new RSI_FedexWsdlToApex.GetTrackingDocumentsRequest();
            request_x.WebAuthenticationDetail = WebAuthenticationDetail;
            request_x.ClientDetail = ClientDetail;
            request_x.TransactionDetail = TransactionDetail;
            request_x.Version = Version;
            request_x.SelectionDetails = SelectionDetails;
            request_x.TrackingDocumentSpecification = TrackingDocumentSpecification;
            RSI_FedexWsdlToApex.GetTrackingDocumentsReply response_x;
            Map<String, RSI_FedexWsdlToApex.GetTrackingDocumentsReply> response_map_x = new Map<String, RSI_FedexWsdlToApex.GetTrackingDocumentsReply>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://fedex.com/ws/track/v19/getTrackingDocuments',
              'http://fedex.com/ws/track/v19',
              'GetTrackingDocumentsRequest',
              'http://fedex.com/ws/track/v19',
              'GetTrackingDocumentsReply',
              'RSI_FedexWsdlToApex.GetTrackingDocumentsReply'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public RSI_FedexWsdlToApex.SendNotificationsReply sendNotifications(RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail,RSI_FedexWsdlToApex.ClientDetail ClientDetail,RSI_FedexWsdlToApex.TransactionDetail TransactionDetail,RSI_FedexWsdlToApex.VersionId Version,String TrackingNumber,Boolean MultiPiece,String PagingToken,String TrackingNumberUniqueId,Date ShipDateRangeBegin,Date ShipDateRangeEnd,String SenderEMailAddress,String SenderContactName,RSI_FedexWsdlToApex.ShipmentEventNotificationDetail EventNotificationDetail) {
            RSI_FedexWsdlToApex.SendNotificationsRequest request_x = new RSI_FedexWsdlToApex.SendNotificationsRequest();
            request_x.WebAuthenticationDetail = WebAuthenticationDetail;
            request_x.ClientDetail = ClientDetail;
            request_x.TransactionDetail = TransactionDetail;
            request_x.Version = Version;
            request_x.TrackingNumber = TrackingNumber;
            request_x.MultiPiece = MultiPiece;
            request_x.PagingToken = PagingToken;
            request_x.TrackingNumberUniqueId = TrackingNumberUniqueId;
            request_x.ShipDateRangeBegin = ShipDateRangeBegin;
            request_x.ShipDateRangeEnd = ShipDateRangeEnd;
            request_x.SenderEMailAddress = SenderEMailAddress;
            request_x.SenderContactName = SenderContactName;
            request_x.EventNotificationDetail = EventNotificationDetail;
            RSI_FedexWsdlToApex.SendNotificationsReply response_x;
            Map<String, RSI_FedexWsdlToApex.SendNotificationsReply> response_map_x = new Map<String, RSI_FedexWsdlToApex.SendNotificationsReply>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://fedex.com/ws/track/v19/sendNotifications',
              'http://fedex.com/ws/track/v19',
              'SendNotificationsRequest',
              'http://fedex.com/ws/track/v19',
              'SendNotificationsReply',
              'RSI_FedexWsdlToApex.SendNotificationsReply'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public RSI_FedexWsdlToApex.TrackReply track(RSI_FedexWsdlToApex.WebAuthenticationDetail WebAuthenticationDetail,RSI_FedexWsdlToApex.ClientDetail ClientDetail,RSI_FedexWsdlToApex.TransactionDetail TransactionDetail,RSI_FedexWsdlToApex.VersionId Version,RSI_FedexWsdlToApex.TrackSelectionDetail[] SelectionDetails,Integer TransactionTimeOutValueInMilliseconds,String[] ProcessingOptions) {
            RSI_FedexWsdlToApex.TrackRequest request_x = new RSI_FedexWsdlToApex.TrackRequest();
            request_x.WebAuthenticationDetail = WebAuthenticationDetail;
            request_x.ClientDetail = ClientDetail;
            request_x.TransactionDetail = TransactionDetail;
            request_x.Version = Version;
            request_x.SelectionDetails = SelectionDetails;
            request_x.TransactionTimeOutValueInMilliseconds = TransactionTimeOutValueInMilliseconds;
            request_x.ProcessingOptions = ProcessingOptions;
            RSI_FedexWsdlToApex.TrackReply response_x;
            Map<String, RSI_FedexWsdlToApex.TrackReply> response_map_x = new Map<String, RSI_FedexWsdlToApex.TrackReply>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://fedex.com/ws/track/v19/track',
              'http://fedex.com/ws/track/v19',
              'TrackRequest',
              'http://fedex.com/ws/track/v19',
              'TrackReply',
              'RSI_FedexWsdlToApex.TrackReply'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}