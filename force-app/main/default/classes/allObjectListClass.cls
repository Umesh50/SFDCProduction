public class allObjectListClass {
public static String selectedObj{get;set;}

    public static List<selectOption> getObjName(){
  
       List<selectOption> options = new List<selectOption>();
        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
        {
           Schema.DescribeSObjectResult objResult = o.getDescribe();           
           system.debug( 'Sobject API Name: ' + objResult.getName() +' Sobject Label Name: ' + objResult.getLabel());           
           options.add(new SelectOption(objResult.getName(),objResult.getLabel()));
         
        }
        return options;
    }

    
    public static List<String> getFieldName(){
     List<String> reqFields = new List<String>();
           if(selectedObj!=null){
        system.debug('^^^^^^'+selectedObj );
    
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(selectedObj);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
                       for(String fieldName : MapofField.keySet()) {
                        Schema.SObjectField field = MapofField .get(fieldName);
                        Schema.DescribeFieldResult F = field.getDescribe();
        if( F.isCreateable() && !F.isNillable() && !F.isDefaultedOnCreate() )
        {
       reqFields.add(fieldName );
        }
       }

    }
    return reqFields;    
}

}