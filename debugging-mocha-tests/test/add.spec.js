const assert = require('chai').assert;
const { add } = require('../lib/calc');

describe('When adding numbers', () => {
  it('Shoud return correct result', () => {
    const result = add(1, 2);
    assert.equal(result, 3);
  });
});