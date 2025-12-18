public without sharing OpportunityHandler{
    public void checkOpportunity(List<Opportunity> oppsList){
        for(Opportunity opp : oppsList){
            if(opp.RecordTypeId == null){
                return;
            }
            if(opp.RecordType.Name == 'Corporate Sale' && opp.Discount__c>10){
                opp.addError('Discount should not exceed more than 10% for Corporate Sale');
            }
            else if(opp.RecordType.Name=='Government Sale'){
                opp.Payment_Terms__c = 'Net 60';

            }
            else if(opp.RecordType.Name == 'Partner Sale' && opp.Partner_Account__c == null){
                opp.addError('Please enter a value in Partner Account');
            }
        }
    }
}