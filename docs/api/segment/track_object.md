# TrackObject Segment

Creates an object, either a BasePart or a Model, that is positioned at a given point in the track.

Similar to ties in NewSmooth.

## TrackObjectSegment

**Extends [Segment](./index.md#segment)**

```rs
TrackObjectSegment : Segment {
	Object : BasePart | Model,

	Offset : CFrame,

	UseLookVector : boolean
}
```

### Properties

**Object**

The part used to make the rails. This will be cloned each time a new segment is created.

**Offset**

The offset from the CFrame

**UseLookVector**

If true, uses LookVector and applies no rotation.


### Constructors

#### fromData

```lua
TrackObjectSegment.fromData(data: table) -> TrackObjectSegment
```

##### data

```rs
{
	Name : string,

	Object : BasePart | Model,

	Offset : CFrame,

	UseLookVector : boolean
}
```

#### fromInstance

```lua
TrackObjectSegment.fromInstance(instance: Instance) -> TrackObjectSegment
```

##### instance Children

```rs
{
	Object : BasePart | Model,

	Offset : CFrameOffsetInstance,

	UseLookVector : ?BoolValue,
}
```

## TrackObjectSegmentBuilder

### Constructors

#### new

```rs
TrackObjectSegmentBuilder.new() -> TrackObjectSegmentBuilder
```

### Methods

#### WithObject

```rs
TrackObjectSegmentBuilder:WithObject(object : BasePart | Model) -> self
```

#### WithOffset

```rs
TrackObjectSegmentBuilder:WithOffset(offset : CFrame) -> self
```

#### WithUseLookVector

```rs
TrackObjectSegmentBuilder:WithUseLookVector(useLookVector : boolean) -> self
```
