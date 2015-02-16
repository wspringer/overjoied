expect = (require 'chai').expect
_ = require 'lodash'
Joi = require 'joi'


pt = Object.getPrototypeOf(Joi.func())
original = pt._base
pt.params = (args...) ->
  this._base = _.wrap original, (fn1, value, state, options) ->
    result = fn1(value, state, options)
    if result.errors is null
      result.value = _.wrap result.value, (fn2) ->
        received =  _.slice(arguments, 1)
        _.each args, (arg, index) ->
          Joi.assert received[index], arg, "Error in argument #{index}:"
        fn2.apply this, received
    result
  this

describe 'stinky', ->
  it 'should validate functions correctly', ->
    Amount = Joi.object().keys
      value: Joi.func()
      increaseBy: Joi.func().params(Joi.number())
    value = 3
    increaseBy = (other) -> value = 3 + other
    amount =
      value: () -> value
      increaseBy: increaseBy
    Joi.validate amount, Amount, (err, validated) ->
      if not err?
        validated.increaseBy 3
        expect(validated.value()).to.equal 6
        try
          expect(validated.increaseBy 'aa')
        catch e
          expect(e).not.to.be.null
