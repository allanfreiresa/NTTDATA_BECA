import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
  { label: 'Name', fieldName: 'Name', type: 'text' },
  { label: 'Phone', fieldName: 'Phone', type: 'phone' },
];

export default class AccountList extends LightningElement {
  columns = COLUMNS;
  accounts;
  error;

  @wire(getAccounts)
  wiredAccounts(result) {
    this.accounts = result;
    if (result.error) {
      this.error = result.error;
      this.accounts = undefined;
    }
  }

  handleRefresh() {
    return refreshApex(this.accounts);
  }
}
