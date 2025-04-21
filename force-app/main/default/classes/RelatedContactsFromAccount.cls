public with sharing class RelatedContactsFromAccount {
  public RelatedContactsFromAccount() {
  }
  public void relatedContacts(List<Account> accsList) {
    Integer sumOfAllContacts = 0;
    for (Account acc : accsList) {
      sumOfAllContacts += (Integer) acc.NumberofLocations__c;
    }
    Integer contactCount = 0;
    Integer accountCount = 0;
    List<Contact> consList = new List<Contact>();
    for (Integer i = 0; i < sumOfAllContacts; i++) {
      if (contactCount <= accsList.get(accountCount).NumberofLocations__c) {
        Contact con = new Contact(
          LastName = 'Related Contact ' + contactCount,
          AccountId = accsList.get(accountCount).Id
        );
        System.debug('Each Contact: ' + con);
        System.debug('Contacts Count: ' + contactCount);
        System.debug('Account Count: ' + accountCount);
        consList.add(con);
        contactCount += 1;
      }
      if (contactCount == accsList.get(accountCount).NumberofLocations__c) {
        contactCount = 0;
        accountCount = (accountCount == accsList.size())
          ? accountCount - 1
          : accountCount + 1;
      }
    }
    System.debug('Contacts List: ' + consList);
    insert consList;
  }
}
