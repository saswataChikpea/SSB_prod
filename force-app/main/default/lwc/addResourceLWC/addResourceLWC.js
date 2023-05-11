import { api, LightningElement, track, wire } from 'lwc';
import getAllResources from '@salesforce/apex/BudgetRequest.getAllResources';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class AddResourceLWC extends LightningElement {
    @api phaseId //= 'a0j7F00000gZfxGQAS' 
    @track resourceList //= [{"EstHrs":0,"EstPerc":0,"itmid":"a0J7F00000QYxEfUAL","ProjectModel":"Waterfall","Resource":"VZ-CT-24H","rtplans":[{"Billcycle":"Monthly","Cost":55,"costBk":"Bestir","cplid":"a1F7F00000B45XUUAZ","Name":"RP-0000000115","Pricingtype":"Flat","Profit":20,"Rate":75,"rateplanselected":false,"rplid":"a0U7F00000G4n5fUAB","UOM":"Hour"},{"Billcycle":"Monthly","Cost":0,"Name":"RP-0000000178","Pricingtype":"Flat","Rate":70,"rateplanselected":false,"rplid":"a0U7F00000KoYKLUA3"}],"selected":true},{"EstHrs":0,"EstPerc":0,"itmid":"a0J7F00000QYxEuUAL","ProjectModel":"Waterfall","Resource":"Project Manager","rtplans":[{"Billcycle":"Monthly","Cost":75,"costBk":"Internal Resources","cplid":"a1F7F00000BSs4zUAD","Name":"RP-0000000117","Pricingtype":"Flat","Profit":-75,"Rate":0,"rateplanselected":false,"rplid":"a0U7F00000G4n6EUAR","UOM":"Hour"},{"Billcycle":"Monthly","Cost":0,"Name":"RP-0000000118","Pricingtype":"Tiered","Rate":0,"rateplanselected":false,"rplid":"a0U7F00000G4uwBUAR"},{"Billcycle":"Monthly","Cost":75,"costBk":"Internal Resources","cplid":"a1F7F00000BSs4zUAD","Name":"RP-0000000182","Pricingtype":"Flat","Profit":25,"Rate":100,"rateplanselected":false,"rplid":"a0U7F00000O2MpJUAV","UOM":"Hour"}],"selected":false}]
    @track resourceMap = {}
    connectedCallback() {
        console.log("phaseId::", JSON.stringify(this.phaseId));
        // this.callgetAllResources(PhaseId)


        // if (this.allResources) {
        //     this.resourceList = [...this.allResources]
        //     this.resourceList.forEach(element => {
        //         this.resourceMap[element.itmid] = element
        //     });
        //     console.log("resourceMap::", JSON.stringify(this.resourceMap));

        // }
    }
    @wire(getAllResources, { recordId: '$phaseId' })
    getResc({ error, data }) {
        if (data) {
            console.log("getAllResources::", JSON.stringify(data));
            this.resourceList = JSON.parse(JSON.stringify(data))
            this.resourceList.forEach(element => {
                this.resourceMap[element.itmid] = element
            });
            // this.resourceMap = this.resourceList.reduce((prev, curr) => ({ ...prev, [curr.itmid]: curr }), {})
        } else {
            console.error("getAllResources::", error);
        }
    }

    // get resourceMap() {
    //     return this.resourceList && this.resourceList.reduce((prev, curr) => ({ ...prev, [curr.itmid]: curr }), {})
    // }
    // callgetAllResources(PhaseId) {
    //     getAllResources({ recordId: PhaseId }).then(data => {
    //         console.log("getAllResources::", JSON.stringify(data));
    //         this.allResourcelist = data
    //         // if (data.length) {
    //         //     this.phaseDetails = data[0].ChikPeaSSB__Phase__r
    //         //     this.resourceDetails = data
    //         // }

    //     }).catch(err => {
    //         console.error("getAllResources::", err);
    //     })
    // }

    handleAddInput(event) {
        const targetValue = event.target.value
        const targetName = event.target.name
        console.log(targetName, targetValue);
        const dataId = event.currentTarget.getAttribute('data-id')

        try {
            this.resourceMap[dataId].EstHrs = Number(targetValue)
        } catch (error) {
            console.error(error);
        }
    }
    handleResourceSelect(event) {
        const targetValue = event.target.checked
        const targetName = event.target.name
        const dataId = event.currentTarget.getAttribute('data-id')
        try {
            console.log(dataId, targetValue, JSON.stringify(this.resourceMap[dataId]));

            this.resourceMap[dataId].selected = targetValue
        } catch (error) {
            console.error(error);
        }
        // console.log(JSON.stringify(this.resourceList));
    }
    handleRatePlanSelect(event) {
        const targetValue = event.target.checked
        const targetName = event.target.name
        const dataId = event.currentTarget.getAttribute('data-id')
        const ratePlanId = event.currentTarget.getAttribute('data-rate-plan')
        console.log(dataId, ratePlanId, targetValue);
        this.resourceMap[dataId].rtplans.forEach(el => {
            if (el.rplid == ratePlanId) {
                el.rateplanselected = targetValue
            } else {
                el.rateplanselected = false
            }
        });
    }
    submitResourceAdd(event) {
        console.log("Handle submit");
    }
    // isNum = (val) => {
    //     return /^\d+$/.test(val);
    // }

    closeModal(event) {
        // to close modal set isModalOpen tarck value as false
        // debugger
        const targetName = event.target.name
        let data = {}
        if (targetName == 'CANCEL') {
            data = { cancel: true }
        } else {
            // debugger
            let ratePlanNotSelected = false
            let hourNotSelected = false
            let resource = this.resourceList.filter(el => (el.selected == true)).map(el => {
                console.log("estimated hour validation::", Number(el.EstHrs), Number(el.EstHrs) <= 0, el.EstHrs);

                if (!Number(el.EstHrs) || Number(el.EstHrs) <= 0) {
                    hourNotSelected = true
                }
                const ratePlans = el.rtplans.filter(el => (el.rateplanselected == true))[0]
                if (!ratePlans) {
                    ratePlanNotSelected = true
                    return
                }
                let a = {
                    ...el,
                    ...ratePlans
                }
                delete a.rtplans;
                // console.log(JSON.stringify(ratePlans))
                return a
            })

            if (hourNotSelected) {
                this.showToast("Please select estimated hour.")
                console.log("Please select estimated hour.");
                return
            }
            if (ratePlanNotSelected) {
                this.showToast("Please select a rate plan")
                console.log("Please select a rate plan");
                return
            }
            if (!resource.length) {
                this.showToast("Please select a resource")
                console.log("Please select a resource");
                return
            }

            data = { selectedData: resource }
        }
        this.isModalOpen = false
        const budgetChangeEvent = new CustomEvent('addnewresource', {
            detail: { data },
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