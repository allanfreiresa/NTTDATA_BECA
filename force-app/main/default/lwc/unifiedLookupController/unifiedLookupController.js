import { LightningElement, track } from 'lwc';
import searchRecords from '@salesforce/apex/UnifiedLookupController.searchRecords';

export default class UnifiedLookupSearch extends LightningElement {
    @track searchTerm = '';
    @track searchOptions = [];
    @track selectedRecord = null;

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length >= 2) {
            searchRecords({ searchTerm: this.searchTerm })
                .then(result => {
                    this.searchOptions = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        } else {
            this.searchOptions = [];
        }
    }

    handleRecordSelect(event) {
        const selectedRecordId = event.target.dataset.id;
        const selectedRecordType = event.target.dataset.type;
        const selectedRecord = this.searchOptions.find(record => record.Id === selectedRecordId && record.ObjectType === selectedRecordType);
        this.selectedRecord = selectedRecord ? { ...selectedRecord } : null;
        this.searchOptions = [];
    }
}
