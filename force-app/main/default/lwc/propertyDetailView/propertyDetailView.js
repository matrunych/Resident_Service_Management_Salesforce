import { LightningElement, wire, track, api} from 'lwc';
import getPropertyId from '@salesforce/apex/PropertyController.getPropertyId';
import uId  from "@salesforce/user/Id";


const OBJECT_API_NAME = 'Property__c';

export default class PropertyDetailView extends LightningElement {
    @track property;
    @track urId=uId ;
    @track record;
    @track error;
    objectApiName = OBJECT_API_NAME;


    @wire(getPropertyId, {userId: '$urId' })
    wiredProperty({ error, data }) {

        if (data) {
            this.record = data;
            this.property = data.Id;
               
        } else if (error) {
            this.error = error;
        } 
    }

}