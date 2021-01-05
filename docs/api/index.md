# API

This page describes the API that is passed when you run a function from a ModuleScript using the Run Program button.

!!! warning

	The API is still a work in progress and can change at any time.

!!! note "How to read the API docs"

	This documentation takes inspiration from the Rust programming language.

	**Type** is defined after colon `:`

	`|` means the type on either side can be either or.

	For example `BasePart | Model` means the type can either be a BasePart or a Model

	`?` means that the type is optional or can be passed as nil. This is used in functions, methods, and tables.

	*Example:* `optionalType: ?OptionalType`


	**Functions** and **Methods** have the returned object as `->`

		-> Type

	Methods that return `Self` return the instance of the class it was called from.

	**Classes** are documented with a struct-like definition. Methods are not defined in this, only properties and module functions.

	Example:

		ClassName {
			Property1 : Type1,
			Property2 : Type2,

			Function : function(arg1 : TypeA, arg2 : TypeB) -> TypeC,
		}

	**Tables** are documented similarly to Classes, but usually do not have a ClassName

	Properties and their types are usually strict and the type checking will enforce this.
	Anything type with a `?`, however can be optional or passed as nil.

	Example:

		{
			Property1 : Type1,

			OptionalProperty : ?OptionalType
		}

	**Methods** are defined in their own single-line code block:

		Class:Method(arg1: TypeA) -> ReturnedType

	The function documentation of methods has the `:` similar to how it is used in Lua. 

	**Misc Roblox**

	Anything that is a `Model` should have it's `PrimaryPart` set.
	This does not apply if the type can be a `Folder`, meaning it's a Container object.


## Module

```
API {
	CFrameTrack : module,

	Segment : module,

	Section : Section,
	SectionBuilder : SectionBuilder,

	TrackGroup : TrackGroup,
	TrackGroupBuilder : TrackGroupBuilder,

	PhysicsRails : PhysicsRails,
	PhysicsRailsBuilder : PhysicsRailsBuilder,
}
```

## Builder Pattern

You will notice modules that end with `-Builder`.

These denote Builder Pattern constructors.

[https://en.wikipedia.org/wiki/Builder_pattern](https://en.wikipedia.org/wiki/Builder_pattern)

All of these include the methods **Build** and **Finish**.

**Build** creates a new object associated with the builder.

**Finish** does the same thing as Build, but destroys the Builder.

This means you can continue using the Builder class after building the object.

## Promise

This API uses evaera's Roblox Lua Promise

**Github Repo:** [https://github.com/evaera/roblox-lua-promise](https://github.com/evaera/roblox-lua-promise)

**Docs:** [https://eryn.io/roblox-lua-promise/lib/](https://eryn.io/roblox-lua-promise/lib/)
