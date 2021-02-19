public with sharing class RSI_DynamicAddRemoveRow {
    
    @AuraEnabled
    public static Map<String, String> getProducts(String opptyId){ 
        
        List<Product2> productList = [SELECT Id, Name
                                     FROM Product2];       
                                     
        Map<String, String> productNameToIdMap = new Map<String, String>();

        for(Product2 product: productList){
            productNameToIdMap.put(product.Name, product.Id);
        }
        
        return productNameToIdMap;
    }

    @AuraEnabled
    public static Map<String, Decimal> getProductsWithPrice(String opptyId){

        List<Pricebookentry> pricebookentryList =  [SELECT Id,Product2.Name,UnitPrice 
                                                    FROM Pricebookentry ];

        Map<String, Decimal> productNameToPriceMap = new Map<String, Decimal>();
        for(Pricebookentry pricebookentry: pricebookentryList){
            productNameToPriceMap.put(pricebookentry.Product2.Name,pricebookentry.UnitPrice );
        }
        
        return productNameToPriceMap;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> getOppLineItemWithShipping(String opptyId){ 
        List<OpportunityLineItem> oppLineItemList = [SELECT Id,Shipping_Method__c,Rate_Net_Charge__c,Total_Price_With_Tax__c
        FROM OpportunityLineItem WHERE OpportunityId =:opptyId];        
        
        return oppLineItemList;
    }

    @AuraEnabled
    public static List<OpportunityLineItem> getOpportunityLineItem(String opptyId){  
        if(String.isBlank(opptyId)){
            return NULL;
        }
        
        List<OpportunityLineItem> opportunityLineItemList = [SELECT Id, Product2Id, Product2.Name, Quantity, UnitPrice, 
                                                             TotalPrice, Shipping_Method__c, Ownership_Type__c,Tax__c,
                                                             Tax_Amount__c FROM OpportunityLineItem WHERE OpportunityId =:opptyId order by CreatedDate asc];        
        
        return opportunityLineItemList;
    }
    
    @AuraEnabled
    public static ResponseWrapper getRecords(String opptyId){          
        if(String.isBlank(opptyId)){
            return NULL;
        }
        
        ResponseWrapper responseWrapper = new ResponseWrapper();
        
        responseWrapper.opportunityLineItemList = [SELECT Id, Equipment__c, PINPAD__c, Quantity, UnitPrice,VAR_Service_Provider__c, 
                                                   Ownership_Type__c, SIM_Card__c, Is_Disabled_Equipment__c,ProductCode
                                                   FROM OpportunityLineItem 
                                                   WHERE OpportunityId =:opptyId 
                                                   order by CreatedDate asc];
        
        List<Equipment_Programming__c> equipmentProgrammingList = [SELECT Id, AUTO_BATCH__c, Retail_Tip__c,
                                                                   Time__c,EBT__c,EBTH__c,No_Signature__c, Quick_Close__c,
                                                                   Contactless__c,CASHBACK_PIN_DEBIT__c,MAX_CASHBACK__c,
                                                                   Fine_Dining__c,Server_Prompt_CA_Only__c,
                                                                   TIP__c,Add_Lodging_Quick_Close_Default__c,Quick_Stay_US_Only__c,
                                                                   Add_Card_Not_Present__c,TAB__c
                                                                   FROM Equipment_Programming__c 
                                                                   WHERE Application__r.Id =: opptyId];
        
        if(equipmentProgrammingList != NULL && !equipmentProgrammingList.isEmpty()){
            responseWrapper.equipmentProgramming = equipmentProgrammingList[0];
        }       
        
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity WHERE Id =:opptyId ];
        
        if(String.isNotBlank(opportunity.AccountId)){
            responseWrapper.account = [SELECT Id, Sales_Percent_Types_Card_Present__c, Sales_Percent_Types_Card_Not_Present__c,
                                       Sales_Percent_Types_Internet__c, Notes__c
                                       FROM Account
                                       WHERE Id =:opportunity.AccountId];
        }
        
        return responseWrapper;        
    }
    
    @AuraEnabled
    public static String deleteLineItem(String recId){
        try {
            delete [SELECT Id FROM OpportunityLineItem WHERE Id =: recId];
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static RSI_Response updateAccountRecord(Account account) {
        System.debug('equipmentProgramming--' + JSON.serializePretty(account));
        RSI_Response response ;
        
        try{           
            UPDATE account;
            response = new RSI_Response( True, account,'Account has been updated successfully.');
        }catch(Exception ex){
            response = new RSI_Response( False , NULL, ex.getMessage());
        }
        
        return response;
    }
    
    @AuraEnabled
    public static RSI_Response updateLineItems(String lineItems) {
        System.debug('OpportunityLineItem--' + JSON.serializePretty(lineItems));
        List<OpportunityLineItem> opportunityLineItem = (List<OpportunityLineItem>) JSON.deserialize(lineItems, List<OpportunityLineItem>.class);
        RSI_Response response ;
        
        try{           
            UPDATE opportunityLineItem;
            response = new RSI_Response( True, lineItems,'Shipping method has been updated successfully.');
        }catch(Exception ex){
            response = new RSI_Response( False , NULL, ex.getMessage());
        }
        
        return response;
    }

    
    @AuraEnabled
    public static RSI_Response createEquipmentProgrammingRecord(Equipment_Programming__c equipmentProgramming, String opportunityId) {
        System.debug('equipmentProgramming--' + JSON.serializePretty(equipmentProgramming));
        RSI_Response response ;
        
        try{
            List<Equipment_Programming__c> epObj =[select id,Application__c from Equipment_Programming__c where Application__c =:opportunityId];
             equipmentProgramming.Application__c = opportunityId;
            if(!epObj.isEmpty()){
                 equipmentProgramming.Id = epObj[0].Id;
                update equipmentProgramming;
            }else{
               insert equipmentProgramming; 
            }
            response = new RSI_Response( True, equipmentProgramming,'Equipment Programming record has been created/updated successfully.');
        }catch(Exception ex){
            response = new RSI_Response( False , NULL, ex.getMessage());
        }
        return response;
    }    
   
    public class ResponseWrapper{
        @AuraEnabled
        public List<OpportunityLineItem> opportunityLineItemList {get;set;}
        @AuraEnabled
        public Equipment_Programming__c equipmentProgramming {get;set;}
        @AuraEnabled
        public Account account {get;set;}
        
        public ResponseWrapper(){
            this.opportunityLineItemList = new list<OpportunityLineItem>();
            this.equipmentProgramming = new Equipment_Programming__c();
            this.account = new Account();
        }
    }
}