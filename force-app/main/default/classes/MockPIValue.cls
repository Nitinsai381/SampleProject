@isTest
public with sharing class MockPIValue implements System.StubProvider {
  public MockPIValue() {
  }
  public Object handleMethodCall(
    Object stubbedObject,
    String stubbedMethodName,
    Type returnType,
    List<Type> listOfParamTypes,
    List<String> listOfParamNames,
    List<Object> listOfArgs
  ) {
    if (stubbedMethodName == 'getPI') {
      return 3.14;
    } else {
      return 0;
    }
  }
}