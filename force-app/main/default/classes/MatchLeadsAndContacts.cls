public without sharing class MatchLeadsAndContacts implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT FirstName, LastName, Phone, Email FROM Lead'
    );
  }
  public void execute(Database.BatchableContext bc, List<lead> scope) {
    List<Contact> conList = [
      SELECT Id, FirstName, LastName, Email, Phone
      FROM Contact
      ORDER BY LastModifiedDate
    ];
    Map<Id, Contact> matchedLeadsContacts = new Map<Id, Contact>();

    for (Lead lead : scope) {
      for (Contact contact : conList) {
        if (
          (!String.isEmpty(lead.FirstName) &&
          !String.isEmpty(lead.LastName) &&
          !String.isEmpty(lead.Email) &&
          !String.isEmpty(lead.Phone)) &&
          (!String.isEmpty(contact.FirstName) &&
          !String.isEmpty(contact.LastName) &&
          !String.isEmpty(contact.Email) &&
          !String.isEmpty(contact.Phone))
        ) {
          if (
            (lead.FirstName == contact.FirstName &&
            lead.LastName == contact.LastName) &&
            lead.Email == contact.Email &&
            lead.Phone == contact.Phone
          ) {
            matchedLeadsContacts.put(lead.Id, contact);
          } else if (
            ((lead.FirstName == contact.FirstName &&
            lead.LastName == contact.LastName) ||
            lead.Email == contact.Email) && (lead.Email == contact.Email)
          ) {
            matchedLeadsContacts.put(lead.Id, contact);
          } else if (
            ((lead.FirstName == contact.FirstName &&
            lead.LastName == contact.LastName) ||
            lead.Phone == contact.Phone) && (lead.Phone == contact.Phone)
          ) {
            matchedLeadsContacts.put(lead.Id, contact);
          } else if (
            ((lead.Email == contact.Email) && lead.Phone == contact.Phone)
          ) {
            matchedLeadsContacts.put(lead.Id, contact);
          }
        }
      }
    }
  }
  public void finish(Database.BatchableContext bc) {
  }
}
