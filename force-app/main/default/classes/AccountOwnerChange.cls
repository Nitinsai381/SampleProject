public with sharing class AccountOwnerChange {
  public static changedOwner(
    Map<Id, Account> oldAccMap,
    Map<Id, Account> newAccMap
  ) {
    Map<Id, Account> changedAccOwners = new Map<Id, Account>();
    for (Account acc : newAccMap.values()) {
      if (oldAccMap.get(acc.Id).OwnerId != acc.OwnerId) {
        changedAccOwners.put(acc.Id, acc);
      }
    }
    List<Contact> relatedContacts = [
      SELECT Id, OwnerId
      FROM Contact
      WHERE AccountId IN :changedAccOwners.keySet()
    ];
    if (relatedContacts.isEmpty()) {
      return;
    }
    for (Contact con : relatedContacts) {
      con.OwnerId = changedAccOwners.get(con.Account).OwnerId;
    }
    if (!relatedContacts.isEmpty()) {
      Database.update(relatedContacts);
    }
  }
}
