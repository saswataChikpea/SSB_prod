import { LightningElement, api, wire, track } from 'lwc'
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions'
import { getRelatedListRecords } from 'lightning/uiRelatedListApi'
import { getRecord, updateRecord } from 'lightning/uiRecordApi'
import getJiraClouldIdLWC from '@salesforce/apex/JiraConnect.getJiraClouldIdLWC'
import createJiraTicketLWC from '@salesforce/apex/JiraConnect.createJiraTicketLWC'
import createJiraProjectLWC from '@salesforce/apex/JiraConnect.createJiraProjectLWC'
import getJiraTicketLWC from '@salesforce/apex/JiraConnect.getJiraTicketLWC'
import jiraGenericCallLWC from '@salesforce/apex/JiraConnect.jiraGenericCallLWC'
import LightningConfirm from 'lightning/confirm';
import LightningAlert from 'lightning/alert';

export default class JiraProjectSync extends NavigationMixin(LightningElement) {
    @api
    invoke() {
        console.log('inside invoke');
        //this.confirmHandler();
    }
}