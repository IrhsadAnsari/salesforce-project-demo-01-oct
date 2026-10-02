trigger UserCreationSubscriber on UserCreationNotification__e (after insert) {
    System.debug('This is the Subscriber.');
    for(UserCreationNotification__e user : trigger.new)
    {
        System.debug('User Name :'+ user.UserName__c);
    }
}