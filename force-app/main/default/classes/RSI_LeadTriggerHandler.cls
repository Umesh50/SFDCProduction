/****************************************************************************************************************
 * Name...................: RSI_LeadTriggerHandler
 * Created By.............: Umesh Kumar
 * Created Date...........: 04/09/2020
 * Description............: This class use by RSI_LeadTrigger trigger to update partner name whenever we insert or
 *                           update the partner code
 *******************************************************************************************************************/

public class RSI_LeadTriggerHandler {
    public static void onBeforeInsert(List<Lead> listOfLead){
        Map<String,String> mapOFCodeWithLeadId = new Map<String,String>();      
        for(Lead objLead : listOfLead){
            if(objLead.Partner_Code__c !=null){
                mapOFCodeWithLeadId.put(objLead.Id,objLead.Partner_Code__c);
            }
        }
        if(mapOFCodeWithLeadId !=null && mapOFCodeWithLeadId.size()>0)
            commonMethod(listOfLead,mapOFCodeWithLeadId);
        
    } 
    
    // method for update partnet code
    public static void onBeforeUpdate(List<Lead> listOfLead,  Map<ID, Lead> oldLeadMap){
        Map<String,String> mapOFCodeWithLeadId = new Map<String,String>();      
        for(Lead objLead : listOfLead){
            Lead oldLead = oldLeadMap.get(objLead.Id);
            if(objLead.Partner_Code__c !=null && oldLead.Partner_Code__c !=objLead.Partner_Code__c){
                mapOFCodeWithLeadId.put(objLead.Id,objLead.Partner_Code__c);
            }
            // else
            // objLead.Partner_Name__c =null;
        }
        if(mapOFCodeWithLeadId !=null && mapOFCodeWithLeadId.size()>0)
            commonMethod(listOfLead,mapOFCodeWithLeadId);
        
        
    } 
    
    // common method for insert and update
    public static void commonMethod(List<Lead> listOfLead,Map<String,String> mapOFCodeWithLeadId){
        Map<String,String> mapOFCodeWithAccountId = new Map<String,String>();
        // check set empty
        if(mapOFCodeWithLeadId !=null&& mapOFCodeWithLeadId.size()>0){
            List<Account>  listOfAccount = [select id,Name,Partner_Code__c  from Account where Partner_Code__c  in  :mapOFCodeWithLeadId .values() ];
            if(listOfAccount !=null && listOfAccount.size()>0){
                for(Account objAcc : listOfAccount){
                    if(objAcc.Partner_Code__c   !=null)
                        mapOFCodeWithAccountId.put(objAcc.Partner_Code__c,objAcc.Id);
                }
            }
        }
        
        if(mapOFCodeWithAccountId !=null && mapOFCodeWithAccountId.size()>0){
            for(Lead objLead : listOfLead){
                String partnetCode = mapOFCodeWithLeadId.get(objLead.Id);
                if(mapOFCodeWithAccountId.get(partnetCode)!=null){
                    objLead.Partner_Name__c = mapOFCodeWithAccountId.get(partnetCode);
                }
                
            }
            
        }
        else
        {
            for(Lead objLead : listOfLead){
                objLead.Partner_Name__c =null;  
                
            }  
        }       
    }

}