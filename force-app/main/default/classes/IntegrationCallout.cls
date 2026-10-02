public class IntegrationCallout {
    public class RequestBody{
        RequestWrapper data;
    }
    public class RequestWrapper{
        String channel;
        String sender;
        String phone;
        String template;
        Integer code_length;
    }
    public static void sendOtp( String phoneNumber){
        RequestBody requestData = new RequestBody();
        requestData.data =  new RequestWrapper();
         requestData.data.channel= 'sms';
         requestData.data.sender = 'GetOTP';
         requestData.data.phone = phoneNumber;
         requestData.data.template = '6d16aa9d-bf19-4141-8169-48b46d972fc6';
         requestData.data.code_length = 4;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.otp.dev/v1/verifications');
        req.setHeader('X-OTP-Key','mtbi2w4hlendfpxa1igthcu5p6mzxf7k');
        req.setHeader('accept','application/json');
        req.setHeader('content-type','application/json');
        req.setMethod('POST');
        req.setBody(JSON.serialize(requestData));
        HttpResponse res = new Http().send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());     
    }
}