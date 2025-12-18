public with sharing class CaseTriggerScenarioHandler1 {
  public static void afterCaseCreated(List<Case> newCases) {
    if (newCases.isEmpty() || newCases == null) {
      return;
    }
    Set<Id> accIds = new Set<Id>();
    for (Case c : newCases) {
      if (c.AccountId != null) {
        accIds.add(c.AccountId);
      }
    }
    if (accIds.isEmpty()) {
      return;
    }
    List<AggregateResult> caseCounts = [
      SELECT AccountId, COUNT(Id) caseCount
      FROM Case
      WHERE AccountId IN :accIds
      GROUP BY AccountId
      HAVING COUNT(Id) > 3
    ];
    if (caseCounts.isEmpty()) {
      return;
    }
    List<Task> tasksToInsert = new List<Task>();
    for (AggregateResult ar : caseCounts) {
      tasksToInsert.add(
        new Task(
          WhatId = (Id) ar.get('AccountId'),
          Priority = 'High',
          Status = 'New'
        )
      );
    }

    if (!tasksToInsert.isEmpty()) {
      insert tasksToInsert;
    }
  }
}
