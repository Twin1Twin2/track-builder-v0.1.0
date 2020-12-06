# PhysicsRails

Builds all the RailSegments it holds along a section of track at once and gives it physics properties.
These physics can help move a track.

Meant for physics based coasters.

```
PhysicsRails : BaseSection {
	Name : string,

	Rails : RailSegments [],
	Interval : positiveNumber,	
}
```

### Methods

#### Create

Creates a Model whose children are segments created from startPosition to endPosition

```lua
Segment:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Model
```

#### CreateAsync

Like Create, but wraps this call in a Promise and returns it.

```lua
Segment:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Promise -> Model
```

### Constructors

#### fromData

```lua
Segment.fromData(data: table) -> Segment
```

##### data

```rs
{
	Name : string,

	Rails : RailSegments [],
	Interval : positiveNumber,
}
```

#### fromInstance

```lua
Segment.fromInstance(instance: Instance) -> Segment
```

##### instance Children

```rs
{
	Rails : Instance, // see RailSegment.fromInstance

	Interval : NumberValue,	
}
```