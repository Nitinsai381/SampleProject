public with sharing class SampleFeatureFlag {
  public SampleFeatureFlag() {
  }
  private Boolean switchFlag = Feature_Flag__c.getInstance().Flag__c;
  public void sampleCode() {
    if (switchFlag) {
      System.debug('New code logic..');
    } else {
      System.debug('Old code logic..');
    }
  }
}
