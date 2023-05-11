import { LightningElement, track, wire } from 'lwc';
import getJiraClouldIdLWC from '@salesforce/apex/JiraConnect.getJiraClouldIdLWC';
import getJiraTicketLWC from '@salesforce/apex/JiraConnect.getJiraTicketLWC';

export default class JiraIssueView extends LightningElement {

    @track error
    @track cloudId
    
    @wire(getJiraClouldIdLWC, {})
    handleJiraCloudIdRes({ error, data }) {
        if (data) {
            console.log('JiraIssueView: get cloud id', JSON.stringify(data))
            this.cloudId = data[0].id
        }
    }
    @wire(getJiraTicketLWC, { cloudId: '$cloudId', key: 'FPMDVVF'})
    handleJiraTicketRes({ error, data }) {
        if (data) {
            console.log('JiraIssueView: getJiraTicketLWC', JSON.stringify(data))
        }
    }

    /*
            getJiraTicketLWC({cloudId: this.cloudId}).then(result => {
                console.log('issue result', JSON.stringify(result))
            })
            .catch(error => {
                this.error = error;
            });*/

}