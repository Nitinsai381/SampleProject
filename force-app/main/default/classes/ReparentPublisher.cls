public with sharing class ReparentPublisher {
  //   public ReparentPublisher() {
  //   }
  public void reparentPublish() {
    List<Reparent__e> reParents = new List<Reparent__e>();
    List<String> childIds = new List<String>{
      '003NS00000Cf95TYAR',
      '003NS00000Cf95KYAR',
      '003NS00000FD9w5YAD'
    };
    String childString = String.join(childIds, ', ');
    System.debug('childString____'+childString);
    Reparent__e reParent = new Reparent__e(
      ParentId__c = '001NS00000X63EjYAJ',
      ChildIds__c = childString,
      Class_Name__c = 'StandardReparent'
    );
    reParents.add(reParent);
    List<Database.SaveResult> publishedEvent = EventBus.publish(reParents);
    for (Database.SaveResult result : publishedEvent) {
      if (result.isSuccess()) {
        System.debug('result'+result);
        System.debug('Successfully Published!');
      } else {
        System.debug('Unsuccesful!');
      }
    }
  }
}