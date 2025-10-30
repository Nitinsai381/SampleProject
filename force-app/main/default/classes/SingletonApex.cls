public with sharing class SingletonApex {
  private SingletonApex() {
    System.debug('Inside of Private Constructor of Singleton Class');
  }
  private static Integer example = 5;
  private static SingletonApex instanceOfClass = null;
  public static SingletonApex getInstance() {
    SingletonApex sa;
    if (instanceOfClass == null) {
      System.debug('Private varible Integer : ' + example);
      instanceOfClass = new SingletonApex();
    }
    return instanceOfClass;
  }
}

// SingletonApex.getInstance();
// new SingletonApex().getInstance();

