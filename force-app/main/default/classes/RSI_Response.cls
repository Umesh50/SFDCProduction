public class RSI_Response {

    @Auraenabled
  public Boolean isSuccess;

  @Auraenabled
  public String message;

  @Auraenabled
  public Object data;

  public RSI_Response(Boolean isSuccess, Object data, String message) {
    this.isSuccess = isSuccess;
    this.data = data;
    this.message = message;
  }
}