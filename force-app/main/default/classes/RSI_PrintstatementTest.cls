@isTest
private class RSI_PrintstatementTest {
    @isTest
    private static  void myTest1() {        
        Test.setMock(HttpCalloutMock.class, new RSI_PrintstatementBatchMockTest  ());
        Account acc = new Account();
            acc.Name='Test';
            acc.Address__c='noida';
            acc.Monthly_Fee__c=123;
            acc.Country__c='USA';
            acc.Phone='9876543210';
            acc.Partner_Code__c ='R-01';
            acc.MID__c = '8036749748';
        Insert acc; 
        Test.startTest();        
            RSI_PrintStatementBatch c = new RSI_PrintStatementBatch();
                Database.executeBatch(c);
        Test.stopTest();
    }
}