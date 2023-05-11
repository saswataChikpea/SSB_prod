import { api, LightningElement, track } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Account.Name';
export default class DashboardModal extends LightningElement {
    @track showAccDetail = false
    objectApiName = 'Account'
    @api recordId = '0017F00003bi2tXQAQ'
    nameField = NAME_FIELD;
    inputFields = {}
    showPopup(evt){
        this.showAccDetail = true
    }
    hidePopup(evt){
        this.showAccDetail = false
    }
    accountNameChange(evt){
        console.log(JSON.stringify(evt.detail.value))
        this.inputFields.Name = evt.detail.value
    }
    handleSubmit(event) {
        event.preventDefault();
        const inputFields = event.detail.fields;
    
        if (inputFields) {
            inputFields.forEach(field => {
                console.log('Field is==> ' + field.fieldName);
                console.log('Field is==> ' + field.value);
            });
        }
        //console.log('=================',JSON.stringify(inputFields))
        this.template.querySelector('lightning-record-edit-form').submit(inputFields);
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
}