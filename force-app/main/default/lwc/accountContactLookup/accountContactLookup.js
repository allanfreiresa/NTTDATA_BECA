import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/LookupController.searchAccounts';
import searchContacts from '@salesforce/apex/LookupController.searchContacts';

export default class AccountContactLookup extends LightningElement {
    @track accountSearchTerm = '';
    @track contactSearchTerm = '';
    @track accountOptions = [];
    @track contactOptions = [];
    @track selectedAccountId = '';
    
    get isContactSearchDisabled() {
        return !this.selectedAccountId;
    }
    
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
        this.accountSearchTerm = selectedAccount ? selectedAccount.Name : '';
        this.accountOptions = [];
        this.contactSearchTerm = '';
        this.contactOptions = [];
    }
    
    handleContactSearchChange(event) {
        this.contactSearchTerm = event.target.value;
        if (this.contactSearchTerm.length >= 2 && this.selectedAccountId) {
            searchContacts({ accountId: this.selectedAccountId, searchTerm: this.contactSearchTerm })
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
    
    handleContactSelect(event) {
        const selectedContactId = event.target.dataset.id;
        const selectedContact = this.contactOptions.find(contact => contact.Id === selectedContactId);
        this.contactSearchTerm = selectedContact ? selectedContact.Name : '';
        this.contactOptions = [];
    }
}
