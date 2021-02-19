@isTest
public class RSI_MccCodeTest {
    static testMethod void mcccode(){ 
        Account acc = new Account();
            acc.Name='Test';
            acc.Address__c='noida';
            acc.Monthly_Fee__c=123;
            acc.Country__c='USA';
            acc.Phone='9876543210';
            acc.Partner_Code__c ='R-01';
            acc.Industry_MCC_Code__c = '7922 - Advanced ticket sales';
        Insert acc; 
        
        Mcccode__c Mcc=new Mcccode__c();
            Mcc.Name ='4812 - Cell Phone Stores';
            Mcc.Annual_Revenue__c = 400;
            Mcc.Average_Ticket__c = 34;
            Mcc.Highest_Ticket_Amount__c =500;
            Mcc.Highest_Ticket_Frequency__c = 100;
            Mcc.Total_Monthly_Sales__c =389;
        Insert Mcc;
        
        RSI_MccCode.getMcccodeList(Mcc.Name);
    }
}