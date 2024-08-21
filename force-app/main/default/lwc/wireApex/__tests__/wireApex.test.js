import { createElement } from 'lwc';
import WireApex from 'c/wireApex';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
  
// Realistic data with a list of contacts
const mockGetAccountList = require('./data/getAccountList.json');
  
// An empty list of records to verify the component does something reasonable
// when there is no data to display
const mockGetAccountListNoRecords = require('./data/getAccountListNoRecords.json');
  
// Mock getAccountList Apex wire adapter
jest.mock(
  '@salesforce/apex/AccountController.getAccountList',
  () => {
    const {
      createApexTestWireAdapter
    } = require('@salesforce/sfdx-lwc-jest');
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);
  
describe('c-wire-apex', () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    // Prevent data saved on mocks from leaking between tests
    jest.clearAllMocks();
  });
    
  describe('getAccountList @wire data', () => {
    it('renders six records', () => {
      const element = createElement('c-wire-apex', {
        is: WireApex
      });
      document.body.appendChild(element);
        
      // Emit data from @wire
      getAccountList.emit(mockGetAccountList);
        
      return Promise.resolve().then(() => {
        // Select elements for validation
        const accountElements = element.shadowRoot.querySelectorAll('p');
        expect(accountElements.length).toBe(mockGetAccountList.length);
        expect(accountElements[0].textContent).toBe(mockGetAccountList[0].Name);
      });
    });
      
    it('renders no items when no records are returned', () => {
      const element = createElement('c-wire-apex', {
        is: WireApex
      });
      document.body.appendChild(element);
        
      // Emit data from @wire
      getAccountList.emit(mockGetAccountListNoRecords);
        
      return Promise.resolve().then(() => {
        // Select elements for validation
        const accountElements = element.shadowRoot.querySelectorAll('p');
        expect(accountElements.length).toBe(
          mockGetAccountListNoRecords.length
        );
      });
    });
  });
    
  describe('getAccountList @wire error', () => {
    it('shows error panel element', () => {
      const element = createElement('c-wire-apex', {
        is: WireApex
      });
      document.body.appendChild(element);
        
      // Emit error from @wire
      getAccountList.error();
        
      return Promise.resolve().then(() => {
        const errorElement = element.shadowRoot.querySelector('p');
        expect(errorElement).not.toBeNull();
        expect(errorElement.textContent).toBe('No accounts found.');
      });
    });
  });
});