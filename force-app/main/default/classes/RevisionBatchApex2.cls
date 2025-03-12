public with sharing class RevisionBatchApex2 implements Database.Batchable<SObject> {
  // Insertion code [working!!] : Inserted 15200 records, 224 failed batches due to storage, total 300 chunks, batch size 200 [default]

  // public Iterable<SObject> start(Database.BatchableContext bc){
  //     List<AccountChild__c> acs = new List<AccountChild__c>();
  //     for(Integer i=0;i<60000;i++){
  //         AccountChild__c ac = new AccountChild__c(Name='RevisionInsertBatch');
  //         acs.add(ac);
  //     }
  //     return acs;
  // }
  // public void execute(Database.BatchableContext bc, List<SObject> scope){
  //     insert scope;
  // }
  // public void finish(Database.BatchableContext bc){
  //     System.debug('Insertion Done!!');
  // }

  //Deletion code

  //   public Iterable<SObject> start(Database.BatchableContext bc) {
  //     List<AccountChild__c> acccs = [
  //       SELECT Id, Name
  //       FROM AccountChild__c
  //       WHERE Name = 'RevisionInsertBatch'
  //     ];
  //     return acccs;
  //   }
  //   public void execute(Database.BatchableContext bc, List<SObject> scope) {
  //     delete scope;
  //   }
  //   public void finish(Database.BatchableContext bc) {
  //     System.debug('Job Finished!!');
  //   }

  //Upsert code:
  //   public Iterable<SObject> start(Database.BatchableContext bc) {
  //     List<AccountChild__c> acs = [
  //       SELECT Id, Name, Description__c
  //       FROM AccountChild__c
  //       WHERE Name = 'RevisionInsertBatch'
  //     ];

  //     if (acs.size() == 0) {
  //       List<AccountChild__c> acs1 = new List<AccountChild__c>();
  //       for (Integer i = 0; i < 2000; i++) {
  //         AccountChild__c ac = new AccountChild__c(Name = 'RevisionInsertBatch');
  //         acs1.add(ac);
  //       }
  //       return acs1;
  //     } else {
  //       for (AccountChild__c ac : acs) {
  //         ac.Description__c = 'RevisionInsertBatch updated from batch upsert';
  //       }
  //       return acs;
  //     }
  //   }
  //   public void execute(Database.BatchableContext bc, List<SObject> scope) {
  //     upsert scope;
  //   }
  //   public void finish(Database.BatchableContext bc) {
  //     System.debug('Insertion Done!!');
  //   }

  //Undelete code :

  public Iterable<SObject> start(Database.BatchableContext bc) {
    List<AccountChild__c> acccs = [
      SELECT Id, Name
      FROM AccountChild__c
      WHERE Name = 'RevisionInsertBatch' AND isDeleted = TRUE
    ];
    return acccs;
  }
  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    undelete scope;
  }
  public void finish(Database.BatchableContext bc) {
    System.debug('Job Finished!!');
  }
}