import { LightningElement, wire, track } from 'lwc';
import accountSearchTemplate from './accountSearch.html';
import getAccount from '@salesforce/apex/AccountController.getAccountRecord';
import createCaseTemp from './createCase.html'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import plafromEventTemp from './platformEventComp.html';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';


const FIELDS = [ACCOUNT_NAME];
const COLUMN = [{ label: 'Name', fieldName: 'Name' },
{ label: 'Rating', fieldName: 'Rating' },
{ label: 'Industry', fieldName: 'Industry' }];
export default class LwcPracticeComponent extends LightningElement {
  selectedTemplate = '';
  searchKey = '';
  delayTime;
  columns = COLUMN;
  accounts;
  error;

  templateOptions = [
    {
      label: 'Account Search',
      value: 'accountSearch'
    },
    {
      label: 'Create Case',
      value: 'createCase'
    },
    {
      label:'Platform Event Comp',
      value:'platformEvent'
    }
  ];

  handleTemplateChange(event) {
    this.selectedTemplate = event.detail.value;
    
    console.log(
      'Selected Template:',
      this.selectedTemplate
    );
  }

  render() {

    if (this.selectedTemplate === 'accountSearch') {
      return accountSearchTemplate;
    }

    if (this.selectedTemplate === 'createCase') {
      return createCaseTemp;
    }
    if(this.selectedTemplate === 'platformEvent'){
      return plafromEventTemp;
    }
    return super.render();
  }

  handleSearchChange(event) {
    let key = event.target.value;
    clearTimeout(this.delayTime);
    this.delayTime = setTimeout(() => {
      this.searchKey = key;
    }, 2000);
  }

  @wire(getAccount, { searchKey: '$searchKey' })
  getAccounts({ data, error }) {
    if (data) {
      this.accounts = data;
      console.log('Accounts Data:' + JSON.stringify(this.accounts));
      this.error = undefined;
    }
    if (error) {
      this.error = error?.body?.messgae;
      this.accounts = undefined;
    }
  }

  //Case creation form
  selectedAccountId;
  filter = {
    criteria: [
      {
        fieldPath: "Website",
        operator: "eq",
        value: null,
      },
      {
        fieldPath: "Type",
        operator: "eq",
        value: "Customer-Direct",
      },

    ],
    filterLogic: "(1 OR 2)",
  };

  matchingInfo = {
    primaryField: { fieldPath: "Name", mode: "startsWith" },
    additionalFields: [{ fieldPath: "Phone" }],
  };

  displayInfo = {
    primaryField: "Name",
    additionalFields: ["Phone", "Industry"],
  };

  handleChange(event) {
    console.log('EventDetails**'+JSON.stringify(event.detail))
    console.log('EventDeta**'+JSON.stringify(event.target))

    this.selectedAccountId = event.detail.recordId;
    console.log('SelectedRecord' + this.selectedAccountId);
  }
  subject = 'Case Creation from UI';
  @wire(getRecord, { recordId: '$selectedAccountId', fields: FIELDS })
  getAccountValue;

  get accountName() {
    console.log('AccountData:', this.getAccountValue?.data?.fields?.name);
    this.subject = this.subject + this.getAccountValue?.data?.fields?.name;
    return this.subject;
  }
  handleSubmit(event) {
    event.preventDefault();

    const fields = event.detail.fields;
    console.log('Fied before Save' + JSON.stringify(fields));
    fields.AccountId = this.selectedAccountId;
    fields.Subject = 'Case Creeation from LWC';
    const subject = fields.Subject;
    if (!subject || subject.length < 10) {
      this.showToast(
        'Validation on subject',
        'Subject must be at least 10 characters.',
        'error'
      );
      return;
    }

    fields.Priority = 'Medium';
    fields.Status = 'New';
    fields.Origin = 'Web';
    fields.Description = 'This is the case related to the UI LWC creation form';
    this.template.querySelector('lightning-record-edit-form').submit(fields);

  }

  handleSuccess(event) {
    const caseId = event.detail.id;
    this.showToast('Success', 'Record Created Successfully' + caseId, 'Success');
  }
  handleError(event) {
    this.showToast('Error', 'Unable To create Case', 'error');
  }

  showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    })
    );
  }
  async handleCall(event) {
    //     console.log('Call button clicked');
    // }
    //   async handlecall() {
    alert('dd')
    const fields = {};
    console.log('Fied before Save' + JSON.stringify(fields));
    fields.AccountId = this.selectedAccountId;
    fields.Subject = 'Case Creeation from LWC';

    fields.Priority = 'Medium';
    fields.Status = 'New';
    fields.Origin = 'Web';
    fields.Description = 'This is the case related to the UI LWC creation form';

    console.log('****Before Promise ');
    let ele = this.template.querySelector('lightning-record-edit-form');
    console.log('****ele', ele)
    let result =await new Promise((resolve, reject) =>{
      ele.addEventListener('success', (data) => {
        console.log('****event Success Promise ', data.id);
            resolve(true)
      })
      ele.addEventListener('error', (err) => {
        console.log('****event error Promise ', err.message);
        reject(false);
      })
      ele.submit(fields);
    })
    console.log('***After Pomise ',result);

  }

  //  connectedCallback(){
  //   setTimeout(()=>{
  //     let ele=  this.template.querySelector('lightning-card');
  //  console.log('DivElement '+ele);
  //  alert(ele?.title);
  //   },2000)

  // }
//   observer;
//   connectedCallback() {
//   this.observer = new MutationObserver((mutations) => {
//     const child = this.querySelector('lightning-card');
//     if (child) {
//       // Do your logic here
//       alert(child);
//       this.observer.disconnect(); // Stop watching once found
//     }
//   });

//   this.observer.observe(this, { childList: true });
// }
// renderedCallback() {

//   let element= this.template.querySelector('lightning-combobox');
//     element.addEventListener('change', this.handleTemplateChange)

// }

//Platform event Comp started
@track message = 'Waiting for platform events...';
    channelName = '/event/ErrorLogEvent__e'; // Replace with your Platform Event API name
    subscription = {};
    actualMessage= 'Wating for platform message';

    connectedCallback() {
        this.handleSubscribe();
        this.registerErrorListener();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('New event received: ', JSON.stringify(response));
            // Extract the payload data
            this.message = JSON.stringify(response.data.payload);
            this.actualMessage ='Message Received'+response.data.payload.Message__c;
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log('Successfully subscribed to channel: ', response.channel);
            this.subscription = response;
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription, (response) => {
            console.log('Unsubscribed successfully: ', response);
        });
    }

    registerErrorListener() {
        onError((error) => {
            console.error('Received error from EMP API: ', JSON.stringify(error));
        });
    }
}