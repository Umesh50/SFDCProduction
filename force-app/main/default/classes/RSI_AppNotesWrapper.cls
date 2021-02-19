public class RSI_AppNotesWrapper {
    
    public Boolean SUCCESS;
    public DATA DATA;
    public String RECORDCOUNT;

    public class DATA {
        public List<List<String>> DATA;
        public List<String> COLUMNS;
    }

    
    public static RSI_AppNotesWrapper parse(String json) {
        return (RSI_AppNotesWrapper) System.JSON.deserialize(json, RSI_AppNotesWrapper.class);
    }

}