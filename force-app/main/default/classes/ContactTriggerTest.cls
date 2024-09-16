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
private class ContactTriggerTest {
  @TestSetup
  static void makeData() {
    // UserRole roleidval = [SELECT Id FROM UserRole WHERE Name = 'Western Sales Team' LIMIT 1]; UserRoleId = roleidval.Id
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Test Profile' LIMIT 1];
    User user1 = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'testUser12321@testorg.com'
    );
    insert user1;
    PermissionSet ps = [
      SELECT Id
      FROM PermissionSet
      WHERE Id = '0PSNS000001KXth'
    ];

    PermissionSetAssignment psa = new PermissionSetAssignment(
      AssigneeId = user1.Id,
      PermissionSetId = ps.Id
    );
    insert psa;
  }
  @isTest
  static void userTest() {
    // Account a = new Account(Name='AccountUser', Status__c=true);
    // insert a;
    User newUser1 = [
      SELECT Id, Name
      FROM User
      WHERE Username = 'testUser12321@testorg.com'
    ];
    Account a = new Account(Name = 'AccountUser', Status__c = true);
    insert a;
    Test.startTest();
    System.runAs(newUser1) {
      // Account ac = [SELECT Id, Status__c FROM Account WHERE Id =: a.Id];
      System.debug(a.Status__c);

      // UserTest.userTest();
      a.Status__c = false;
      update a;

      Account acc = [
        SELECT Id, Status__c
        FROM Account
        WHERE Name = 'AccountUser'
      ];
      System.debug(a.Status__c);
      Test.stopTest();
      System.debug(a.Status__c);
      System.assertEquals(
        false,
        a.Status__c,
        'Account status should be updated'
      );
    }

  }

  @isTest
  static void beforeInsert() {
    // TO DO: implement unit test

    Account acc = new Account(Name = 'Test Account');
    insert acc;
    acc.Status__c = true;
    update acc;
    Contact con = new Contact(
      FirstName = 'Test1',
      LastName = 'Contact',
      AccountId = acc.Id
    );
    Test.startTest();
    insert con;
    Test.stopTest();
    // System.debug(acc.Status__c);
    Contact c = [SELECT Id, Status__c FROM Contact WHERE AccountId = :acc.Id];
    // System.debug(c.Status__c);
    // System.assert(result.isSuccess());
    // System.assert(result.getErrors().size() > 0);
    // System.assertEquals('Account is not Active', result.getErrors()[0].getMessage());

    //System.assertEquals(acc.Status__c,con.Status__c,'Account Status is not equal to Contact Status');
    System.assertEquals(
      true,
      c.Status__c,
      'Account Status is not equal to Contact Status'
    );
  }
  @istest
  static void beforeUpdate() {
    Account acc = new Account(Name = 'Test Account', Status__c = true);
    insert acc;
    Contact con = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      AccountId = acc.Id
    );
    insert con;
    Test.startTest();
    con.Status__c = false;
    update con;
    Test.stopTest();

    Contact c = [SELECT Id, Status__c FROM Contact WHERE AccountId = :acc.Id];
    System.assertEquals(true, c.Status__c, 'Should be true');
  }
}
