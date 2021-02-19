/**
 * @description       :
 * @author            : Ajay Kumar
 * @group             :
 * @last modified on  : 31-12-2020
 * @last modified by  : Ajay Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   4-1-2021   Ajay Kumar   Initial Version
**/
global class UpdateOppFromEmail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(
    Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
     Messaging.InboundEmailresult result = new Messaging.InboundEmailResult();
      system.debug('--Subject----'+email.subject);
      system.debug('--plainTextBody----'+email.plainTextBody);
      system.debug('email--------'+email);
      String textBody = email.plainTextBody;
      String status = '';
      String sub = email.subject;
      if(textBody != null){
          if(textBody.contains('Approved'))
              status = 'Approved';
          if(textBody.contains('Declined'))
              status = 'Denied';
         //String oppName = textBody.substringBefore('Old Status').trim();
         String oppName = sub.SubStringAfter('AppStatus -').trim();
          String mid;
          //if(!Test.isRunningTest())
          mid = textBody.substringBetween('MID: ','The').trim();          
          List<Opportunity> listOpp = [SELECT Id,Name,AccountId,Last_Status_Update__c FROM Opportunity WHERE Name=:oppName];
          if(!listOpp.isEmpty() && status != null){
              listOpp[0].StageName = status;
              listOpp[0].Last_Status_Update__c = date.today();
              Update listOpp;
              if(listOpp[0].AccountId != null && mid != null){
                  Account acc = [SELECT Id,Name,MID__c FROM Account WHERE Id=:listOpp[0].AccountId];
                      acc.MID__c = mid;
                  Update acc;
              }
              result.message = 'You have successfully updated this Opportunities stage to ' +status ;
          }else{
              result.message = 'Application not found with this name';
          }  
      }else{
          result.message = 'Email body should not empty';
      }
      return result;
    }
}