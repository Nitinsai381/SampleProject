public with sharing class NewAccountConsOpp {
  public NewAccountConsOpp() {
  }
  public void execute() {
    switch on Trigger.operationType {
      when AFTER_INSERT {
        relatedContacts(Trigger.new);
      }
    }
  }
  public void relatedContacts(List<Account> accsList) {
    List<Opportunity> oppsList = new List<Opportunity>();
    List<Account> accListToUpdate = new List<Account>();
    Integer sumOfAllContacts = 0;
    for (Account acc : accsList) {
      sumOfAllContacts += (Integer) acc.Number_Of_Contacts__c;
      oppsList.add(
        new Opportunity(
          Name = acc.Name + ' - First Opportunity',
          CloseDate = Date.today().addDays(30),
          StageName = 'Prospecting',
          AccountId = acc.Id
        )
      );

      accListToUpdate.add(new Account(Id = acc.Id, has_Opportunity__c = true));
    }
    Integer contactCount = 0;
    Integer accountCount = 0;
    List<Contact> consList = new List<Contact>();
    for (Integer i = 0; i < sumOfAllContacts; i++) {
      if (contactCount <= accsList.get(accountCount).Number_Of_Contacts__c) {
        Contact con = new Contact(
          LastName = 'Related Contact ' + contactCount,
          AccountId = accsList.get(accountCount).Id
        );
        // System.debug('Each Contact: ' + con);
        // System.debug('Contacts Count: ' + contactCount);
        // System.debug('Account Count: ' + accountCount);
        consList.add(con);
        contactCount += 1;
      }
      if (contactCount == accsList.get(accountCount).Number_Of_Contacts__c) {
        contactCount = 0;
        accountCount = (accountCount == accsList.size())
          ? accountCount - 1
          : accountCount + 1;
      }
    }
    System.debug('Contacts List: ' + consList);
    if (!oppsList.isEmpty()) {
      Database.insert(oppsList, false);
    }
    if (!consList.isEmpty()) {
      Database.insert(consList, false);
    }
    if (!accListToUpdate.isEmpty()) {
      Database.update(accListToUpdate, false);
    }
  }
}
