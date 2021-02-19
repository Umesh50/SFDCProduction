public class RSI_PrintStatementPDF implements Database.Batchable<sObject>,Database.AllowsCallouts{


public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT Id,STATEMENTKEY__c,MERCHANTNO__c FROM Statement__c WHERE STATEMENTKEY__c !=null');
   }

   public void execute(Database.BatchableContext BC, List<Statement__c> scopeAcc){
       List<Statement__c> listState = new List<Statement__c>();
       for(Statement__c acc : scopeAcc){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
           
            Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
       
           
            req.setEndpoint(mapOfConnection.get('Connection') +'/v1/merchants/'+acc.MERCHANTNO__c+'/printstatements/'+acc.STATEMENTKEY__c+'appkey='+ mapOfConnection.get('APPKEY'));
            req.setMethod('Post');
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Map<String, Object> meta1 = (Map<String, Object>)meta.get('STATEMENTLIST');
                List<Object> listObj = (List<Object>)meta1.get('DATA');
                for(Object obj : listObj){
                    List<String> listStr = String.valueOf(obj).split(',');
                    Statement__c st = new Statement__c();
                        st.Batch_No__c = listStr[2];
                        st.Date_Added__c = date.parse(listStr[3]);
                        st.MERCHANTNO__c = listStr[1];
                        st.STATEMENTKEY__c = String.valueOf(listStr[0]).remove('(');
                        st.Statement_Type__c = String.valueOf(listStr[4]).remove(')');
                        st.Account__c = acc.Id;
                    listState.add(st);
                }
            }
       }
       if(!listState.isEmpty())
            Insert listState;
   }

   public void finish(Database.BatchableContext BC){
   }
}