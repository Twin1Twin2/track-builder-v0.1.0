# Section API

Builds the given Segment at a set position interval along a section of track.

```
Section : BaseSection {
	Name : string,
	Segment : Segment,

	Interval : positiveNumber,
	StartOffset : number,

	Optimize : boolean,
	BuildEnd : boolean,
}
```

### Methods

#### Create

Creates a Model whose children are segments created from startPosition to endPosition

```lua
Section:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Model
```

#### CreateAsync

Like Create, but wraps this call in a Promise and returns it.

```lua
Section:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Promise -> Model
```

### Constructors

#### fromData

```lua
Section.fromData(data: table) -> Section
```

##### data

```rs
{
	Name : ?string,
	Segment : Segment,

	Interval : positiveNumber,
	StartOffset : number,

	Optimize : boolean,
	BuildEnd : boolean,
}
```

#### fromInstance

```lua
Section.fromInstance(instance: Instance) -> Section
```

##### instance Children

```rs
{
	Name : StringValue,
	Segment : Instance, // see Segment.CreateFromInstance

	Interval : NumberValue,
	StartOffset : NumberValue,

	Optimize : BoolValue,
	BuildEnd : BoolValue,
}
```