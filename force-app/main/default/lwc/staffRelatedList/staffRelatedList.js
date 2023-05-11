import { LightningElement,wire,track ,api} from 'lwc';
import StaffrelatedRec from '@salesforce/apex/Staffingpagecontroller.StaffrelatedRec';

export default class StaffRelatedList extends LightningElement {
    //@api recordId;
    @track staffrelatedlst

    @wire(StaffrelatedRec, {
       // Staffid: '$recordId'
        
        
    })
    wireddetails({ data, error }) {
        console.log('current data'+data);
        if (data) {
            this.staffrelatedlst = data;
        
                
                
              
        }

    }

    connectedCallback() {
    }
}