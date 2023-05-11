import { LightningElement, track,wire,api } from 'lwc';
import getStaffimg from '@salesforce/apex/Staffingpagecontroller.getStaffimg';
import onloadgetStaffimg from '@salesforce/apex/Staffingpagecontroller.onloadgetStaffimg';
import RoleNameList from '@salesforce/apex/Staffingpagecontroller.RoleNameList';
import staffroleuppend from '@salesforce/apex/Staffingpagecontroller.staffroleuppend';
import StaffrelatedRec from '@salesforce/apex/Staffingpagecontroller.StaffrelatedRec';
import StaffPrjCmplt from '@salesforce/apex/Staffingpagecontroller.StaffPrjCmplt';



import delstaff from '@salesforce/apex/Staffingpagecontroller.delstaff';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class Staffing_LWC extends NavigationMixin(LightningElement) {
    //@track Staffid;
    @track Staffrec;
    @api recordId;
    @track staffcurentid;
    @track imageUrl;
    @track currenRecordId;
    @track rolevaluelist;
    @track options = [];
    @track values = [];
    @track Selectedvalue;
    @track Staffrelatedrec;
    @track staffimgid;
    @track editstaff;
    @track StaffPrjCmplted;

 @wire(onloadgetStaffimg, {
        Staffsid: '$recordId'
        
    })
    wireddetails({ data, error }) {
        if (data) {
           this.Staffrec = data;
                console.log('image '+this.Staffrec);
                
                this.imageUrl = '/sfc/servlet.shepherd/document/download/'+ this.Staffrec;
 
        }

    }
     @wire(StaffrelatedRec, {
        Staffid: '$recordId'
        
    })
    wireddetailsrec({ data, error }) {
        console.log('data--'+data);
        if (data) {
           this.Staffrelatedrec = data;
                
 
        }

    }
    @wire(StaffPrjCmplt, {
        Staffid: '$recordId'
        
    })
    wireddetailsrect({ data, error }) {
        console.log('data StaffPrjCmplted--'+data);
        if (data) {
           this.StaffPrjCmplted = data;
                
 
        }

    }
    
    
    connectedCallback() {
    }
    
    @track selecetedrolelist =[];
    onrolevaluechange(event){
       
        this.selecetedrolelist = event.target.value;
        this.values = this.selecetedrolelist;
        console.log('this.selecetedrolelist'+this.selecetedrolelist);
        var selectedfinal = [];
        for (var i = 0; i < this.selecetedrolelist; i++) {
                    
           
            this.selectedfinal.push(i.value);
        }
        console.log('this.selectedfinal'+this.selectedfinal);
        staffroleuppend({
            staffid: this.recordId,
            staffselectedroles: this.selecetedrolelist
        })
        .then(result =>{
        })
    }
    
    handlesucessClick(event){
        const evt = new ShowToastEvent({
            title : 'Staff details updated',
            message: 'Staff details updated Sucessfully',
            variant:"Success"
        });
        this.dispatchEvent(evt);
        window.location.reload();
        
    }
get encryptedToken() {
    //use apex to get
}

get acceptedFormats() {
    return ['.pdf', '.png','.jpg'];
}

handleUploadFinished(event) {
    // Get the list of uploaded files
    
    const uploadedFiles = event.detail.files;
   
    console.log('curreent RECORD id'+this.recordId);

    getStaffimg({
        Staffsid: this.recordId

    })
        .then(result => {
            console.log('result'+result);
            if (result != null) {
                this.Staffrec = result;
                console.log('image detail'+this.Staffrec);
                this.imageUrl = '/sfc/servlet.shepherd/document/download/'+ this.Staffrec;
                const evt = new ShowToastEvent({
                    title : 'Staff Image uploaded',
                    message: 'Staff Image uploaded Sucessfully',
                    variant:"Success"
                });
                this.dispatchEvent(evt);


            }

        })
}
handleClickDel(event){
    console.log('curreent RECORD id'+this.recordId);
    var msg ='Are you sure you want to delete this Staff?';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            console.log('Yes');
            delstaff({
                staffid:this.recordId
            })
            .then(result =>{
                console.log('final result last'+ this.result);
                    const evt = new ShowToastEvent({
            title : 'Staff Deleted',
            message: 'Staff Deleted Sucessfully',
            variant:"Success"
        });
        this.dispatchEvent(evt);
        
// Navigate to the Accounts object's Recent list view.
      this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'ChikPeaSSB__Staffing__c',
        actionName: 'list'
    },
    state: {       
        filterName: 'Recent' 
    }
});          
                
            })
        }

}
@track finalrolelist
@track rolevaluemapped = false;
avoidrolesrecsurvie;
handleEdit(event){
    this.editstaff = true;
   // if(this.rolevaluemapped = false){
        //this.rolevaluemapped = true;
    
    
    console.log('this.editstaff---'+this.editstaff);
    RoleNameList({
        staffid: this.recordId

    }) 
        .then(result => {
            console.log('result'+result);
            if (result != null) {
                //this.finalrolelist = result;
                var items = [];
                for (var i = 0; i < result.length; i++) {
                    
                    var item = {
                        "label": result[i].Name,
                        "value": result[i].Name
                    };
                    items.push(item);
                }
                console.log('avoidrolesrecsurvie'+this.avoidrolesrecsurvie);
                console.log('Array size--'+this.options.length);
                console.log('values'+this.values);
                console.log('this.selecetedrolelist'+this.selecetedrolelist);
                if(this.options.length == 0){
                    this.options.push(...items);
                    this.values.push();
                }
                
                   
                    
                   
                
                
}

        })
    

}
handleCancelDel(event){
    this.editstaff = false;
    

}
}