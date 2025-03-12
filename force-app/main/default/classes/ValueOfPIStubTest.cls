@isTest
public with sharing class ValueOfPIStubTest {
  public ValueOfPIStubTest() {
  }
  @isTest
  public static void valueOfPIStubMockTest() {
    ValueOfPI valuePIMock = (ValueOfPI) MockStubPI.createStubOfPI(
      ValueOfPI.class
    );
    ValueOfPIHelper vph = new ValueOfPIHelper();

    System.assertEquals(3.14, vph.valuePIFromHelper(valuePIMock));
  }
}