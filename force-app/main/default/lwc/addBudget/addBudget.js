import { api, LightningElement, track } from 'lwc'
import getResc from '@salesforce/apex/BudgetRequest.getResc';
import saveNewBudget from '@salesforce/apex/BudgetRequest.saveNewBudget';
import updateHours from '@salesforce/apex/BudgetRequest.updateHours';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'




export default class AddBudget extends LightningElement {
    @track isModalOpen = false
    @track phaseDetails = []
    @track resourceDetails = []
    @track allResourcelist = []
    @track newAddedResource = []
    @track finalHoursString;
    // estimatedHour = 200
    // estimatedRate = 2000
    showNewResource
    @track phaseId
    @track dataId
    
    reasonForIncrement=""

    @api showDialog(PhaseId) {
        console.log('show budget showDialog::', PhaseId)
        this.phaseId = PhaseId
        this.isModalOpen = true
        this.getPhaseDetails(PhaseId)
    }

    get estimatedHour() {
        // if (this.newAddedResource) {
        //     EstHrs
        // }
        return this.resourceDetails.reduce((prev, curr) =>
            (Number(curr.addedHour) ? prev + Number(curr.addedHour) : prev), 0) +
            this.newAddedResource.reduce((prev, curr) =>
            (Number(curr.EstHrs) ? prev + Number(curr.EstHrs) : prev), 0)

    }
    get estimatedRate() {
        return this.resourceDetails.reduce((prev, curr) =>
            (Number(curr.addedHour) ? prev + Number(curr.addedHour) * Number(curr.ChikPeaSSB__Rate__c) : prev), 0) +
            this.newAddedResource.reduce((prev, curr) =>
            (Number(curr.EstHrs) ? prev + Number(curr.EstHrs) * Number(curr.Rate) : prev), 0) 
    }
    //add hours

    addNewResource(event) {
        console.log("showNewResource called");
        this.showNewResource = this.showNewResource ? false : true
    }
    handleAddChange(event) {
        this.dataId = event.target.dataset.id
        const value = event.target.value
        console.log("dataId:: " + this.dataId + " :: " + value);
        let resource = this.resourceDetails.filter(el => el.Id == this.dataId)
        if (resource.length) {
            resource[0].addedHour = Number(value)
        }
        // console.log(JSON.stringify(this.resourceDetails));
       
    }
    
    handleReasonForIncrementChange(event){
        this.reasonForIncrement=event.target.value
    }
    getPhaseDetails(PhaseId) {
        getResc({ recordId: PhaseId }).then(data => {
            console.log("getPhaseDetails::", JSON.stringify(data));
            if (data.length) {
                this.phaseDetails = data[0].ChikPeaSSB__Phase__r
                this.resourceDetails = data
            }

        }).catch(err => {
            console.error("getPhaseDetails::", err);
        })
    }
    handleNewResourceAdd(event) {
        console.log("handleNewResourceAdd::", JSON.stringify(event.detail));
        if (event.detail.data.cancel) {
            this.showNewResource = false
        } else {
            const selectedData = event.detail.data.selectedData
            if (selectedData) {

                this.newAddedResource = [...this.newAddedResource,
                ...selectedData
                ]
            }
            console.log("newaddedResource::", JSON.stringify(this.newAddedResource));
            this.showNewResource = false

        }
    }

    submitResource(event) {
        let finalRecords = []

        const addedHourResource = this.resourceDetails.filter(el => (Number(el.addedHour) >= 0))
        console.log("addedHourResource::", JSON.stringify(addedHourResource));

        // if (addedHourResource.length > 0) {
        //     addedHourResource.forEach(el => {
        //         finalRecords.push({
        //             Phase__c: el.ChikPeaSSB__Phase__c,
        //             Item__c: el.ChikPeaSSB__Item__c,
        //             Rate_Plan__c: el.ChikPeaSSB__Rate_Plan__c,
        //             Cost_Plan__c: el.ChikPeaSSB__Cost_Plan__c,
        //             ChikPeaSSB__Est_Hours__c: el.addedHour
        //         })

        //     });
        // }
        if (this.newAddedResource.length > 0) {
            this.newAddedResource.forEach(el => {
                finalRecords.push({
                    Phase__c: this.phaseId,
                    Item__c: el.itmid,
                    Rate_Plan__c: el.rplid,
                    Cost_Plan__c: el.cplid,
                    ChikPeaSSB__Est_Hours__c: el.EstHrs
                })
            })
        }
        
        console.log("FinalRecords::", JSON.stringify(finalRecords));
        if (finalRecords.length > 0) {
            saveNewBudget({ resourceList: finalRecords, reasonForIncrement: this.reasonForIncrement, PhaseId: this.phaseId })
                .then(res => {
                    if (res) {
                        this.showToast("New budget resource added.", "Success", "success")
                        this.newAddedResource = []
                    }
                }).catch(error => {
                    console.error(error);
                })
        }
    }

    submitHours(event){
        let finalHours=0;
        const addedHourResource = this.resourceDetails.filter(el => (Number(el.addedHour) >= 0))
        console.log("addedHourResource::", JSON.stringify(addedHourResource));

        


        if (addedHourResource.length > 0) {
            addedHourResource.forEach(el => {

                finalHours = el.addedHour;
                // finalHours.push({
                //     // dataId: this.dataId,
                //     ChikPeaSSB__Est_Hours__c: el.addedHour
                // })

            });
        }
         this.finalHoursString =JSON.stringify(finalHours);
       
        console.log('finalHours====>',finalHours)
        console.log('dataId====>',this.dataId);
        console.log('finalHoursString====> \n',this.finalHoursString);

        updateHours({
            hoursToUpdate: finalHours,
            dataid:this.dataId
        })
        .then(res => {
                        if (res) {
                            this.showToast("Hour added.", "Success", "success")
                        }
                    }).catch(error => {
                        console.error(error);
                    })

        // console.log("FinalHours::", JSON.stringify(finalHours));
        // if (finalHours.length > 0) {
        //     updateHours({ addedHour: finalHours, reasonForIncrement: this.reasonForIncrement, PhaseId: this.phaseId })
        //         .then(res => {
        //             if (res) {
        //                 this.showToast("Hour added.", "Success", "success")
        //             }
        //         }).catch(error => {
        //             console.error(error);
        //         })
        // }
        finalHours=0;

    }


    handleSuccess(event) {
        this.accountId = event.detail.id
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        debugger
        this.isModalOpen = false
        const data1 = { test: 1 }
        const budgetChangeEvent = new CustomEvent('budgetchange', {
            detail: { data1 },
        })
        // Fire the custom event
        this.dispatchEvent(budgetChangeEvent)
    }
    showToast = (message, title, variant) => {
        try {
            if (this.isLocal) {
                alert(message || "")
                return
            }
            const toastEvent = new ShowToastEvent({
                title: title || 'Error!',
                message: message || "",
                variant: variant || 'error'
            })
            this.dispatchEvent(toastEvent)
        } catch (error) {
            console.error(error)
        }

    }
}