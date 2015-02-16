expect = (require 'chai').expect
_ = require 'lodash'
Joi = require '../src/index'

# Factory method for an amount.
amount = (value = 3) ->
  current: () -> value
  increaseBy: (other) -> value = value + other

describe 'overjoied', ->

  it 'should insert validations for function arguments', ->

    # The schema we're using
    AmountSchema = Joi.object().keys
      current: Joi.func()
      increaseBy: Joi.func().params(Joi.number())

    expect(-> Joi.assert(amount(3), AmountSchema)).not.to.throw(Error)
    validated = Joi.validate amount(3), AmountSchema, (err, validated) ->
      expect(err).to.be.null
      validated.increaseBy 3
      expect(validated.current()).to.equal 6
      expect(-> validated.increaseBy 'aa').to.throw(/value must be a number/)
