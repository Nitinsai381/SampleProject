public with sharing class BuilderDesignPattern {
  private String firstName, lastName, email, phone;
  public BuilderDesignPattern() {
  }

  public BuilderDesignPattern setFirstName(String firstName) {
    this.firstName = firstName;
    return this;
  }
  public BuilderDesignPattern setLastName(String lastName) {
    this.lastName = lastName;
    return this;
  }
  public BuilderDesignPattern setEmail(String email) {
    this.email = email;
    return this;
  }
  public BuilderDesignPattern setPhone(String phone) {
    this.phone = phone;
    return this;
  }

  //   public PersonWrapper build() {
  //     return new PersonWrapper(
  //       this.firstName,
  //       this.lastName,
  //       this.email,
  //       this.phone
  //     );
  //   }
  public Person build() {
    return new Person(this.firstName, this.lastName, this.email, this.phone);
  }
  public class Person {
    private final String firstName;
    private final String lastName;
    private final String email;
    private final String phone;
    public Person(
      String firstName,
      String lastName,
      String email,
      String phone
    ) {
      this.firstName = firstName;
      this.lastName = lastName;
      this.email = email;
      this.phone = phone;
    }
  }
}

BuilderDesignPattern bdp = new BuilderDesignPattern().setFirstName('John').setEmail('john@email.com').setLastName('Kennedy').setPhone('872362876');
// bdp.setFirstName('NewFirstName');
// bdp.setLastName('NewLastName');
// bdp.setEmail('NewEmail');
// bdp.setPhone('102470211');
System.debug('New Object data : '+bdp.build());

