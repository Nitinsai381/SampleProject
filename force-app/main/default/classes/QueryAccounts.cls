public without sharing class QueryAccounts implements Database.Batchable<sObject>, Schedulable {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'Select Id,Name from Account Order by CreatedDate'
    );
  }
  public void execute(Database.BatchableContext bc, List<Account> scope) {
    List<Account> accounts = new List<Account>();
    Map<String, List<Account>> accMap = new Map<String, List<Account>>();
    for (Account account : scope) {
      // Checking for Accounts with unique name
      if (!accMap.containsKey(account.Name)) {
        accMap.put(account.Name, new List<Account>{});

        // checks for Account with same names
      } else if (accMap.containsKey(account.Name)) {
        accMap.get(account.Name).add(account);
      }
    }
    // Getting list of Accounts with same names (Duplicates)
    for (List<Account> accList : accMap.values()) {
      accounts.addAll(accList);
    }
    System.debug(accMap.values());
    System.debug(accounts);

    // Error Handling
    List<Database.DeleteResult> results = Database.delete(accounts, false);
    System.debug(results.size() + ' Size of the result list..');

    Map<String, Event_Logs__c> delFailAccs = new Map<String, Event_Logs__c>();

    Integer i = 0;
    for (Account acc : accounts) {
      if (!results.isEmpty() && (i < results.size())) {
        Database.DeleteResult result = results[i];
        if (acc.Id == result.id) {
          if (!delFailAccs.containsKey(acc.Name)) {
            delFailAccs.put(
              acc.Name,
              new Event_Logs__c(
                Name = 'Deduplication failed for Account : ' + acc.Name,
                Error_Message__c = result.getErrors()[0].getMessage(),
                Business_Description__c = 'Failed to delete Account ID: ' +
                  result.getId(),
                ApexClassName__c = 'QueryAccounts'
              )
            );
          } else if (delFailAccs.containsKey(acc.Name)) {
            delFailAccs.get(acc.Name).Business_Description__c +=
              ', ' + result.Id;
          }
        }
        i++;
      }
    }
    if (!delFailAccs.isEmpty()) {
      insert delFailAccs.values();
    }

    // for (Integer i = 0; i < results.size(); i++) {
    //   Database.DeleteResult result = results[i];
    //   result.
    //   if (accounts.) {
    //     System.debug('I am in error loop -- accMap');
    //   }
    // if (!result.isSuccess()) {
    //   // Account failedAccount = accounts[i];
    //   System.debug('Failed to delete Account ID: ' + result.getId());

    //   // Log the error details
    //   Event_Logs__c log = new Event_Logs__c(
    // Name = 'QueryAccountsLog',
    // Error_Message__c = result.getErrors()[0].getMessage(),
    // Business_Description__c = 'Failed to delete Account ID: ' +
    //   result.getId(),
    // ApexClassName__c = 'QueryAccounts'
    //   );
    //   batchLogs.add(log);
    // }
    // }

    // for (Integer i = 0; i < results.size(); i++) {
    //   Database.DeleteResult result = results[i];
    //   if (!result.isSuccess()) {
    //     // Account failedAccount = accounts[i];
    //     System.debug('Failed to delete Account ID: ' + result.getId());

    //     // Log the error details
    //     Event_Logs__c log = new Event_Logs__c(
    //       Name = 'QueryAccountsLog',
    //       Error_Message__c = result.getErrors()[0].getMessage(),
    //       Business_Description__c = 'Failed to delete Account ID: ' +
    //         result.getId(),
    //       ApexClassName__c = 'QueryAccounts'
    //     );
    //     batchLogs.add(log);
    //   }
    // }

    // if (!batchLogs.isEmpty()) {
    //   insert batchLogs;
    // }

    // List<String> accIds = new List<String>();
    // for (Database.DeleteResult r : result) {
    //   System.debug(r.getId());
    //   accIds.add((String) r.getId());
    //   System.debug(r.getErrors());
    // }
    // Map<Id, Account> dupL = new Map<Id, Account>(
    //   [SELECT Id, Name FROM Account WHERE Id IN :accIds]
    // );
    // System.debug(dupL);
    // Map<Account, List<Account>> dupMap = new Map<Account, List<Account>>();
    // for(Account dupAccs : dupL){
    //   Event_Logs__c be = new Event_Logs__c(
    //       Name = 'QueryAccountsLog',
    //       Error_Message__c = e.getMessage(),
    //       Business_Description__c = ,
    //       ApexClassName__c = 'QueryAccounts'
    //     );
    //     batchLogs.add(be);
    // }

    /* try {
      // Attempting to delete list of duplicate Accounts
      // delete accounts;
    }
    // Checking for other issues
    catch (Exception e) {
      System.debug(e.getMessage() + ' Hey I am catch block....');
      // for (Database.DeleteResult r : result) {
      System.debug(result.size() + ' Something....');
      // }
      // Event_Logs__c be = new Event_Logs__c(
      //   Name = 'QueryAccountsLog',
      //   Error_Message__c = e.getMessage(),
      //   Business_Description__c = (e.getMessage() == null
      //     ? 'No problems found, duplicates removed successfully!'
      //     : e.getMessage()),
      //   ApexClassName__c = 'QueryAccounts'
      // );
      // batchLogs.add(be);
      insert batchLogs;
    } */
  }
  // public void execute(SchedulableContext sc) {
  // }
  public void finish(Database.BatchableContext bc) {
    // System.debug(1);
  }
  public void execute(SchedulableContext sc) {
    Database.executeBatch(new QueryAccounts());
  }
  public static void scheduleJob() {
    String cronExp = '0 20 * * * ?';
    String jobName = 'Batch Job';
    System.schedule(jobName, cronExp, new QueryAccounts());
  }
}
