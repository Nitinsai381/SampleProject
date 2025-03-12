public class RevisionBatchApex implements Database.Batchable<SObject>{
 
    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator([select Id,Name from Contact where LastName like 'ContactDeleteFromBatch%']);
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
//Integer count =0;
//List<Contact> cont = new List<Contact>();
    //   for(Contact con : scope){
// if(con.LastName == 'RevisionBatchApex'){
//     cont.add(con);
// }
 //      }
     //   System.debug('Total Contacts == '+count);
     System.debug('Scope == '+scope);
        Delete scope;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Finished executing RevisionBatchApex..');
    }
}