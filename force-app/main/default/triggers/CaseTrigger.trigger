trigger CaseTrigger on Case(after insert) {
  if (Trigger.isAfter && Trigger.isInsert) {
    CaseTriggerScenarioHandler1.afterCaseCreated(Trigger.new);
  }
}
