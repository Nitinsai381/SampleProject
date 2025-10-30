public without sharing class ContactTriggerScenario1 {
  public ContactTriggerScenario1() {
  }
  public static void assignContactIndustry(List<Contact> newContacts) {
    if (newContacts == null || newContacts.isEmpty()) {
      return;
    }
    Set<Id> accIds = new Set<Id>();
    for (Contact con : newContacts) {
      if (con.AccountId != null) {
        accIds.add(con.AccountId);
      }
    }
    if (accIds.isEmpty()) {
      return;
    }
    List<Account> accList = [
      SELECT Id, Industry
      FROM Account
      WHERE Id IN :accIds
    ];
    Map<Id, String> accIndustryMap = new Map<Id, String>();
    for (Account acc : accList) {
      accIndustryMap.put(acc.Id, acc.Industry);
    }
    for (Contact con : newContacts) {
      if (con.AccountId != null && accIndustryMap.containsKey(con.AccountId)) {
        con.Industry__c = accIndustryMap.get(con.AccountId);
      }
    }
  }
}
