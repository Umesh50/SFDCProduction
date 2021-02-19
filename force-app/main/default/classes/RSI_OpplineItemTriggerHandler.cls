public class RSI_OpplineItemTriggerHandler{
    public static void afterInsert(List<OpportunityLineItem> listOpp){
        Set<Id> setOppId = new Set<Id>();
        for(OpportunityLineItem obj : listOpp){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2'))
                setOppId.add(obj.OpportunityId);
        }
        List<Opportunity> listOpp1 = [SELECT Id,Rental__c FROM Opportunity WHERE Id IN : setOppId];
        for(Opportunity obj : listOpp1){
            obj.Rental__c = true;
        }
        if(!listOpp1.isEmpty())
            update listOpp1;
    }
    public static void afterUpdate(List<OpportunityLineItem> listOpp, Map<Id,OpportunityLineItem> oldMap){
        Set<Id> setOppId = new Set<Id>();
        for(OpportunityLineItem obj : listOpp){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2') && obj.Ownership_Type__c != oldMap.get(obj.Id).Ownership_Type__c)
                setOppId.add(obj.OpportunityId);
        }
        List<Opportunity> listOpp1 = [SELECT Id,Rental__c FROM Opportunity WHERE Id IN : setOppId];
        for(Opportunity obj : listOpp1){
            obj.Rental__c = true;
        }
        if(!listOpp1.isEmpty())
            update listOpp1;
    }
    public static void afterDelete(List<OpportunityLineItem> listOpp){
        Set<Id> setOppId = new Set<Id>();
        for(OpportunityLineItem obj : listOpp){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2'))
                setOppId.add(obj.OpportunityId);
        }
        if(!setOppId.isEmpty()){
            List<Opportunity> listOpp1 = [SELECT Id,Rental__c FROM Opportunity WHERE Id IN : setOppId];
            for(Opportunity obj : listOpp1){
                obj.Rental__c = false;
            }
            if(!listOpp1.isEmpty())
                update listOpp1;
        }
    }
}