public with sharing class OpportunityTriggerHandler {
  public static void afterUpdate(
    List<Opportunity> oppNew,
    Map<Id, Opportunity> oppOldMap
  ) {
    List<Opportunity> oppList = new List<Opportunity>();
    //  List<Decimal> oldOppList = new List<Decimal>();
    // Set<Id> accId = new Set<Id>();
    Boolean flag;
    String oldId, newId;
    Map<String, Map<Id, Decimal>> accAmount = new Map<String, Map<Id, Decimal>>{
      'Increment' => new Map<Id, Decimal>(),
      'Decrement' => new Map<Id, Decimal>()
    };

    for (Opportunity eachOpp : oppNew) {
      System.debug(
        'oppOldMap.get(eachOpp.Id).Amount--14>' +
        oppOldMap.get(eachOpp.Id).Amount
      );
      System.debug('eachOpp.Amount15-->' + eachOpp.Amount);
      if (eachOpp.Amount != oppOldMap.get(eachOpp.Id).Amount) {
        //check if amount got deducted or increased
        System.debug(
          'oppOldMap.get(eachOpp.Id).Amount-->' +
          oppOldMap.get(eachOpp.Id).Amount
        );
        System.debug('eachOpp.Amount-->' + eachOpp.Amount);
        if (eachOpp.Amount > oppOldMap.get(eachOpp.Id).Amount) {
          //increased amount
          if (!accAmount.containsKey(eachOpp.AccountId)) {
            accAmount.get('Increment')
              .put(
                eachOpp.AccountId,
                eachOpp.Amount - oppOldMap.get(eachOpp.Id).Amount
              );
          } else {
            accAmount.get('Increment')
              .put(
                eachOpp.AccountId,
                accAmount.get('Increment').get(eachOpp.AccountId) +
                (eachOpp.Amount - oppOldMap.get(eachOpp.Id).Amount)
              );
          }
          /* accAmount.put(
            eachOpp.AccountId,
            (eachOpp.Amount - oppOldMap.get(eachOpp.AccountId).Amount)
          ); */
        } else {
          //decreased amount
          if (!accAmount.containsKey(eachOpp.AccountId)) {
            accAmount.get('Decrement')
              .put(
                eachOpp.AccountId,
                oppOldMap.get(eachOpp.Id).Amount - eachOpp.Amount
              );
          } else {
            accAmount.get('Decrement')
              .put(
                eachOpp.AccountId,
                accAmount.get('Decrement').get(eachOpp.AccountId) +
                (oppOldMap.get(eachOpp.Id).Amount - eachOpp.Amount)
              );
          }
          /* accAmount.put(
            eachOpp.AccountId,
            (eachOpp.Amount - oppOldMap.get(eachOpp.AccountId).Amount)
          ); */
        }
        /* if (!accAmount.containsKey(eachOpp.AccountId)) {
          // sum = eachOpp.Amount;
          accAmount.put(eachOpp.AccountId, 0);

        } */
        oppList.add(eachOpp);
        //accAmount.put(eachOpp.AccountId, eachOpp.Amount);
      } else if (eachOpp.AccountId <> oppOldMap.get(eachOpp.Id).AccountId) {
        //if Account is lost on Opp.
        if (String.isBlank((String) eachOpp.AccountId)) {
          //get old account from old opp map
          //accAmount.put(oppOldMap.get(eachOpp.Id).AccountId, -eachOpp.Amount);
          flag = true;
          oldId = oppOldMap.get(eachOpp.Id).AccountId;
          accAmount.get('Decrement')
            .put(oppOldMap.get(eachOpp.Id).AccountId, eachOpp.Amount);
        } else {
          //get new account to update or increment new value
          flag = true;
          oldId = oppOldMap.get(eachOpp.Id).AccountId;
          newId = eachOpp.AccountId;
          accAmount.get('Decrement')
            .put(oppOldMap.get(eachOpp.Id).AccountId, eachOpp.Amount);
          accAmount.get('Increment').put(eachOpp.AccountId, eachOpp.Amount);
          //get old account to decrement lost value.
          //accAmount.put(eachOpp.AccountId, eachOpp.Amount);
          //accAmount.put(oppOldMap.get(eachOpp.Id).AccountId, -eachOpp.Amount);
        }
        oppList.add(eachOpp);
      }
    }
    System.debug(flag);
    System.debug(oldId);
    List<Account> accList = [
      SELECT Id, SumOfOppAmount__c
      FROM Account
      WHERE
        Id IN :accAmount.get('Increment').keySet()
        OR Id IN :accAmount.get('Decrement').keySet()
    ];
    for (Account a : accList) {
      if (
        accAmount.get('Increment').containsKey(a.Id) || (flag && a.Id == newId)
      ) {
        a.SumOfOppAmount__c += accAmount.get('Increment').get(a.Id);
      } else if (
        accAmount.get('Decrement').containsKey(a.Id) || (flag && a.Id == oldId)
      ) {
        a.SumOfOppAmount__c -= accAmount.get('Decrement').get(a.Id);
      }
    }
    update accList;

    //updateSumOfOppsAmount(oppList, accList, accAmount);
  }

  private static void updateAccountIfOppIsLost() {
  }

  // public static void afterInsert(List<Opportunity> newOpp){
  //     Set<Id> accId = new Set<Id>();
  //     for(Opportunity eachOpp : newOpp){
  //         accId.add(eachOpp.AccountId);
  //     }
  //     updateSumOfOppsAmount(newOpp, accId);
  // }

  public static void updateSumOfOppsAmount(
    List<Opportunity> oppList,
    List<Account> accList,
    Map<Id, Decimal> accAmount
  ) {
    Map<Id, Account> accMap = new Map<Id, Account>();
    // List<Id> accIdList = new List<Id>(accIdSet);

    Integer i = 0;
    for (Opportunity opp : oppList) {
      if (
        accAmount.containsKey(opp.AccountId) &&
        opp.Amount != null &&
        accList[i].Id == opp.AccountId
      ) {
        if (!accMap.containsKey(opp.AccountId)) {
          accMap.put(
            opp.AccountId,
            new Account(
              Id = opp.AccountId,
              SumOfOppAmount__c = accList[i].SumOfOppAmount__c +
                accAmount.get(opp.AccountId)
            )
          );
        }

        Account acc = accMap.get(opp.AccountId);
        acc.SumOfOppAmount__c += opp.Amount; //map get decimal amoutn
        accMap.put(opp.AccountId, acc);
      }
      i++;
    }

    // Correctly working code but should be Optimized by removing query.
    // for(Opportunity eachOpp : [Select Id, AccountId, Amount from Opportunity where Amount != null AND AccountId IN : accIdSet with SECURITY_ENFORCED]){

    //     if(!accMap.containsKey(eachOpp.AccountId)){
    //         accMap.put(eachOpp.AccountId, new Account(Id = eachOpp.AccountId, SumOfOppAmount__c = 0));
    //     }

    //     Account acc = accMap.get(eachOpp.AccountId);
    //     acc.SumOfOppAmount__c += eachOpp.Amount;
    //     accMap.put(eachOpp.AccountId, acc);
    // }
    update accMap.values();

    // Previous written code.
    // for (Opportunity eachOpp : oppList) {
    //     // Account a = oppMap.get(eachOpp.AccountId);
    //     if(eachOpp.Account.SumOfOppAmount__c == null){
    //         eachOpp.Account.SumOfOppAmount__c = 0;
    //     }
    //     eachOpp.Account.SumOfOppAmount__c += eachOpp.Amount;

    // }
  }
}
