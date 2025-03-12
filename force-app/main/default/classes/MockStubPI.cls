public with sharing class MockStubPI {
  public MockStubPI() {
  }
  public static MockPIValue getInstance() {
    return new MockPIValue();
  }
  public static Object createStubOfPI(Type typeToMock) {
    return Test.createStub(typeToMock, MockStubPI.getInstance());
  }
}