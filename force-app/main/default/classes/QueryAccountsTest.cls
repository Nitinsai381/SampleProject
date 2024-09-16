@isTest
public class QueryAccountsTest {
  @TestSetup
  static void makeData() {
    List<Account> accounts = new List<Account>{
      new Account(Name = 'Test'),
      new Account(Name = 'Test'),
      new Account(Name = 'Test1'),
      new Account(Name = 'Test1'),
      new Account(Name = 'Test2'),
      new Account(Name = 'Test2'),
      new Account(Name = 'Test2'),
      new Account(Name = 'Test2')
    };
    insert accounts;
  }

  @isTest
  static void queryAccountsTest1() {
    // TO DO: implement unit test
    Test.startTest();
    QueryAccounts qa = new QueryAccounts();
    Id batchId = Database.executeBatch(qa);
    Test.stopTest();
    System.debug(
      [SELECT Name FROM Account WHERE Name IN ('Test', 'Test1', 'Test2')]
    );
    System.assertEquals(
      3,
      [SELECT COUNT() FROM Account],
      'Error: Working incorrectly..'
    );
  }
  // static void queryAccountsTest2() {
  //   Test.startTest();
  //   QueryAccounts qa = new QueryAccounts();
  //   Id batchId = Database.schedule('Process batch', '* 20 * * * *', qa);
  //   Test.stopTest();

  //   List<CronTrigger> cts = [
  //     SELECT Id, TimesTriggered, NextFireTime
  //     FROM CronTrigger
  //     WHERE Id = :jobId
  //   ];
  //   System.debug('Next fire time ' + cts[0].NextFireTime);
  // }
}
