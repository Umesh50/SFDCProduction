public with sharing class RSI_PDFGenerater {
  @AuraEnabled
  public static void savePdf(String oppId) {
    PageReference pdf = Page.Company_Rep_Cert_Pdf;
        pdf.getParameters().put('id',oppId);
    Blob body; 
    if(Test.isRunningTest())
        body = blob.valueOf('Unit.Test');
    else
        body = pdf.getContent();
    Opportunity obj = [SELECT Name FROM Opportunity WHERE Id=:oppId];
    List<ContentDocumentLink> listDocLink = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:oppId];
    if(!listDocLink.isEmpty()){
        ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Terms.pdf'; 
            conVer.Title = 'Signature_'+obj.Name;
            conVer.VersionData = body;
            conVer.ContentDocumentId = listDocLink[0].ContentDocumentId;
        Insert conVer;
    }else{
        ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'Terms.pdf'; 
            conVer.Title = 'Signature_'+obj.Name; 
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
            opp.Pending_documents_Email__c = True;
            Update opp;
    } 
  }
     
}