public class RSI_UpdateMPASection {
    
    @AuraEnabled
    public static void getUpdateMPASection(Id oppId){
        Id mpaId;
        String ownOne;
        String ownTwo;
        String titleOne;
        String titleTwo;
        List<MPA_Section__c> mpaObj=new List<MPA_Section__c>();
         for(Opportunity oppObj : [SELECT Id,Corporate_Name__c,DBA_Address_1__c,Country__c,Address_Type__c,City__c,State__c,Zip_Code__c,    
                                  (SELECT Id,FullName__c, Primary_Owner_Or_Officer__c,Principal_Title__c FROM Owners_Or_Officers__r 
                                   where Owner_Type__c = '2' ORDER BY Primary_Owner_Or_Officer__c DESC limit 2),
                                  (SELECT Id from MPA_Section__r) from Opportunity where id =:oppId]){
                                   for(MPA_Section__c objmpa :oppObj.MPA_Section__r) {
                                       mpaId = objmpa.Id;    
                                      }   
                                      
                                      List<Owners_Or_Officers__c> ownrObj  = oppObj.Owners_Or_Officers__r;
                                      if(ownrObj != null && ownrObj.size() >0) {
                                          ownOne = ownrObj[0].FullName__c;
                                          titleOne = ownrObj[0].Principal_Title__c;
                                          if(ownrObj.size() > 1) {
                                              ownTwo = ownrObj[1].FullName__c;
                                              titleTwo = ownrObj[1].Principal_Title__c;
                                          }
                                          
                                      }           
                                            
                                    mpaObj.add(new MPA_Section__c(id =mpaId,
                                                                 Title__c = titleOne,
                                                                 Title2__c = titleTwo,
                                                                 City__c = oppObj.City__c,
                                                                 Date__c = System.today(),
                                                                 Date2__c = System.today(),
                                                                 Date3__c = System.today(),
                                                                 Date4__c = System.today(),
                                                                 State__c = oppObj.State__c,
                                                                 Application__c = oppObj.Id,
                                                                 Country__c = oppObj.Country__c,
                                                                 Zip_Code__c = oppObj.Zip_Code__c,
                                                                 Xnd_Owner_Printed_Name__c = ownTwo,
                                                                 Xst_Owner_Printed_Name__c = ownOne,
                                                                 Address__c = oppObj.DBA_Address_1__c,
                                                                 Rep_Signature_Date__c = System.today(),
                                                                 Xst_Personal_Guarantee_Name__c = ownOne,
                                                                 Xnd_Personal_Guarantee_Name__c = ownTwo,
                                                                 Address_Type__c = oppObj.Address_Type__c,
                                                                 Legal_Business_Name__c = oppObj.Corporate_Name__c));                                         
                                                 
                                   
                                       
                                       
                                   }
        if(!mpaObj.isEmpty()){
           upsert  mpaObj; 
        }   
    }
}