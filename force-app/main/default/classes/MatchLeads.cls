public with sharing class MatchLeads {
  // public MatchLeads() {

  // }

  public void matchingLeads(List<Lead> leadsList) {
    // List<Lead> allLeads = [
    //   SELECT Id, Name, Email, Phone
    //   FROM Lead
    //   ORDER BY CreatedDate DESC
    // ];
    // Map<String, List<Lead>> sameNames = new Map<String, List<Lead>>();
    // Map<String, List<Lead>> sameEmail = new Map<String, List<Lead>>();
    // Map<String, List<Lead>> samePhone = new Map<String, List<Lead>>();
    String LeadName = 'Name';
    String LeadEmail = 'Email';
    String LeadPhone = 'Phone';
    Map<String, Map<String, List<Lead>>> leadsMap = new Map<String, Map<String, List<Lead>>>{
      LeadName => new Map<String, List<Lead>>(),
      LeadEmail => new Map<String, List<Lead>>(),
      LeadPhone => new Map<String, List<Lead>>()
    };
    for (Lead eachLead : leadsList) {
      if (!leadsMap.get(LeadName).containsKey(eachLead.Name)) {
        leadsMap.get(LeadName).put(eachLead.Name, new List<Lead>{ eachLead });
      } else {
        leadsMap.get(LeadName).get(eachLead.Name).add(eachLead);
      }
      if (!leadsMap.get(LeadEmail).containsKey(eachLead.Email)) {
        leadsMap.get(LeadEmail).put(eachLead.Email, new List<Lead>{ eachLead });
      } else {
        leadsMap.get(LeadEmail).get(eachLead.Email).add(eachLead);
      }
      if (!leadsMap.get(LeadPhone).containsKey(eachLead.Phone)) {
        leadsMap.get(LeadPhone).put(eachLead.Phone, new List<Lead>{ eachLead });
      } else {
        leadsMap.get(LeadPhone).get(eachLead.Phone).add(eachLead);
      }
    }

    System.debug('SameNames == ' + leadsMap.get(LeadName));
    System.debug('SameEmail == ' + leadsMap.get(LeadEmail));
    System.debug('SamePhone == ' + leadsMap.get(LeadPhone));
    Map<String, List<Lead>> sameLead = new Map<String, List<Lead>>();
    List<Lead> perfectMatch = new List<Lead>();
    for (Lead eachRecord : leadsList) {
        if(leadsMap.get(LeadName).get(eachRecord.Name).size()>1){
            if(!sameLead.containsKey(eachRecord.Name)){

                sameLead.put(eachRecord.Name, new List<Lead>());
            }
            if (
              (leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name == eachRecord.Name) &&
              (leadsMap.get(LeadEmail).get(eachRecord.Email).get(leadsMap.get(LeadEmail).get(eachRecord.Email).indexOf(eachRecord)).Email == eachRecord.Email)  &&
              (leadsMap.get(LeadPhone).get(eachRecord.Phone).get(leadsMap.get(LeadPhone).get(eachRecord.Phone).indexOf(eachRecord)).Phone == eachRecord.Phone) 
            ) {
                sameLead.get(eachRecord.Name).add(eachRecord);

            }

           else if( (leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name == eachRecord.Name) &&
           (leadsMap.get(LeadEmail).get(eachRecord.Email).get(leadsMap.get(LeadEmail).get(eachRecord.Email).indexOf(eachRecord)).Email == eachRecord.Email)){
            sameLead.get(leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name).add(eachRecord);

           }
           else if( (leadsMap.get(LeadEmail).get(eachRecord.Email).get(leadsMap.get(LeadEmail).get(eachRecord.Email).indexOf(eachRecord)).Email == eachRecord.Email)  &&
           (leadsMap.get(LeadPhone).get(eachRecord.Phone).get(leadsMap.get(LeadPhone).get(eachRecord.Phone).indexOf(eachRecord)).Phone == eachRecord.Phone) ){
            sameLead.get(leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name).add(eachRecord);

           }
           else if( (leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name == eachRecord.Name) && 
            (leadsMap.get(LeadPhone).get(eachRecord.Phone).get(leadsMap.get(LeadPhone).get(eachRecord.Phone).indexOf(eachRecord)).Phone == eachRecord.Phone) ){
                sameLead.get(leadsMap.get(LeadName).get(eachRecord.Name).get(leadsMap.get(LeadName).get(eachRecord.Name).indexOf(eachRecord)).Name).add(eachRecord);

            }
        }
    }
    System.debug(sameLead);
  }
}

// String allTogether = eachLead.Name+eachLead.Email+eachLead.Phone;
// String nameEmail = eachLead.Name+eachLead.Email;
// String emailPhone = eachLead.Email+eachLead.Phone;
// String namePhone = eachLead.Name+eachLead.Phone;
// if(!leadsMap.containsKey(allTogether)){
//     leadsMap.put(allTogether, new List<Lead>{eachLead});
// }
// else if(!leadsMap.containsKey(nameEmail)){
//     leadsMap.put(nameEmail, new List<Lead>{eachLead});
// }
// else if(!leadsMap.containsKey(emailPhone)){
//     leadsMap.put(emailPhone, new List<Lead>{eachLead});
// }
// else if(!leadsMap.containsKey(namePhone)){
//     leadsMap.put(namePhone, new List<Lead>{eachLead});
// }
// else{
//     if(leadsMap.containsKey(allTogether))
//     leadsMap.get(arg0)
// }