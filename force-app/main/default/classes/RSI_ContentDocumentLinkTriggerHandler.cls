/****************************************************************************************************************
 * Name...................: RSI_ContentDocumentLinkTriggerHandler
 * Created By.............: Umesh Kumar
 * Created Date...........: 01/08/2021
 * Description............: trigger helper to update application status to signed
 *******************************************************************************************************************/


public class RSI_ContentDocumentLinkTriggerHandler {
    
    public static void onAfterInsert(list<ContentDocumentLink> listCDtLink) {
        String strObjPrefix;
        // Set<Id> setOppIds = new Set<Id>();
        Set<Id> setCDIds = new set<Id>();
        
        for(ContentDocumentLink cDObj : listCDtLink) {
            strObjPrefix = String.valueOf(cDObj.LinkedEntityId).substring(0, 3);
            system.debug('strObjPrefix = :'+strObjPrefix);
            if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
                //setOppIds.add(cDObj.LinkedEntityId);
                setCDIds.add(cDObj.ContentDocumentId);
            }
        }
        
        if(!setCDIds.isEmpty()){
            Set<Id> setOppId =new Set<Id>();
            List<Opportunity> listOfUpdatedOpp =new List<Opportunity>();
            for (ContentDocumentLink cdObj : [SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE ContentDocumentId IN :setCDIds]) {
                String fileName = cdObj.ContentDocument.Title;
                system.debug('fileName = :'+fileName);
                system.debug('FileExtension = :'+cdObj.ContentDocument.FileExtension);
                if (fileName.startsWith('CertificateOfCompletion') && cdObj.ContentDocument.FileExtension =='pdf') {
                    setOppId.add(cdObj.LinkedEntityId);
                }
            }
            for(Opportunity oppObj : [SELECT Id,StageName FROM Opportunity where id IN :setOppId]){
                if(oppObj.StageName != 'Signed'){
                    listOfUpdatedOpp.add(new Opportunity(id = oppObj.id ,StageName ='Signed'));  
                }
                
            }    
            if(!listOfUpdatedOpp.isEmpty()){
                update listOfUpdatedOpp;
                system.debug('update status of Opportunity');
            }
        }     
    }
}