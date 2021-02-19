/**
 * @description       :
 * @author            : Ajay Kumar
 * @group             :
 * @last modified on  : 31-12-2020
 * @last modified by  : Ajay Kumar
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   4-1-2021   Ajay Kumar   Initial Version
**/

public without sharing class RSI_PPMerchent_ID{
    @future (callout=true)
    public static void pulsepointmerchent(List<Id> listAccId){
        List<Account> listAccToUpdate = new List<Account>();
        String method = 'POST';
        String ContentType = 'application/json';
        Map<String,String> mapOfConnection = RSI_UtilityClass.getApplicationConnection();
        for(Account obj : [SELECT Id,MID__c,MERCHANT_ID__c  FROM Account WHERE Id IN : listAccId]){
            String baseEndpoint = mapOfConnection.get('Connection') + '/' + mapOfConnection.get('APPID') + '/v1/applications/merchants'+'?appkey=' + mapOfConnection.get('APPKEY')+'&search='+obj.MID__c;
            HttpResponse response = RSI_UtilityClass.getMakeHttpRequest('',baseEndpoint,method,ContentType);
            if(response.getStatusCode() == 200){
                Map<String,Object> docResult=(Map<String,Object>)JSON.deserializeUntyped (response.getBody());
                List<Object> listStr = (List<Object>)docResult.get('DATA');
                List<String> listData = String.valueOf(listStr[0]).split(',');
                Account acc = new Account();
                    acc.Id = obj.Id;
                    acc.MERCHANT_ID__c  = listData[6];
                listAccToUpdate.add(acc);
            }
        }
        if(!listAccToUpdate.isEmpty())
            update listAccToUpdate;
    }
}