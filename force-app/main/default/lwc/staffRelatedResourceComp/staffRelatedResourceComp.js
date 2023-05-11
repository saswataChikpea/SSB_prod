import { LightningElement,api,wire,track } from 'lwc';
import StaffrelatedRec from '@salesforce/apex/Staffingpagecontroller.StaffrelatedRec';

export default class StaffRelatedResourceComp extends LightningElement {
    @api recordId;
    @track Staffrelatedrec;

    @wire(StaffrelatedRec, {
        Staffid: '$recordId'
        
    })
    wireddetailsrec({ data, error }) {
        console.log('data--'+data);
        if (data) {
           this.Staffrelatedrec = data;
                
 
        }

    }
    
    connectedCallback() {
    }
    
}