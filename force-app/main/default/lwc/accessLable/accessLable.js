import { LightningElement } from 'lwc';
import DESCRIPTION_1 from '@salesforce/label/c.Description_One';
import DESCRIPTION_2 from '@salesforce/label/c.Description_Two';

export default class AccessLable extends LightningElement {
    Labels={
        description1:DESCRIPTION_1,
        description2:DESCRIPTION_2

    }
}