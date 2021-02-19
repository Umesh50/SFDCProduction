public with sharing class RSI_PDFRental{

 @AuraEnabled
public static void savePdfRental(String oppId) {
    List<OpportunityLineItem> listOppLineItem = [SELECT Id, OpportunityId,Product2.Name, Ownership_Type__c FROM OpportunityLineItem WHERE OpportunityId=:oppId AND Ownership_Type__c = 'Rental'  AND (Product2.Name='Pax E500' OR Product2.Name='Pax E700' OR Product2.Name = 'Poynt V2')];
        if(!listOppLineItem.isEmpty()){
            PageReference pdf = Page.RSI_RENTAL;
                pdf.getParameters().put('id',oppId);
                Blob body;
                if(Test.isRunningTest()) 
                    body = blob.valueOf('Unit.Test');
                else
                    body = pdf.getContent();

            ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = 'Terms.pdf'; 
                conVer.Title = 'Rental'; 
                conVer.VersionData = body;
            Insert conVer;   
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = oppId;
                conDocLink.ContentDocumentId = conDoc;
                conDocLink.shareType = 'V';
            Insert conDocLink;
            Opportunity opp  = new Opportunity();
            
            opp.Id=oppId;
            opp.Rental__c = True;
            Update opp;
        }
    }
}