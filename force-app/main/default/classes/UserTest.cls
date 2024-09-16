public  class UserTest {
    public static void userTest() {
        Account a = new Account(Name='AccountUser', Status__c=true);
        insert a;
        System.debug(a.Status__c);
// User newUser1 = [select Id, Name from User where Username ='testUser12321@testorg.com'];
    }
}