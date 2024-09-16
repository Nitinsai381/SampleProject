/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MatchLeadsAndContactsTest {
  @TestSetup
  static void makeData() {
    List<Lead> leads = new List<Lead>();
    List<Contact> contacts = new List<Contact>();
    for (Integer i = 0; i < 10; i++) {
      if (i < 3) {
        leads.add(
          new Lead(
            FirstName = 'Test ',
            LastName = 'Lead',
            Email = 'testlead@email.com',
            Phone = '12345'
          )
        );
        contacts.add(
          new Contact(
            FirstName = 'Test ',
            LastName = 'Lead',
            Email = 'testlead@email.com',
            Phone = '12345'
          )
        );
    } else if (i >= 3 && i < 6) {
        leads.add(
            new Lead(
                FirstName = 'Test ',
                LastName = 'Lead ' + i,
                Email = 'testlead@email.com',
                Phone = '12345'
                )
                );
                contacts.add(
                  new Contact(
                    FirstName = 'Test ',
                    LastName = 'Lead ' +i,
                    Email = 'testlead@email.com',
                    Phone = '12345'
                  )
                );
      } else if (i >= 6 && i < 8) {
        leads.add(
          new Lead(
            FirstName = 'Test ',
            LastName = 'Lead ',
            Email = 'testlead@email' + i + '.com',
            Phone = '12345'
          )
        );
        contacts.add(
          new Contact(
            FirstName = 'Test ',
            LastName = 'Lead ',
            Email = 'testlead@email' + i + '.com',
            Phone = '12345'
          )
        );
      } else {
        leads.add(
          new Lead(
            FirstName = 'Test ',
            LastName = 'Lead ' + i,
            Email = 'testlead@email' + i + '.com',
            Phone = '12345'
          )
        );
        contacts.add(
          new Contact(
            FirstName = 'Test ',
            LastName = 'Lead ' + i,
            Email = 'testlead@email' + i + '.com',
            Phone = '12345'
          )
        );
      }
    }
    insert leads;
  }

  @isTest
  static void unitTest1() {
    // TO DO: implement unit test

    Test.startTest();
    Database.executeBatch(new MatchLeadsAndContacts());
    Test.stopTest();
    
  }
}
