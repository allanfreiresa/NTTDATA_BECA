import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/LookupController.searchAccounts';
import searchContacts from '@salesforce/apex/LookupController.searchContacts';
import getContactsByAccountId from '@salesforce/apex/LookupController.getContactsByAccountId';
import getAccountByContactId from '@salesforce/apex/LookupController.getAccountByContactId';

export default class AccountContactSearch extends LightningElement {
    @track accountSearchTerm = '';
    @track contactSearchTerm = '';
    @track accountOptions = [];
    @track contactOptions = [];
    @track selectedAccountId = '';
    @track selectedAccountName = '';
    @track contacts = [];
    @track selectedContactId = '';
    @track selectedContactName = '';
    @track relatedAccount = null;

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

    handleContactSearchChange(event) {
        this.contactSearchTerm = event.target.value;
        if (this.contactSearchTerm.length >= 2) {
            searchContacts({ searchTerm: this.contactSearchTerm })
                .then(result => {
                    this.contactOptions = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        } else {
            this.contactOptions = [];
        }
    }

    handleAccountSelect(event) {
        this.selectedAccountId = event.target.dataset.id;
        const selectedAccount = this.accountOptions.find(account => account.Id === this.selectedAccountId);
        this.selectedAccountName = selectedAccount ? selectedAccount.Name : '';
        this.accountOptions = [];
        this.selectedContactId = '';
        this.selectedContactName = '';
        this.relatedAccount = null;
        this.fetchContacts();
    }

    handleContactSelect(event) {
        this.selectedContactId = event.target.dataset.id;
        const selectedContact = this.contactOptions.find(contact => contact.Id === this.selectedContactId);
        this.selectedContactName = selectedContact ? selectedContact.Name : '';
        this.contactOptions = [];
        this.selectedAccountId = '';
        this.selectedAccountName = '';
        this.contacts = [];
        this.fetchAccount();
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

    fetchAccount() {
        if (this.selectedContactId) {
            getAccountByContactId({ contactId: this.selectedContactId })
                .then(result => {
                    this.relatedAccount = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    }
}
