trigger FieldUpdates1 on OpportunityLineItem (After Insert, After Update,After delete){
    Set<Id> setOppId = new Set<Id>();
    if(trigger.isInsert && trigger.isAfter){
        for(OpportunityLineItem obj : trigger.new){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2'))
                setOppId.add(obj.OpportunityId);
        }
    }
    if(trigger.isUpdate && trigger.isAfter){
        for(OpportunityLineItem obj : trigger.new){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2') && obj.Ownership_Type__c != trigger.oldMap.get(obj.Id).Ownership_Type__c)
                setOppId.add(obj.OpportunityId);
        }
    }
    if(!setOppId.isEmpty()){
        List<Opportunity> listOpp = [SELECT Id,Rental__c FROM Opportunity WHERE Id IN : setOppId];
        for(Opportunity obj : listOpp){
            obj.Rental__c = true;
        }
        if(!listOpp.isEmpty())
            update listOpp;
    }
    if(trigger.isAfter && trigger.isDelete){
        for(OpportunityLineItem obj : trigger.old){
            if(obj.Ownership_Type__c == 'Rental' && (obj.Product_Name__c == 'Pax E500'||obj.Product_Name__c == 'Pax E700'||obj.Product_Name__c == 'Poynt V2'))
                setOppId.add(obj.OpportunityId);
        }
        if(!setOppId.isEmpty()){
            List<Opportunity> listOpp = [SELECT Id,Rental__c FROM Opportunity WHERE Id IN : setOppId];
            for(Opportunity obj : listOpp){
                obj.Rental__c = false;
            }
            if(!listOpp.isEmpty())
                update listOpp;
        }
    }
}