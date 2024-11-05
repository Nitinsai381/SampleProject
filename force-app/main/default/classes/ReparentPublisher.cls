public with sharing class ReparentPublisher {
  //   public ReparentPublisher() {
  //   }
  public void reparentPublish() {
    List<Reparent__e> reParents = new List<Reparent__e>();
    List<Id> Ids = new List<Id>{
      '003NS00000Cf95TYAR',
      '003NS00000Cf95KYAR',
      '003NS00000FD9w5YAD'
    };
    String childIds = JSON.serialize(Ids);
    System.debug('childString____' + childIds);
    Reparent__e reParent = new Reparent__e(
      ParentId__c = '001NS00000X63EjYAJ',
      ChildIds__c = childIds,
      Class_Name__c = 'StandardReparent'
    );
    reParents.add(reParent);
    List<Database.SaveResult> publishedEvent = EventBus.publish(reParents);
    for (Database.SaveResult result : publishedEvent) {
      if (result.isSuccess()) {
        System.debug('result' + result);
        System.debug('Successfully Published!');
      } else {
        System.debug('Unsuccesful!');
      }
    }
  }
}
