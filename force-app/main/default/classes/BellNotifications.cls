public with sharing class BellNotifications {
  public BellNotifications() {
  }
  @AuraEnabled(cacheable=true)
  public static String bellNotifications(Id conId) {
    System.debug('Contact Id : ' + conId);
    Contact con = [
      SELECT Id, Bell_Notifications__c
      FROM Contact
      WHERE Id = :conId
    ];

    return con.Bell_Notifications__c;
  }
}
