trigger UserTrigger on User (After insert) {
  if(Trigger.isAfter)
  {
      System.debug('Start afert trigger for user');
      UserCreation.permissionSetforUser(Trigger.isInsert, trigger.new);
      UserCreation.publishUserPlateformEvent(Trigger.isInsert,  trigger.new);

      System.debug('End afert trigger for user');

  }
}