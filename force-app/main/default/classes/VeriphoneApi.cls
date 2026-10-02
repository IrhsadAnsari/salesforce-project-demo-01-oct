public class VeriphoneApi {
    Public static LIst<ResponseVeriPhone> validatePhone(List<String> pnumber){
        string apiKey ='04E32C2FB9B5443980016597972B01C9';
        String veriPhoneEndpoint ='https://api.veriphone.io/v2/verify?phone='+pnumber+'&key='+apiKey;
        //Set endpoint,method
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(veriPhoneEndpoint);
        req.setMethod('GET');
        HttpResponse res =h.send(req);
        //System.debug('response---'+res.getBody());
        List<ResponseVeriPhone> reponsephone =new List<ResponseVeriPhone>();
        if(res.getStatusCode()==200)
        {
            System.debug('response---'+res.getBody());
            reponsephone = (LIST<ResponseVeriPhone>)JSON.deserialize(res.getBody(), ResponseVeriPhone.class);
            system.debug('Deserialize response--->'+reponsephone);
        }
           return reponsephone;
    }
    public class ResponseVeriPhone
    {
        //Wrapper class
        Public string success;
        Public string phone;
        Public string phone_valid;
        Public string phone_type;
        Public string phone_region;
        Public string country;
        Public string country_code;
        Public string country_prefix;
        Public string international_number;
        Public string local_number;
        Public string e164;
        Public string carrier;     
  
    }
    
      
   //method for anotating as future call
  /* //@future(callout=true)
  public static List<String> invokePhoneAPI(List<String> pnumber)
   {
       List<String> phoneValidString;
       //List<Boolean>p
     List<VeriPhoneApi.ResponseVeriPhone> p= VeriPhoneApi.validatePhone(pnumber);
      //phoneValid {p.phone_valid};
      for(ResponseVeriPhone res:p)
      {
          phoneValidString.add(res.phone_valid);
      }
      return phoneValidString;
  }*/
    ///
     @future(callout=true)
    public static void validatePhoneFuture(Set<Id> accountIds, List<String> phoneNumbers) {
        // Make the API call to validate the phone numbers
        List<String> returnResponse = invokePhoneAPI(phoneNumbers);
        System.debug('returnResponse '+returnResponse);
        // Update the accounts with the validation results
        if (returnResponse.size() == phoneNumbers.size()) {
            List<Account> accountsToUpdate = new List<Account>();
            for (Integer i = 0; i < phoneNumbers.size(); i++) {
                String response = returnResponse[i];
                System.debug('Response '+response);
                Account acc = [SELECT Id, Phone, PhoneNumberisValid__c FROM Account WHERE Id = :accountIds LIMIT 1];
                acc.PhoneNumberisValid__c = Boolean.valueOf(response);
                System.debug('Phone field checking-->'+ acc.PhoneNumberisValid__c);
                accountsToUpdate.add(acc);
            }
            // Perform the update asynchronously
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }

    public static List<String> invokePhoneAPI(List<String> phoneNumbers) {
        // Implement the API callout logic here
        // Return the list of responses
         List<String> phoneValidString = new List<String>();
       //List<Boolean>p
     List<VeriPhoneApi.ResponseVeriPhone> p= VeriPhoneApi.validatePhone(phoneNumbers);
      //phoneValid {p.phone_valid};
      for(ResponseVeriPhone res:p)
      {
          phoneValidString.add(res.phone_valid);
      }
      return phoneValidString;
        
    }
       
}