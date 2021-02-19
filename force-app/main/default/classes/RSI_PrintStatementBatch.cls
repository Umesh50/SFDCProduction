public class RSI_PrintStatementBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{

   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT Id,MID__c FROM Account WHERE MID__c !=null');
   }

   public void execute(Database.BatchableContext BC, List<Account> scopeAcc){
       List<Statement__c> listState = new List<Statement__c>();
       for(Account acc : scopeAcc){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.msppulsepoint.com/nexusdatalink/v1/merchants/'+acc.MID__c+'/printstatements.json?appkey=152E9C551A7AE89DD48AFC8816D0FF0B41659D0703F3B5EFD5512568DE28BFB9');
            req.setMethod('GET');
            req.setTimeOut(12000);
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                if(Integer.valueOf(meta.get('STATEMENTS')) > 0){
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
       }
       if(!listState.isEmpty())
            Insert listState;       
   }
   public void finish(Database.BatchableContext BC){
   }
}