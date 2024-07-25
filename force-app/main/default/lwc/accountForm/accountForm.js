import { LightningElement, track } from 'lwc';
import saveAccount from '@salesforce/apex/AccountController.saveAccount';

export default class AccountForm extends LightningElement {
  @track accountName = '';
  @track phone = '';

  handleNameChange(event) {
    this.accountName = event.target.value;
  }

  handlePhoneChange(event) {
    this.phone = event.target.value;
  }

  handleSave() {
    saveAccount({ name: this.accountName, phone: this.phone })
      .then(() => {
        this.accountName = '';
        this.phone = '';
        // Notify user of success or refresh the list
      })
      .catch(error => {
        // Handle error
      });
  }
}
