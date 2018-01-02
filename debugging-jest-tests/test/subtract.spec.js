const { subtract } = require('../lib/calc');

describe('When subtracing numbers', () => {
  it('Shoud return correct result', () => {
    const result = subtract(3, 2);
    expect(result).toEqual(1);
  });
});
