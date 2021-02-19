public with sharing class RSI_NavigateToUrlGen{
    
    @AuraEnabled
    public static string getNavigateUrl(String oppId){
        if(oppId !=null){
            List<Opportunity> oppObj =[select id,StageName from Opportunity where id =: oppId];
            if(oppObj != null || oppObj.size() > 0 && oppObj[0].StageName !='Sent for Signatures'){
                update (new Opportunity(id = oppObj[0].id,StageName = 'Sent for Signatures'));
            }
        }
        Pagereference pg = Page.dfsle__gendocumentgenerator;
            pg.getParameters().put('sId',oppId); 
            pg.getParameters().put('templateId','a163K000000MThgQAG');
            pg.getParameters().put('recordId',oppId);           
            pg.getParameters().put('title','Generate ETF-Agreement');
            system.debug('-----url======='+pg.getUrl());
        return pg.getUrl();
    }
}