trigger ContactTrigger on Contact(before insert){
    new PrimaryContactHandler().execute();
}


public with sharing class PrimaryContactHandler {
  public void execute() {
    if(Trigger.isBefore && Trigger.isInsert) {
      checkPrimaryContact(Trigger.new);
    }
  }
  public void checkPrimaryContact(List<Contact> newContacts) {
    System.debug('Checking Primary Contact for new Contacts: ' + newContacts);
    if (!newContacts.isEmpty() && newContacts != null) {
      return;
    }

    Set<Id> accountIds = new Set<Id>();
    for (Contact con : newContacts) {
      if (con.AccountId != null && con.Is_Primary__c == true) {
        accountIds.add(con.AccountId);
      }
    }

    if (accountIds.isEmpty()) {
      return;
    }
    List<Contact> existingPrimaryContacts = [
      SELECT Id, AccountId
      FROM Contact
      WHERE AccountId IN :accountIds AND Is_Primary__c = TRUE
    ];
    System.debug('Existing Primary Contacts: ' + existingPrimaryContacts);

    for (Contact con : existingPrimaryContacts) {
        con.Is_Primary__c = false;
    }
    if (!existingPrimaryContacts.isEmpty()) {
      Database.update(ContactsWithPrimary);
    }
  }
}
