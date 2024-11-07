public with sharing class RecordsFormSelectAccount {
  @AuraEnabled(cacheable=true)
  public static List<Account> recordsFormSelectAccount() {
    return [SELECT Id, Name FROM Account];
  }
}
