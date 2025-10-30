trigger ContactTrigger on Contact(before insert, after insert, before update) {
  ContactTriggerHandler cth = new ContactTriggerHandler();
  if ((Trigger.isBefore) && (Trigger.isInsert)) {
    cth.beforeInsert(Trigger.new);
    ContactTriggerScenario1.assignContactIndustry(Trigger.new);
  }
  // if (Trigger.isAfter && Trigger.isInsert) {
  //   ContactTriggerScenario1.assignContactIndustry(Trigger.new);
  // }
  if (Trigger.isBefore && Trigger.isUpdate) {
    cth.beforeUpdate(Trigger.new, Trigger.oldMap);
  }

}
