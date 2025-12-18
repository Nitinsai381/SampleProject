trigger OpportunityTrigger on Opportunity(before insert, after update) {
  if (Trigger.isAfter && Trigger.isUpdate) {
    OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
  }
  if (Trigger.isBefore && Trigger.isInsert) {
    CheckOpportunitySumHandler.checkTotalSum(Trigger.new);
  }
}
