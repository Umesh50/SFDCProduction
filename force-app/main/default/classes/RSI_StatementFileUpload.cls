public class RSI_StatementFileUpload implements Queueable,Database.AllowsCallouts{
    private List<Statement__c> statements;
    public RSI_StatementFileUpload (List<Statement__c> records) {
        this.statements = records;
    }
    public void execute(QueueableContext context) {
        if(!statements.isEmpty()){
            Map<Id,ContentVersion> mapConv = new Map<Id,ContentVersion>();
            for(Statement__c obj : statements){
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://api.msppulsepoint.com/nexusdatalink/v1/merchants/'+obj.MERCHANTNO__c+'/printstatements/'+obj.STATEMENTKEY__c+'?appkey=152E9C551A7AE89DD48AFC8816D0FF0B41659D0703F3B5EFD5512568DE28BFB9');
                req.setMethod('POST');
                req.setTimeOut(12000);
                HTTPResponse res = http.send(req);
                system.debug('----------'+res.getBody());
                if(res.getStatusCode() == 200){
                    ContentVersion cv = new ContentVersion();
                        cv.Title = 'Statement';
                        cv.PathOnClient = 'Statement.pdf';
                        cv.VersionData = Blob.valueOf(res.getBody());
                        cv.IsMajorVersion = true;
                    mapConv.put(obj.Id,cv);
                }
            }
            system.debug('mapConv----'+mapConv);
            if(!mapConv.isEmpty()){
                Insert mapConv.values();
                Map<Id,Id> mapConCont = new Map<Id,Id>();
                List<ContentDocumentLink> listLink = new List<ContentDocumentLink>();
                for(ContentVersion obj : [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :mapConv.values()]){
                    mapConCont.put(obj.Id,obj.ContentDocumentId);
                }
                for(Id recId : mapConv.keySet()){
                    if(mapConCont.containsKey(mapConv.get(recId).Id)){
                        ContentDocumentLink cdl = New ContentDocumentLink();
                            cdl.LinkedEntityId = recId;
                            cdl.ContentDocumentId = mapConCont.get(mapConv.get(recId).Id);
                            cdl.shareType = 'V';
                        listLink.add(cdl);
                    }
                }
                if(!listLink.isEmpty())
                    Insert listLink;
            }
        }
    }
}