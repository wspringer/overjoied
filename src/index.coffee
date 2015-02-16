Joi = require 'joi'
_ = require 'lodash'

augment = (func, schemas...) ->
  _.wrap func, (wrapped) ->
    args = _.slice(arguments, 1)
    _.each schemas, (schema, index) ->
      Joi.assert args[index], schema, "Error in argument #{index}:"
    wrapped.apply this, args

protoFunc = Object.getPrototypeOf(Joi.func())

protoFunc.params = (schemas...) ->
  this._base = _.wrap this._base, (fn, value, state, options) ->
    result = fn(value, state, options)
    if not result.errors
      result.value = augment result.value, schemas...
    result
  this

module.exports = Joi


