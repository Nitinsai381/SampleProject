public with sharing class RecordsFormSelectAccount {
  @AuraEnabled(Cacheable=true)
  public static List<Account> recordsFormSelectAccount() {
    return [SELECT Id, Name FROM Account];
  }
}
