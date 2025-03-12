// public with sharing class SandBoxCodeCheck {
//     public SandBoxCodeCheck() {

//     }
// }

// Class - 1
/*Class Name        : CTC_CountPurgeDocumentsBatch
  Description       : Batch to count the number of files
  Developed By      : Akshatha
  Created On        : 31/01/2022
  Last Modified On  : 07/06/2022 By Harshal
*/
// global class CTC_CountPurgeDocumentsBatch implements Database.Batchable<sObject> {
//   global Database.QueryLocator start(Database.BatchableContext bc) {
//     String query = 'SELECT Id,No_Of_Related_Files__c FROM ResidentialLoanApplication  WHERE Loan_Status__c IN (\'Cancelled\',\'Declined\',\'Active\')';
//     return Database.getQueryLocator(query);
//   }

//   global void execute(
//     Database.BatchableContext bc,
//     List<ResidentialLoanApplication> mort
//   ) {
//     Set<Id> dealIdSet = new Set<Id>();
//     Map<String, Integer> countOfDocument = new Map<String, Integer>();
//     for (ResidentialLoanApplication rm : mort) {
//       dealIdSet.add(rm.id);
//     }
//     for (ContentDocumentLink document : [
//       SELECT ContentDocumentId, LinkedEntityId
//       FROM ContentDocumentLink
//       WHERE LinkedEntityId IN :dealIdSet
//     ]) {
//       if (!countOfDocument.containsKey(document.LinkedEntityId)) {
//         countOfDocument.put(document.LinkedEntityId, 1);
//       } else {
//         Integer currentInt = countOfDocument.get(document.LinkedEntityId) + 1;
//         countOfDocument.put(document.LinkedEntityId, currentInt);
//       }
//     }
//     List<ResidentialLoanApplication> rmObjToUpdate = new List<ResidentialLoanApplication>();

//     for (ResidentialLoanApplication resMortg : mort) {
//       if (countOfDocument.containsKey(resMortg.Id)) {
//         resMortg.No_Of_Related_Files__c = countOfDocument.get(resMortg.Id);
//         rmObjToUpdate.add(resMortg);
//       } else {
//         resMortg.No_Of_Related_Files__c = 0;
//         rmObjToUpdate.add(resMortg);
//       }
//     }

//     if (rmObjToUpdate.size() > 0) {
//       update rmObjToUpdate;
//     }
//   }
//   global void finish(Database.BatchableContext BC) {
//   }
// }

//Class - 2 : CTC_UpdateWhatIdOn
/*Class Name        : CTC_UpdateWhatIdOnCTCTaskBatch
Test Class Name		: CTC_UpdateWhatIdOnCTCTaskBatchTest
Description      	: Batch class to update WhatId as Deal Id on CTC Tasks
Developed By     	: Sandip Padekar
Created On       	: 05/11/2022
Last Modified By  	: 13/06/2022
Last Modified Date  : Sandip Padekar
*/
// global class CTC_UpdateWhatIdOnCTCTaskBatch implements Database.Batchable<sObject> {
//   Id digiMARecId = Schema.SObjectType.Task.getRecordTypeInfosByName()
//     .get('CTC Digital MA Task')
//     .getRecordTypeId();
//   global Database.QueryLocator start(Database.BatchableContext bc) {
//     String query =
//       'SELECT Id, Residential_Mortgage__c, WhatId, RecordtypeId FROM Task WHERE Residential_Mortgage__c!=NULL AND WhatId=NULL AND (RecordtypeId = \'' +
//       digiMARecId +
//       '\')';
//     return Database.getQueryLocator(query);
//   }
//   global void execute(Database.BatchableContext bc, List<Task> taskList) {
//     List<Task> tasksToUpdateList = new List<Task>();
//     for (Task tsk : taskList) {
//       if (
//         tsk.residential_mortgage__c != null &&
//         tsk.WhatId == null &&
//         tsk.recordtypeid == digiMARecId
//       ) {
//         tsk.WhatId = tsk.residential_mortgage__c;
//         tasksToUpdateList.add(tsk);
//       }
//     }

//     try {
//       if (tasksToUpdateList.size() > 0)
//         update (tasksToUpdateList);
//     } catch (DMLException e) {
//       system.debug('Error in updating tasks for related to field:' + e);
//     }
//   }
//   global void finish(Database.BatchableContext BC) {
//   }
// }

// Class - 3 : CTC_PurgeBrokerPortalFilesBatch

/*Class Name        : CTC_PurgeBrokerPortalFilesBatch
  Test Class Name	: CTC_PurgeBrokerPortalFilesSchedulerTest
  Description       : Batch class to purge files from deal where Funding_Date__c is 7 year old
  Developed By      : Sandip Padekar
  Created On        : 28/10/2021 
  Last Modified On  : 02/11/2021 
*/
// global class CTC_PurgeBrokerPortalFilesBatch implements Database.Batchable<sObject> {
//   CTC_File_Purge_Configuration__mdt fundedMonths = [
//     SELECT MasterLabel, Value__c
//     FROM CTC_File_Purge_Configuration__mdt
//     WHERE MasterLabel = 'Funded Deal Months'
//     LIMIT 1
//   ];
//   global Database.QueryLocator start(Database.BatchableContext bc) {
//     String query =
//       'SELECT Id,Funding_Date__c  FROM ResidentialLoanApplication WHERE Funding_Date__c < LAST_N_MONTHS:' +
//       fundedMonths.value__c +
//       ' and Funding_Date__c!=null and Loan_Status__c =\'Active\' ';
//     return Database.getQueryLocator(query);
//   }
//   global void execute(
//     Database.BatchableContext bc,
//     List<ResidentialLoanApplication> mort
//   ) {
//     Set<Id> dealIdSet = new Set<Id>();
//     Set<Id> filesIdSet = new Set<Id>();
//     List<ContentDocument> filesToDeleteList = new List<ContentDocument>();
//     List<ContentDocumentLink> docLinkList = new List<ContentDocumentLink>();

//     for (ResidentialLoanApplication rm : mort) {
//       dealIdSet.add(rm.id);
//     }
//     docLinkList = [
//       SELECT ContentDocumentId, LinkedEntityId
//       FROM ContentDocumentLink
//       WHERE LinkedEntityId IN :dealIdSet
//     ];
//     for (ContentDocumentLink dlk : docLinkList) {
//       filesIdSet.add(dlk.ContentDocumentId);
//     }
//     filesToDeleteList = [
//       SELECT Id
//       FROM ContentDocument
//       WHERE ID IN :filesIdSet
//     ];
//     try {
//       if (filesToDeleteList.size() > 0)
//         delete (filesToDeleteList);
//     } catch (Exception e) {
//       system.debug('Error in deleting deal files:' + e);
//     }
//   }
//   global void finish(Database.BatchableContext BC) {
//   }
// }

//Class-4 : CTC_UpdateRateExpiryDateBatch
/**
 * arg ClassName    : CTC_UpdateRateExpiryDateBatch
 * arg CreatededBy  : Akshatha
 * arg created on   : 12/05/2022
 * arg Description  : To update the Rate_Expiry_Date__c when Commitment_Date__c>=7/5/2022
 * Last Modified on : 18/5/2022
 * Last Modified by : Akshatha
 **/

// global class CTC_UpdateRateExpiryDateBatch implements Database.Batchable<sObject>, DataBase.Stateful {
//   global Database.QueryLocator start(Database.BatchableContext BC) {
//     //String query = 'SELECT Id,LMS_Loan_Number__c,Purpose__c,submitted_date__c,Loan_Status__c,Commitment_Date__c FROM ResidentialLoanApplication Where Loan_Status__c IN (\'Application\',\'Commitment\') AND Purpose__c in (\'Purchase\',\'Refinance - Debt Consolidation\',\'Refinance - ETO\',\'Purchase New Construction\',\'Equity Take Out\',\'Purchase Private\',\'Purchase with Improvements\',\'Purchase Port\',\'Purchase Rent to own\',\'Refinance External\')';
//     String query = 'SELECT Id,LMS_Loan_Number__c,Purpose__c,submitted_date__c,Rate_Expiry_Date__c,Loan_Status__c,Commitment_Date__c FROM ResidentialLoanApplication Where Loan_Status__c IN (\'Application\',\'Commitment\') AND (Rate_Expiry_Date__c = null) AND Purpose__c in (\'Purchase\',\'Refinance - Debt Consolidation\',\'Refinance - ETO\',\'Purchase New Construction\',\'Equity Take Out\',\'Purchase Private\',\'Purchase with Improvements\',\'Purchase Port\',\'Purchase Rent to own\',\'Refinance External\')';
//     return Database.getQueryLocator(query);
//   }
//   global void execute(
//     Database.BatchableContext BC,
//     List<ResidentialLoanApplication> rmList
//   ) {
//     //List<Case> listOfCase = new List<Case>();
//     List<ResidentialLoanApplication> rmObjList = new List<ResidentialLoanApplication>();
//     CTC_RMCommitmentDate__mdt dateValue = [
//       SELECT CommitmentDate__c
//       FROM CTC_RMCommitmentDate__mdt
//       WHERE label = 'CTC_RM_CommitmentDate'
//       LIMIT 1
//     ];

//     try {
//       for (ResidentialLoanApplication rm : rmList) {
//         /*
//          * TICKET: QFSCU-1394 Create Fields -
//          * DESC: Added New If Condition as per the pre-prod
//          */
//         //if((rm.Purpose__c == 'Refinance External'||rm.Purpose__c == 'Refinance - Debt Consolidation' ||rm.Purpose__c == 'Refinance - ETO' || rm.Purpose__c == 'Equity Take Out')&& rm.submitted_date__c != null && rm.Commitment_Date__c >= dateValue.CommitmentDate__c && (rm.Loan_Status__c == 'Application' || rm.Loan_Status__c =='Commitment')){
//         if (
//           (rm.Purpose__c == 'Refinance External' ||
//           rm.Purpose__c == 'Refinance - Debt Consolidation' ||
//           rm.Purpose__c == 'Refinance - ETO' ||
//           rm.Purpose__c == 'Equity Take Out') &&
//           rm.submitted_date__c != null &&
//           rm.Commitment_Date__c >= dateValue.CommitmentDate__c &&
//           rm.Rate_Expiry_Date__c == null &&
//           (rm.Loan_Status__c == 'Application' ||
//           rm.Loan_Status__c == 'Commitment')
//         ) {
//           Date getSubmittedDate = rm.submitted_date__c;
//           Date getRateExpiryDate = getSubmittedDate.addDays(60);
//           /*
//            * TICKET: QFSCU-1394 Create Fields -
//            * DESC: Added Rate_Expiry_Date__c Field back as per the pre-prod
//            */
//           rm.Rate_Expiry_Date__c = getRateExpiryDate;
//           rmObjList.add(rm);
//         }
//         /*
//          * TICKET: QFSCU-1394 Create Fields -
//          * DESC: Added New If Condition as per the pre-prod
//          */
//         //else if((rm.Purpose__c == 'Purchase' ||rm.Purpose__c == 'Purchase New Construction' || rm.Purpose__c == 'Purchase Private' ||rm.Purpose__c == 'Purchase with Improvements' || rm.Purpose__c == 'Purchase Port' ||  rm.Purpose__c =='Purchase Rent to own') && rm.submitted_date__c != null && rm.Commitment_Date__c >= dateValue.CommitmentDate__c  && (rm.Loan_Status__c == 'Application' || rm.Loan_Status__c =='Commitment')){
//         else if (
//           (rm.Purpose__c == 'Purchase' ||
//           rm.Purpose__c == 'Purchase New Construction' ||
//           rm.Purpose__c == 'Purchase Private' ||
//           rm.Purpose__c == 'Purchase with Improvements' ||
//           rm.Purpose__c == 'Purchase Port' ||
//           rm.Purpose__c == 'Purchase Rent to own') &&
//           rm.submitted_date__c != null &&
//           rm.Commitment_Date__c >= dateValue.CommitmentDate__c &&
//           rm.Rate_Expiry_Date__c == null &&
//           (rm.Loan_Status__c == 'Application' ||
//           rm.Loan_Status__c == 'Commitment')
//         ) {
//           Date getSubmittedDate = rm.submitted_date__c;
//           Date getRateExpiryDate = getSubmittedDate.addDays(90);
//           /*
//            * TICKET: QFSCU-1394 Create Fields -
//            * DESC: Added Rate_Expiry_Date__c Field back as per the pre-prod
//            */
//           rm.Rate_Expiry_Date__c = getRateExpiryDate;
//           rmObjList.add(rm);
//         }

//         /*  if(rm.CTC_Business_Days_To_Expiry_Notificatio__c == true)
//                 {
//                     System.debug('Case  created');
//                     Case cobj = new Case();
//                     cobj.Subject = 'Case Created by Residentioal mortgage';
//                     listOfCase.add(cobj);
//                 }*/
//       }
//       if (rmObjList.size() > 0) {
//         update rmObjList;
//       }
//       /* if(listOfCase.size()>0){
//                 Insert listOfCase;
//             }*/
//     } catch (exception e) {
//       e.getMessage();
//     }
//   }
//   global void finish(Database.BatchableContext BC) {
//   }
// }

// Class-5 : LMSSyncBatch

/* Class Name           : LMSSyncBatch 
Description             : To Create and Update sObject Records periodically based on Data Stored in Temparory objects Loan, Appraiser,Broker and Client
Created By and On       : BrightMark Developer on 14/12/2017
Last Modified By and On : BrightMark Developer on 01/06/2018
Last Modified By and On : Anup Raagvitech on 02/March/2020 
last modified by Ramesh : New FSC changes updated*/
/**
 * @description To Create and Update sObject Records periodically based on Data Stored in Temparory objects Loan, Appraiser,Broker and Client
 * @author BrightMark Developer on 14/12/2017
 * @since Changes added on December 22 2023
 */
// @SuppressWarnings(
//   'PMD.ExcessiveClassLength, PMD.CognitiveComplexity, PMD.StdCyclomaticComplexity, PMD.CyclomaticComplexity'
// )
// public class LMSSyncBatch implements Database.Batchable<sObject>, Database.Stateful {
//   /*Start - Global Variables*/
//   /*changed global to public in all places */
//   public String strQuery = 'SELECT Id,Credit_Manager__c,Loan_Type__c,User_Profile_ID__c,Branch__c,Commitment_Date__c,Error_Description__c, MPID__c,Appraisal_Date__c,TDS_QualRate__c,Spread_Rate__c,Holder__c,LMS_Rate__c,Other_Agent__c,Program__c,Occupancy_Type__c,Risk_Code__c,Province__c,Late_Interest__c,GDS_QualRate__c,Core_Rate__c,Commitment_Fee__c,Void_Date__c,Commitment_Expiry__c,Cancel_Date__c,Borrower_Lastname__c,Beacon_Score__c,App_Source__c,Funder__c,Funding_date__c,LMS_Appraiser_ID__c,LMS_BrokerHouse_ID__c,LMS_Broker_ID__c,LMS_CIF__c,LMS_Loan_Number__c,Loan_Amount__c,LegacySalesforceID__c,Loan_Status__c,Loan_to_Value_LTV__c,Maturity_date__c,Mortgage_Officer__c,Name,Property_Address__c,Property_City__c,Property_Value__c,Purpose__c,Status__c,Submitted_Date__c,Term__c,Submission_Agent__c,Underwriter__c,Anticipated_Funding_Date__c,Sub_Status__c,Sundry_Balance__c,Tax_Balance__c, LMS_Premium__c,LMS_Discount__c FROM Loan__c WHERE Status__c != \'Failed\' ';

//   public Map<String, RecordType_Name_to_ID__c> mapRecordTypeNameToId = RecordType_Name_to_ID__c.getAll();
//   public List<String> lstErrorRecords = new List<String>();
//   public List<Client__c> lstClientToUpdate = new List<Client__c>();
//   public Map<string, Id> accountIdMap = new Map<string, Id>();
//   public Set<String> setClientToUpdate = new Set<String>();
//   public set<string> clientKeySet = new Set<string>();
//   public Map<String, String> mapClientLMSIdToClientId = new Map<String, String>(); //To Get Appraiser ID when processing fails

//   public static final Id MORTGAGE_RT = Schema.SObjectType.ResidentialLoanApplication.getRecordTypeInfosByDeveloperName()
//     .get('Mortgage_CTC')
//     .getRecordTypeId();
//   public static final Id FAR_CONTACT_RT = Schema.SObjectType.FinServ__FinancialAccountRole__c.getRecordTypeInfosByDeveloperName()
//     .get('ContactRole')
//     .getRecordTypeId();
//   public static final Id FAR_ACCOUNT_RT = Schema.SObjectType.FinServ__FinancialAccountRole__c.getRecordTypeInfosByDeveloperName()
//     .get('AccountRole')
//     .getRecordTypeId();
//   public String strExecuteErrorMessage = '';

//   public Boolean isExecuteError = false;
//   public Boolean isProcessingError = false;
//   private static Boolean isEnableCapturingExceptionForCTCRLACreation = Feature_Flag__c.getInstance()
//     .Enable_Capturing_CreateCTCRLA_Exception__c;

//   @testVisible
//   private static Boolean updateClientBasedOnMPID = Feature_Flag__c.getInstance()
//     .Update_Client_Based_on_MPID__c;

//   private static Boolean featureFlagToResolveDuplicateIdError = Feature_Flag__c.getInstance()
//     .FF_To_Resolve_DuplicateId_Error__c;
//   /*End - Global Variables*/

//   /*Start - Method start to return QueryLocator based on Query*/
//   /**
//    * @description Method start to return QueryLocator based on Query
//    * @param bc
//    * @return `Database.QueryLocator`
//    */
//   public Database.QueryLocator start(Database.BatchableContext bc) {
//     return Database.getQueryLocator(strQuery);
//   }
//   /*End - Method start to return QueryLocator based on Query*/

//   /*Start - Method execute perform business logic on the data returned*/
//   /**
//    * @description Method execute perform business logic on the data returned
//    * @param bc
//    * @param scope
//    */
//   public void execute(Database.BatchableContext bc, List<sObject> scope) {
//     if (!isEnableCapturingExceptionForCTCRLACreation) {
//       this.innerExecute(scope);
//       return;
//     }
//     try {
//       this.innerExecute(scope);
//     } catch (CreateCTCMortgageException e) {
//       Logger.Error(
//         'Exception occurred for mapping data to rla and upserting rla: ' +
//           e.getFailedLoanNumbers() +
//           e.getMessage()
//       );
//       Logger.saveLog();
//     }
//   }

//   private void innerExecute(List<sObject> scope) {
//     Set<String> setLMSAppraiserId = new Set<String>(); //Set Containing all the Appraiser Id's
//     Set<String> setLMSIdinBroker = new Set<String>(); //Set Containing Broker House and Broker Id's of Loan that would be LMS Client ID in Broker Records
//     Set<String> setClientId = new Set<String>(); //Set Containing LMS ClientId of Client Records
//     Set<String> setAccountExternalId = new Set<String>(); //Set Containing external ID of all related Accounts.
//     Set<String> setUsername = new Set<String>(); //Set string Containing usernames presented in loan
//     Set<String> setLoanId = new Set<String>(); //Set string Containing Id's of loan procesed
//     List<Loan__c> lstLoan = (List<Loan__c>) scope; //Type Cast the scope into Loan Temporary Object

//     for (Loan__c objLoan : lstLoan) {
//       setLoanId.add(objLoan.Id);

//       if (!String.isEmpty(objLoan.LMS_Appraiser_ID__c)) {
//         setLMSAppraiserId.add(objLoan.LMS_Appraiser_ID__c);
//       }

//       if (!String.isEmpty(objLoan.LMS_Broker_ID__c)) {
//         setLMSIdinBroker.add(objLoan.LMS_Broker_ID__c);
//       }

//       if (!String.isEmpty(objLoan.LMS_BrokerHouse_ID__c)) {
//         setLMSIdinBroker.add(objLoan.LMS_BrokerHouse_ID__c);
//       }

//       if (!String.isEmpty(objLoan.LMS_CIF__c)) {
//         setClientId.add(objLoan.LMS_CIF__c);
//       }

//       if (String.isNotBlank(objLoan.Underwriter__c)) {
//         setUsername.add(objLoan.Underwriter__c);
//       }

//       if (String.isNotBlank(objLoan.Mortgage_Officer__c)) {
//         setUsername.add(objLoan.Mortgage_Officer__c);
//       }

//       if (String.isNotBlank(objLoan.Funder__c)) {
//         setUsername.add(objLoan.Funder__c);
//       }

//       if (String.isNotBlank(objLoan.Credit_Manager__c)) {
//         setUsername.add(objLoan.Credit_Manager__c);
//       }
//     }
//     setAccountExternalId.addAll(setLMSAppraiserId);
//     setAccountExternalId.addAll(setLMSIdinBroker);
//     setAccountExternalId.addAll(setClientId);
//     createAppraiser(setLMSAppraiserId); //Method to createAppraiser to create Account based on the information from Loan and Appraiser Temporary Object
//     createBroker(setLMSIdinBroker); //Method to create Account and Contact based on the information from Loan and Broker Temporary Object
//     if (updateClientBasedOnMPID) {
//       createClientWithFeatureFlagON(setClientId); // Method to update PersonAccount created from CLP with Feature flag implementation
//     } else {
//       createClient(setClientId); //Method to  to create Contact based on the information from Loan and Client Temporary Object
//     }
//     createMortgages(setClientId, setAccountExternalId, setUsername, setLoanId); //Method to create Rsidential Mortgage records
//   }
//   /*End - Method execute perform business logic on the data returned*/

//   /*Start - Method createAppraiser to create Account based on the information from Loan and Appraiser Temporary Object*/
//   private void createAppraiser(Set<String> setLMSAppraiserId) {
//     List<Account> lstAccountToInsert = new List<Account>();
//     List<Appraiser__c> lstAppraiserToUpdate = new List<Appraiser__c>();

//     Map<String, String> mapAppraiserLMSIdToAppraiserId = new Map<String, String>(); //To Get Appraiser ID when processing fails

//     Set<string> setAppraiserToUpdate = new Set<String>();

//     //Iterate on List of Appraisers based on Appraiser ID in Loan
//     for (Appraiser__c objAppraiser : [
//       SELECT
//         Id,
//         Name,
//         BillingCity__c,
//         BillingPostalCode__c,
//         BillingState__c,
//         BillingStreet__c,
//         Company_Type__c,
//         Email__c,
//         Error_Description__c,
//         LMS_Client_ID__c,
//         Status__c,
//         Phone__c
//       FROM Appraiser__c
//       WHERE LMS_Client_ID__c IN :setLMSAppraiserId AND Status__c != 'Failed'
//     ]) {
//       mapAppraiserLMSIdToAppraiserId.put(
//         objAppraiser.LMS_Client_ID__c,
//         objAppraiser.Id
//       );

//       //Create an Account instance based on details from Appraiser with recordType as Corporation   //       mapRecordTypeNameToId.get('Corporation_ctc').Id__c,
//       lstAccountToInsert.add(
//         new Account(
//           RecordTypeId = mapRecordTypeNameToId.get('Corporation_ctc').Id__c,
//           LMS_Client_ID__c = objAppraiser.LMS_Client_ID__c,
//           Type = objAppraiser.Company_Type__c,
//           Name = objAppraiser.Name,
//           BillingStreet = objAppraiser.BillingStreet__c,
//           BillingCity = objAppraiser.BillingCity__c,
//           BillingState = objAppraiser.BillingState__c,
//           BillingPostalCode = objAppraiser.BillingPostalCode__c,
//           Phone = objAppraiser.Phone__c,
//           Email__c = objAppraiser.Email__c,
//           Source_System__c = 'CTC'
//         )
//       );
//     }
//     // set external id for upsert
//     Schema.SObjectField fieldExternalId = Account.Fields.LMS_Client_ID__c;
//     //Save result of DML
//     Database.UpsertResult[] saveResultList = Database.upsert(
//       lstAccountToInsert,
//       fieldExternalId,
//       false
//     );

//     Integer intResultIndex = 0;
//     //Iterate over list of results
//     for (Database.UpsertResult objSaveResult : saveResultList) {
//       //Check if DML has failed
//       if (!objSaveResult.isSuccess()) {
//         isProcessingError = true;
//         if (
//           !setAppraiserToUpdate.contains(
//             mapAppraiserLMSIdToAppraiserId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           )
//         ) {
//           lstErrorRecords.add(
//             mapAppraiserLMSIdToAppraiserId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           setAppraiserToUpdate.add(
//             mapAppraiserLMSIdToAppraiserId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           // Updated By Anup: If error message length is more then 255.
//           String errorMsg = objSaveResult.getErrors()[0].getMessage();
//           errorMsg = errorMsg.length() > 255
//             ? errorMsg.substring(0, 254)
//             : errorMsg;
//           //Create an instance for failed Appraiser with status as failed and place error message in description
//           lstAppraiserToUpdate.add(
//             new Appraiser__c(
//               Id = mapAppraiserLMSIdToAppraiserId.get(
//                 lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//               ),
//               Status__c = 'Failed',
//               Error_Description__c = errorMsg
//             )
//           );
//         }
//       }
//       intResultIndex++;
//     }
//     update lstAppraiserToUpdate; //Update Failed Appraiser with Message
//   }
//   /*End - Method createAppraiser to create Account based on the information from Loan and Appraiser Temporary Object*/

//   /*Start - Method createBroker to create Account and Contact based on the information from Loan and Broker Temporary Object*/
//   private void createBroker(Set<String> setLMSIdinBroker) {
//     List<Account> lstAccountToInsert = new List<Account>();
//     List<Broker__c> lstBrokerToUpdate = new List<Broker__c>();

//     Map<String, String> mapBrokerLMSIdToBrokerId = new Map<String, String>(); //To Get Broker ID when processing fails
//     Map<String, String> mapAccountLMSIdToAccountId = new Map<String, String>();

//     Set<String> setBrokerToUpdate = new Set<String>();

//     //Iterate over Brokers based on LMS Id
//     for (Broker__c objBroker : [
//       SELECT
//         Id,
//         Name,
//         Company_Type__c,
//         Email__c,
//         Error_Description__c,
//         LMS_Client_ID__c,
//         PersonFirstName__c,
//         PersonLastName__c,
//         PersonMailingAddress__c,
//         PersonMailingCity__c,
//         PersonMailingPostalCode__c,
//         PersonMailingState__c,
//         Phone__c,
//         RelatedLMSAccount__c,
//         Status__c,
//         Brokerage_Status__c
//       FROM Broker__c
//       WHERE LMS_Client_ID__c IN :setLMSIdinBroker AND Status__c != 'Failed'
//     ]) {
//       mapBrokerLMSIdToBrokerId.put(objBroker.LMS_Client_ID__c, objBroker.Id);
//       if (objBroker.Company_Type__c == 'Broker House') {
//         lstAccountToInsert.add(
//           new Account(
//             RecordTypeId = mapRecordTypeNameToId.get('Brokerage_ctc').Id__c,
//             LMS_Client_ID__c = objBroker.LMS_Client_ID__c,
//             Type = objBroker.Company_Type__c,
//             Name = objBroker.PersonLastName__c,
//             BillingStreet = objBroker.PersonMailingAddress__c,
//             BillingCity = objBroker.PersonMailingCity__c,
//             BillingState = objBroker.PersonMailingState__c,
//             BillingPostalCode = objBroker.PersonMailingPostalCode__c,
//             Phone = objBroker.Phone__c,
//             Email__c = objBroker.Email__c,
//             Source_System__c = 'CTC',
//             Brokerage_Status__c = objBroker.Brokerage_Status__c
//           )
//         );
//       }
//     }
//     // set external id for upsert
//     Schema.SObjectField fieldExternalId = Account.Fields.LMS_Client_ID__c;
//     //Save result of DML
//     Database.UpsertResult[] saveResultList = Database.upsert(
//       lstAccountToInsert,
//       fieldExternalId,
//       false
//     );

//     Integer intResultIndex = 0;
//     //Iterate over list of results
//     for (Database.UpsertResult objSaveResult : saveResultList) {
//       //Check if DML has failed
//       if (!objSaveResult.isSuccess()) {
//         isProcessingError = true;
//         if (
//           !setBrokerToUpdate.contains(
//             mapBrokerLMSIdToBrokerId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           )
//         ) {
//           lstErrorRecords.add(
//             mapBrokerLMSIdToBrokerId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           setBrokerToUpdate.add(
//             mapBrokerLMSIdToBrokerId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           // Updated By Anup: If error message length is more then 255.
//           String errorMsg = objSaveResult.getErrors()[0].getMessage();
//           errorMsg = errorMsg.length() > 255
//             ? errorMsg.substring(0, 254)
//             : errorMsg;
//           //Create an instance for failed Broker with status as failed and place error message in description
//           lstBrokerToUpdate.add(
//             new Broker__c(
//               Id = mapBrokerLMSIdToBrokerId.get(
//                 lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//               ),
//               Status__c = 'Failed',
//               Error_Description__c = errorMsg
//             )
//           );
//         }
//       }
//       intResultIndex++;
//     }
//     update lstBrokerToUpdate; //Update Failed Broker with Message
//     for (Account objAccount : [
//       SELECT Id, LMS_Client_ID__c
//       FROM Account
//       WHERE Type = 'Broker House'
//     ]) {
//       mapAccountLMSIdToAccountId.put(
//         objAccount.LMS_Client_ID__c,
//         objAccount.Id
//       );
//     }

//     createBrokerAgent(mapAccountLMSIdToAccountId, setLMSIdinBroker);
//   }
//   /*End - Method createBroker to create Account and Contact based on the information from Loan and Broker Temporary Object*/

//   /*Start - Method createBrokerAgent to create Contact and associate it to appropriate Broker House*/
//   private void createBrokerAgent(
//     Map<String, String> mapAccountLMSIdToAccountId,
//     Set<String> setLMSIdinBroker
//   ) {
//     List<Contact> lstContactToInsert = new List<Contact>();
//     List<Broker__c> lstBrokerToUpdate = new List<Broker__c>();

//     Map<String, String> mapBrokerLMSIdToBrokerId = new Map<String, String>(); //To Get Broker ID when processing fails

//     Set<String> setBrokerToUpdate = new Set<String>();

//     //Iterate over Brokers based on LMS Id
//     for (Broker__c objBroker : [
//       SELECT
//         Id,
//         Name,
//         Company_Type__c,
//         Email__c,
//         Error_Description__c,
//         LMS_Client_ID__c,
//         PersonFirstName__c,
//         PersonLastName__c,
//         PersonMailingAddress__c,
//         PersonMailingCity__c,
//         PersonMailingPostalCode__c,
//         PersonMailingState__c,
//         Phone__c,
//         RelatedLMSAccount__c,
//         Broker_Licence__c,
//         Broker_Status__c,
//         Broker_SubStatus__c,
//         Custom_Underwriter__c,
//         Status__c
//       FROM Broker__c
//       WHERE LMS_Client_ID__c IN :setLMSIdinBroker AND Status__c != 'Failed'
//     ]) {
//       mapBrokerLMSIdToBrokerId.put(objBroker.LMS_Client_ID__c, objBroker.Id);
//       String brokerRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
//         .get('Broker/Agent_CTC')
//         .getRecordTypeId();

//       if (objBroker.Company_Type__c == 'Broker Agent') {
//         lstContactToInsert.add(
//           new Contact(
//             RecordTypeId = brokerRecId,
//             LMS_CIF__c = objBroker.LMS_Client_ID__c,
//             FirstName = objBroker.PersonFirstName__c,
//             Lastname = objBroker.PersonLastName__c,
//             MailingStreet = objBroker.PersonMailingAddress__c,
//             MailingCity = objBroker.PersonMailingCity__c,
//             MailingState = objBroker.PersonMailingState__c,
//             MailingPostalCode = objBroker.PersonMailingPostalCode__c,
//             Phone = objBroker.Phone__c,
//             Email = objBroker.Email__c,
//             AccountId = mapAccountLMSIdToAccountId.get(
//               objBroker.RelatedLMSAccount__c
//             ),
//             FSCO_License_Number__c = objBroker.Broker_Licence__c,
//             Broker_Status__c = objBroker.Broker_Status__c,
//             Broker_SubStatus__c = objBroker.Broker_SubStatus__c,
//             Custom_Underwriter__c = objBroker.Custom_Underwriter__c,
//             Source_System__c = 'CTC'
//           )
//         );
//       }
//     }
//     // set external id for upsert
//     Schema.SObjectField fieldExternalId = Contact.Fields.LMS_CIF__c;
//     //Save result of DML
//     Database.UpsertResult[] saveResultList = Database.upsert(
//       lstContactToInsert,
//       fieldExternalId,
//       false
//     );

//     Integer intResultIndex = 0;
//     //Iterate over list of results
//     for (Database.UpsertResult objSaveResult : saveResultList) {
//       //Check if DML has failed
//       if (!objSaveResult.isSuccess()) {
//         isProcessingError = true;
//         if (
//           !setBrokerToUpdate.contains(
//             mapBrokerLMSIdToBrokerId.get(
//               lstContactToInsert[intResultIndex].LMS_CIF__c
//             )
//           )
//         ) {
//           lstErrorRecords.add(
//             mapBrokerLMSIdToBrokerId.get(
//               lstContactToInsert[intResultIndex].LMS_CIF__c
//             )
//           );
//           setBrokerToUpdate.add(
//             mapBrokerLMSIdToBrokerId.get(
//               lstContactToInsert[intResultIndex].LMS_CIF__c
//             )
//           );
//           // Updated By Anup: If error message length is more then 255.
//           String errorMsg = objSaveResult.getErrors()[0].getMessage();
//           errorMsg = errorMsg.length() > 255
//             ? errorMsg.substring(0, 254)
//             : errorMsg;
//           //Create an instance for failed Broker with status as failed and place error message in description
//           lstBrokerToUpdate.add(
//             new Broker__c(
//               Id = mapBrokerLMSIdToBrokerId.get(
//                 lstContactToInsert[intResultIndex].LMS_CIF__c
//               ),
//               Status__c = 'Failed',
//               Error_Description__c = errorMsg
//             )
//           );
//         }
//       }
//       intResultIndex++;
//     }
//     update lstBrokerToUpdate; //Update Failed Broker with Message
//   }

//   /*End - Method createBrokerAgent to create Contact and associate it to appropriate Broker House*/

//   /**
//    * @description Method to return map with account MPID as key and account as values. Also, checking if the account MPID is in list of Client MPID's.
//    * @param clientList List of Clients
//    * @return  `Map<String, Account>` Map of Account MPID to Account
//    */
//   private Map<String, Account> getMpidAccountMap(List<Client__c> clientList) {
//     Map<String, Account> mpidAccountMap = new Map<String, Account>();
//     List<String> mpids = new List<String>();
//     for (Client__c objClient : clientList) {
//       mpids.add(objClient.MPID__c);
//     }

//     List<Account> accountList = [
//       SELECT id, MPID__c
//       FROM Account
//       WHERE
//         RecordTypeId = :Account.sObjectType.getDescribe(
//             SObjectDescribeOptions.DEFERRED
//           )
//           .getRecordTypeInfosByDeveloperName()
//           .get('Individual')
//           .getRecordTypeId()
//         AND MPID__c IN :mpids
//     ];
//     for (Account account : accountList) {
//       mpidAccountMap.put(account.MPID__c, account);
//     }
//     return mpidAccountMap;
//   }

//   /**
//    * @description Method to create Loan Of Borrower Custom Object
//    * @param clientList List of Clients
//    */
//   private void createLoanOfBorrower(List<Client__c> clientList) {
//     list<Loan_Of_Borrower__c> lstLoanBorrower = new List<Loan_Of_Borrower__c>();
//     for (Client__c objClient : clientList) {
//       String compositKey = updateClientBasedOnMPID
//         ? objClient.MPID__c
//         : (objClient.PersonFirstName__c +
//             objClient.PersonLastName__c +
//             objClient.PersonBirthDate__c)
//             .toLowerCase();
//       lstLoanBorrower.add(
//         new Loan_Of_Borrower__c(
//           LMS_CIF_Id__c = objClient.LMS_CIF__c,
//           LMS_Client_ID__c = objClient.LMS_Client_ID__c,
//           Account__c = accountIdMap.get(compositKey),
//           CIF_Client_Key__c = objClient.LMS_CIF__c + objClient.LMS_Client_ID__c
//         )
//       );
//     }
//     Schema.SObjectField borrowerfieldExternalId = Loan_Of_Borrower__c.Fields.CIF_Client_Key__c; // Sumit Changes
//     //Save result of DML
//     Database.upsert(lstLoanBorrower, borrowerfieldExternalId, false);
//   }

//   /*Start - Method createClient to create PersonAccount based on the information from Loan and Client Temporary Object*/
//   private void createClientWithFeatureFlagON(Set<String> setClientId) {
//     List<Account> lstAccountToUpdate = new List<Account>();

//     List<Client__c> clientList = [
//       SELECT
//         Id,
//         Name,
//         Email__c,
//         Error_Description__c,
//         LMS_Client_ID__c,
//         PersonFirstName__c,
//         PersonLastName__c,
//         PersonMailingAddress__c,
//         PersonMailingCity__c,
//         PersonMailingPostalCode__c,
//         MPID__c,
//         PersonMailingState__c,
//         Phone__c,
//         Status__c,
//         LMS_CIF__c,
//         PersonBirthDate__c,
//         AML_Code__c,
//         Income_Type__c
//       FROM Client__c
//       WHERE
//         LMS_CIF__c IN :setClientId
//         AND Status__c != 'Failed'
//         AND MPID__c != NULL
//     ];

//     Map<String, Account> mpidAccountMap = getMpidAccountMap(clientList);
//     for (Client__c objClient : clientList) {
//       if (!clientKeySet.contains(objClient.MPID__c)) {
//         mapClientLMSIdToClientId.put(objClient.MPID__c, objClient.Id);
//         clientKeySet.add(objClient.MPID__c);
//       }

//       if (
//         objClient.MPID__c != null &&
//         mpidAccountMap.get(objClient.MPID__c) != null
//       ) {
//         //Create an Account instance based on details from Client
//         lstAccountToUpdate.add(
//           new Account(
//             Id = mpidAccountMap.get(objClient.MPID__c).Id,
//             Income_Type__c = objClient.Income_Type__c,
//             MPID__c = objClient.MPID__c,
//             Primary_Borrower_CTC__c = true,
//             Customer_Source_System__c = 'CTC',
//             AML_Code__c = objClient.AML_Code__c
//           )
//         );
//       }
//     }
//     Map<Id, Account> accountMap = new Map<Id, Account>();
//     accountMap.putAll(lstAccountToUpdate);

//     if (accountMap.size() == 0) {
//       return;
//     }

//     if (featureFlagToResolveDuplicateIdError) {
//       lstAccountToUpdate.clear();
//       lstAccountToUpdate = accountMap.values();
//     }

//     //Save result of DML
//     Database.SaveResult[] updateResultList = Database.update(
//       lstAccountToUpdate,
//       false
//     );

//     for (Database.SaveResult savedMPID : updateResultList) {
//       if (savedMPID.isSuccess()) {
//         accountIdMap.put(
//           lstAccountToUpdate[updateResultList.indexOf(savedMPID)].MPID__c,
//           savedMPID.getId()
//         );
//       }
//     }
//     // create Loan Of Borrower records
//     createLoanOfBorrower(clientList);
//     Integer intResultIndex = 0;
//     if (updateResultList != null) {
//       for (Database.SaveResult objSaveResult : updateResultList) {
//         //Check if DML has failed
//         if (!objSaveResult.isSuccess()) {
//           isProcessingError = true;
//           if (
//             !setClientToUpdate.contains(
//               mapClientLMSIdToClientId.get(
//                 lstAccountToUpdate[intResultIndex].LMS_Client_ID__c
//               )
//             )
//           ) {
//             lstErrorRecords.add(
//               mapClientLMSIdToClientId.get(
//                 lstAccountToUpdate[intResultIndex].LMS_Client_ID__c
//               )
//             );
//             setClientToUpdate.add(
//               mapClientLMSIdToClientId.get(
//                 lstAccountToUpdate[intResultIndex].LMS_Client_ID__c
//               )
//             );

//             String errorMsg = objSaveResult.getErrors()[0].getMessage();
//             errorMsg = errorMsg.length() > 255
//               ? errorMsg.substring(0, 254)
//               : errorMsg;
//             lstClientToUpdate.add(
//               new Client__c(
//                 Id = mapClientLMSIdToClientId.get(
//                   lstAccountToUpdate[intResultIndex].MPID__c
//                 ),
//                 Status__c = 'Failed',
//                 Error_Description__c = errorMsg
//               )
//             );
//           }
//         }
//         intResultIndex++;
//       }
//       update lstClientToUpdate;
//     }
//   }
//   /*End - Method createClient to update PersonAccount based on the information from Loan and Client Temporary Object*/

//   /*Start - Method createClient to create PersonAccount based on the information from Loan and Client Temporary Object*/
//   private void createClient(Set<String> setClientId) {
//     List<Account> lstAccountToInsert = new List<Account>();

//     List<Client__c> clientList = [
//       SELECT
//         Id,
//         Name,
//         Email__c,
//         Error_Description__c,
//         LMS_Client_ID__c,
//         PersonFirstName__c,
//         PersonLastName__c,
//         PersonMailingAddress__c,
//         PersonMailingCity__c,
//         PersonMailingPostalCode__c,
//         MPID__c,
//         PersonMailingState__c,
//         Phone__c,
//         Status__c,
//         LMS_CIF__c,
//         PersonBirthDate__c,
//         AML_Code__c,
//         Income_Type__c
//       FROM Client__c
//       WHERE LMS_CIF__c IN :setClientId AND Status__c != 'Failed'
//     ];

//     //Iterate over Clients based on LMS Id
//     for (Client__c objClient : clientList) {
//       if (
//         !clientKeySet.contains(
//           objClient.PersonFirstName__c +
//             objClient.PersonLastName__c +
//             objClient.PersonBirthDate__c
//         )
//       ) {
//         mapClientLMSIdToClientId.put(
//           objClient.PersonFirstName__c +
//             objClient.PersonLastName__c +
//             objClient.PersonBirthDate__c,
//           objClient.Id
//         );

//         //Create an Account instance based on details from Client
//         lstAccountToInsert.add(
//           new Account(
//             RecordTypeId = mapRecordTypeNameToId.get('Individual').Id__c,
//             FirstName = objClient.PersonFirstName__c,
//             Income_Type__c = objClient.Income_Type__c,
//             LastName = objClient.PersonLastName__c,
//             PersonMailingStreet = objClient.PersonMailingAddress__c,
//             PersonMailingCity = objClient.PersonMailingCity__c,
//             PersonMailingState = objClient.PersonMailingState__c,
//             PersonMailingPostalCode = objClient.PersonMailingPostalCode__c,
//             Phone = objClient.Phone__c,
//             MPID__c = objClient.MPID__c,
//             PersonEmail = objClient.Email__c,
//             Email__c = objClient.Email__c,
//             PersonBirthDate = objClient.PersonBirthDate__c,
//             Primary_Borrower_CTC__c = true,
//             Customer_Source_System__c = 'CTC',
//             Composit_Key__c = objClient.PersonFirstName__c +
//               objClient.PersonLastName__c +
//               objClient.PersonBirthDate__c,
//             Source_System__c = 'CTC',
//             AML_Code__c = objClient.AML_Code__c
//           )
//         );
//         clientKeySet.add(
//           objClient.PersonFirstName__c +
//             objClient.PersonLastName__c +
//             objClient.PersonBirthDate__c
//         );
//       }
//     }
//     // set external id for upsert
//     Schema.SObjectField fieldExternalId = Account.Fields.Composit_Key__c; // Sumit Changes

//     //Save result of DML
//     Database.UpsertResult[] saveResultList = Database.upsert(
//       lstAccountToInsert,
//       fieldExternalId,
//       false
//     );

//     for (Account acc : [
//       SELECT id, Composit_Key__c
//       FROM Account
//       WHERE Composit_Key__c IN :clientKeySet
//     ]) {
//       // Updated By Anup : External Id is case insensitive  so it can match with uppercase string also.
//       // But Map key case sensitive. so we are converting the composit key to lower case.
//       // before getting the value convert key to lower case.
//       if (acc.Composit_Key__c != null) {
//         accountIdMap.put(acc.Composit_Key__c.toLowerCase(), acc.id);
//       }
//     }
//     createLoanOfBorrower(clientList);
//     Integer intResultIndex = 0;
//     //Iterate over list of results
//     for (Database.UpsertResult objSaveResult : saveResultList) {
//       //Check if DML has failed
//       if (!objSaveResult.isSuccess()) {
//         isProcessingError = true;
//         if (
//           !setClientToUpdate.contains(
//             mapClientLMSIdToClientId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           )
//         ) {
//           lstErrorRecords.add(
//             mapClientLMSIdToClientId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           setClientToUpdate.add(
//             mapClientLMSIdToClientId.get(
//               lstAccountToInsert[intResultIndex].LMS_Client_ID__c
//             )
//           );
//           //Create an instance for failed Client with status as failed and place error message in description
//           // Updated By Anup: If error message length is more then 255.
//           String errorMsg = objSaveResult.getErrors()[0].getMessage();
//           errorMsg = errorMsg.length() > 255
//             ? errorMsg.substring(0, 254)
//             : errorMsg;
//           lstClientToUpdate.add(
//             new Client__c(
//               Id = mapClientLMSIdToClientId.get(
//                 lstAccountToInsert[intResultIndex].FirstName +
//                   lstAccountToInsert[intResultIndex].LastName +
//                   lstAccountToInsert[intResultIndex].PersonBirthDate
//               ),
//               Status__c = 'Failed',
//               Error_Description__c = errorMsg
//             )
//           );
//         }
//       }
//       intResultIndex++;
//     }
//     update lstClientToUpdate; //Update Failed Client with Message
//   }
//   /*End - Method createClient to create PersonAccount based on the information from Loan and Client Temporary Object*/

//   /*Start - Method createMortgages to create Rsidential Mortgage records*/
//   private void createMortgages(
//     Set<String> setClientId,
//     Set<String> setAccountExternalId,
//     Set<String> setUsername,
//     Set<String> setLoanId
//   ) {
//     Set<String> failedRLALoanNumbers = new Set<String>();
//     Map<String, String> failedRLALoanNumberToUPID = new Map<String, String>();
//     List<ResidentialLoanApplication> lstMortgagesToInsert = new List<ResidentialLoanApplication>();
//     List<Loan__c> lstLoanToUpdate = new List<Loan__c>();

//     Map<String, Account> mapAccountExternalIdToAccountId = new Map<String, Account>();
//     Map<String, String> mapContactExternalIdToContactId = new Map<String, String>();
//     Map<String, String> mapUserNameToUserId = new Map<String, String>();
//     Map<String, String> mapLoanNumberIdToLoanId = new Map<String, String>(); //To Get Loan ID when processing fails
//     Map<String, Loan_Of_Borrower__c> mapBorrowerNumberIdToLoanId = new Map<String, Loan_Of_Borrower__c>();
//     Set<String> setMortgageToUpdate = new Set<String>();
//     Map<String, Loan__c> lmsLoanNumberToLoanObjMap = new Map<String, Loan__c>();
//     Map<String, String> lmsAppriserNumberToAppriserMap = new Map<String, String>();

//     Set<String> rlaIds = new Set<String>();

//     for (Account objAccount : [
//       SELECT Id, LMS_Client_ID__c, PersonContactId
//       FROM Account
//       WHERE LMS_Client_ID__c IN :setAccountExternalId
//     ]) {
//       mapAccountExternalIdToAccountId.put(
//         objAccount.LMS_Client_ID__c,
//         objAccount
//       );
//     }

//     for (Account objAccount : [
//       SELECT Id, LMS_Client_ID__c, LMS_CIF__c, PersonContactId
//       FROM Account
//       WHERE LMS_CIF__c IN :setAccountExternalId
//     ]) {
//       mapAccountExternalIdToAccountId.put(objAccount.LMS_CIF__c, objAccount);
//     }

//     for (Loan_Of_Borrower__c lB : [
//       SELECT id, Account__c, CIF_Client_Key__c, LMS_CIF_Id__c, LMS_Client_ID__c
//       FROM Loan_Of_Borrower__c
//       WHERE LMS_CIF_Id__c IN :setClientId OR LMS_Client_ID__c IN :setClientId
//     ]) {
//       mapBorrowerNumberIdToLoanId.put(lB.LMS_CIF_Id__c, lB);
//     }

//     for (Contact objContact : [
//       SELECT Id, LMS_CIF__c
//       FROM Contact
//       WHERE LMS_CIF__c IN :setAccountExternalId
//     ]) {
//       mapContactExternalIdToContactId.put(objContact.LMS_CIF__c, objContact.Id);
//     }

//     for (User objUser : [
//       SELECT Id, Name
//       FROM User
//       WHERE Name IN :setUsername AND IsActive = TRUE
//     ]) {
//       mapUserNameToUserId.put(objUser.Name, objUser.Id);
//     }
//     List<String> loanNumberList = new List<String>();
//     for (Loan__c objLoan : [
//       SELECT Id, LMS_Loan_Number__c
//       FROM Loan__c
//       WHERE Id IN :setLoanId
//     ]) {
//       loanNumberList.add(objLoan.LMS_Loan_Number__c);
//     }
//     Map<String, String> rlaLoanNumberMap = new Map<String, String>();
//     for (ResidentialLoanApplication rla : [
//       SELECT Id, LMS_Loan_Number__c, AccountId
//       FROM ResidentialLoanApplication
//       WHERE LMS_Loan_Number__c IN :loanNumberList
//     ]) {
//       rlaLoanNumberMap.put(rla.LMS_Loan_Number__c, rla.AccountId);
//     }
//     for (Loan__c objLoan : [
//       SELECT
//         Id,
//         Name,
//         LMS_CIF__c,
//         Appraisal_Date__c,
//         App_Source__c,
//         Beacon_Score__c,
//         Borrower_Lastname__c,
//         Cancel_Date__c,
//         Commitment_Expiry__c,
//         Commitment_Fee__c,
//         Core_Rate__c,
//         GDS_QualRate__c,
//         Holder__c,
//         Late_Interest__c,
//         LMS_Rate__c,
//         Occupancy_Type__c,
//         Other_Agent__c,
//         Loan_Type__c,
//         Program__c,
//         Province__c,
//         Risk_Code__c,
//         Spread_Rate__c,
//         Sundry_Balance__c,
//         Tax_Balance__c,
//         TDS_QualRate__c,
//         LMS_Loan_Number__c,
//         Property_Address__c,
//         Property_City__c,
//         Property_Value__c,
//         Loan_Amount__c,
//         Term__c,
//         Branch__c,
//         Loan_to_Value_LTV__c,
//         LegacySalesforceID__c,
//         Submitted_Date__c,
//         Commitment_Date__c,
//         Funding_date__c,
//         Maturity_date__c,
//         LMS_Broker_ID__c,
//         LMS_BrokerHouse_ID__c,
//         LMS_Appraiser_ID__c,
//         Purpose__c,
//         Loan_Status__c,
//         Underwriter__c,
//         Mortgage_Officer__c,
//         Funder__c,
//         Sub_Status__c,
//         Anticipated_Funding_Date__c,
//         Credit_Manager__c,
//         MPID__c,
//         Submission_Agent__c,
//         Void_Date__c,
//         LMS_Premium__c,
//         LMS_Discount__c,
//         User_Profile_ID__c
//       FROM Loan__c
//       WHERE Id IN :setLoanId
//     ]) {
//       mapLoanNumberIdToLoanId.put(objLoan.LMS_Loan_Number__c, objLoan.Id);
//       String strBrokerageId = (mapAccountExternalIdToAccountId.containsKey(
//           objLoan.LMS_BrokerHouse_ID__c
//         ))
//         ? String.valueof(
//             mapAccountExternalIdToAccountId.get(objLoan.LMS_BrokerHouse_ID__c)
//               .Id
//           )
//         : null;
//       String strAppraiserId = (mapAccountExternalIdToAccountId.containsKey(
//           objLoan.LMS_Appraiser_ID__c
//         ))
//         ? String.valueof(
//             mapAccountExternalIdToAccountId.get(objLoan.LMS_Appraiser_ID__c).Id
//           )
//         : null;
//       String strBrokerId = (mapContactExternalIdToContactId.containsKey(
//           objLoan.LMS_Broker_ID__c
//         ))
//         ? String.valueof(
//             mapContactExternalIdToContactId.get(objLoan.LMS_Broker_ID__c)
//           )
//         : null;
//       String strBorrowerId = (mapBorrowerNumberIdToLoanId.containsKey(
//           objLoan.LMS_CIF__c
//         ))
//         ? String.valueof(
//             mapBorrowerNumberIdToLoanId.get(objLoan.LMS_CIF__c).Account__c
//           )
//         : null;
//       String strLoanOfBorrowerId = (mapBorrowerNumberIdToLoanId.containsKey(
//           objLoan.LMS_CIF__c
//         ))
//         ? String.valueof(mapBorrowerNumberIdToLoanId.get(objLoan.LMS_CIF__c).id)
//         : null;

//       if (null != strAppraiserId) {
//         lmsAppriserNumberToAppriserMap.put(
//           objLoan.LMS_Appraiser_ID__c,
//           strAppraiserId
//         );
//       }
//       if (strBrokerageId != null) {
//         lmsLoanNumberToLoanObjMap.put(objLoan.LMS_Loan_Number__c, objLoan);
//         ResidentialLoanApplication objResidentialMortgage = new ResidentialLoanApplication();
//         objResidentialMortgage.RecordTypeId = MORTGAGE_RT;
//         objResidentialMortgage.LMS_CIF__c = objLoan.LMS_CIF__c;
//         if (rlaLoanNumberMap.containsKey(objLoan.LMS_Loan_Number__c)) {
//           objResidentialMortgage.accountId = rlaLoanNumberMap.get(
//             objLoan.LMS_Loan_Number__c
//           );
//         } else {
//           objResidentialMortgage.accountId = strBrokerageId;
//         }
//         objResidentialMortgage.MPID__c = objLoan.MPID__c;
//         objResidentialMortgage.LMS_Loan_Number__c = objLoan.LMS_Loan_Number__c;
//         objResidentialMortgage.Loan_Of_Borrower__c = strLoanOfBorrowerId;
//         objResidentialMortgage.Borrower__c = strBorrowerId;
//         objResidentialMortgage.Name = objLoan.LMS_Loan_Number__c;
//         objResidentialMortgage.Borrower_Lastname__c = objLoan.Borrower_Lastname__c;
//         objResidentialMortgage.Cancel_Date__c = objLoan.Cancel_Date__c;
//         objResidentialMortgage.Commitment_Expiry__c = objLoan.Commitment_Expiry__c;
//         objResidentialMortgage.Commitment_Fee__c = objLoan.Commitment_Fee__c;
//         objResidentialMortgage.Core_Rate__c = objLoan.Core_Rate__c;
//         objResidentialMortgage.GDS_QualRate__c = objLoan.GDS_QualRate__c;
//         objResidentialMortgage.LMS_Rate__c = objLoan.LMS_Rate__c;
//         objResidentialMortgage.Other_Agent__c = objLoan.Other_Agent__c;
//         objResidentialMortgage.Program__c = objLoan.Program__c;
//         objResidentialMortgage.Risk_Code__c = objLoan.Risk_Code__c;
//         objResidentialMortgage.Branch__c = objLoan.Branch__c;
//         objResidentialMortgage.Spread_Rate__c = objLoan.Spread_Rate__c;
//         objResidentialMortgage.TDS_QualRate__c = objloan.TDS_QualRate__c;
//         objResidentialMortgage.Loan_Amount__c = objLoan.Loan_Amount__c;
//         objResidentialMortgage.Submitted_Date__c = objLoan.Submitted_Date__c;
//         objResidentialMortgage.Commitment_Date__c = objLoan.Commitment_Date__c;
//         objResidentialMortgage.Funding_date__c = objLoan.Funding_date__c;
//         objResidentialMortgage.Maturity_date__c = objLoan.Maturity_date__c;
//         objResidentialMortgage.AppSource__c = objLoan.App_Source__c;
//         objResidentialMortgage.Property_Value__c = objLoan.Property_Value__c;
//         objResidentialMortgage.Void_Date__c = objLoan.Void_Date__c;
//         objResidentialMortgage.Submission_Agent__c = objLoan.Submission_Agent__c;
//         objResidentialMortgage.LMS_Premium__c = objLoan.LMS_Premium__c;
//         objResidentialMortgage.LMS_Discount__c = objLoan.LMS_Discount__c;
//         objResidentialMortgage.Sundry_Balance__c = objLoan.Sundry_Balance__c;
//         objResidentialMortgage.Tax_Balance__c = objLoan.Tax_Balance__c;
//         objResidentialMortgage.Broker__c = strBrokerId;
//         objResidentialMortgage.Brokerage__c = strBrokerageId;
//         objResidentialMortgage.Purpose__c = objLoan.Purpose__c;
//         objResidentialMortgage.Loan_Status__c = objLoan.Loan_Status__c;
//         objResidentialMortgage.Loan_Type__c = objLoan.Loan_Type__c;
//         objResidentialMortgage.User_Profile_ID__c = objLoan.User_Profile_ID__c;
//         objResidentialMortgage.Mortgage_Officer__c = mapUserNameToUserId.containsKey(
//             objLoan.Mortgage_Officer__c
//           )
//           ? mapUserNameToUserId.get(objLoan.Mortgage_Officer__c)
//           : null;
//         Logger.info(
//           'Residential Loan Application that will be updated: ',
//           objResidentialMortgage
//         );
//         objResidentialMortgage.Funder__c = mapUserNameToUserId.containsKey(
//             objLoan.Funder__c
//           )
//           ? mapUserNameToUserId.get(objLoan.Funder__c)
//           : null;
//         objResidentialMortgage.Credit_Manager__c = mapUserNameToUserId.containsKey(
//             objLoan.Credit_Manager__c
//           )
//           ? mapUserNameToUserId.get(objLoan.Credit_Manager__c)
//           : null;
//         objResidentialMortgage.Sub_Status__c = objLoan.Sub_Status__c;
//         objResidentialMortgage.Anticipated_Funding_Date__c = objLoan.Anticipated_Funding_Date__c;
//         objResidentialMortgage.Term__c = objLoan.Term__c; //TICKET: QFSCU-1394 Create Fields - DESC: Added Term__c Field back as per the pre-prod

//         if (
//           mapUserNameToUserId.containsKey(objLoan.Underwriter__c) &&
//           (!String.isEmpty(mapUserNameToUserId.get(objLoan.Underwriter__c)))
//         ) {
//           objResidentialMortgage.OwnerId = mapUserNameToUserId.get(
//             objLoan.Underwriter__c
//           );
//           objResidentialMortgage.Underwriter__c = mapUserNameToUserId.get(
//             objLoan.Underwriter__c
//           );
//         } else {
//           objResidentialMortgage.Underwriter__c = userinfo.getUserId();
//         }
//         lstMortgagesToInsert.add(objResidentialMortgage);
//       }
//     }
//     // set external id for upsert
//     Schema.SObjectField fieldExternalId = ResidentialLoanApplication.Fields.LMS_Loan_Number__c;
//     //Save result of DML
//     Database.UpsertResult[] saveResultList = Database.upsert(
//       lstMortgagesToInsert,
//       fieldExternalId,
//       false
//     );
//     Logger.info(
//       'Number of RLAs that are Inserted/Updated: ' + lstMortgagesToInsert.size()
//     );
//     Integer intResultIndex = 0;
//     //Iterate over list of results
//     for (Database.UpsertResult objSaveResult : saveResultList) {
//       //Check if DML has failed
//       if (!objSaveResult.isSuccess()) {
//         isProcessingError = true;
//         if (
//           !setMortgageToUpdate.contains(
//             mapLoanNumberIdToLoanId.get(
//               lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c
//             )
//           )
//         ) {
//           failedRLALoanNumbers.add(
//             lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c
//           );
//           failedRLALoanNumberToUPID.put(
//             lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c,
//             lstMortgagesToInsert[intResultIndex].User_Profile_ID__c
//           );
//           lstErrorRecords.add(
//             mapLoanNumberIdToLoanId.get(
//               lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c
//             )
//           );
//           setMortgageToUpdate.add(
//             mapLoanNumberIdToLoanId.get(
//               lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c
//             )
//           );
//           //Create an instance for failed Client with status as failed and place error message in description
//           // Updated By Anup: If error message length is more then 255.
//           String errorMsg = objSaveResult.getErrors()[0].getMessage();
//           errorMsg = errorMsg.length() > 255
//             ? errorMsg.substring(0, 254)
//             : errorMsg;
//           //ErrorD = ErrorD.substring(0,254);
//           lstLoanToUpdate.add(
//             new Loan__c(
//               Id = mapLoanNumberIdToLoanId.get(
//                 lstMortgagesToInsert[intResultIndex].LMS_Loan_Number__c
//               ),
//               Status__c = 'Failed',
//               Error_Description__c = errorMsg
//             )
//           );
//         }
//       } else {
//         rlaIds.add(objSaveResult.getId());
//       }
//       intResultIndex++;
//     }
//     update lstLoanToUpdate; //Update Failed Mortgage with Messages
//     // check if failedRLALoanNumbers size is > 0, throw the exception
//     if (
//       failedRLALoanNumbers.size() > 0 &&
//       isEnableCapturingExceptionForCTCRLACreation
//     ) {
//       Logger.info(
//         'FailedRLALoanNumber: ' +
//           failedRLALoanNumberToUPID.keySet() +
//           'FailedRLAUserProfileID: ' +
//           failedRLALoanNumberToUPID.values()
//       );
//       throw new CreateCTCMortgageException(failedRLALoanNumbers);
//     }
//     if (rlaIds?.size() > 0) {
//       createRLARelatedChildRecords(
//         rlaIds,
//         lmsLoanNumberToLoanObjMap,
//         lmsAppriserNumberToAppriserMap
//       );
//       upsertFARecords(rlaIds);
//     }
//   }
//   /*End - Method createMortgages to create Rsidential Mortgage records*/

//   /*Start - Method createRLARelatedChildRecords to create RLArelatedchild records*/
//   /**
//    * @description Method createRLARelatedChildRecords to create RLArelatedchild records
//    * @param rlaIds
//    * @param lmsLoanNumberToLoanObjMap
//    * @param lmsAppriserNumberToAppriserMap
//    */
//   @SuppressWarnings('PMD.NcssMethodCount')
//   public static void createRLARelatedChildRecords(
//     Set<String> rlaIds,
//     Map<String, Loan__c> lmsLoanNumberToLoanObjMap,
//     Map<String, String> lmsAppriserNumberToAppriserMap
//   ) {
//     List<LoanApplicant> insertloanAppRecords = new List<LoanApplicant>();
//     List<LoanApplicationProperty> insertloanPRecords = new List<LoanApplicationProperty>();

//     List<ResidentialLoanApplication> insertedRLAs = [
//       SELECT
//         Id,
//         Name,
//         Broker__c,
//         LMS_Loan_Number__c,
//         Loan_Amount__c,
//         Borrower__c,
//         Borrower__r.Income_Type__c,
//         Borrower__r.Email__c
//       FROM ResidentialLoanApplication
//       WHERE Id IN :rlaIds
//     ];

//     List<Id> rlappIds = new List<Id>();
//     for (ResidentialLoanApplication rla : insertedRLAs) {
//       rlappIds.add(rla.Id);
//     }

//     /*GET All EXisting Properties*/
//     List<LoanApplicationProperty> properties = [
//       SELECT id, LoanApplicationId, name
//       FROM LoanApplicationProperty
//       WHERE LoanApplicationId IN :rlappIds
//       ORDER BY LoanApplicationId
//     ];

//     Map<Id, List<LoanApplicationProperty>> rlaTolap = new Map<Id, List<LoanApplicationProperty>>();
//     Map<Id, List<String>> rlaTolapNames = new Map<Id, List<String>>();

//     for (LoanApplicationProperty lap : properties) {
//       if (rlaTolap.get(lap.LoanApplicationId) == null) {
//         List<LoanApplicationProperty> laps = new List<LoanApplicationProperty>();
//         List<String> rlaNames = new List<String>();
//         laps.add(lap);
//         rlaTolap.put(lap.LoanApplicationId, laps);
//         rlaNames.add(lap.name);

//         rlaTolapNames.put(lap.LoanApplicationId, rlaNames);
//       } else {
//         rlaTolap.get(lap.LoanApplicationId).add(lap);
//         rlaTolapNames.get(lap.LoanApplicationId).add(lap.name);
//       }
//     }

//     /*GET All EXisting Properties - FINISH*/

//     /*GET All EXisting Applicants*/
//     List<LoanApplicant> applicants = [
//       SELECT id, LoanApplicationId, name
//       FROM LoanApplicant
//       WHERE LoanApplicationId IN :rlappIds
//       ORDER BY LoanApplicationId
//     ];
//     Map<Id, List<LoanApplicant>> rlaToApplicants = new Map<Id, List<LoanApplicant>>();
//     Map<Id, List<String>> rlaToApplicantNames = new Map<Id, List<String>>();

//     for (LoanApplicant applicant : applicants) {
//       if (rlaToApplicants.get(applicant.LoanApplicationId) == null) {
//         List<LoanApplicant> loanApplicants = new List<LoanApplicant>();
//         loanApplicants.add(applicant);
//         rlaToApplicants.put(applicant.LoanApplicationId, loanApplicants);

//         List<String> rlaNames = new List<String>();
//         rlaNames.add(applicant.name);
//         rlaToApplicantNames.put(applicant.LoanApplicationId, rlaNames);
//       } else {
//         rlaToApplicants.get(applicant.LoanApplicationId).add(applicant);
//         rlaToApplicantNames.get(applicant.LoanApplicationId)
//           .add(applicant.name);
//       }
//     }
//     /*GET All EXisting Applicants FINISH*/

//     for (ResidentialLoanApplication rla : insertedRLAs) {
//       if (
//         null != rlaTolapNames.get(rla.Id) &&
//         rlaTolapNames.get(rla.Id).contains(rla.Name) &&
//         null != rlaTolap.get(rla.Id)
//       ) {
//         List<LoanApplicationProperty> laps = rlaTolap.get(rla.Id);
//         for (LoanApplicationProperty lap : laps) {
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.Property_Address__c = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Property_Address__c;
//             lap.PropertyStreet = lap.Property_Address__c;
//             lap.PropertyState = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Province__c;
//           }
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.PropertyCity = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Property_City__c;
//           }
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.Property_Value__c = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Property_Value__c;
//           }
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.PropertyUseType = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Occupancy_Type__c;
//           }
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.Appraisal_Date__c = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Appraisal_Date__c;
//           }
//           if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//             lap.RequestedLoanAmount = lmsLoanNumberToLoanObjMap.get(
//                 rla.LMS_Loan_Number__c
//               )
//               .Loan_Amount__c;
//           }
//           if (
//             null !=
//             lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)
//               .LMS_Appraiser_ID__c
//           ) {
//             lap.Appraisal_Firm__c = lmsAppriserNumberToAppriserMap.get(
//               lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)
//                 .LMS_Appraiser_ID__c
//             );
//           }
//         }

//         insertloanPRecords.addAll(rlaTolap.get(rla.Id));
//       } else {
//         LoanApplicationProperty loanP = new LoanApplicationProperty();
//         loanP.Name = rla.Name;
//         loanP.LoanApplicationId = rla.Id;

//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanP.Property_Address__c = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Property_Address__c;
//           loanP.PropertyStreet = loanP.Property_Address__c;
//           loanP.PropertyState = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Province__c;
//         }
//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanP.PropertyCity = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Property_City__c;
//         }

//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanp.Property_Value__c = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Property_Value__c;
//         }
//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanp.PropertyUseType = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Occupancy_Type__c;
//         }
//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanp.Appraisal_Date__c = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Appraisal_Date__c;
//         }
//         if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//           loanp.RequestedLoanAmount = lmsLoanNumberToLoanObjMap.get(
//               rla.LMS_Loan_Number__c
//             )
//             .Loan_Amount__c;
//         }
//         if (
//           null !=
//           lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)
//             .LMS_Appraiser_ID__c
//         ) {
//           loanp.Appraisal_Firm__c = lmsAppriserNumberToAppriserMap.get(
//             lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)
//               .LMS_Appraiser_ID__c
//           );
//         }

//         insertloanPRecords.add(loanp);
//       }

//       if (
//         null != rlaToApplicantNames.get(rla.Id) &&
//         rlaToApplicantNames.get(rla.Id).contains(rla.Name)
//       ) {
//         List<LoanApplicant> applicantCustomers = rlaToApplicants.get(rla.Id);

//         if (null != applicantCustomers) {
//           for (LoanApplicant lapp : applicantCustomers) {
//             if (null != rla.Borrower__c) {
//               lapp.Income_Type_Description__c = rla.Borrower__r.Income_Type__c;
//               lapp.Email_Address__c = rla.Borrower__r.Email__c;
//             }

//             if (null != lmsLoanNumberToLoanObjMap.get(rla.LMS_Loan_Number__c)) {
//               lapp.Beacon_Score__c = lmsLoanNumberToLoanObjMap.get(
//                   rla.LMS_Loan_Number__c
//                 )
//                 .Beacon_Score__c;
//             }
//           }
//           insertloanAppRecords.addAll(rlaToApplicants.get(rla.Id));
//         }
//       } else {
//         LoanApplicant loanApp = new LoanApplicant();
//         loanApp.Name = rla.Name;
//         loanApp.LoanApplicationId = rla.Id;
//         loanApp.BorrowerType = 'Borrower';
//         loanApp.ContactId = rla.Broker__c;
//         if (null != rla.Borrower__c) {
//           loanApp.Income_Type_Description__c = rla.Borrower__r.Income_Type__c;
//           loanApp.Email_Address__c = rla.Borrower__r.Email__c;
//         }

//         loanApp.Beacon_Score__c = lmsLoanNumberToLoanObjMap.get(
//             rla.LMS_Loan_Number__c
//           )
//           .Beacon_Score__c;
//         insertloanAppRecords.add(loanApp);
//       }
//     }
//     Database.upsert(insertloanPRecords, false);

//     Database.upsert(insertloanAppRecords, false);
//   }
//   //method to create FA records
//   /**
//    * @description method to create FA records
//    * @param rlaIds
//    */
//   public static void upsertFARecords(Set<String> rlaIds) {
//     List<FinServ__FinancialAccount__c> insertFARecords = new List<FinServ__FinancialAccount__c>();
//     List<FinServ__FinancialAccountRole__c> insertFinAccRoleRecords = new List<FinServ__FinancialAccountRole__c>();
//     Map<String, FinServ__FinancialAccountRole__c> faWithFARs = new Map<String, FinServ__FinancialAccountRole__c>();

//     List<recordtype> faRecordType = [
//       SELECT id, name, SobjectType
//       FROM recordtype
//       WHERE name = 'Mortgage' AND SobjectType = 'FinServ__FinancialAccount__c'
//     ];

//     Map<Id, List<Case>> caseByRLA = new Map<Id, List<Case>>();
//     List<Case> lstOfCasesToUpdate = new List<Case>();

//     for (Case checkOpenCase : [
//       SELECT Id, Subject, Status, Mortgages__c
//       FROM Case
//       WHERE Status = 'Open' AND Mortgages__c = :rlaIds
//     ]) {
//       if (!caseByRLA.containsKey(checkOpenCase.Mortgages__c)) {
//         caseByRLA.put(
//           checkOpenCase.Mortgages__c,
//           new List<case>{ checkOpenCase }
//         );
//       } else {
//         caseByRLA.get(checkOpenCase.Mortgages__c).add(checkOpenCase);
//       }
//     }

//     for (ResidentialLoanApplication rla : [
//       SELECT
//         id,
//         Borrower__c,
//         Borrower_Lastname__c,
//         borrower_listView__c,
//         Broker__c,
//         Broker_Broker__c,
//         Broker_Email__c,
//         Broker_First_Name__c,
//         Brokerage__c,
//         Funder__c,
//         Funding_Date__c,
//         LMS_Loan_Number__c,
//         Loan_Amount__c,
//         Loan_Status__c,
//         Maturity_Date__c,
//         Name,
//         Primary_Contact__c,
//         AccountId,
//         MPID__c,
//         LMS_Discount__c,
//         LMS_Premium__c,
//         AppSource__c,
//         Other_Agent__c,
//         Sundry_Balance__c,
//         Submission_Agent__c,
//         Tax_Balance__c,
//         Loan_Type__c,
//         Branch__c,
//         LMS_Rate__c,
//         Risk_Code__c,
//         User_Profile_ID__c,
//         Purpose__c,
//         (SELECT Loan_to_Value_LTV__c FROM LoanApplicationProperties),
//         (
//           SELECT Id, ContactId, BorrowerType
//           FROM LoanApplicants
//           WHERE ContactId != NULL
//         )
//       FROM ResidentialLoanApplication
//       WHERE Id IN :rlaIds
//     ]) {
//       /*
//                                                   TICKET#: QFSCU-1379 LMS Job Fails on UAT- Don't See CTC RLA Created in UAT Org (FB123)
//                                                   DESC:  Replace "funded" with "paid-out" in the code as per the request.
//                                               */
//       if (rla.Loan_Status__c == 'Active' || rla.Loan_Status__c == 'Paid-Out') {
//         FinServ__FinancialAccount__c insertFAs = new FinServ__FinancialAccount__c(
//           Residential_Loan_Application__c = rla.Id,
//           Borrower__c = rla.Borrower__c,
//           RecordTypeId = faRecordType[0].Id,
//           FinServ__FinancialAccountType__c = 'CTC Residential Mortgage',
//           FinServ__PrimaryOwner__c = rla.AccountId,
//           BorrowerName__c = rla.Borrower_Lastname__c,
//           Broker__c = rla.Broker__c,
//           Brokerage__c = rla.Brokerage__c,
//           Funder__c = rla.Funder__c,
//           Funding_Date__c = rla.Funding_Date__c,
//           FinServ__SourceSystemId__c = rla.LMS_Loan_Number__c,
//           LMS_Loan_Number__c = rla.LMS_Loan_Number__c,
//           Branch__c = rla.Branch__c,
//           FinServ__LoanAmount__c = rla.Loan_Amount__c,
//           FinServ__Stage__c = rla.Loan_Status__c,
//           Submission_Agent__c = rla.Submission_Agent__c,
//           LMS_Discount__c = rla.LMS_Discount__c,
//           LMS_Premium__c = rla.LMS_Premium__c,
//           Rate__c = rla.LMS_Rate__c,
//           Risk_Code__c = rla.Risk_Code__c,
//           User_Profile_ID__c = rla.User_Profile_ID__c,
//           Loan_to_Value_LTV__c = rla.LoanApplicationProperties[0]
//             .Loan_to_Value_LTV__c,
//           //MaturityDate__c=rla.Maturity_Date__c,
//           Name = rla.LMS_Loan_Number__c,
//           Purpose__c = rla.Purpose__c,
//           Loan_Type__c = rla.Loan_Type__c
//         );

//         insertFARecords.add(insertFAs);

//         if (rla.LoanApplicants != null && rla.LoanApplicants.size() > 0) {
//           FinServ__FinancialAccountRole__c far = new FinServ__FinancialAccountRole__c();
//           far.FinServ__RelatedContact__c = rla.LoanApplicants[0].ContactId;
//           if (rla.LoanApplicants[0].BorrowerType == 'Borrower') {
//             far.FinServ__Role__c = 'Primary Owner';
//           } else {
//             far.FinServ__Role__c = 'Coapplicant';
//           }
//           far.RecordTypeId = FAR_CONTACT_RT;
//           far.FinServ__Active__c = true;
//           far.FinServ__SourceSystemId__c =
//             rla.LoanApplicants[0].Id + rla.LMS_Loan_Number__c;

//           faWithFARs.put(rla.LMS_Loan_Number__c, far);

//           //Create Financial Account Role for Brokerage
//           FinServ__FinancialAccountRole__c farBrokerage = new FinServ__FinancialAccountRole__c();
//           //farBrokerage.FinServ__RelatedContact__c = rla.LoanApplicants[0].ContactId;
//           farBrokerage.FinServ__RelatedAccount__c = rla.Brokerage__c;
//           farBrokerage.FinServ__Role__c = 'Brokerage';
//           farBrokerage.RecordTypeId = FAR_ACCOUNT_RT;
//           farBrokerage.FinServ__Active__c = true;
//           farBrokerage.FinServ__SourceSystemId__c =
//             rla.LoanApplicants[0].Id + rla.LMS_Loan_Number__c;

//           faWithFARs.put(rla.LMS_Loan_Number__c, farBrokerage);

//           //Create Financial Account Role for Broker
//           FinServ__FinancialAccountRole__c farBroker = new FinServ__FinancialAccountRole__c();
//           farBroker.FinServ__RelatedAccount__c = rla.Broker__c;
//           farBroker.FinServ__Role__c = 'Broker';
//           farBroker.RecordTypeId = FAR_ACCOUNT_RT;
//           farBroker.FinServ__Active__c = true;
//           farBroker.FinServ__SourceSystemId__c =
//             rla.LoanApplicants[0].Id + rla.LMS_Loan_Number__c;

//           faWithFARs.put(rla.LMS_Loan_Number__c, farBroker);
//         }
//       }
//     }

//     Schema.SObjectField fieldExternalId = FinServ__FinancialAccount__c.Fields.FinServ__SourceSystemId__c;

//     Database.upsert(insertFARecords, fieldExternalId, false);

//     List<FinServ__FinancialAccount__c> getFARecords = [
//       SELECT
//         Id,
//         Residential_Loan_Application__c,
//         Residential_Loan_Application__r.Borrower__c,
//         FinServ__PrimaryOwner__c,
//         FinServ__SourceSystemId__c,
//         Broker__c
//       FROM FinServ__FinancialAccount__c
//       WHERE Id IN :insertFARecords
//     ];

//     for (FinServ__FinancialAccount__c fa : getFARecords) {
//       fa.FinServ__PrimaryOwner__c = fa.Residential_Loan_Application__r.Borrower__c;

//       if (
//         faWithFARs != null &&
//         faWithFARs.containsKey(fa.FinServ__SourceSystemId__c)
//       ) {
//         FinServ__FinancialAccountRole__c farToInsert = faWithFARs.get(
//           fa.FinServ__SourceSystemId__c
//         );
//         farToInsert.FinServ__FinancialAccount__c = fa.Id;
//         insertFinAccRoleRecords.add(farToInsert);
//       }
//       if (
//         caseByRLA != null &&
//         caseByRLA.containsKey(fa.Residential_Loan_Application__c)
//       ) {
//         for (
//           Case caseToUpdt : caseByRLA.get(fa.Residential_Loan_Application__c)
//         ) {
//           //  caseToUpdt.FinServ__FinancialAccount__c= fa.Id;
//           lstOfCasesToUpdate.add(caseToUpdt);
//         }
//       }
//     }

//     if (!getFARecords.isEmpty()) {
//       Database.update(getFARecords, false);
//     }

//     if (!lstOfCasesToUpdate.isEmpty()) {
//       Database.Upsert(lstOfCasesToUpdate, false);
//     }
//     Schema.SObjectField farExtrenalField = FinServ__FinancialAccountRole__c.Fields.FinServ__SourceSystemId__c;
//     Database.upsert(insertFinAccRoleRecords, farExtrenalField, false);
//   }

//   /*Start - Method finish to perform operations after the business logic*/
//   /**
//    * @description Method finish to perform operations after the business logic
//    * @param bc
//    */
//   @SuppressWarnings('PMD.OperationWithLimitsInLoop')
//   public void finish(Database.BatchableContext bc) {
//     Set<String> setObjectAPIToDelete = new Set<String>{
//       'Loan__c',
//       'Appraiser__c',
//       'Client__c',
//       'Broker__c'
//     };

//     for (String strObjAPI : setObjectAPIToDelete) {
//       BMSyncBatchToDeleteTempRecords objBatchToDelete = new BMSyncBatchToDeleteTempRecords(
//         'SELECT ID FROM ' + strObjAPI + ' WHERE Status__c !=\'Failed\''
//       );
//       if (!Test.isRunningTest()) {
//         database.executeBatch(objBatchToDelete, 200);
//       }
//     }
//     // call to LMSSyncBrokerDealConditionBatch batch to load Broker conditions
//     Set<ID> dealId = new Set<Id>();
//     LMSSyncBrokerDealConditionBatch batch = new LMSSyncBrokerDealConditionBatch(
//       dealId
//     );
//     Database.executeBatch(batch, 50);
//   }
//   /*End - Method finish to perform operations after the business logic*/
// }

//Class-6 : OnBoardingCaseCommunications_Batch

/* Class Name     : OnBoardingCaseCommunications_Batch.cls
Description       : to update Total Onboarding Case Communications in Account
Developed By      : Raagvitech team
Created On        : 07/06/2021
Last Modified On  : 09/06/2021
*/

// global class OnBoardingCaseCommunications_Batch implements Database.Batchable<sObject>,Schedulable {

//     global Database.QueryLocator start(Database.BatchableContext BC) {

//          String corporationRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporation').getRecordTypeId();

//         return Database.getQueryLocator([SELECT id, AccountId, Casenumber, Total_Case_Communications__c,Type__c
//                                          FROM Case
//                                          WHERE Type__c = 'Onboarding Team'
//                                          AND Account.RecordTypeId =: corporationRTId]);
//     }

//     global void execute(Database.BatchableContext BC, List<Case> scope) {

//         List<Account> updateAcc = new List<Account>();
//         Map<String,List<Case>> listofCasesByAccId = new Map<String,List<Case>>();

//         for(Case cobj : scope){
//             if(listofCasesByAccId.containsKey(cobj.AccountId)){
//                 listofCasesByAccId.get(cobj.AccountId).add(cobj);
//             }else{
//                 listofCasesByAccId.put(cobj.AccountId,new List<Case>{cobj});
//             }
//         }

//         for(Account accObj : [SELECT Id,Name,Total_Onboarding_Case_Communications__c
//                               FROM Account
//                               Where Id IN : listofCasesByAccId.KeySet()]){

//             Decimal totalCaseCommunications = 0;

//             if(listofCasesByAccId.get(accObj.Id) != null)
//             for(Case c : listofCasesByAccId.get(accObj.Id)){
//                 totalCaseCommunications += c.Total_Case_Communications__c;
//             }
//             updateAcc.add(new Account(Id = accObj.Id,Total_Onboarding_Case_Communications__c = totalCaseCommunications));
//         }

//         if(!updateAcc.isEmpty())
//             try{
//                 UPDATE updateAcc;
//             }Catch(DMLException e){System.debug('Exception while updating total onboarding case communications in account : '+e.getMessage());}

//     }

//     global void finish(Database.BatchableContext BC) {

//     }

//     global void execute(SchedulableContext SC) {
//         OnBoardingCaseCommunications_Batch schedulableClass = new OnBoardingCaseCommunications_Batch();
//         Database.executeBatch(schedulableClass);
//     }
// }

// Class-7 : KafkaDocumentCaseCreate
// global class KafkaDocumentCaseCreate implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
//   Map<String, List<String>> mapOfDealNoToDocumentName = new Map<String, List<String>>();
//   Map<String, List<String>> mapOfDealNoToDocumentType = new Map<String, List<String>>();
//   List<CTC_Documents_Kafka__c> lstOfAllKafkaDocuments = new List<CTC_Documents_Kafka__c>();
//   Map<String, List<String>> mapOfDealNoToGeneralConditionsName = new Map<String, List<String>>();
//   List<CTC_Documents_Kafka__c> lstOfAllKafkaToBeUpdated = new List<CTC_Documents_Kafka__c>();
//   Map<String, String> mapOfKafkaIdWithDealId = new Map<String, String>();
//   List<Case> lstOfCasesToBeInserted = new List<Case>();
//   String userName = '';
//   Set<String> setOfUserIds = new Set<String>();

//   global Database.QueryLocator start(Database.BatchableContext BC) {
//     return Database.getQueryLocator(
//       [
//         SELECT Id, Inserted_Doc__c, Processed__c, Status__c
//         FROM CTC_Documents_Kafka__c
//         WHERE Processed__c = FALSE
//       ]
//     );
//   }

//   global void execute(
//     Database.BatchableContext BC,
//     List<CTC_Documents_Kafka__c> kafkaDocumentList
//   ) {
//     List<Broker_Condition_API_Log_History__c> lstOfapiLogHistory = new List<Broker_Condition_API_Log_History__c>();
//     List<String> lstOfConditionIdsInSalesforce = new List<String>();

//     Map<String, List<String>> mapOfDealNoToConditionIdsInSalesforce = new Map<String, List<String>>();
//     Set<String> setOfDealNo = new Set<String>();

//     for (CTC_Documents_Kafka__c kafkaDocument : kafkaDocumentList) {
//       deserializeInsertedDoc insertedDoc = (deserializeInsertedDoc) JSON.deserialize(
//         kafkaDocument.Inserted_Doc__c,
//         deserializeInsertedDoc.class
//       );
//       mapOfKafkaIdWithDealId.put(kafkaDocument.Id, insertedDoc.loanId);
//       setOfDealNo.add(insertedDoc.loanId);
//     }

//     for (Broker_Conditions__c BCObject : [
//       SELECT
//         ID,
//         Condition_Id__c,
//         Broker_Conditions_Name__c,
//         Residential_Mortgage__r.LMS_Loan_Number__c
//       FROM Broker_Conditions__c
//       WHERE Residential_Mortgage__r.LMS_Loan_Number__c IN :setOfDealNo
//     ]) {
//       if (
//         mapOfDealNoToConditionIdsInSalesforce.containsKey(
//           BCObject.Residential_Mortgage__r.LMS_Loan_Number__c
//         )
//       ) {
//         mapOfDealNoToConditionIdsInSalesforce.get(
//             BCObject.Residential_Mortgage__r.LMS_Loan_Number__c
//           )
//           .add(BCObject.Condition_Id__c);
//       } else {
//         mapOfDealNoToConditionIdsInSalesforce.put(
//           BCObject.Residential_Mortgage__r.LMS_Loan_Number__c,
//           new List<String>{ BCObject.Condition_Id__c }
//         );
//       }
//     }

//     for (CTC_Documents_Kafka__c kafkaDocument : kafkaDocumentList) {
//       try {
//         lstOfAllKafkaDocuments.add(kafkaDocument);
//         deserializeInsertedDoc insertedDoc = (deserializeInsertedDoc) JSON.deserialize(
//           kafkaDocument.Inserted_Doc__c,
//           deserializeInsertedDoc.class
//         );

//         userName = insertedDoc.uploadedBy;
//         setOfUserIds.add(insertedDoc.uploadedBy);

//         if (
//           mapOfDealNoToDocumentName.containsKey(insertedDoc.loanId) &&
//           (mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId) ==
//           null ||
//           (!mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId)
//             .contains(insertedDoc.conditionId)))
//         ) {
//           mapOfDealNoToDocumentName.get(insertedDoc.loanId)
//             .add(insertedDoc.fileName);
//         } else if (
//           mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId) ==
//           null ||
//           (!mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId)
//             .contains(insertedDoc.conditionId))
//         ) {
//           mapOfDealNoToDocumentName.put(
//             insertedDoc.loanId,
//             new List<String>{ insertedDoc.fileName }
//           );
//         }

//         if (
//           mapOfDealNoToDocumentType.containsKey(insertedDoc.loanId) &&
//           (mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId) ==
//           null ||
//           (!mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId)
//             .contains(insertedDoc.conditionId)))
//         ) {
//           if (insertedDoc.documentTypeName != null) {
//             mapOfDealNoToDocumentType.get(insertedDoc.loanId)
//               .add(insertedDoc.documentTypeName);
//           }
//         } else if (
//           mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId) ==
//           null ||
//           (!mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId)
//             .contains(insertedDoc.conditionId))
//         ) {
//           if (insertedDoc.documentTypeName != null) {
//             mapOfDealNoToDocumentType.put(
//               insertedDoc.loanId,
//               new List<String>{ insertedDoc.documentTypeName }
//             );
//           }
//         }

//         if (
//           mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId) != null
//         ) {
//           if (
//             !mapOfDealNoToConditionIdsInSalesforce.get(insertedDoc.loanId)
//               .contains(insertedDoc.conditionId)
//           ) {
//             mapOfDealNoToGeneralConditionsName.put(
//               insertedDoc.loanId,
//               new List<String>{ 'General condition' }
//             );
//           }
//         } else {
//           mapOfDealNoToGeneralConditionsName.put(
//             insertedDoc.loanId,
//             new List<String>{ 'General condition' }
//           );
//         }
//       } catch (Exception e) {
//         Broker_Condition_API_Log_History__c apiLogHistory = new Broker_Condition_API_Log_History__c(
//           Status__c = 'Failure',
//           Error_Description_c__c = e.getMessage()
//         );
//         lstOfapiLogHistory.add(apiLogHistory);
//       }
//     }

//     if (lstOfapiLogHistory.size() > 0) {
//       Database.insert(lstOfapiLogHistory, false);
//     }
//   }

//   global void finish(Database.BatchableContext BC) {
//     List<Case> lstOfCasesToBeInserted = new List<Case>();
//     List<Case> caseErrorList = new List<Case>(); //this list contains the failed case details
//     List<String> listOfEmail;
//     Set<Id> ownerIdOfFailedCase = new Set<Id>();
//     Map<Id, List<String>> mapOfOwnerEmails = new Map<Id, List<String>>(); //used to store the case Owner(MO/UW) email
//     Map<Id, String> mapOfDealNumber = new Map<Id, String>(); //Used to store the Deal Number this will be used in the Subject
//     Map<Id, String> mapOfCaseOwnerName = new Map<Id, String>(); //Used to store the name of UW/MO this will be used in Email Body
//     Id recordTypeId;
//     for (RecordType typeId : [
//       SELECT Id, Name, Description
//       FROM RecordType
//       WHERE Name = :label.KafkaCaseRecordType
//     ]) {
//       recordTypeId = typeId.Id;
//     }

//     Map<Id, String> mapOfUserIdWithUserName = new Map<Id, String>();
//     for (User userObj : [
//       SELECT Id, Name
//       FROM User
//       WHERE Id IN :setOfUserIds
//     ]) {
//       mapOfUserIdWithUserName.put(userObj.Id, userObj.Name);
//     }

//     for (ResidentialLoanApplication RMObject : [
//       SELECT
//         ID,
//         LMS_Loan_Number__c,
//         Mortgage_Officer__c,
//         Broker__c,
//         Underwriter__c,
//         Broker__r.Broker_User__r.Id
//       FROM ResidentialLoanApplication
//       WHERE LMS_Loan_Number__c IN :mapOfDealNoToDocumentName.keySet()
//     ]) {
//       mapOfDealNumber.put(RMObject.Id, RMObject.LMS_Loan_Number__c);

//       String conditionName = '';
//       String documentName = '';
//       String documentType = '';
//       String userId = RMObject.Broker__r.Broker_User__r.Id;
//       if (
//         mapOfDealNoToGeneralConditionsName.get(RMObject.LMS_Loan_Number__c) !=
//         null
//       ) {
//         String generalCond = string.join(
//           mapOfDealNoToGeneralConditionsName.get(RMObject.LMS_Loan_Number__c),
//           ','
//         );
//         String truncgeneralCond = generalCond.substring(
//           0,
//           generalCond.length()
//         );
//         conditionName = truncgeneralCond;

//         if (
//           mapOfDealNoToDocumentName.get(RMObject.LMS_Loan_Number__c) != null
//         ) {
//           documentName = string.join(
//             mapOfDealNoToDocumentName.get(RMObject.LMS_Loan_Number__c),
//             ',' + '\n'
//           );
//         }

//         if (
//           mapOfDealNoToDocumentType.get(RMObject.LMS_Loan_Number__c) != null
//         ) {
//           documentType = string.join(
//             mapOfDealNoToDocumentType.get(RMObject.LMS_Loan_Number__c),
//             ',' + '\n'
//           );
//         }

//         Case caseObj = new Case();
//         caseObj.Source_System__c = 'CTC';
//         caseObj.Status = 'Open';
//         caseObj.Priority = 'Normal';
//         caseObj.Subject = 'Kapti Document Upload';
//         caseObj.RecordTypeId = recordTypeId;
//         caseObj.Description =
//           'Loan number: ' +
//           RMObject.LMS_Loan_Number__c +
//           '\n' +
//           '\n' +
//           'Document name: ' +
//           documentName +
//           '\n' +
//           '\n' +
//           'Document type: ' +
//           documentType +
//           '\n' +
//           '\n' +
//           'Condition name: ' +
//           conditionName +
//           '\n' +
//           '\n' +
//           'Uploaded By: ' +
//           mapOfUserIdWithUserName.get(userId);
//         caseObj.Residential_Mortgage__c = RMObject.ID;
//         caseObj.ContactId = RMObject.Broker__c;
//         caseObj.Department__c = 'Originations';
//         caseObj.CTC_Type__c = 'Documents';
//         if (RMObject.Mortgage_Officer__c != null) {
//           caseObj.OwnerId = RMObject.Mortgage_Officer__c;
//         } else {
//           caseObj.OwnerId = RMObject.Underwriter__c;
//         }
//         lstOfCasesToBeInserted.add(caseObj);
//       }
//     }

//     Set<Id> setOfNewlyCreatedCaseId = new Set<Id>();
//     Set<Id> lstOfProcessedDeals = new Set<Id>();
//     if (lstOfCasesToBeInserted.size() > 0) {
//       Database.SaveResult[] SR;
//       try {
//         SR = Database.insert(lstOfCasesToBeInserted, false);
//         for (Integer i = 0; i < SR.size(); i++) {
//           if (SR[i].isSuccess()) {
//             setOfNewlyCreatedCaseId.add(SR[i].getId());
//           }
//         }
//         for (Case obj : [
//           SELECT Id, Residential_Mortgage__r.Name
//           FROM Case
//           WHERE Id IN :setOfNewlyCreatedCaseId
//         ]) {
//           for (String key : mapOfKafkaIdWithDealId.keySet()) {
//             if (
//               mapOfKafkaIdWithDealId.get(key) ==
//               obj.Residential_Mortgage__r.Name
//             ) {
//               lstOfProcessedDeals.add(key);
//             }
//           }
//         }
//         //
//       } catch (Exception e) {
//         // do nothing
//         System.debug(' Case not created Error >>>>>>>>>>>>>>>> 511' + e);
//       }

//       for (Integer i = 0; i < SR.size(); i++) {
//         if (!SR[i].isSuccess()) {
//           //only look at failures, or NOT Successes
//           caseErrorList.add(lstOfCasesToBeInserted[i]);
//         }
//       }
//     }

//     for (CTC_Documents_Kafka__c kafkaDocument : lstOfAllKafkaDocuments) {
//       if (lstOfProcessedDeals.contains(kafkaDocument.Id)) {
//         kafkaDocument.Processed__c = true;
//         kafkaDocument.Status__c = 'Processed';
//         lstOfAllKafkaToBeUpdated.add(kafkaDocument);
//       }
//     }
//     if (lstOfAllKafkaToBeUpdated.size() > 0) {
//       Database.update(lstOfAllKafkaToBeUpdated, false);
//     }

//     if (caseErrorList.size() > 0) {
//       for (Case faiedCase : caseErrorList) {
//         ownerIdOfFailedCase.add(faiedCase.OwnerId);
//       }

//       for (User u : [
//         SELECT Id, Email, Name
//         FROM User
//         WHERE Id IN :ownerIdOfFailedCase
//       ]) {
//         //ownerIdOfFailedCase

//         listOfEmail = new List<String>();
//         listOfEmail.add(u.Email);
//         mapOfOwnerEmails.put(u.Id, listOfEmail);
//         mapOfCaseOwnerName.put(u.Id, u.Name);
//       }
//       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

//       for (Case caseList : caseErrorList) {
//         if (
//           mapOfCaseOwnerName.get(caseList.OwnerID) != null &&
//           mapOfOwnerEmails.get(caseList.OwnerID) != null
//         ) {
//           mails.add(
//             sendEmailToUWForCaseFailure(
//               mapOfCaseOwnerName.get(caseList.OwnerID),
//               mapOfDealNumber.get(caseList.Residential_Mortgage__c),
//               mapOfOwnerEmails.get(caseList.OwnerID)
//             )
//           );
//         }
//       }
//       if (!mails.isEmpty()) {
//         Messaging.sendEmail(mails);
//       }
//     }
//   }

//   public Messaging.SingleEmailMessage sendEmailToUWForCaseFailure(
//     String caseOwnerId,
//     String dealNumber,
//     List<String> lstOfEmails
//   ) {
//     String htmlBody = 'Hi ' + caseOwnerId + ',' + '<br/><br/>';
//     htmlBody += 'A Document was uploaded under General Conditions on this deal but no Case was created due to a system error. Please Login to  Kapti to see the Document.<br/><br/>Thank You,<br/>The Community Trust team';
//     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
//     mail.setUseSignature(false);
//     mail.setBccSender(false);
//     mail.setSaveAsActivity(false);
//     mail.setToAddresses(lstOfEmails);
//     mail.setSubject('Deal ' + dealNumber);
//     mail.setHtmlBody(htmlBody);
//     mail.setCharset('UTF-8');
//     mail.setOrgWideEmailAddressId(system.label.Broker_OrgWideEmail);
//     return mail;
//   }

//   public class deserializeInsertedDoc {
//     public String loanId { get; set; }
//     public String conditionId { get; set; }
//     public String documentId { get; set; }
//     public String documentTypeId { get; set; }
//     public String documentTypeName { get; set; }
//     public String fileName { get; set; }
//     public String uploadedAt { get; set; }
//     public String uploadedBy { get; set; }
//   }
// }


// Persistent class:
@TestVisible
    private static BRE2Wrapper.propertyDetailsWrapper getApplicationPropertyDetails(Property__c propertyDetails, Opportunity loanApplicationData) {
        BRE2Wrapper.propertyDetailsWrapper applicationPropertyDetails = new BRE2Wrapper.propertyDetailsWrapper();
        applicationPropertyDetails.PROPERTYVALUATION = new List<BRE2Wrapper.propertyDetailsValuationWrapper>();
        System.debug('==11== '+propertyDetails.APF_Property__c);
        if(propertyDetails.Verifications__r.size() > 0 && propertyDetails.APF_Property__c == false) {
            for(Verification__c techVerificationData :propertyDetails.Verifications__r) {
                applicationPropertyDetails.PROPERTYVALUATION.add(getApplicationPropertyValDetails(techVerificationData, propertyDetails));
            }
        }
        
        if(propertyDetails.APF_Property__c == true) {
            applicationPropertyDetails.PROPERTYVALUATION.add(getApplicationPropertyValonPrice(propertyDetails));
        }
        applicationPropertyDetails.PROPERTYSTATE = String.valueOf(propertyDetails.State__c) != null ? propertyDetails.State__c : '';
        applicationPropertyDetails.PROPERTYPINCODE = String.valueOf(propertyDetails.Pin_Code__r) != null ? propertyDetails.Pin_Code__r.Name : '';
        applicationPropertyDetails.PROPERTYGEOLIMITS = String.valueOf(propertyDetails.GeoLimits__c) != null ? propertyDetails.GeoLimits__c : '';
        applicationPropertyDetails.PROPERTYCOUNTRY = String.valueOf(propertyDetails.Pin_Code__r) != null && String.valueOf(propertyDetails.Pin_Code__r.Country_of_Property__c) != null ? propertyDetails.Pin_Code__r.Country_of_Property__c : '';
        applicationPropertyDetails.PROPERTYCITY = String.valueOf(propertyDetails.City__c) != null ? propertyDetails.City__c : '';
         //Start----Added for next line check in Property address by Priya
        String propertyAddress = String.valueOf(propertyDetails.Full_Address__c);
        if(propertyAddress != null){
            propertyAddress = propertyAddress.replaceAll('\n', '');
        }
        applicationPropertyDetails.PROPERTYADDRESS = propertyAddress != null ? propertyAddress : '';
        //applicationPropertyDetails.PROPERTYADDRESS = String.valueOf(propertyDetails.Full_Address__c) != null ? String.valueOf(propertyDetails.Full_Address__c) : '';
        //End ----Added for next line check in Property address by Priya
        return applicationPropertyDetails;
    }
 @TestVisible
    private static BRE2Wrapper.propertyDetailsValuationWrapper getApplicationPropertyValonPrice(Property__c propertyDetails) {
        BRE2Wrapper.propertyDetailsValuationWrapper applicationPropertyValDetails = new BRE2Wrapper.propertyDetailsValuationWrapper();
        // Setting Application Property Valuation Details
        System.debug('==12== '+propertyDetails.APF_Property__c);
        System.debug('==12== '+propertyDetails);
        applicationPropertyValDetails.TECHNICALSTATUS = 'COMPLETED';
        applicationPropertyValDetails.REVIEWDONEFLAG = 'TRUE';
        applicationPropertyValDetails.REPORTRESULT = 'POSITIVE';
        applicationPropertyValDetails.RECENTFLAG = 'TRUE';
        applicationPropertyValDetails.PROPERTYYEAROFCONSTRUCTION = '';
        applicationPropertyValDetails.PROPERTYWITHINMUNICIPALLIMITS = '';
        applicationPropertyValDetails.PROPERTYVALUATIONFLOORWISEAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONCARPETAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONAMT = String.valueOf(propertyDetails.APF_PropertyL__r.Property_Valuation__c) != null ? String.valueOf(propertyDetails.APF_PropertyL__r.Property_Valuation__c) : '';
        applicationPropertyValDetails.PROPERTYVALUATIONAGENCY = 'HHFL';
        applicationPropertyValDetails.PROPERTYTYPE = String.isNotBlank(propertyDetails.Type_of_Property__c) ? String.valueOf(propertyDetails.Type_of_Property__c) : '';
        applicationPropertyValDetails.PROPERTYTOTALFLOORS = '';
        applicationPropertyValDetails.PROPERTYTOTALALLOCATEDPERENTAGE = '';
        applicationPropertyValDetails.PROPERTYSTATUS = String.isNotBlank(propertyDetails.Property_Status__c) ? String.valueOf(propertyDetails.Property_Status__c) : '';
        applicationPropertyValDetails.PROPERTYRENTALSINAREA = '';
        applicationPropertyValDetails.PROPERTYRELATIONSHIPOFOCCUPANTWITHCUSTOMER = '';
        applicationPropertyValDetails.PROPERTYOWNERSHIPTYPE = '';
        applicationPropertyValDetails.PROPERTYMUNICIPALLIMITS = '';
        applicationPropertyValDetails.PROPERTYMUNICIPALCORPORATION = '';
        applicationPropertyValDetails.PROPERTYLOCALITYCLASS = '';
        applicationPropertyValDetails.PROPERTYINCAUTIONAREA = '';
        applicationPropertyValDetails.PROPERTYFLOORVALUED = '';
        applicationPropertyValDetails.PROPERTYEXTIMPROVEMENTAREARATE = '';
        applicationPropertyValDetails.PROPERTYEXTIMPROVEMENTAREA = '';
        applicationPropertyValDetails.PROPERTYCURRENTUSAGEOFPROPERTY = '';
        applicationPropertyValDetails.PROPERTYCONSTRUCTIONSTAGE = '';
        applicationPropertyValDetails.PROPERTYCOMPLETIONPERENTAGE = '';
        
        return applicationPropertyValDetails;
    }
    
    
    @TestVisible
    private static BRE2Wrapper.propertyDetailsValuationWrapper getApplicationPropertyValDetails(Verification__c techVerificationData, Property__c propertyDetails) {
        BRE2Wrapper.propertyDetailsValuationWrapper applicationPropertyValDetails = new BRE2Wrapper.propertyDetailsValuationWrapper();
        // Setting Application Property Valuation Details
        if(techVerificationData.Final_Status__c == 'Waived off' || techVerificationData.Final_Status__c == 'Waived Off - Swim Lane') {
            applicationPropertyValDetails.TECHNICALSTATUS = 'COMPLETED';
            applicationPropertyValDetails.REVIEWDONEFLAG = 'TRUE';
            applicationPropertyValDetails.REPORTRESULT = 'POSITIVE';
            applicationPropertyValDetails.PROPERTYVALUATIONAMT = String.valueOf(propertyDetails.Purchase_price_of_property__c) != null ? String.valueOf(propertyDetails.Purchase_price_of_property__c) : '';
        } else{
            applicationPropertyValDetails.TECHNICALSTATUS = String.isNotBlank(techVerificationData.Final_Status__c) ? getVerificationStatusValue(String.valueOf(techVerificationData.Final_Status__c),'V') : '';
            applicationPropertyValDetails.REVIEWDONEFLAG = techVerificationData.Manager_Reviewed__c ? 'TRUE' : 'FALSE';
            applicationPropertyValDetails.REPORTRESULT = String.isNotBlank(techVerificationData.Final_Status__c) ? getVerificationStatusValue(String.valueOf(techVerificationData.Final_Status__c),'R') : '';
            applicationPropertyValDetails.PROPERTYVALUATIONAMT = String.valueOf(techVerificationData.Final_Property_Valuation__c) != null ? String.valueOf(techVerificationData.Final_Property_Valuation__c) : '';
        }
        
        applicationPropertyValDetails.RECENTFLAG = 'TRUE';
        applicationPropertyValDetails.PROPERTYYEAROFCONSTRUCTION = '';
        applicationPropertyValDetails.PROPERTYWITHINMUNICIPALLIMITS = String.isNotBlank(techVerificationData.Property_within_municipal_limits__c) ? String.valueOf(techVerificationData.Property_within_municipal_limits__c) : '';
        applicationPropertyValDetails.PROPERTYVALUATIONFLOORWISEAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONCARPETAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONAREA = '';
        applicationPropertyValDetails.PROPERTYVALUATIONAGENCY = String.isNotBlank(techVerificationData.Agency__c) ? String.valueOf(techVerificationData.Agency__c) : '';
        applicationPropertyValDetails.PROPERTYTYPE = String.isNotBlank(techVerificationData.Type_of_Property__c) ? String.valueOf(techVerificationData.Type_of_Property__c) : '';
        applicationPropertyValDetails.PROPERTYTOTALFLOORS = '';
        applicationPropertyValDetails.PROPERTYTOTALALLOCATEDPERENTAGE = '';
        applicationPropertyValDetails.PROPERTYSTATUS = String.isNotBlank(techVerificationData.Property_Status__c) ? String.valueOf(techVerificationData.Property_Status__c) : '';
        applicationPropertyValDetails.PROPERTYRENTALSINAREA = '';
        applicationPropertyValDetails.PROPERTYRELATIONSHIPOFOCCUPANTWITHCUSTOMER = '';
        applicationPropertyValDetails.PROPERTYOWNERSHIPTYPE = String.isNotBlank(techVerificationData.Ownership_type__c) ? String.valueOf(techVerificationData.Ownership_type__c) : '';
        applicationPropertyValDetails.PROPERTYMUNICIPALLIMITS = '';
        applicationPropertyValDetails.PROPERTYMUNICIPALCORPORATION = String.isNotBlank(techVerificationData.Name_of_Municipal_Corporation__c) ? String.valueOf(techVerificationData.Name_of_Municipal_Corporation__c) : '';
        applicationPropertyValDetails.PROPERTYLOCALITYCLASS = String.isNotBlank(techVerificationData.Locality_Class__c) ? String.valueOf(techVerificationData.Locality_Class__c) : '';
        applicationPropertyValDetails.PROPERTYINCAUTIONAREA = '';
        applicationPropertyValDetails.PROPERTYFLOORVALUED = '';
        applicationPropertyValDetails.PROPERTYEXTIMPROVEMENTAREARATE = '';
        applicationPropertyValDetails.PROPERTYEXTIMPROVEMENTAREA = '';
        //Start -------- Changes for PRODI-1678 by Priya--------------------------------------------------------------
        String currentUsageOfProperty = String.valueOf(techVerificationData.Current_Usage_of_Property__c);
        if(currentUsageOfProperty != null){
            currentUsageOfProperty = currentUsageOfProperty.replaceAll('\r', '');
            currentUsageOfProperty = currentUsageOfProperty.replaceAll('\n', '');
        }
        //applicationPropertyValDetails.PROPERTYCURRENTUSAGEOFPROPERTY = String.isNotBlank(techVerificationData.Current_Usage_of_Property__c) ? String.valueOf(techVerificationData.Current_Usage_of_Property__c) : '';
        applicationPropertyValDetails.PROPERTYCURRENTUSAGEOFPROPERTY = currentUsageOfProperty != null ? currentUsageOfProperty : '';
        //End -------- Changes for PRODI-1678 by Priya -----------------------------------------------------------------
        applicationPropertyValDetails.PROPERTYCONSTRUCTIONSTAGE = '';
        applicationPropertyValDetails.PROPERTYCOMPLETIONPERENTAGE = '';
        
        return applicationPropertyValDetails;
    }