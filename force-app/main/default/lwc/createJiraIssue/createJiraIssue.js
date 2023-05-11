import { LightningElement, track, wire } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getJiraClouldIdLWC from '@salesforce/apex/JiraConnect.getJiraClouldIdLWC'
import createJiraTicketLWC from '@salesforce/apex/JiraConnect.createJiraTicketLWC'
import createJiraProjectLWC from '@salesforce/apex/JiraConnect.createJiraProjectLWC'
export default class CreateJiraIssue extends LightningElement {
    @track error
    @track cloudId
    //accountId = "557058:a57ea455-03d8-4b3c-8a0c-af1007914b13"
    accountId = "5af9464ad7cce75687b9ef14"
    body = { "fields": { "project": { "key": "SP" }, "summary": "", "description": { "type": "doc", "version": 1, "content": [{ "type": "paragraph", "content": [{ "type": "text", "text": "This is an autogenerated issue from a demo." }] }] }, "issuetype": { "name": "Task" } } }
    project_body = {
        "projectTypeKey": "business",
        "leadAccountId": this.accountId
    }

    @wire(getJiraClouldIdLWC, {})
    handleJiraCloudIdRes({ error, data }) {
        if (data) {
            console.log('get cloud id', JSON.stringify(data))
            this.cloudId = data[0].id
            console.log('cloud id', this.cloudId)
            //this.accountId = 
        }
    }
    handleFieldsOnchange(event) {
        console.log('handleOnchange2', event.target.value);
        console.log('handleOnchange3', event.target.name);
        this.body.fields[event.target.name] = event.target.value
        console.log('handleOnchange5', JSON.stringify(this.body));
        //event.target.name 
    }
    handleProjectFieldsOnchange(event) {
        console.log('handleOnchange2', event.target.value);
        console.log('handleOnchange3', event.target.name);
        this.project_body[event.target.name] = event.target.value
        console.log('handleOnchange5', JSON.stringify(this.project_body));
        //event.target.name 
    }
    handleDescriptionOnchange(event) {
        this.body.fields.description.content[0].content[0][event.target.name] = event.target.value
        console.log('handleOnchange6', event.target.name);
        console.log('handleOnchange4', JSON.stringify(this.body));
    }
    createJiraIssue(e) {
        createJiraTicketLWC({ cloudId: this.cloudId, jsonBody: JSON.stringify(this.body) }).then(result => {
            console.log('create issue result', JSON.stringify(result))
        })
            .catch(error => {
                this.error = error;
                console.error(error);
            });
    }
    createJiraProject(e) {
        /*const project_json = {
            "key": "SOF",
            "name": "Software Sample",
            "projectTypeKey": "software",
            "projectTemplateKey": "com.pyxis.greenhopper.jira:gh-scrum-template",
            "description": "Example Project description",
            "lead": "mehebubhossain",
            "assigneeType": "PROJECT_LEAD",
            "avatarId": 10200
        }*/
        createJiraProjectLWC({ cloudId: this.cloudId, jsonBody: JSON.stringify(this.project_body) }).then(result => {
            console.log('create issue result', JSON.stringify(result))
            //{"errorMessages":[],"errors":{"projectKey":"Project keys must start with an uppercase letter, followed by one or more uppercase alphanumeric characters."},"StatusCode":400}
            if (result.StatusCode === 201) {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "Project created successfully",
                    variant: "success",
                });
                this.dispatchEvent(evt)
            }else{
                const evt = new ShowToastEvent({
                    title: "Error",
                    message: result.errors,
                    variant: "error",
                });
                this.dispatchEvent(evt)
            }
        }).catch(error => {
            this.error = error;
            console.error(error);
        });
    }
}