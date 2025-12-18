trigger AccountTrigger on Account(after insert, after update) {
  AccountTriggerHandler accTH = new AccountTriggerHandler();
  new NewAccountConsOpp().execute();
  if ((Trigger.isAfter) && (Trigger.isUpdate)) {
    accTH.afterUpdate(Trigger.new, Trigger.oldMap);
  }
}
