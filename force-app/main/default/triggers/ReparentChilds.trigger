trigger ReparentChilds on Reparent__e(after insert) {
  if (Trigger.isAfter) {
    ReparentTriggerHandler rth = new ReparentTriggerHandler();
    rth.reparentingChilds(Trigger.new);
  }
  //   System.debug('trigger.new ---- ' + Trigger.new);
}
