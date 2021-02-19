/**
 * @description       :
 * @author            : Tanmay Jain
 * @group             :
 * @last modified on  : 11-12-2020
 * @last modified by  : Tanmay Jain
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-04-2020   Tanmay Jain   Initial Version
**/
public without sharing class RSI_UploadFileController {

  @AuraEnabled
  public static List<ContentDocument> updateFileRecord (String documentId, String description, String recordId){
      ContentDocument cd = [SELECT Id, Title, Description, LatestPublishedVersionId FROM ContentDocument WHERE Id =: documentId]; // Getting files from Parent record
      ContentVersion cv = new ContentVersion (Id = cd.LatestPublishedVersionId, Document_Type__c = description);
      //cd.Title = title;  // Changing file Title with user entered title
      //cd.Description = description;
      try{
        update cv;  // Update ContentDocument (File)
        Opportunity opp = new Opportunity();
            opp.Id = recordId;
            if(description == 'Business License')
            opp.Business_License__c = false;
           if(description == 'Business Photos')
                        opp.Business_Photos__c = false;
                if(description == 'Corporate Docs')
                        opp.Corporate_Docs__c = false;
                if(description == 'Drivers License')
                       opp.Drivers_License__c = false;
                if(description == 'Processing Statement (3 Months)')
                        opp.Processing_Statement_3_Months__c = false;
                if(description == 'Voided Check Or Bank Letter')
                        opp.Voided_Check_Or_Bank_Letter__c = false;
        update opp;
      }
      catch(DMLException e){
        system.debug('Exception has occurred! ' +e.getMessage());
      }
      return getFiles(recordId);  // Return list of files on parent record
  }

  @AuraEnabled
  public static List<ContentDocument> getFiles(String recordId){
    List<ContentDocument> documentList = new List<ContentDocument>();
    Set<Id> documentIds = new Set<Id>();
    List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId];
    for(ContentDocumentLink cdLink:cdl){
      documentIds.add(cdLink.ContentDocumentId);
    }
    documentList = [SELECT Id, Title, FileType, ContentSize, Description, LatestPublishedVersionId, LatestPublishedVersion.Document_Type__c FROM ContentDocument WHERE Id IN: documentIds];
    return documentList;  // Return list of files on parent record
  }
  
    @AuraEnabled
    public static void getAppStatus(String oppId,string selectedLabel,Boolean isChecked){
        if(oppId !=null){
            List<Opportunity> oppObj =[select id,StageName,Certified_Articles_of_Incorporation__c,Business_License__c,Business_Photos__c,Corporate_Docs__c,Drivers_License__c,Processing_Statement_3_Months__c,Voided_Check_Or_Bank_Letter__c from Opportunity where id =: oppId];
            if(oppObj != null || oppObj.size() > 0 && oppObj[0].StageName !='Pending Merchant Docs'){
                Opportunity opp = new Opportunity();
                    opp.id = oppObj[0].id;
                    opp.StageName = 'Pending Merchant Docs';
                    if(selectedLabel == 'Legal: Certified Articles of Incorporation')
                        opp.Certified_Articles_of_Incorporation__c = isChecked;
                    if(selectedLabel == 'Business License')
                        opp.Business_License__c = isChecked;
                if(selectedLabel == 'Business Photos')
                        opp.Business_Photos__c = isChecked;
                if(selectedLabel == 'Corporate Docs')
                        opp.Corporate_Docs__c = isChecked;
                if(selectedLabel == 'Drivers License')
                        opp.Drivers_License__c = isChecked;
                if(selectedLabel == 'Processing Statement (3 Months)')
                        opp.Processing_Statement_3_Months__c = isChecked;
                if(selectedLabel == 'Voided Check Or Bank Letter')
                        opp.Voided_Check_Or_Bank_Letter__c = isChecked;
                update opp;
                //update (new Opportunity(id = oppObj[0].id,StageName = 'Pending Merchant Docs'));
            }
        }
    }
    
    
    
}