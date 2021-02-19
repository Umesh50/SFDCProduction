global class RSI_PPointVolume implements Database.Batchable<sobject> ,Schedulable ,Database.AllowsCallouts {
    //constructor
    global RSI_PPointVolume(){} 
    //execute method of schedulable interface use to schedule the class
    //System.Schedule('GetPPVolume0001','0 59 23 1/1 * ? *', new RSI_PPointVolume());run at 23:59 every day
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new RSI_PPointVolume(),1);
    }  
    //start method of batch class to collect the data
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date d =system.today();
        Date dt = d.addDays(-7);
        system.debug('dt--'+dt);
        return Database.getQueryLocator([SELECT id,Status__c ,MERCHANT_ID__c,(SELECT id,DATECREATED__c FROM Volumes__r where DATECREATED__c <= :dt) FROM Account where MERCHANT_ID__c !=null AND Status__c IN ('Approved','Deployment','Active','Inactive')]);
    }
    
    //execute method of batch class to process the data
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        //list of updated or inserted new record
        List<Volume__c> listOfUpsertRecord =new List<Volume__c>();
        List<Account> updatedAccount = new List<Account>();
        //list of existing volume
        List<Volume__c> listOfExistingVol =new List<Volume__c>();
        //get appkey from custom meta data
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        system.debug('mapOfConnection '+mapOfConnection);
        // get app key to make a url...
        String appKey=mapOfConnection.get('APPKEY');
        // get end point url to get application notes.....
        String getEndpointUrl = RSI_UtilityClass.getApplicationEndPointURL();
        
        //list of account
        List<Account> listOfAccount = (List<Account>)scope ==null ? null : (List<Account>)scope;
        //check list of account is null or not
        if(listOfAccount != null) {
            for(Account objAccount : listOfAccount) {
                Boolean actv = true;
                Boolean inActv = true;
                for(Volume__c volObj :objAccount.Volumes__r){
                    listOfExistingVol.add(volObj);
                }
                //end point url
                getEndpointUrl  = getEndpointUrl.substring(0, getEndpointUrl.indexOf('1')+1);
                getEndpointUrl = getEndpointUrl +'/merchants/'+Integer.valueOf(objAccount.MERCHANT_ID__c)+'/volume?';
                getEndpointUrl = getEndpointUrl + 'appkey=' + appKey;
                system.debug('url '+getEndpointUrl);
                
                //Now do a GET Request 
                HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',getEndpointUrl, 'GET', 'application/json');
                if (response.getStatusCode()==200) {
                    Map<String,String> mapOfDataString =new Map<String,String>();
                    WrappJson wrappResult = parse(response.getBody());
                    //WrappJson wrappResult = parse('{"COLUMNS":["MID","TIDNUM","DATECREATED","TOTALNETAMT","TOTALTRANSNUM","BATCHNUM","AMTPURCHASE","NUMPURCHASE","AMTRETURN","NUMRETURN","APPLICATIONNO","MERCHANTBATCHNO","AVERAGETICKET","ROW"],"DATA":[[8036874876,"0075420008036874876515","January, 17 2021 00:00:00",7500.00,3,14,7500.00,3,0.00,0,"TZK603RC",245611972,2500.000000,0],[8036874876,"0075420008036874876515","January, 18 2021 00:00:00",2000.00,1,13,2000.00,1,0.00,0,"TZK603RC",245172226,2000.000000,0],[8036874876,"0075420008036874876515","January, 19 2021 00:00:00",12250.00,3,12,12250.00,3,0.00,0,"TZK603RC",245100688,4083.333333,0]]}');
                    //list of list of data from wrapper class..........
                    List<List<String>> listOfListOfData = wrappResult.DATA;
                    //loop to iterate the list of data......
                    for(List<String> listOfData : listOfListOfData){
                        system.debug('listOfData :'+listOfData);
                        // created date.......
                        String dt = listOfData[2];
                        if(dt !=null){
                            //replace space with slace........
                            String newdt = dt.replace(' ','/');
                            //split date with slace......
                            List<String> lstdate = newdt.split('/');
                            //get month string.......
                            String strMonth = lstdate[0].subString(0, lstdate[0].indexOf(','));
                            //convert month into number.......
                            Integer month = convertMonthTextToNumber(strMonth);
                            //convert string into date........
                            Date maxDate =Date.newInstance(Integer.valueOf(lstdate[2]), month, Integer.valueOf(lstdate[1]) );
                            //get current system date.........
                            Date minDate =system.today();
                            //check last 7 dayes dates......
                            if(maxDate >= minDate.addDays(-3)){
                                inActv =false;
                                system.debug('3 day--'+maxDate);
                                if(objAccount.Status__c != 'Active' && actv == true){
                                    system.debug('Active');
                                    updatedAccount.add(new Account(Id =objAccount.Id,Status__c='Active'));
                                    actv=false;
                                } 
                            }
                            //system.debug(minDate.addDays(-7));
                            if(maxDate > minDate.addDays(-7)){
                                // add new volume in the list......
                                listOfUpsertRecord.add(new Volume__c(Account__c = objAccount.Id,
                                                                     MID__c =listOfData[0],
                                                                     TIDNUM__c = listOfData[1],
                                                                     DATECREATED__c = maxDate,
                                                                     TOTALNETAMT__c = Decimal.valueOf(listOfData[3]),
                                                                     TOTALTRANSNUM__c = listOfData[4],
                                                                     BATCHNUM__c = listOfData[5],
                                                                     AMTPURCHASE__c = Decimal.valueOf(listOfData[6]),
                                                                     NUMPURCHASE__c = listOfData[7],
                                                                     AMTRETURN__c = Decimal.valueOf(listOfData[8]),
                                                                     NUMRETURN__c = listOfData[9],
                                                                     APPLICATIONNO__c = listOfData[10],
                                                                     MERCHANTBATCHNO__c = listOfData[11],
                                                                     AVERAGETICKET__c = Decimal.valueOf(listOfData[12]),
                                                                     ROW__c = listOfData[13],
                                                                     VExternalId__c = objAccount.Id + listOfData[11])); 
                            }
                            
                        }//dt end if  
                    } //end list of list loop
                    if(inActv == true && objAccount.Status__c != 'Inactive'){
                        system.debug('Inactive');
                        updatedAccount.add(new Account(Id =objAccount.Id,Status__c='Inactive'));    
                    }    
                    
                }    
            }//end for loop
            
        }//end if
        //delete before 7 days data.......
        if(!listOfExistingVol.isEmpty()){
            delete listOfExistingVol;
        }
        system.debug('exit--'+listOfExistingVol);
        //update account status.......
        if(!updatedAccount.isEmpty()){
            update updatedAccount;
        }
        
        //insert or update record based on external id.........
        if(!listOfUpsertRecord.isEmpty()){
            upsert listOfUpsertRecord VExternalId__c;
            system.debug('Record is created or updated');
        }else{system.debug('Record is not created or updated');}
    }
    
    //finish method of batch class
    global void finish(Database.BatchableContext bc) {
        system.debug('batch processing completed !');
    }
    //wrapper class use to convert json to apex......
    class WrappJson{
        public List<String> COLUMNS;
        public List<List<String>> DATA;   
    }
    
    public static WrappJson parse(String json){
        return (WrappJson) System.JSON.deserialize(json, WrappJson.class);
    }
    //convert months into number........
    private static Integer convertMonthTextToNumber(String month){
        Map<String, Integer> monthsMap = new Map<String, Integer>{
            'January'  => 1,
                'February' => 2,
                'March' =>3, 
                'April'  => 4,
                'May' => 5,
                'June' =>6, 
                'July'  => 7,
                'August' => 8,
                'September' =>9, 
                'October'  => 10,
                'November' => 11,
                'December' =>12 
                };
                    return monthsMap.get( month );
    }

}