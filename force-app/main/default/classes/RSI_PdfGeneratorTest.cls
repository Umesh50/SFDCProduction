@isTest
private class RSI_PdfGeneratorTest {
    static testMethod void testPdfGenerator() {
        Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.StageName = 'Approved';
        Insert opp;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
            cv.Title = 'Signature';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = opp.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'V';
        Insert cdl;
        
        PageReference pref = Page.Company_Rep_Cert_Pdf;
        pref.getParameters().put('id',opp.Id);
        Test.setCurrentPage(pref);
        RSI_PDFGenerater.savePdf(opp.Id);   
        //System.assertEquals(pref.getUrl(),'/'+account.id);
    }
    static testMethod void testPdfGenerator2() {
    Opportunity opp = new Opportunity();
      opp.Name = 'Test1 Opp';
      opp.StageName = 'Approved';
    Insert opp;
     

    PageReference pref = Page.Company_Rep_Cert_Pdf;
     pref.getParameters().put('id',opp.Id);
    Test.setCurrentPage(pref);
    RSI_PDFGenerater.savePdf(opp.Id);   
    //System.assertEquals(pref.getUrl(),'/'+account.id);
  }
}