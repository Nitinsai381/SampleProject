import { LightningElement,wire,track } from 'lwc';
import getContactDetails from '@salesforce/apex/ContactsInLwcTask.getContactDetails';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
// import CONTACT_OBJECT from "@salesforce/schema/Contact";
// import Bell_Notifications from "@salesforce/schema/Contact.Bell_Notifications__c";
// import FIRST_NAME_FIELD from "@salesforce/schema/Contact.FirstName";
// import LAST_NAME_FIELD from "@salesforce/schema/Contact.LastName";
// import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
// import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
// import Birthdate_FIELD from "@salesforce/schema/Contact.Birthdate";
// import Department_FIELD from "@salesforce/schema/Contact.Department";
// import CreatedDate_FIELD from "@salesforce/schema/Contact.CreatedDate";
// import Languages_FIELD from "@salesforce/schema/Contact.Languages__c";
// import 	Upload_Image_FIELD from "@salesforce/schema/Contact.Upload_Image__c";

export default class ExpSiteUserDetails extends LightningElement {
    @track userId = USER_ID;
    @track contactId;
    contactDetails;
    @wire(getRecord, { recordId: '$userId', fields: [CONTACT_ID_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            console.log('Raw data:', JSON.stringify(data));
            this.contactId = getFieldValue(data, CONTACT_ID_FIELD);
            console.log('Extracted ContactId:', this.contactId);
            console.log('Field value exists:', !!this.contactId);
        } else if (error) {
            console.error('Error details:', JSON.stringify(error));
            this.contactId = null;
        }
    }


    get hasContactId() {
        return !!this.contactId;
    }
    
    @wire(getContactDetails,{conId :'$contactId'})
        wiredContact({data,error}){
            if(data){
                console.log('contact Id',this.contactId)
                console.log('Data of contact',data)
                this.contactDetails = data[0];
                this.name = this.contactDetails.FirstName + ' '+this.contactDetails.LastName
            }else if(error){
                console.log(error)
            }
        
    }

}
// @wire(getRecord,{recordId: '$contactId', fields: [FIRST_NAME_FIELD,LAST_NAME_FIELD, PHONE_FIELD,EMAIL_FIELD,Birthdate_FIELD,Department_FIELD,CreatedDate_FIELD,Languages_FIELD],}) Contact;
// get name() {
//     return getFieldValue(this.Contact.data, FIRST_NAME_FIELD) +' ' + getFieldValue(this.Contact.data, LAST_NAME_FIELD);
//   }
// get phone() {
//     return getFieldValue(this.Contact.data, PHONE_FIELD);
//   }
// get email() {
//     return getFieldValue(this.Contact.data, EMAIL_FIELD);
//   }
// get birthDate() {
//     return getFieldValue(this.Contact.data, Birthdate_FIELD);
//   }
// get department() {
//     return getFieldValue(this.Contact.data, Department_FIELD);
//   }
// get createdDate() {
//     return getFieldValue(this.Contact.data, CreatedDate_FIELD);
//   }
// get languages() {
//     return getFieldValue(this.Contact.data, Languages_FIELD);
//   }
// get image() {
//     return getFieldValue(this.Contact.data, Upload_Image_FIELD);
//   }