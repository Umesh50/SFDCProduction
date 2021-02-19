global class RSI_PrintStatementSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      RSI_PrintStatementBatch BS = new RSI_PrintStatementBatch ();
        Database.executeBatch(BS); 
   }
}