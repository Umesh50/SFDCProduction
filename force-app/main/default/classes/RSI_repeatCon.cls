public class RSI_repeatCon {
    public String ownerOfficerId;
    public String appId;
    public boolean isDiplay {get;set;}
    public String ownerOffName {get;set;}
    public RSI_repeatCon (ApexPages.StandardController controller){
        ownerOfficerId = apexpages.currentpage().getparameters().get('parentId');
        appId = apexpages.currentpage().getparameters().get('appId');
        isDiplay = true;
    }
    public PageReference getStrings() {
        String pId;
        String Name;
        PageReference pageRef;
        Opportunity opp = [SELECT Id,Application_Process__c,AccountId FROM Opportunity WHERE Id=:appId];
        if(appId != null){
             for(Owners_Or_Officers__c obj : [SELECT Id,FullName__c,Application__c,(SELECT Id FROM Signatures__r) FROM Owners_Or_Officers__c WHERE Application__c=:appId AND Owner_Type__c !='3' ORDER BY CREATEDDATE  LIMIT 2 ] ){
                if((obj.Signatures__r).isEmpty()){
                    pId = obj.Id;               
                    ownerOffName = obj.FullName__c;
                }
             }

            if(pId != null && ownerOfficerId != pId){
                pageRef = new PageReference('/apex/RSI_SignaturePage?parentId='+pId+'&appId='+appId);
                pageRef.setRedirect(true);  
                return pageRef;
            }
            if(pId == null){
               pageRef = new PageReference(system.label.instance+'/lightning/cmp/c__RSI_ContinueAPP?c__recordId='+opp.Id+'&c__accountId='+opp.AccountId+'');
                pageRef.setRedirect(true);
                return pageRef;
            }
            
        }else
            isDiplay = false;
        return null;
    }
}