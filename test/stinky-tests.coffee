expect = (require 'chai').expect
_ = require 'lodash'
Joi = require 'joi'


pt = Object.getPrototypeOf(Joi.func())
original = pt._base
pt._base = _.wrap original, (func, value, state, options) ->
  console.info 'Doing'
  return func(value, state, options)

describe 'stinky', ->
  it 'should validate functions correctly', ->
    expect(Joi.func().validate(() ->).error).to.not.exist
    expect(Joi.func().validate('foo').error).to.exist
