public with sharing class IPApi {
    public IPApi() {

    }
    //Fetching complete location of a Ip Address
    @AuraEnabled(cacheable=true)
    public static IpLocationResponser ipCompleteLocation(String ipAddress)
    {
        IpLocationResponser iplocation = new IpLocationResponser();
      //End point
      //GET https://ipapi.co/{ip}/{format}/
      String endpoint = 'https://ipapi.co/'+ipAddress+'/json/';
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpoint);
      req.setMethod('GET');
      req.setHeader('Content-Type','application/json');
      HttpResponse res= h.send(req);
      if(res.getStatusCode()==200)
      {
        try{
            iplocation =(IpLocationResponser)JSON.deserialize(res.getBody(),IpLocationResponser.class);
        }
        catch(Exception e)
        {
            System.debug('Exception in IP location fetch: ' + e.getMessage());
      }
      System.debug('IP location-->'+iplocation);
      }
      return iplocation;
    }
    //Specifice location field by IP Address and the field
    @AuraEnabled(cacheable=true)
    Public static String fetchLocationOfIpAddess(String ipAddress ,String field)
    {
       String addressfield='';
       String endpoint;
       if(ipAddress !=null && field !=null)
       {
        endpoint= 'https://ipapi.co/'+ipAddress+'/'+field+'/';
       }
    
        Http h = new Http();
        HttpRequest req =  new HttpRequest();
        HttpResponse res =  new HttpResponse();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type','application.json');
        res =h.send(req);
        if(res.getStatusCode()==200)
        {
          System.debug('Response--->'+res.getBody());
          addressfield=res.getBody();
        }
        return addressfield;
    }
    //wrapper calss
    public class IpLocationResponser{
     @AuraEnabled public String ip;
     @AuraEnabled public String version;
     @AuraEnabled public String city;
     @AuraEnabled public String region;
     @AuraEnabled public String region_code;
     @AuraEnabled public String country_code;
     @AuraEnabled public String country_code_iso3;
     @AuraEnabled public String country_name;
     @AuraEnabled public String country_capital;
     @AuraEnabled public String country_tld;
     @AuraEnabled public String continent_code;
     @AuraEnabled public Boolean in_eu;
     @AuraEnabled public String postal;
     @AuraEnabled public Decimal latitude;
     @AuraEnabled public Decimal longitude;
     @AuraEnabled public String timezone;
     @AuraEnabled public String utc_offset;
     @AuraEnabled public String country_calling_code;
     @AuraEnabled public String currency1;
     @AuraEnabled public String currency_name;
     @AuraEnabled public String languages;
     @AuraEnabled public Decimal country_area;
     @AuraEnabled public Decimal country_population;
     @AuraEnabled public String asn;
     @AuraEnabled public String org;
     @AuraEnabled public String hostname;
    }


}