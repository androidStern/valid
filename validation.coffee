R = require 'ramda'
typeCheck = R.curry(require('type-check').typeCheck, 2)


Validator = (message, fn)->
    {message: message, fn: fn}

Checker = R.curry (validators, fn)->
    origional_fn = fn
    (args...)->
        reducer = (acc, validator)->
            {fn, message} = validator
            message ?= "FAILED but no error message available"
            if fn.call(null, args[0]) then acc else R.cons(message, acc)

        errors = R.reduce(reducer,[], validators)

        if errors.length > 0
            err_message = errors.join(", ")
            throw new Error(err_message)

        return origional_fn.apply(null, args)





mustBeMap = Checker([
    Validator("Argument must be a map", typeCheck("Object"))
    ])

mustBeArray = Checker([
    Validator("Argument must be an array", typeCheck("Array"))
    ])

mustBeFunction = Checker([
    Validator("Argument must be a funtion", typeCheck("Function"))
    ])

mustBeString = Checker([
    Validator("Argument must be a string", typeCheck("String"))
    ])


module.exports = {
    Validator: Validator
    Checker: Checker
    mustBeMap: mustBeMap
    mustBeArray: mustBeArray
    mustBeFunction: mustBeFunction
    mustBeString: mustBeString
}

# Validator, Checker, mustBeMap, mustBeArray, mustBeFunction, mustBeString
