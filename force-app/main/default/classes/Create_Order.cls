public with sharing class Create_Order {
  @InvocableMethod(label='Create Order')
  public static List<Order__c> createOrder(List<Order__c> orderDetails) {
    insert orderDetails.get(0);
    return orderDetails;
  }
}
