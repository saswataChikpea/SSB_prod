import { LightningElement, api } from "lwc";

export default class ChildRating extends LightningElement {
  
  packagerating;

  rating(event) {
    
    if (event.target.name === "Rating") {
      this.packagerating = event.target.value;
      alert('starvalue'+this.packagerating);
    
  }
  }
  
}