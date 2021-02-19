global class RSI_PPTransactionData implements Database.Batchable<sobject> ,Schedulable ,Database.AllowsCallouts{
    
    //constructor
    global RSI_PPTransactionData(){} 
    //execute method of schedulable interface use to schedule the class
    //System.Schedule('GetPPTrans0002','0 0 2 1/1 * ? *', new RSI_PPTransactionData());run at 02:00 AM every day
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new RSI_PPTransactionData(),1);
    }  
    //start method of batch class to collect the data
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date d =system.today();
        Date dt = d.addDays(-7);
        return Database.getQueryLocator([SELECT id,Account__r.MERCHANT_ID__c,BATCHNUM__c,(SELECT id,DATECREATED__c FROM Transaction_Data__r where DATECREATED__c <= :dt) FROM Volume__c where BATCHNUM__c !=null]);
    }
    
    //execute method of batch class to process the data
    global void execute(Database.BatchableContext bc, List<Volume__c> scope) {
        //list of updated or inserted new record
        List<Transaction_Data__c> listOfUpsertRecord =new List<Transaction_Data__c>();
        //list of existing volume
        List<Transaction_Data__c> listOfExistingTrans =new List<Transaction_Data__c>();
        //get appkey from custom meta data
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        //system.debug('mapOfConnection '+mapOfConnection);
        // get app key to make a url...
        String appKey=mapOfConnection.get('APPKEY');
        // get end point url to get application notes.....
        String getEndpointUrl = RSI_UtilityClass.getApplicationEndPointURL();
        
        //list of account
        List<Volume__c> listOfVolume = (List<Volume__c>)scope ==null ? null : (List<Volume__c>)scope;
        //check list of account is null or not
        if(listOfVolume != null) {
            for(Volume__c objVolume : listOfVolume) {
                for(Transaction_Data__c transObj :objVolume.Transaction_Data__r){
                    listOfExistingTrans.add(transObj);
                }
                if(objVolume.Account__r.MERCHANT_ID__c != null){
                //end point url
                getEndpointUrl  = getEndpointUrl.substring(0, getEndpointUrl.indexOf('1')+1);
                getEndpointUrl = getEndpointUrl +'/merchants/'+Integer.valueOf(objVolume.Account__r.MERCHANT_ID__c)+'/volume/';
                getEndpointUrl = getEndpointUrl+Integer.valueOf(objVolume.BATCHNUM__c)+'?';
                getEndpointUrl = getEndpointUrl + 'appkey=' + appKey;
                system.debug('url '+getEndpointUrl);
                
                //Now do a GET Request 
                HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',getEndpointUrl, 'GET', 'application/json');
                if (response.getStatusCode()==200) {
                    WrappJson wrappResult = parse(response.getBody());
                    //WrappJson wrappResult = parse('{"COLUMNS":["TOTALNETAMT","DATECREATED","BATCHNUM","CARDTYPE","SECNUM","TRANSDATE","TRANSAMT1","TRANSAMT1","CARDTYPEID","CARDIDMETHOD","VOIDINDICATOR","TRANSCODE","AUTHAMOUNT"],"DATA":[[2000.00,"January, 18 2021 00:00:00",14,"Discover","601101******3024","December, 21 2020 00:00:00",2000.00,2000.00,12,"D740308255","N","01",66694224.00]]}');
                    //list of list of data from wrapper class..........
                    List<List<String>> listOfListOfData = wrappResult.DATA;
                    //loop to iterate the list of data......
                    for(List<String> listOfData : listOfListOfData){
                        system.debug('listOfData :'+listOfData);
                        // created date.......
                        Date trDate;
                        String dt = listOfData[1];
                        String trnsDate = listOfData[5];
                        if(trnsDate !=null || trnsDate != ''){
                            trDate = convertDate(trnsDate); 
                        }
                        if(dt !=null || dt != ''){
                            //convert string into date........
                            Date maxDate = convertDate(dt);
                            //get current system date.........
                            Date minDate =system.today();
                            //check last 7 dayes dates......
                            //system.debug('max--'+maxDate);
                            //system.debug(minDate.addDays(-7));
                            if(maxDate > minDate.addDays(-7)){
                                system.debug('in side if');
                                // add new volume in the list......
                                listOfUpsertRecord.add(new Transaction_Data__c(Volume__c = objVolume.Id,
                                                                               Account__c = objVolume.Account__c,
                                                                               TOTALNETAMT__c = Decimal.valueOf(listOfData[0]),
                                                                               DATECREATED__c = maxDate,
                                                                               BATCHNUM__c = listOfData[2],
                                                                               CARDTYPE__c = listOfData[3],
                                                                               SECNUM__c = listOfData[4],
                                                                               TRANSDATE__c = trDate,
                                                                               TRANSAMT1__c = Decimal.valueOf(listOfData[6]),
                                                                               TRANSAMT2__c = Decimal.valueOf(listOfData[7]),
                                                                               CARDTYPEID__c = listOfData[8],
                                                                               CARDIDMETHOD__c = listOfData[9],
                                                                               VOIDINDICATOR__c = listOfData[10],
                                                                               TRANSCODE__c = listOfData[11],
                                                                               AUTHAMOUNT__c = Decimal.valueOf(listOfData[12]),
                                                                               TExternalId__c = objVolume.Id+listOfData[2])); 
                            }
                            
                        }//dt end if  
                    } 
                }
            }//merchant no if end
            }//end for loop
            
        }//end if
        //delete before 7 days data.......
        if(!listOfExistingTrans.isEmpty()){
            delete listOfExistingTrans;
        }
        system.debug('exit--'+listOfExistingTrans);
        //insert or update record based on external id.........
        if(!listOfUpsertRecord.isEmpty()){
            upsert listOfUpsertRecord TExternalId__c;
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
    
    //convert Date........
    private static Date convertDate(String dt){
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
        //replace space with slace........
        String newdt = dt.replace(' ','/');
        //split date with slace......
        List<String> lstdate = newdt.split('/');
        //get month string.......
        String strMonth = lstdate[0].subString(0, lstdate[0].indexOf(','));
        //convert month into number.......
        Integer month = monthsMap.get(strMonth);
        //convert string into date........
        Date maxDate =Date.newInstance(Integer.valueOf(lstdate[2]), month, Integer.valueOf(lstdate[1]) );
        
        return maxDate;
    }
    

}