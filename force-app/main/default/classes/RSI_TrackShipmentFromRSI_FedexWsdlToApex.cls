/*********************************************************************************************************************
 * Name...................: RSI_TrackShipmentFromRSI_FedexWsdlToApex
 * Created By.............: Umesh Kumar
 * Created Date...........: 07/10/2020
 * Description............: This class use to set authentication credential and pass the tracking number into RSI_FedexWsdlToApex class
 *                          to get the shipment details.
 ************************************************************************************************************************/

global class RSI_TrackShipmentFromRSI_FedexWsdlToApex implements Database.Batchable<sobject> ,Schedulable ,Database.AllowsCallouts {
    //constructor
    global RSI_TrackShipmentFromRSI_FedexWsdlToApex(){} 
    //execute method of schedulable interface use to schedule the class
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new RSI_TrackShipmentFromRSI_FedexWsdlToApex());
     }  
    //start method of batch class to collect the data
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,Name,Tracking_Number__c,Current_Location__c,Shipping_Status__c FROM Account where Tracking_Number__c!=null AND Shipping_Status__c = 'Shipped']);
    }
    //execute method of batch class to process the data
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        //map to store tracking number and asset 
        Map<String,Account> mapOfAsset=new Map<String,Account>();
        //set of tracking number
        Set<String> setOfTrakNumb=new Set<String>();
        //loop to  set tracking number and add into map
        List<Account> listOfAsset = (List<Account>)scope ==null ? null : (List<Account>)scope;
        if(listOfAsset!=null) {
        for(Account objAsset : listOfAsset) {
            setOfTrakNumb.add(objAsset.Tracking_Number__c);
            mapOfAsset.put(objAsset.Tracking_Number__c,objAsset);
        }
        system.debug('setOfTrakNumb=='+setOfTrakNumb);
        //custom setting obj to store fedex info
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
        List<String> processingOptionsObj=new List<String>();
        
        //track service port obj
        RSI_FedexWsdlToApex.TrackServicePort trackServicePortObj=new RSI_FedexWsdlToApex.TrackServicePort();
        
        //call track method and return complete result
        RSI_FedexWsdlToApex.TrackReply trackReplyClassResult= trackServicePortObj.track(webAuthenticationDetailObj,clientDetailObj,transactionDetailObj,versionIdObj,trackSelectionDetailObjList,120000,processingOptionsObj);
        
        //completed track detail class result
        List<RSI_FedexWsdlToApex.CompletedTrackDetail> completedTrackDetailClassResult=trackReplyClassResult.CompletedTrackDetails;
                
        //List of status details under the track details...
        // List<RSI_FedexWsdlToApex.TrackStatusDetail> listOfTrackStatusDetail=new List<RSI_FedexWsdlToApex.TrackStatusDetail>();
        Map<String,String> mpOfTrckNoStatusDetail=new Map<String,String>();
            //list of completed track details...
        List<RSI_FedexWsdlToApex.CompletedTrackDetail> listOfCompletedTrackDetail = (List<RSI_FedexWsdlToApex.CompletedTrackDetail>)completedTrackDetailClassResult ==null ? null 
            : (List<RSI_FedexWsdlToApex.CompletedTrackDetail>)completedTrackDetailClassResult;    
            if(listOfCompletedTrackDetail !=null){
                //loop for list of completed track details...
             for(RSI_FedexWsdlToApex.CompletedTrackDetail compTrackDetailObj:listOfCompletedTrackDetail){
                 //list of track details
               List<RSI_FedexWsdlToApex.TrackDetail> listOfAllTrackDetail = compTrackDetailObj.TrackDetails;  
                List<RSI_FedexWsdlToApex.TrackDetail> listOfTKDetail = (List<RSI_FedexWsdlToApex.TrackDetail>)listOfAllTrackDetail ==null ? null 
                 : (List<RSI_FedexWsdlToApex.TrackDetail>)listOfAllTrackDetail; 
                  if(listOfTKDetail !=null){
                   for(RSI_FedexWsdlToApex.TrackDetail trackDetailObj: listOfTKDetail){ 
                       //add tracking number and satus into map...
                    mpOfTrckNoStatusDetail.put(trackDetailObj.TrackingNumber,trackDetailObj.StatusDetail.Description);  
                  }
               }
             }
                //updated assets
        List<Account> updatedAsset=new List<Account>();
        for(String key:mapOfAsset.keySet()){
            Account ObjAsset=mapOfAsset.get(key);
            if(mpOfTrckNoStatusDetail.get(key) == 'Delivered'){
               ObjAsset.Current_Location__c=mpOfTrckNoStatusDetail.get(key);
               ObjAsset.Shipping_Status__c ='Delivered'; 
               updatedAsset.add(ObjAsset); 
            } else{
              ObjAsset.Current_Location__c=mpOfTrckNoStatusDetail.get(key);
              updatedAsset.add(ObjAsset);   
            }   
        }
        system.debug('updatedAsset==='+updatedAsset);
        update updatedAsset;         
       }      
      }            
    } 
    //finish method of batch class
    global void finish(Database.BatchableContext bc) {
        system.debug('batch processing completed !');
    }
    
}