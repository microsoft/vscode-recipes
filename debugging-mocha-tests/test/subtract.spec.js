const assert = require('chai').assert;
const { subtract } = require('../lib/calc');

describe('When subtracing numbers', () => {
  it('Shoud return correct result', () => {
    const result = subtract(3, 2);
    assert.equal(result, 1);
  });
});
