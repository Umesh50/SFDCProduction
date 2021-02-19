/****************************************************************************************************************
 * Name...................: RSI_OwnersOrOfficersTriggerHelper
 * Created By.............: Umesh Kumar
 * Created Date...........: 09/10/2020
 * Description............: This class use to maintain the primary Owners Or Officers.
 *******************************************************************************************************************/

public class RSI_OwnersOrOfficersTriggerHelper {

    public static void handlePrimaryOwner(List <Owners_Or_Officers__c> triggNew){
        //Hold the record id
        Id ownerorOfficerId;
        //Qquery to get all primary record
        List<Owners_Or_Officers__c> ownerList=[select id,Primary_Owner_Or_Officer__c from Owners_Or_Officers__c
                       where Primary_Owner_Or_Officer__c=true AND Application__c =: triggNew[0].Application__c];
        for(Owners_Or_Officers__c objOwner: triggNew){
            if(objOwner.Primary_Owner_Or_Officer__c==true){
                ownerorOfficerId=objOwner.Id;
            }else if(ownerList.size()==0 || ownerList.size()==null){
                objOwner.Primary_Owner_Or_Officer__c.addError('You should have at least one primary owner');
            }
        }
        commonMethodForPrimaryOwner(ownerorOfficerId,triggNew[0].Application__c);
    }

    // public static boolean istrue=true;
    public static void commonMethodForPrimaryOwner(Id ownerorOfficerId,Id oppId){
        List<Owners_Or_Officers__c> ownerList;
        if(ownerorOfficerId!=null && oppId !=null){
            //Qquery to get all primary record
            ownerList=[select id,Primary_Owner_Or_Officer__c from Owners_Or_Officers__c
                       where Primary_Owner_Or_Officer__c=true AND Id!=:ownerorOfficerId AND Application__c =: oppId ];}
        if(ownerList!=null ){
            //Build a list of updated record
            List<Owners_Or_Officers__c> updatedList=new List<Owners_Or_Officers__c>();
            //Loop to add updated record in list
            for(Owners_Or_Officers__c objOwner:ownerList){
                objOwner.Primary_Owner_Or_Officer__c=false;
                updatedList.add(objOwner);
            }
            //update command to update the record
            update updatedList;
        }
        // istrue=false;
    }

    public static void afterHandler (List <Owners_Or_Officers__c> trgNew, Map <Id, Owners_Or_Officers__c> oldMap) {
        Set <Id> opptyIds = new Set <Id> ();
        for (Owners_Or_Officers__c ofc : trgNew) {
            if (!RSI_StopRecursion.setExecutedIds.contains(ofc.Id)) {
                if (oldMap == null || ofc.Ownership_Percentage__c != oldMap.get(ofc.Id).Ownership_Percentage__c) {
                    opptyIds.add(ofc.Application__c);
                }
            }
        }
        if (!opptyIds.isEmpty()) {
            updateAddOwnerField(opptyIds);
        }
    }

    private static void updateAddOwnerField (Set <Id> opptyIds) {
        //Scenario 1: Primary Owner above 75 %
        //Scenario 2: Primary Owner <= 75%
        //Scenario 3: Primary Owner <= 75%; Secondary Owner >= 25%
        //Scenario 4: Primary Owner <= 75%; Multiple Secondary Owners >= 25%
        List <Owners_Or_Officers__c> lstToUpd = new List <Owners_Or_Officers__c> ();
        for (Opportunity opp : [SELECT Id, (SELECT Id, Primary_Owner_Or_Officer__c, Ownership_Percentage__c, Additional_Owner_Or_25_Ownership__c FROM Owners_Or_Officers__r ORDER BY Primary_Owner_Or_Officer__c DESC, CreatedDate ASC) FROM Opportunity WHERE Id IN: opptyIds]) {
            for (Integer i = 0; i < opp.Owners_Or_Officers__r.size(); i++) {
                String addVal = 'YES';
                addVal = i == opp.Owners_Or_Officers__r.size() - 1 ? 'NO' : 'YES';
                addVal = opp.Owners_Or_Officers__r.size() == 1 && opp.Owners_Or_Officers__r[i].Ownership_Percentage__c < 75 ? 'YES' : addVal;
                //addVal = opp.Owners_Or_Officers__r.size() == 1 && opp.Owners_Or_Officers__r[0].Ownership_Percentage__c >= 75 ? 'NO' : addVal;
                lstToUpd.add(new Owners_Or_Officers__c(Id = opp.Owners_Or_Officers__r[i].Id, Additional_Owner_Or_25_Ownership__c = addVal));
                RSI_StopRecursion.setExecutedIds.add(opp.Owners_Or_Officers__r[i].Id);
            }
        }
        if (!lstToUpd.isEmpty()) {
            update lstToUpd;
        }
    }
  
     public static void updateAccSSN(List <Owners_Or_Officers__c> trgNew,Map <Id, Owners_Or_Officers__c> oldMap) {
         Set<Id> setOfOPPId =new Set<Id>();
         List<Account> updatedAccs=new List<Account>();
         Map<Id,Id> mapOfOpp =new Map<Id,Id>();
         for(Owners_Or_Officers__c ownOb :trgNew){
             if(ownOb.Application__c != null){
                 setOfOPPId.add(ownOb.Application__c); 
             }
             
         }
         
         for(Opportunity oppObj :[select id,Business_Type__c,AccountId  from Opportunity where id IN :setOfOPPId]){
             if(oppObj.Business_Type__c == '0' && oppObj.AccountId !=null){ 
                 mapOfOpp.put(oppObj.id,oppObj.AccountId);
             }
         } 
    
         if(!mapOfOpp.isEmpty())  {      
         for (Owners_Or_Officers__c newOwnr : trgNew) {
             if(oldMap ==null){
             if(mapOfOpp.containsKey(newOwnr.Application__c)==true && newOwnr.Country_of_Citizenship_1__c == 'USA' && newOwnr.ID_Type__c =='SSN' && newOwnr.ID_Number__c !=null && newOwnr.Primary_Owner_Or_Officer__c == true && newOwnr.Ownership_Percentage__c ==100){
                 updatedAccs.add(New Account(id = mapOfOpp.get(newOwnr.Application__c),SSN__c =newOwnr.ID_Number__c));  
             }
             }else if(newOwnr.ID_Number__c !=oldMap.get(newOwnr.Id).ID_Number__c && mapOfOpp.containsKey(newOwnr.Application__c)==true && newOwnr.Country_of_Citizenship_1__c == 'USA' && newOwnr.ID_Type__c =='SSN' && newOwnr.ID_Number__c !=null && newOwnr.Primary_Owner_Or_Officer__c == true && newOwnr.Ownership_Percentage__c ==100){
                 updatedAccs.add(New Account(id = mapOfOpp.get(newOwnr.Application__c),SSN__c =newOwnr.ID_Number__c));    
             }
           }
         }
         if(!updatedAccs.isEmpty()){
             update updatedAccs;
         }
     } 
}