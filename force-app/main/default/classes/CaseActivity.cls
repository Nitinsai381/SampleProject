public with sharing class CaseActivity {
  @AuraEnabled(cacheable=true)
  public static Map<String, Case_Activity__mdt> caseActivities() {
    return Case_Activity__mdt.getAll();
  }
}