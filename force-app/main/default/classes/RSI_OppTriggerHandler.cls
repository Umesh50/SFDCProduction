public class RSI_OppTriggerHandler{
    //After Update
    //
    public static void createVisa(List<Opportunity> listOpp,Map<Id,Opportunity> oldMapOpp){
        Set<Id> setOppId = new Set<Id>();
        Set<Id> setOppId1 = new Set<Id>();
        Map<String,RSI_PricingStructure__mdt> mapMetadata = new Map<String,RSI_PricingStructure__mdt>();
        for(RSI_PricingStructure__mdt obj : [SELECT MasterLabel,DCC_ANNUAL_REGISTRATION__c,EBT__c,MARKUP_RATE1__c,AUTHORIZATION_PRICING_PROGRAM__c FROM RSI_PricingStructure__mdt]){
            mapMetadata.put(obj.MasterLabel,obj);
        }
        
       Map<String,String> mapEuipment = new Map<String,String>();
        for(Equipment_Programming__c obj : [SELECT Id,Name,EBTH__c,Application__c  FROM Equipment_Programming__c WHERE Application__c IN : oldMapOpp.keySet()]){
            mapEuipment.put(obj.Application__c,obj.EBTH__c);
        }
        system.debug('mapEuipment-----'+mapEuipment);
        List<Other_Card_Types_VAS__c> listOctv = new List<Other_Card_Types_VAS__c>();
         List<Additional_Information__c> listAif = new List<Additional_Information__c>();
       
        for(Opportunity obj : listOpp){
            if(obj.Pricing_Plans__c != null && obj.Pricing_Plans__c != oldMapOpp.get(obj.Id).Pricing_Plans__c){
                String label = '';
                if(obj.Pricing_Plans__c == 'Volume =< $25K')
                    label = 'x01';  
                    else if(obj.Pricing_Plans__c == 'Volume up to $75,000')
                        label = 'x02';
                        else if(obj.Pricing_Plans__c == 'Volume up to $150,000')
                            label = 'x03';
                         else if(obj.Pricing_Plans__c == 'FIXED RATE - API')
                            label = 'x04';
                if(mapMetadata.containsKey(label)){
                    Other_Card_Types_VAS__c octv = new Other_Card_Types_VAS__c();
                        octv.DCC_Annual_Registration__c = mapMetadata.get(label).DCC_ANNUAL_REGISTRATION__c != null ? String.valueOf(mapMetadata.get(label).DCC_ANNUAL_REGISTRATION__c):'';
                        octv.EBT_Auth_Fee__c = mapMetadata.get(label).EBT__c!=null?String.valueOf(mapMetadata.get(label).EBT__c):'';
                        octv.Markup_Rate__c = mapMetadata.get(label).MARKUP_RATE1__c!=null?String.valueOf(mapMetadata.get(label).MARKUP_RATE1__c):'';
                        octv.Dynamic_Currency_Conversion_Setup__c = '0';
                        system.debug('---eupId--------'+mapEuipment.get(obj.Id));
                        if(mapEuipment.containsKey(obj.Id))
                            octv.EBT__c  = mapEuipment.get(obj.Id);
                        octv.Application__c = obj.Id;
                    listOctv.add(octv);
                   setOppId.add(obj.Id);
                }
                if(mapMetadata.containsKey(label)){
                    
                    Additional_Information__c Ainf = new Additional_Information__c();
                        Ainf.Authorization_Pricing_Program__c = mapMetadata.get(label).AUTHORIZATION_PRICING_PROGRAM__c != null ? String.valueOf(mapMetadata.get(label).AUTHORIZATION_PRICING_PROGRAM__c):''; 
                        Ainf.Application__c = obj.Id;
                    listAif.add(Ainf);
                    setOppId1.add(obj.Id);
                }
            }
        }
        if(!setOppId.isEmpty()){
            List<Other_Card_Types_VAS__c> listCard = [SELECT Id FROM Other_Card_Types_VAS__c WHERE Application__c IN :setOppId];
                if(!listCard.isEmpty())
                    Delete listCard;
        }
        if(!setOppId1.isEmpty()){
            List<Additional_Information__c> listAdd = [SELECT Id FROM Additional_Information__c WHERE Application__c IN :setOppId1];
                if(!listAdd.isEmpty())
                    Delete listAdd;
        }
        if(!listOctv.isEmpty())
            Insert listOctv;
            if(!listAif.isEmpty())
            Insert listAif;
    }
    //After Insert
    public static void createVisa1(List<Opportunity> listOpp,Map<Id,Opportunity> mapOpp){
        Map<String,RSI_PricingStructure__mdt> mapMetadata = new Map<String,RSI_PricingStructure__mdt>();
        for(RSI_PricingStructure__mdt obj : [SELECT MasterLabel,DCC_ANNUAL_REGISTRATION__c,EBT__c,MARKUP_RATE1__c FROM RSI_PricingStructure__mdt]){
            mapMetadata.put(obj.MasterLabel,obj);
        }
        Map<String,String> mapEuipment = new Map<String,String>();
        for(Equipment_Programming__c obj : [SELECT Id,Name,EBTH__c,Application__c  FROM Equipment_Programming__c WHERE Application__c IN : mapOpp.keySet()]){
            mapEuipment.put(obj.Application__c,obj.EBTH__c);
        }
        system.debug('mapEuipment---------------'+mapEuipment);
        List<Other_Card_Types_VAS__c> listOctv = new List<Other_Card_Types_VAS__c>();
         List<Additional_Information__c> listAif = new List<Additional_Information__c>();
        for(Opportunity obj : listOpp){
            if(obj.Pricing_Plans__c != null){
                String label = '';
                if(obj.Pricing_Plans__c == 'Volume =< $25K')
                    label = 'x01';  
                    else if(obj.Pricing_Plans__c == 'Volume up to $75,000')
                        label = 'x02';
                        else if(obj.Pricing_Plans__c == 'Volume up to $150,000')
                            label = 'x03';
                if(mapMetadata.containsKey(label)){
                    Other_Card_Types_VAS__c octv = new Other_Card_Types_VAS__c();
                        octv.DCC_Annual_Registration__c = mapMetadata.get(label).DCC_ANNUAL_REGISTRATION__c != null ? String.valueOf(mapMetadata.get(label).DCC_ANNUAL_REGISTRATION__c):'';
                        octv.EBT__c = mapMetadata.get(label).EBT__c!=null?String.valueOf(mapMetadata.get(label).EBT__c):'';
                        octv.Markup_Rate__c = mapMetadata.get(label).MARKUP_RATE1__c!=null?String.valueOf(mapMetadata.get(label).MARKUP_RATE1__c):'';
                        octv.Application__c = obj.Id;
                        system.debug('mapEuipment----11111--------'+mapEuipment.get(obj.Id));
                        if(mapEuipment.containsKey(obj.Id))
                            octv.EBT__c  = mapEuipment.get(obj.Id);
                    listOctv.add(octv);
                    
                }
               
            }
        }
        if(!listOctv.isEmpty())
            Insert listOctv;
            
    }
}