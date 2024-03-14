import { LightningElement, api } from 'lwc';

export default class UserEntity extends LightningElement {    
    @api item;
    @api propertyValue;
}