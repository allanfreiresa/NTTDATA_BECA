const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
<<<<<<< HEAD
=======
    moduleNameMapper: {
        '^c/displayPanel$': '<rootDir>/force-app/test/jest-mocks/c/displayPanel',
        '^thunder/hammerButton$': '<rootDir>/force-app/test/jest-mocks/thunder/hammerButton',
        '^lightning/button$': '<rootDir>/force-app/test/jest-mocks/lightning/button'
      },
>>>>>>> a70505dd480579b7a55925d421de5df505664602
    modulePathIgnorePatterns: ['<rootDir>/.localdevserver']
};
