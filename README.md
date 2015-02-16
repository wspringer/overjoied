# README

If we're using Joi all over the place for doing validations of our objects, then why not instrument the functions on these objects with Joi validations as well.

This stuff is experimental. Don't use this for production.

Before anything else, **Overjoied** is just **Joi**, with some extras. The extra bit is has allows you to express additional expectations on the types of the function's arguments.

```javascript
var Joi = require('overjoied');

var schema = Joi.object().keys({
	"increaseBy": Joi.func().params(Joi.number())
});
```

In the schema above, the `"increaseBy":Joi.func()` expresses we're expecting the object to have an `increaseBy(…)` method. The bit that is new is the `.params(Joi.number())` bit. It specializes our expectation by stating that we expect the first parameter to be a number.

Now, with JavaScript's dynamic nature, we obviously cannot check up front if an object with an `increaseBy(…)` function accepts a single numeric parameter. However, when the method is invoked, we *can* check if the first argument getting passed in is numeric. 

And that's *exactly* what **Overjoied** is doing: by adding the `params(…)` method, you can guarantee that the object getting returned by the `Joi.validate(…)` method has an `increaseBy(…)` method that checks if the first argument is numeric. 

So, in summary: **Overjoied** is just like **Joi**, with one extra feature: if `params()` is called on a `func()`, then **Overjoied** will cause the validated object to have assertions for all the parameter specifications you passed in.

So if this is your schema:

```javascript
var Joi = require('overjoied');

var schema = Joi.object().keys({
	"increaseBy": Joi.func().params(Joi.number())
});
```

And if this the way you use it:

```javascript
var obj = …;
Joi.validate(obj, schema, function(err, validated) {
	if (!err) {
		// Then this will be okay
		validated.increaseBy(12);
		// And this will throw a detailed error message,
		// stating that it expected a number.
		validated.increaseBy('aa'); // will throw an Error				
	}
});
```

The error will be fairly specific. Not as specific as I want it to be just yet – it would have been nice if I'd use information from the function signatures – but absolutely readable.[]()