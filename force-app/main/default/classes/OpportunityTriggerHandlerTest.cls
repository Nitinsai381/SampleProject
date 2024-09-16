@isTest
private class OpportunityTriggerHandlerTest {
  @isTest
  static void testAfterUpdate() {
    Account acc = new Account(Name = 'Test Account', SumOfOppAmount__c = 0);

    insert acc;
    Opportunity opp1 = new Opportunity(
      Name = 'Test Opp 1',
      StageName = 'Closed Won',
      CloseDate = Date.today(),
      Amount = 100,
      AccountId = acc.Id
    );
    Opportunity opp2 = new Opportunity(
      Name = 'Test Opp 2',
      StageName = 'Prospecting',
      CloseDate = Date.today(),
      Amount = 200,
      AccountId = acc.Id
    );
    List<Opportunity> oppList = new List<Opportunity>();
    oppList.add(opp1);

    oppList.add(opp2);
    insert oppList;
    acc.SumOfOppAmount__c = 300;
    update acc;
    Test.startTest();
    oppList[0].Amount = 300;
    update oppList[0];
    Test.stopTest();
    Account accAfter = [
      SELECT Id, SumOfOppAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      500,
      accAfter.SumOfOppAmount__c,
      'SumOfOppAmount__c should be updated to 300'
    );
  }

  @isTest
  static void accountLosingOpportunityTest() {
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {

      Account acc = new Account(Name = 'Test Account', SumOfOppAmount__c = 0);

      insert acc;
      Opportunity opp = new Opportunity(
        Name = 'Test Opp 1',
        StageName = 'Closed Lost',
        CloseDate = Date.today(),
        Amount = 100,
        AccountId = acc.Id
      );
      insert opp;
    //   acc.SumOfOppAmount__c = 100;
    //   update acc;     
      opp.AccountId = null;
      update opp;
      Account accc = [select Id, SumOfOppAmount__c from Account where Name ='Test Account'];
      System.assertEquals(acc.SumOfOppAmount__c, 0);
      Test.stopTest();
    }
  }
  /**
   * account exists - acc1(200)
   * two opps exists - opp1 (100), opp2(100)
   * opp1.Amount = 50;
   * opp2.Amount = 200;
   */
  /* @IsTest
  static void accountLosingOppTest() {
    //insert acc
    //insert opp with amount
    //your acc has some value...
    
    System.runAs(new User(Id = UserInfo.getUserId())) {
      //update opp by removing acc
      Test.startTest();
      Account acc = new Account(Name = 'Test Account', SumOfOppAmount__c = 0);

    insert acc;
    Opportunity opp = new Opportunity(
      Name = 'Test Opp 1',
      StageName = 'Closed Lost',
      CloseDate = Date.today(),
      Amount = 100,
      AccountId = acc.Id
    );
    insert opp;
    acc.SumOfOppAmount__c=100;
    update acc;
    Account acc2 = new Account(Name = 'Test Account 2', SumOfOppAmount__c = 0);
    insert acc2;
    // Account accc2 = [select Id, Name from Account where Name = 'Test Account 2'];
    opp.AccountId=accc2.Id;
    update opp;
    Account accc = [select Id, SumOfOppAmount__c from Account where Name ='Test Account'];
      System.assertEquals(acc.SumOfOppAmount__c, 0);
    }
    Test.stopTest();
  } */
}
// @isTest
// private class OpportunityTriggerHandlerTest {
//     @isTest
//     static void amountUpdate()
//     {
//         Account acc = new Account(Name = 'Test Account');
//         insert acc;
//         List<Opportunity> opp=new List<Opportunity>();
//         opp.add(new Opportunity(Name='First Opportunity',StageName='Closed Lost',CloseDate=Date.today(),AccountId=acc.Id,Amount=1000));
//         opp.add(new Opportunity(Name='Second Opportunity',StageName='Closed Won',CloseDate=Date.today(),AccountId=acc.Id,Amount=1500));
//         insert opp;
//         Test.startTest();
//         for(Opportunity op:opp)
//         {
//             op.Amount=2000;
//         }
//         update opp;
//         Test.stopTest();
//         Account a=[Select Id,SumofOppAmount__c from Account where Id=:acc.Id];
//         System.assertEquals(3000,a.SumofOppAmount__c);
//     }
// }
