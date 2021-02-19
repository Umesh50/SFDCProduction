@isTest
private class RSI_PDFrentalTest {
  static testMethod void testPdfGenerator() {
  
    Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName = 'Approved';
        opp.Rental__c = TRUE ;
    Insert opp;
    
    Pricebook2 standardPricebook = new Pricebook2(); 
        standardPricebook.Id = Test.getStandardPricebookId();
        standardPricebook.IsActive = true;
    Update standardPricebook;

    Product2 p = new Product2();
        p.Name = 'Pax E500';
        p.Description = 'This is the Product description.';
        p.ProductCode = 'EX1234';
        p.StockKeepingUnit = 'EX5678';
        p.Family = 'Example Product Family';
        p.QuantityUnitOfMeasure = 'inches';
        p.DisplayUrl = 'https://www.example.com/';
        p.ExternalId = 'ID #1234';
        p.IsActive = true;
    Insert p;
      
    PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = standardPricebook.Id;
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 1020;
        pbe.IsActive = true;
    Insert pbe;
    
    OpportunityLineItem itm=new OpportunityLineItem();
        itm.Access_Number__c=17;
        itm.Capture_Method__c='HOST';
        itm.Close_Method__c='AUTO';
        itm.Equipment_Type__c='0';
        itm.OpportunityId=opp.Id;
        itm.Quantity=4;
        itm.TotalPrice=100;
        itm.Product2Id=p.Id;
        itm.PricebookEntryId=pbe.Id;
        itm.Ownership_Type__c = 'Rental';
    Insert itm; 
    
    PageReference pref = Page.RSI_RENTAL;
    pref.getParameters().put('id',opp.Id);
    Test.setCurrentPage(pref);
    RSI_PDFRental.savePdfRental(opp.Id);   
    //System.assertEquals(pref.getUrl(),'/'+account.id);
  }
}