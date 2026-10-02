trigger ErrorLogProcessorTrigger on ErrorLogEvent__e (after insert) {
  LogExceptionHelper.logErrorProcess(trigger.new);
}