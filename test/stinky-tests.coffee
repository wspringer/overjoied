expect = (require 'chai').expect
Joi = require 'joi'


schema = Joi.object().keys
  value: Joi.string()


describe 'stinky', ->
  it 'should consider two numbers to be equal', ->
    validation = schema.validate
      value: 1
    expect(validation.error).to.exist
