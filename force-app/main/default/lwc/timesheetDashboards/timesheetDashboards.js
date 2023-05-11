import { api, LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getTimeDetails from '@salesforce/apex/DashboardClsses.getTimeDetails'; // import apexMethodName from '@salesforce/apex/Namespace.Classname.apexMethodReference';    
import { NavigationMixin } from 'lightning/navigation';

export default class TimesheetDashboards extends NavigationMixin(LightningElement) {

    userid = Id;    
    
    @track data = [];
    columns = [
        { label: 'Project', fieldName: 'projectName' },
        { label: 'Phase', fieldName: 'phaseName'},       
        { label: 'Start Date', fieldName: 'ChikPeaSSB__Start_date__c', type: 'date'},
        { label: 'End Date', fieldName: 'ChikPeaSSB__End_Date__c'},
        { label: 'Resource Name', fieldName: 'accName'},
    ];
    

    @wire(getTimeDetails,{UserId: '$userid'}) // @wire(apexMethodName, { apexMethodParams })
    handleRes({data, error}){
        if(data){
            console.log('####', JSON.stringify(data));
            const timesheets = [];
            data.forEach(element => {
                console.log(JSON.stringify(element));
                const el={...element}
                el.accName = el.ChikPeaSSB__Resource_Name__r.Name;
                el.projectName = el.ChikPeaSSB__Project__r.Name;
                el.phaseName = el.ChikPeaSSB__Phase__r.Name;
                timesheets.push(el);
            });
            this.data = timesheets;
            console.log('####----', JSON.stringify(timesheets));
        }else if(error){
            console.error(JSON.stringify(error));
        }  

    }

    // Button Code Start
    clickedButtonLabel = 'null';

    handleClick(event) {
        console.log('----------', JSON.stringify('Inside handleClick'));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/gntportalhome/tsdetails'
            },
        });
        //console.log('----------', JSON.stringify('clickedButtonLabel'));
    }

}