public class PostalCodeApi {
  public static string pincode='841203';
  public static List<String> callPostalApi()
  {
      List<String> places =new List<String>();
      String endpoint ='https://api.postalpincode.in/pincode/'+pincode;
      Http sp =new Http();
      HttpRequest req =new HttpRequest();
      req.setEndpoint(endpoint);
      req.setMethod('GET');
      HttpResponse res=sp.send(req);
      if(res.getStatusCode()==200)
      {
          String jsonString =res.getBody();
          System.debug('JsonString---->'+jsonString);
          //****Deserialization****
          System.JSONParser jp= JSON.createParser(jsonString);
          while(jp.nextToken()!=null)
          {
              if(jp.getText()=='Name')
              {
                 jp.nextToken();
                 places.add(jp.getText());
              }
          }
      }
      
      System.debug('List of Places--->'+places);
     Return places;
      
  }
}