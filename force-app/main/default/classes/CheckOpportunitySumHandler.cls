public class CheckOpportunitySumHandler {
  public static void checkTotalSum(List<Opportunity> newOpps) {
    System.debug('Checking total sum for new Opportunities: ' + newOpps);
    if (newOpps?.isEmpty() ?? true) {
      return;
    }

    Set<Id> ownerIds = new Set<Id>();
    for (Opportunity opp : newOpps) {
      if (opp.OwnerId != null) {
        ownerIds.add(opp.OwnerId);
      }
    }

    if (ownerIds.isEmpty()) {
      return;
    }

    List<AggregateResult> sumCheck = [
      SELECT OwnerId UserId, Sum(Amount) sumOfOpp
      FROM Opportunity
      WHERE OwnerId IN :ownerIds
      GROUP BY OwnerId
      HAVING Sum(Amount) > 5000
    ]; 
    
    System.debug('Sum Check Results: ' + sumCheck);
    if (sumCheck.isEmpty()) {
      return;
    }
    Set<Id> userIds = new Set<Id>();
    for (AggregateResult sumOfOpps : sumCheck) {
      userIds.add((Id) sumOfOpps.get('UserId'));
    }
    for (Opportunity opp : newOpps) {
      if (userIds.contains(opp.OwnerId)) {
        System.debug(
          'Blocking Opportunity Insertion for OwnerId: ' + opp.OwnerId
        );
        opp.addError('Prevent insertion');
      }
    }
  }
}
