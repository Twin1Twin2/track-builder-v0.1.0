# MidTrackObject Segment

Creates an object, either a BasePart or a Model, that is positioned at a given point in the track.

Compared to TrackObject, will position the object between two TrackPositions.

## MidTrackObjectSegment

**Extends [Segment](./index.md#segment)**

```rs
MidTrackObjectSegment : Segment {
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
MidTrackObjectSegment.fromData(data: table) -> MidTrackObjectSegment
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
MidTrackObjectSegment.fromInstance(instance: Instance) -> MidTrackObjectSegment
```

##### instance Children

```rs
{
	Object : BasePart | Model,

	Offset : CFrameOffsetInstance,

	UseLookVector : ?BoolValue,
}
```

## MidTrackObjectSegmentBuilder

### Constructors

#### new

```rs
MidTrackObjectSegmentBuilder.new() -> MidTrackObjectSegmentBuilder
```

### Methods

#### WithObject

```rs
MidTrackObjectSegmentBuilder:WithObject(object : BasePart | Model) -> self
```

#### WithOffset

```rs
MidTrackObjectSegmentBuilder:WithOffset(offset : CFrame) -> self
```

#### WithUseLookVector

```rs
MidTrackObjectSegmentBuilder:WithUseLookVector(useLookVector : boolean) -> self
```
