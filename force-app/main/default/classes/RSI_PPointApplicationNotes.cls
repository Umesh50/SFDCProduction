public class RSI_PPointApplicationNotes {
    
    //execute the code
    @AuraEnabled
    public static List<Application_Note__c> getPPointNotes(String oppid){ 
        // list of updated Application with application note number and notes....
        List<Opportunity> lstoppty =[select id,Merchant_Application_No__c from Opportunity where id=:oppid AND Merchant_Application_No__c !=null];
        List<Application_Note__c> newAppNotes = new List<Application_Note__c>();
        //get appkey from custom meta data
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        // get app key to make a url...
        String appKey=mapOfConnection.get('APPKEY');
        // get end point url to get application notes.....
        String getEndpointUrl = RSI_UtilityClass.getApplicationEndPointURL();
        for (Opportunity oppty : lstoppty) {
            if (Integer.valueOf(oppty.Merchant_Application_No__c) != null) {
                getEndpointUrl = getEndpointUrl +Integer.valueOf(oppty.Merchant_Application_No__c)+'/notes?';
                getEndpointUrl = getEndpointUrl + 'appkey=' + appKey;
                //Now do a GET Request
                HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',getEndpointUrl, 'GET', 'application/json');
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
        return newAppNotes;
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