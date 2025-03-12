public with sharing class MergeLeads implements Batchable<SObject> {
  // public MergeLeads() {

  // }
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'Select Id, Name, Email, Phone from Lead Order by CreatedDate Desc'
    );
  }
  public void execute(Database.BatchableContext bc, List<Lead> scope) {
  }
}
