public class RSI_OpportunityStageHandler {
    
    public static void oppStageHanlerMethod(List <Opportunity> triggerNew,Map<Id,Opportunity> oldMap){
     for(Opportunity oppObj : triggerNew) {
        if(oldMap.get(oppObj.id).StageName == 'New' && oppObj.StageName == 'Incomplete' ) {
            oppObj.Last_Status_Update__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Incomplete' && oppObj.StageName == 'Complete' ) {
            oppObj.Last_Status_Update__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Complete' && oppObj.StageName == 'Sent for Signature' ) {
            oppObj.Last_Status_Update__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Sent for Signature' && oppObj.StageName == 'Signed' ) {
            oppObj.Last_Status_Update__c= Date.today();
            oppObj.Signed_Date__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Signed' && oppObj.StageName == 'Under Review' ) {
            oppObj.Last_Status_Update__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Under Review' && oppObj.StageName == 'Approved' ) {
            oppObj.Last_Status_Update__c= Date.today();
            oppObj.Approval_Date__c= Date.today();
        }
        
        if(oldMap.get(oppObj.id).StageName == 'Under Review' && oppObj.StageName == 'Denied' ) {
            oppObj.Last_Status_Update__c= Date.today();
        }
    }
  }
}