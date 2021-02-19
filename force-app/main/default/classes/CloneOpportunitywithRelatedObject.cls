public with sharing class CloneOpportunitywithRelatedObject {
    
    @auraEnabled
    public static String cloneOpportunity(Id applicationId, String appName) //  pass parameters
    {
        System.debug('applicationId--' + applicationId);
        System.debug('appName--' + appName);
        
        String oppName= appName;
        
        ID recordId =  applicationId; 
        
        DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();     
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );      
        String query =        ' SELECT ' +     
            String.join( fieldNames, ',' ) +    
            ' FROM ' +              describeResult.getName() +       
            ' WHERE ' +     
            ' id = :recordId ' +        ' LIMIT 1 '       ;       
        // return generic list of sobjects or typecast to expected type     List<SObject> records = Database.query( query );
        
        List<opportunity> records = Database.query( query );
        
        Opportunity oppCopy = records[0].clone(false, true);
        //     Append the new opportunity name with Clone Text 
        oppCopy.Name = oppName ;
        
        oppCopy.Describe_Other__c='dd'; 
        insert oppCopy; 
        
        /*********** getting data of Office object **********/
        
        List< Owners_Or_Officers__c > ofcList = new List< Owners_Or_Officers__c >();
        
        Owners_Or_Officers__c ofcid = [select id from Owners_Or_Officers__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultofc = ofcid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesofc = new List<String>( describeResultofc.fields.getMap().keySet() );      
        String queryofc =        ' SELECT ' +     
            String.join( fieldNamesofc, ',' ) +    
            ' FROM ' +              describeResultofc.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Owners_Or_Officers__c ofc :   Database.query( queryofc )){
            
            Owners_Or_Officers__c ofcClone = ofc.clone(false, true,false,false);
            
            ofcClone.Application__c= oppCopy.id;
            ofcList.add(ofcClone);
            
            
        } 
        insert ofcList;
        
        
        /* *******************.  Insert  price Information Object ************************** */    
        List< Pricing_Information__c > priceList = new List< Pricing_Information__c >();
        
        Pricing_Information__c prcid = [select id from Pricing_Information__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultprc = prcid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesprc = new List<String>( describeResultprc.fields.getMap().keySet() );      
        String queryprc =        ' SELECT ' +     
            String.join( fieldNamesprc, ',' ) +    
            ' FROM ' +              describeResultprc.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Pricing_Information__c prc :   Database.query( queryprc )){
            
            Pricing_Information__c prcClone = prc.clone(false, true,false,false);
            
            prcClone.Application__c= oppCopy.id;
            priceList.add(prcClone);
            
            
        } 
        insert priceList;  
        
        /* *******************.  Insert  opportunity Products  Object ************************** */  
        
        List< OpportunityLineItem > oliList = new List< OpportunityLineItem >();
        
        OpportunityLineItem oliId = [select id from OpportunityLineItem where opportunityID =: recordId limit 1];
        
        DescribeSObjectResult describeResultoli = oliId.id.getSObjectType().getDescribe();     
        List<String> fieldNamesoli = new List<String>( describeResultoli.fields.getMap().keySet() );      
        String queryoli =        ' SELECT ' +     
            String.join( fieldNamesoli, ',' ) +    
            ' FROM ' +              describeResultoli.getName() +       
            ' WHERE ' +     
            ' opportunityID = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(OpportunityLineItem oli :   Database.query( queryoli )){
            
            OpportunityLineItem oliClone = oli.clone(false, true,false,false);
            oliClone.TotalPrice= null;
            oliClone.opportunityID= oppCopy.id;
            oliList.add(oliClone);
            
            
        } 
        insert oliList;      
        
        
        /* **************. Insert Fee Section....  *************** */   
        
        /*   List< Fee__c > feeList = new List< Fee__c >();

Fee__c feeid = [select id from Fee__c where Application__c =: recordId limit 1];

DescribeSObjectResult describeResultfee = feeid.id.getSObjectType().getDescribe();     
List<String> fieldNamesfee = new List<String>( describeResultfee.fields.getMap().keySet() );      
String queryfee =        ' SELECT ' +     
String.join( fieldNamesfee, ',' ) +    
' FROM ' +              describeResultfee.getName() +       
' WHERE ' +     
' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       


for(Fee__c  fee :   Database.query( queryfee )){

Fee__c  feeClone = fee.clone(false, true,false,false);

feeClone.Application__c= oppCopy.id;
feeList.add(feeClone);


}  
insert feeList;   */
        
        /* **************. Insert Authorzaiton Section....  *************** */        
        
        List< Authorization__c > authList = new List < Authorization__c >();
        
        Authorization__c authid = [select id from Authorization__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultauth = authid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesauth = new List<String>( describeResultauth.fields.getMap().keySet() );      
        String queryauth =        ' SELECT ' +     
            String.join( fieldNamesauth, ',' ) +    
            ' FROM ' +              describeResultauth.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Authorization__c  auth :   Database.query( queryauth )){
            
            Authorization__c  authClone = auth.clone(false, true,false,false);
            
            authClone.Application__c= oppCopy.id;
            authList.add(authClone);
            
        } 
        insert authList;   
        
        
        /* **************. Insert Debit Network Section....  *************** */        
        
        List< Debit_Network__c > debList = new List < Debit_Network__c >();
        
        Debit_Network__c debid = [select id from Debit_Network__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultdeb = debid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesdeb = new List<String>( describeResultdeb.fields.getMap().keySet() );      
        String querydeb =        ' SELECT ' +     
            String.join( fieldNamesdeb, ',' ) +    
            ' FROM ' +              describeResultdeb.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Debit_Network__c  deb :   Database.query( querydeb )){
            
            Debit_Network__c  debClone = deb.clone(false, true,false,false);
            
            debClone.Application__c= oppCopy.id;
            debList.add(debClone);
            
        } 
        insert debList;  
        
        /* **************. Insert Credit  card types Section....  *************** */     
        
        List< Other_Card_Types_VAS__c > octList = new List < Other_Card_Types_VAS__c >();
        
        Other_Card_Types_VAS__c octid = [select id from Other_Card_Types_VAS__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultoct = octid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesoct = new List<String>( describeResultoct.fields.getMap().keySet() );      
        String queryoct =        ' SELECT ' +     
            String.join( fieldNamesoct, ',' ) +    
            ' FROM ' +              describeResultoct.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Other_Card_Types_VAS__c  oct :   Database.query( queryoct )){
            
            Other_Card_Types_VAS__c  octClone = oct.clone(false, true,false,false);
            
            octClone.Application__c= oppCopy.id;
            octList.add(octClone);
            
        } 
        insert octList;   
        
        
        /* **************. Insert Gift  card types Section....  *************** */     
        
        List< Gift_Card__c > gccList = new List < Gift_Card__c >();
        
        Gift_Card__c gccid = [select id from Gift_Card__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultgcc = gccid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesgcc = new List<String>( describeResultgcc.fields.getMap().keySet() );      
        String querygcc =        ' SELECT ' +     
            String.join( fieldNamesgcc, ',' ) +    
            ' FROM ' +              describeResultgcc.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Gift_Card__c  gcc :   Database.query( querygcc )){
            
            Gift_Card__c  gccClone = gcc.clone(false, true,false,false);
            
            gccClone.Application__c= oppCopy.id;
            gccList.add(gccClone);
            
        } 
        insert gccList;  
        
        
        
        /* **************. Insert Additonal Information  Section....  *************** */    
        
        List< Additional_Information__c > aicList = new List < Additional_Information__c >();
        
        Additional_Information__c aicid = [select id from Additional_Information__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultaic = aicid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesaic = new List<String>( describeResultaic.fields.getMap().keySet() );      
        String queryaic =        ' SELECT ' +     
            String.join( fieldNamesaic, ',' ) +    
            ' FROM ' +              describeResultaic.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Additional_Information__c  aic :   Database.query( queryaic )){
            
            Additional_Information__c  aicClone = aic.clone(false, true,false,false);
            
            aicClone.Application__c= oppCopy.id;
            aicList.add(aicClone);
            
        } 
        insert aicList;  
        
        
        /* **************. Equipment Programming Section....  *************** */    
        
        List< Equipment_Programming__c > epcList = new List < Equipment_Programming__c >();
        
        Equipment_Programming__c epcid = [select id from Equipment_Programming__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultepc = epcid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesepc = new List<String>( describeResultepc.fields.getMap().keySet() );      
        String queryepc =        ' SELECT ' +     
            String.join( fieldNamesepc, ',' ) +    
            ' FROM ' +              describeResultepc.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Equipment_Programming__c  epc :   Database.query( queryepc )){
            
            Equipment_Programming__c  epcClone = epc.clone(false, true,false,false);
            
            epcClone.Application__c= oppCopy.id;
            epcList.add(epcClone);
            
        } 
        insert epcList; 
        
        
        /* **************. Insert MPA  Section....  *************** */   
        
        List< MPA_Section__c > mpaList = new List < MPA_Section__c >();
        
        MPA_Section__c mpaid = [select id from MPA_Section__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultmpa = mpaid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesmpa = new List<String>( describeResultmpa.fields.getMap().keySet() );      
        String querympa =        ' SELECT ' +     
            String.join( fieldNamesmpa, ',' ) +    
            ' FROM ' +              describeResultmpa.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(MPA_Section__c  mpa :   Database.query( querympa )){
            
            MPA_Section__c  mpaClone = mpa.clone(false, true,false,false);
            
            mpaClone.Application__c= oppCopy.id;
            mpaList.add(mpaClone);
            
        } 
        insert mpaList;    
        
        /* **************. Insert  Electronic. Check Service  Section....  *************** */   
        
        
        List< Electronic_Check_Service__c > ecsList = new List < Electronic_Check_Service__c >();
        
        Electronic_Check_Service__c ecsid = [select id from Electronic_Check_Service__c where Application__c =: recordId limit 1];
        
        DescribeSObjectResult describeResultecs = ecsid.id.getSObjectType().getDescribe();     
        List<String> fieldNamesecs = new List<String>( describeResultecs.fields.getMap().keySet() );      
        String queryecs =        ' SELECT ' +     
            String.join( fieldNamesecs, ',' ) +    
            ' FROM ' +              describeResultecs.getName() +       
            ' WHERE ' +     
            ' Application__c = :recordId ' +        ' LIMIT 1000 '       ;       
        
        
        for(Electronic_Check_Service__c  ecs :   Database.query( queryecs)){
            
            Electronic_Check_Service__c  ecsClone = ecs.clone(false, true,false,false);
            
            ecsClone.Application__c= oppCopy.id;
            ecsList.add(ecsClone);
            
        } 
        insert ecsList;  
        
        
        
        
        
        
        
        
        
        
        
        
        /*    try{
INSERT
return true;
}catch(exception ex){
return false;
}*/
        
        return oppCopy.Id;
        
    }     
    
}