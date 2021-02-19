public with sharing class RSI_PPMerchantVolume {
    
    @AuraEnabled(cacheable=true)
    public static List<Volume__c> getVolumeList(String accId) {
      return [SELECT Id,MID__c,TIDNUM__c,DATECREATED__c,TOTALNETAMT__c,TOTALTRANSNUM__c,BATCHNUM__c,AMTPURCHASE__c,NUMPURCHASE__c,
       AMTRETURN__c, NUMRETURN__c, APPLICATIONNO__c,MERCHANTBATCHNO__c ,AVERAGETICKET__c,ROW__c FROM Volume__c where Account__c =:accId];
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Transaction_Data__c> getTransList(String batchNo) {
        List<Transaction_Data__c> listOfTrans =new List<Transaction_Data__c>();
        if(batchNo !=null || batchNo != ''){
            List<Volume__c> listOfVol= [SELECT id, (SELECT Id,TOTALNETAMT__c,DATECREATED__c,BATCHNUM__c,CARDTYPE__c,SECNUM__c,
                                                    TRANSDATE__c,TRANSAMT1__c,TRANSAMT2__c,CARDTYPEID__c, CARDIDMETHOD__c, VOIDINDICATOR__c,
                                                    TRANSCODE__c ,AUTHAMOUNT__c FROM Transaction_Data__r) FROM Volume__c where MERCHANTBATCHNO__c =:batchNo];
            for(Volume__c vol :listOfVol){
                for(Transaction_Data__c td :vol.Transaction_Data__r){
                    listOfTrans.add(td);
                }
            }
        }
            system.debug('listOfTrans='+listOfTrans);
            return listOfTrans;
            
        }
   }