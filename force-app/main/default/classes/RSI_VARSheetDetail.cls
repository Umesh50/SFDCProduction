public class RSI_VARSheetDetail implements Queueable, Database.AllowsCallouts{
    
     public List<Id> newTrigger ; 
    public RSI_VARSheetDetail(List<Id> newTrigg){
        this.newTrigger = newTrigg ;  
    }
    public void execute(QueueableContext context) {
        // get account List based on account id....
        List<Account> accList =[select id,MERCHANT_ID__c from Account where Id IN : newTrigger];
        //get appkey from custom meta data
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        // get app key to make a url...
        String appKey=mapOfConnection.get('APPKEY');
        // get end point url to get application notes.....
        String getEndpointUrl = RSI_UtilityClass.getApplicationEndPointURL();
        //list of new VAR Sheet.......
        List<VAR_Sheet__c> listOfUpdatedVARSheet =new List<VAR_Sheet__c>();
        for(Account accObj :accList){
            //request end point url to get coding id.....
            getEndpointUrl  = getEndpointUrl.substring(0, getEndpointUrl.indexOf('1')+1);
            getEndpointUrl = getEndpointUrl +'/merchants/'+Integer.valueOf(accObj.MERCHANT_ID__c)+'/coding?';
            getEndpointUrl = getEndpointUrl + 'appkey=' + appKey;
            //Now do a GET Request Object // 
            system.debug('url1 '+getEndpointUrl);
            HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',getEndpointUrl, 'GET', 'application/json');
            if (response.getStatusCode()==200) {
                //response wrapper class..........
                WrappJson wrappResult = parse(response.getBody());
                //WrappJson wrappResult = parse('{ "SUCCESS": true,"DATA": [["","",12,"","NEXUS DATALINK",40005,"","X","Vendor Distributed"]],"COLUMNS": [ "APPLICATIONNUM","CHECK_READER_TYPE","CODE_ID","DOWNLOADNUM","MERCHANT_NAME","MERCH_ID","PINPADTYPE","PRINTERTYPE","TERMINALTYPE"]}');
                 List<List<String>> listOfListOfData = wrappResult.DATA;
                 for(List<String> listOfData : listOfListOfData){
                     if(listOfData[2] != null){
                    //end point url to get VAR Sheet detail..........
                    getEndpointUrl  = getEndpointUrl.substring(0, getEndpointUrl.indexOf('1')+1);
                    getEndpointUrl = getEndpointUrl +'/merchants/'+Integer.valueOf(accObj.MERCHANT_ID__c)+'/coding/'+Integer.valueOf(listOfData[2])+'?';
                    getEndpointUrl = getEndpointUrl + 'appkey=' + appKey;
                    system.debug('url2 '+getEndpointUrl);
                    HttpResponse vARResponse = RSI_UtilityClass.getMakeHttpRequest('',getEndpointUrl, 'GET', 'application/json');
                    if(vARResponse.getStatusCode()==200) {
                     Map<String,Object> result = (Map<String,Object>)JSON.deserializeUntyped(vARResponse.getBody());
                        //Map<String,Object> result = (Map<String,Object>)JSON.deserializeUntyped('{"AMEX": "","CODE_ID": 12,"CREATED_DATE": "October, 26 2020 00:00:00","DISCOVER": "","CHECK_READER_TYPE": "","WIRELESSMAN": "","PINPADTYPE":"","TERMINALIDNUM": "0008036749748607","BANKID": "","MERCHANTHELPDESKNUM": "1-800-741-3737","TRACKINGPROVIDER": "","MERCHSERVICETYPE": "","TERMINALAPPNUM": "","TERMINALTYPE": "Vendor Distributed","WIRELESSESN": "","NOVAMERCHANTHELPDESK": "1-800-972-4608","NOVAMSPHELPDESK": "1-800-741-3737","GATEWAYPASSWORD": "","TRACKINGNUMBER": "","LEASECOMPANYNAME": "","CREATED_BY": "MerchWire","VERIFICATIONPHONENUM": "","PRINTERTYPE": "X","JCB": "","LEASENUM": "","GATEWAYLOGIN": "","EQUIPMENTTID": "","APPLICATIONNUM": "","PHONEINAPPROVALNUM": "1-800-972-4608","CREDITDECISION": "","DOWNLOADNUM": "","DINERSCLUB": "","LADCOAPPLICATIONNUM": ""}');
                            system.debug('----result---'+JSON.serialize(result));
                            listOfUpdatedVARSheet.add(new VAR_Sheet__c(Account__c = accObj.Id,
                            MERCHANT_NAME__c  = listOfData[4],
                            MERCH_ID__c  = listOfData[5],
                            
                            CODE_ID__c = String.valueOf(result.get('CODE_ID')),
                            APPLICATIONNUM__c = String.valueOf(result.get('APPLICATIONNUM')),
                            AMEX__c = String.valueOf(result.get('AMEX')),
                            CHECK_READER_TYPE__c = String.valueOf(result.get('CHECK_READER_TYPE')),
                            CREATED_DATE__c = convertDate(String.valueOf(result.get('CREATED_DATE'))),
                            DISCOVER__c = String.valueOf(result.get('DISCOVER')),
                            WIRELESSMAN__c = String.valueOf(result.get('WIRELESSMAN')),
                            TERMINALIDNUM__c = String.valueOf(result.get('TERMINALIDNUM')),
                            BANKID__c = String.valueOf(result.get('BANKID')),
                            TERMINALTYPE__c = String.valueOf(result.get('TERMINALTYPE')),
                            PRINTERTYPE__c = String.valueOf(result.get('PRINTERTYPE')),
                            PINPADTYPE__c = String.valueOf(result.get('PINPADTYPE')),
                            DOWNLOADNUM__c =  String.valueOf(result.get('DOWNLOADNUM')),
                            MERCHANTHELPDESKNUM__c = String.valueOf(result.get('MERCHANTHELPDESKNUM')),
                            TRACKINGPROVIDER__c = String.valueOf(result.get('TRACKINGPROVIDER')),
                            MERCHSERVICETYPE__c = String.valueOf(result.get('MERCHSERVICETYPE')),
                            TERMINALAPPNUM__c = String.valueOf(result.get('TERMINALAPPNUM')),
                            WIRELESSESN__c = String.valueOf(result.get('WIRELESSESN')),
                            NOVAMERCHANTHELPDESK__c = String.valueOf(result.get('NOVAMERCHANTHELPDESK')),
                            NOVAMSPHELPDESK__c = String.valueOf(result.get('NOVAMSPHELPDESK')),
                            GATEWAYPASSWORD__c = String.valueOf(result.get('GATEWAYPASSWORD')),
                            TRACKINGNUMBER__c = String.valueOf(result.get('TRACKINGNUMBER')),
                            LEASECOMPANYNAME__c = String.valueOf(result.get('LEASECOMPANYNAME')),
                            CREATED_BY__c = String.valueOf(result.get('CREATED_BY')),
                            VERIFICATIONPHONENUM__c = String.valueOf(result.get('VERIFICATIONPHONENUM')),
                            JCB__c = String.valueOf(result.get('JCB')),
                            LEASENUM__c = String.valueOf(result.get('LEASENUM')),
                            GATEWAYLOGIN__c = String.valueOf(result.get('GATEWAYLOGIN')),
                            EQUIPMENTTID__c = String.valueOf(result.get('EQUIPMENTTID')),
                            PHONEINAPPROVALNUM__c = String.valueOf(result.get('PHONEINAPPROVALNUM')),
                            CREDITDECISION__c = String.valueOf(result.get('CREDITDECISION')),
                            DINERSCLUB__c = String.valueOf(result.get('DINERSCLUB')),
                            LADCOAPPLICATIONNUM__c = String.valueOf(result.get('LADCOAPPLICATIONNUM')),
                            VARSExternalId__c = String.valueOf(result.get('CODE_ID'))+ accObj.Id));
                    }
                    }  
                    }
                 }
             }
             if(!listOfUpdatedVARSheet.isEmpty()){
                upsert listOfUpdatedVARSheet VARSExternalId__c;
                system.debug('Record is created or updated');
            }else{system.debug('Record is not created or updated');}
        }

    class WrappJson {
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
        Date maxDate;
        if(!Test.isRunningTest()){
            String newdt = dt.replace(' ','/');
            //split date with slace......
            List<String> lstdate = newdt.split('/');
            //get month string.......
            String strMonth = lstdate[0].subString(0, lstdate[0].indexOf(','));
            //convert month into number.......
            Integer month = monthsMap.get(strMonth);
            //convert string into date........       
             maxDate = Date.newInstance(Integer.valueOf(lstdate[2]), month, Integer.valueOf(lstdate[1]) );
        }
        return maxDate;
    }
}