// import { LightningElement, wire, track } from 'lwc';
// import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
// import USER_ID from '@salesforce/user/Id';
// import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
// import RICH_TEXT_FIELD from '@salesforce/schema/User.Rich_Text_Field__c';
// import basePath from "@salesforce/community/basePath";

// export default class MyProfileInExpSite extends LightningElement {
   
//     get logoutLink() {
//         const sitePrefix = basePath.replace("/", "");
//         return `/${sitePrefix}vforcesite/secur/logout.jsp`;
//     }
 
//     @track imgUrl;
// isImgUrl=false;
//     @track userId = USER_ID;
//     @track contactId;
  
//     @wire(getRecord, { recordId: '$userId', fields: [CONTACT_ID_FIELD] })
//     wiredUser({ error, data }) {
//         if (data) {
//             console.log('Raw data:', JSON.stringify(data));
//             this.contactId = getFieldValue(data, CONTACT_ID_FIELD);
//             console.log('Extracted ContactId:', this.contactId);
//             console.log('Field value exists:', !!this.contactId);
//         } else if (error) {
//             console.error('Error details:', JSON.stringify(error));
//             this.contactId = null;
//         }
//     }
//     // Fetch the rich text field from the user's record (or whatever record contains the image URL)
//     connectedCallback() {
//         this.fetchImageUrl();
//     }

//     fetchImageUrl() {
//         // eslint-disable-next-line @lwc/lwc/no-unexpected-wire-adapter-usages
//         getRecord({ recordId: this.contactId, fields: [RICH_TEXT_FIELD] })
//             .then(result => {
//                 // Assuming the image URL is stored in the rich text field
//                 const richTextValue = result.fields.Rich_Text_Field__c.value;
//                 const regex = /<img[^>]+src="([^">]+)"/g;
//                 const matches = regex.exec(richTextValue);
//                 if (matches && matches[1]) {
//                     this.imgUrl = matches[1];  // Extract the image URL from the rich text field
//                     this.isImgUrl=true
//                 }
//             })
//             .catch(error => {
//                 console.error('Error fetching rich text field: ', error);
//             });
//     }

// }

import { LightningElement, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
// import RICH_TEXT_FIELD from '@salesforce/schema/Contact.Upload_Image__c';  
import basePath from "@salesforce/community/basePath";

export default class MyProfileInExpSite extends LightningElement {
    // @track imgUrl;
    // @track isImgUrl = false;
    @track userId = USER_ID;
    @track contactId;
    @track isDropdownOpen = false;

    @wire(getRecord, { recordId: '$userId', fields: [CONTACT_ID_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            console.log('Raw user data:', JSON.stringify(data));
            this.contactId = getFieldValue(data, CONTACT_ID_FIELD);
            console.log('Extracted ContactId:', this.contactId);

          
            // if (this.contactId) {
                
            //     this.fetchImageUrl();
            // }
        } else if (error) {
            console.error('Error fetching User record:', JSON.stringify(error));
            this.contactId = null;
        }
    }

    
    // @wire(getRecord, { recordId: '$contactId', fields: [RICH_TEXT_FIELD] })
    // wiredContact({ error, data }) {
    //     if (data) {
    //         console.log('Raw contact data:', JSON.stringify(data));
    //         const richTextValue = getFieldValue(data, RICH_TEXT_FIELD);

    //         if (richTextValue) {

    //             const regex = /<img[^>]+src="([^">]+)"/g;
    //             const matches = regex.exec(richTextValue);
    //             console.log('Image url: ',matches)
    //             if (matches && matches[1]) {
    //                 this.imgUrl = matches[1]; 
    //                 console.log('Image url fetched: ',this.imgUrl)
    //                 this.isImgUrl = true;  
    //             }
    //         }
    //     } else if (error) {
    //         console.error('Error fetching Contact record:', JSON.stringify(error));
    //         this.isImgUrl = false;  
    //     }
    // }

    toggleDropdown() {
        this.isDropdownOpen = !this.isDropdownOpen;
    }
    // navigateToSettings() {
    //     window.location.href = 'https://raagvitech76-dev-ed.develop.my.site.com/FirstTestSite';
    // }

    // navigateToProfile() {
    //     window.location.href = 'https://raagvitech76-dev-ed.develop.my.site.com/FirstTestSite/my-profile';
    // }
  
    get logoutLink() {
        const sitePrefix = basePath ? basePath.replace("/", "") : ''; 
        return `/${sitePrefix}vforcesite/secur/logout.jsp`;
    }
}
