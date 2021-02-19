/**
 * @description       :
 * @author            : Umesh Kumar
 * @group             :
 * @last modified on  : 01-15-2021
 * @last modified by  : Umesh Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   01-15-2021   Tanmay Jain   Initial Version
**/

public without sharing class RSI_UpdateApplicationStatus {
    
    @AuraEnabled
    public static void updateAppStatus(String opptyId){
        Boolean b=false;
        
        List<Opportunity> allRecords= [SELECT Id,Name,Business_Contact_First_Name__c,Business_Contact_Last_Name__c,Contact_Phone_Number__c,
                                       Contact_Email_Address__c,Type,StageName,Processor__c,Business_Type__c,DBA_Name__c,Legal_Name_As_DBA__c,Corporate_Name__c,
                                       Employer_Identification_Number__c,DBA_Phone__c,DBA_Fax__c,Email_Address__c,Mobile_Phone__c,Year_Established__c,DBA_Address_1__c,
                                       DBA_Address_2__c,State__c,City__c,Zip_Code__c,Account.Shipping_Address__c,Account.Shipping_Country__c,Account.Shipping_State__c ,
                                       Account.Shipping_City__c ,Account.Shipping_Zip__c ,Account.Shipping_Phone__c ,Account.Mailing_Address__c ,Account.Mailing_Country__c ,
                                       Account.Mailing_State__c ,Account.Mailing_City__c ,Account.Mailing_Zip__c ,Account.Mailing_Phone__c ,Account.ABA_RoutingLookup2__c ,
                                       Account.DDA_Account__c ,Account.DDA_Account2_No__c ,Account.Previous_Processor_Name__c ,Account.Industry_MCC_Code__c ,
                                       Account.Copy_Industry_Standards__c ,Account.Total_Monthly_Sales__c ,Account.Average_Ticket__c ,Account.Highest_Ticket_Amount__c ,
                                       Account.Highest_Ticket_Frequency__c ,Account.Pricing_Plans__c ,Account.Annual_Revenue__c,Account.Description_Of_Products_Or_Services__c ,
                                       Account.Describe_When_Product_Is_Received__c ,Account.No_of_Days__c ,Account.Seasonal__c ,Account.Website,Account.Customer_Service_Phone__c,
                                       Account.Sales_Percent_Types_Card_Present__c,
                                       (SELECT Id, Owner_Type__c, Primary_Owner_Or_Officer__c, Ownership_Percentage__c, Responsible_Party__c FROM Owners_Or_Officers__r),
                                       (SELECT Id,Equipment__c FROM OpportunityLineItems),(SELECT Id,AUTO_BATCH__c FROM Equipment_Programming__r) from Opportunity where id =:opptyId];
        
        if(allRecords.size()>0){
            b=true;
            id oppid;
            for(Opportunity obj :allRecords){
                oppid =obj.Id;
                if(obj.Owners_Or_Officers__r.size() == 0 || obj.Owners_Or_Officers__r == null){
                    b=false;
                }
                if(obj.OpportunityLineItems.size() == 0 || obj.OpportunityLineItems == null){
                    b=false;
                }
                if(obj.Equipment_Programming__r.size() == 0 || obj.Equipment_Programming__r == null){
                    b=false;
                }
                if(obj.Name ==null ||obj.Business_Contact_First_Name__c ==null ||obj.Business_Contact_Last_Name__c ==null  
                   ||obj.Contact_Phone_Number__c==null ||obj.Contact_Email_Address__c==null ||obj.Business_Type__c==null 
                   ||obj.DBA_Name__c==null ||obj.Legal_Name_As_DBA__c==null ||obj.Corporate_Name__c==null 
                   ||obj.Employer_Identification_Number__c==null ||obj.DBA_Phone__c==null ||obj.DBA_Fax__c==null 
                   ||obj.Email_Address__c==null ||obj.Mobile_Phone__c==null ||obj.Year_Established__c==null ||obj.DBA_Address_1__c==null 
                   ||obj.DBA_Address_2__c==null ||obj.State__c==null ||obj.City__c==null ||obj.Zip_Code__c ==null 
                   ||obj.Account.Shipping_Address__c==null ||obj.Account.Shipping_Country__c==null || obj.Account.Shipping_State__c == null 
                   ||obj.Account.Shipping_City__c==null ||obj.Account.Shipping_Zip__c==null ||obj.Account.Shipping_Phone__c==null 
                   ||obj.Account.Mailing_Address__c==null ||obj.Account.Mailing_Country__c==null ||obj.Account.Mailing_State__c==null
                   ||obj.Account.Mailing_City__c==null ||obj.Account.Mailing_Zip__c==null ||obj.Account.Mailing_Phone__c==null 
                   ||obj.Account.Sales_Percent_Types_Card_Present__c==null ||obj.Account.DDA_Account__c==null ||obj.Account.DDA_Account2_No__c==null 
                   ||obj.Account.Previous_Processor_Name__c==null ||obj.Account.Industry_MCC_Code__c==null ||obj.Account.Copy_Industry_Standards__c==null
                   ||obj.Account.Total_Monthly_Sales__c==null ||obj.Account.Average_Ticket__c==null ||obj.Account.Highest_Ticket_Amount__c==null 
                   ||obj.Account.Highest_Ticket_Frequency__c==null ||obj.Account.Pricing_Plans__c==null ||obj.Account.Annual_Revenue__c==null 
                   ||obj.Account.Description_Of_Products_Or_Services__c==null ||obj.Account.Describe_When_Product_Is_Received__c==null 
                   ||obj.Account.No_of_Days__c==null || obj.Account.Seasonal__c == null || obj.Account.Website ==null || obj.Account.Customer_Service_Phone__c ==null
                   ||obj.Account.ABA_RoutingLookup2__c==null ){
                       b =false;
                   }
            }
            
            if(b == true && allRecords[0].StageName == 'Incomplete'){
                update (new Opportunity(id =oppid,StageName ='Ready for Signatures'));
            }
            
        }
    }

}