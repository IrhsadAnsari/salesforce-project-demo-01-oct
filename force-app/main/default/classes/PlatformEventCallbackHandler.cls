public class PlatformEventCallbackHandler  implements EventBus.EventPublishFailureCallback,EventBus.EventPublishSuccessCallback{ 
    public void onFailure(EventBus.FailureResult result){
        List<String> failedUuids = result.getEventUuids();
        System.debug('Failed UUID:'+failedUuids);
    }
    
    public void onSuccess(EventBus.SuccessResult result){
        List<String> successUuids = result.getEventUuids();
        System.debug('Success UUID:'+successUuids);
    }
    
    
}