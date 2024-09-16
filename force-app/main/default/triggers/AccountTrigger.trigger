trigger AccountTrigger on Account(after update) {
  AccountTriggerHandler accTH = new AccountTriggerHandler();
  if ((Trigger.isAfter) && (Trigger.isUpdate)) {
    accTH.afterUpdate(Trigger.new, Trigger.oldMap);
  }
}