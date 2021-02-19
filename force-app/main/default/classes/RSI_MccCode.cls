public  with sharing class RSI_MccCode {
@AuraEnabled
    public static List <Mcccode__c> getMcccodeList(String picklistName){
        return [SELECT Id,Name,Annual_Revenue__c,Average_Ticket__c,Highest_Ticket_Amount__c,Highest_Ticket_Frequency__c,Total_Monthly_Sales__c FROM Mcccode__c WHERE Name=:picklistName];
    } 
}