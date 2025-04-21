// import { LightningElement, wire, track } from 'lwc';
// // import bellNotification from '@salesforce/apex/BellNotifications.bellNotifications';
// import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
// import USER_ID from '@salesforce/user/Id';
// import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
// // import CONTACT_OBJECT from "@salesforce/schema/Contact";
// import Bell_Notifications from "@salesforce/schema/Contact.Bell_Notifications__c";

// export default class BellNotificationsExpSite extends LightningElement {
//     @track newNotification;
//     @track userId = USER_ID;
    
//     @wire(getRecord, { recordId: '$userId', fields: [CONTACT_ID_FIELD] })
//     wiredUser({ error, data }) {
//         if (data) {
//             console.log('Raw data:', JSON.stringify(data));
//             this.contactId = getFieldValue(data, CONTACT_ID_FIELD);
//             console.log('Extracted ContactId:', this.contactId);
//             console.log('Field value exists:', !!this.contactId);
//             this.contactId='003NS00000V5eFtYAJ';
//         } else if (error) {
//             console.error('Error details:', JSON.stringify(error));
//             this.contactId = null;
//         }
//     }

//     get hasContactId() {
//         return !!this.contactId;
//     }

//     // @wire(bellNotification,({id: '$contactId'}))
//     // wiredData({ data, error }) {
//     //     if (data) {
//     //         this.newNotification = data;
//     //         console.log('Bell notification data:', data);
//     //     } else if (error) {
//     //         console.error('Bell notification error:', error);
//     //     }
//     // }
   
//     @wire(getRecord,{recordId: '$contactId', fields: [Bell_Notifications],}) Contact;
//     get bellNotfications() {
//         console.log('Contact Id in bellNotification method',this.Contact.data);
        
//         return getFieldValue(this.Contact.data, Bell_Notifications) +' ' + getFieldValue(this.Contact.data, Bell_Notifications);
//       }

//     handleClick() {
//         console.log('Notification data:', this.bellNotfications);
//         console.log('Current ContactId:', this.contactId);
//     }

//     connectedCallback() {
//         console.log('Component initialized with UserId:', this.userId);
//     }
// }

import { LightningElement, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
import BELL_NOTIFICATIONS from "@salesforce/schema/Contact.Bell_Notifications__c";

export default class BellNotificationsExpSite extends LightningElement {
    @track newNotification;
    @track userId = USER_ID;
    contactId; // Declare contactId variable outside of the wire method
    isDisplay = false;
    
    // Fetch the ContactId based on the UserId
    @wire(getRecord, { recordId: '$userId', fields: [CONTACT_ID_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            console.log('Raw data:', JSON.stringify(data));
            this.contactId = getFieldValue(data, CONTACT_ID_FIELD);
            console.log('Extracted ContactId:', this.contactId);
        } else if (error) {
            console.error('Error details:', JSON.stringify(error));
            this.contactId = null;
        }
    }

    // Getter to check if a ContactId exists
    get hasContactId() {
        return !!this.contactId;
    }

    // Fetch Bell Notifications using the ContactId
    @wire(getRecord, { recordId: '$contactId', fields: [BELL_NOTIFICATIONS] })
    wiredNotification({ data, error }) {
        if (data) {
            // Assuming Bell_Notifications is a text field or you need some logic to handle it properly
            this.newNotification = getFieldValue(data, BELL_NOTIFICATIONS);
            console.log('Bell notification data:', this.newNotification);
        } else if (error) {         
            console.error('Error fetching Bell Notifications:', error);
        }
    }

    // Method to handle notification click
    handleClick() {
        this.isDisplay = !this.isDisplay
        console.log('isDisplay notification : ',this.isDisplay);
        
        console.log('Notification data:', this.newNotification);
        console.log('Current ContactId:', this.contactId);
    }

    // Lifecycle hook to log the component initialization
    connectedCallback() {
        console.log('Component initialized with UserId:', this.userId);
    }
}
