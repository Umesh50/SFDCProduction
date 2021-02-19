global class RSI_ApplicationNotesBatch implements Database.Batchable<sobject> ,Schedulable ,Database.AllowsCallouts {
    
    //constructor
    global RSI_ApplicationNotesBatch(){} 
    //execute method of schedulable interface use to schedule the class
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new RSI_ApplicationNotesBatch(),1);
    }  
    //start method of batch class to collect the data
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select id,Merchant_Application_No__c from Opportunity where Merchant_Application_No__c !=null AND StageName IN ('Approved','Underwriting Request')]);
    }
    
    //execute method of batch class to process the data
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        // list of updated Application notes ....
        List<Application_Note__c> newAppNotes = new List<Application_Note__c>();
        //get appkey from custom meta data
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        // get app key to make a url...
        String appKey=mapOfConnection.get('APPKEY');
        // get end point url to get application notes.....
        String getEndpointUrl = RSI_UtilityClass.getApplicationEndPointURL();
        //list of opportunity
        List<Opportunity> listOfOpp = (List<Opportunity>)scope ==null ? null : (List<Opportunity>)scope;
        //check list of opp is null or not
        if(listOfOpp != null) {
            for (Opportunity oppty : listOfOpp) {
                String endpoint = getEndpointUrl;
                endpoint = endpoint +Integer.valueOf(oppty.Merchant_Application_No__c)+'/notes?';
                endpoint = endpoint + 'appkey=' + appKey;
                system.debug('Url=='+endpoint);
                //Now do a GET Request
                HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',endpoint, 'GET', 'application/json');
                if (response.getStatusCode()==200) {
                    RSI_AppNotesWrapper res =RSI_AppNotesWrapper.parse(response.getBody());
                    List<List<String>> resDataOfData = res.DATA.DATA;
                    system.debug('res---'+resDataOfData);
                    //loop to iterate the list of data......
                    for(List<String> listOfData : resDataOfData){
                        system.debug('listOfData :'+listOfData);
                        // created date.......
                        DateTime addedDate;
                        String addDate = listOfData[3];
                        if(addDate !=null || addDate != ''){
                            addedDate = convertDateTime(addDate); 
                        }
                        newAppNotes.add(new Application_Note__c(Note_No__c=listOfData[0],
                                                                Note__c=listOfData[2],
                                                                Application__c=oppty.Id,
                                                                Date_Added__c =addedDate,
                                                                NExternalId__c=listOfData[0]+oppty.Id));   
                        
                    }
                    
                    
                }
                
            }  
        }
        
        if(!newAppNotes.isEmpty()){
            upsert newAppNotes NExternalId__c;
            system.debug('Notes inserted!');
        }else{system.debug('Notes not inserted!');} 
    }  
    //finish method of batch class
    global void finish(Database.BatchableContext bc) {
        system.debug('batch processing completed !');
    }
    
    //convert Date........
    private static DateTime convertDateTime(String dt){
        //replace space with slace........
        String newdt = dt.replace(' ','/');
        newdt = newdt.replace(':','/');
        system.debug('newdt--'+newdt);
        //split date with slace......
        List<String> lstdate = newdt.split('/');
        //convert string into date........
        DateTime dtime =DateTime.newInstance(Integer.valueOf(lstdate[2]),Integer.valueOf(lstdate[0]),Integer.valueOf(lstdate[1]),Integer.valueOf(lstdate[3]),Integer.valueOf(lstdate[4]),0);
        return dtime;
    }
}