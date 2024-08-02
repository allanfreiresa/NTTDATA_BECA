import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/LookupController.searchAccounts';
import getContactsByAccountId from '@salesforce/apex/LookupController.getContactsByAccountId';

export default class AccountContactSearch extends LightningElement {
    @track accountSearchTerm = '';
    @track accountOptions = [];
    @track selectedAccountId = '';
    @track selectedAccountName = '';
    @track contacts = [];

    handleAccountSearchChange(event) {
        this.accountSearchTerm = event.target.value;
        if (this.accountSearchTerm.length >= 2) {
            searchAccounts({ searchTerm: this.accountSearchTerm })
                .then(result => {
                    this.accountOptions = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        } else {
            this.accountOptions = [];
        }
    }

    handleAccountSelect(event) {
        this.selectedAccountId = event.target.dataset.id;
        const selectedAccount = this.accountOptions.find(account => account.Id === this.selectedAccountId);
        this.selectedAccountName = selectedAccount ? selectedAccount.Name : '';
        this.accountOptions = [];
        this.fetchContacts();
    }

    fetchContacts() {
        if (this.selectedAccountId) {
            getContactsByAccountId({ accountId: this.selectedAccountId })
                .then(result => {
                    this.contacts = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    }
}
