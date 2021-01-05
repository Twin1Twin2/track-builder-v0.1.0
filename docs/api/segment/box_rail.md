## BoxRail Segment

Creates a Rail using Triangles based on a box of 4 points. Extrudes a Box from these 4 points.

## BoxRailSegment

**Extends [Segment](./index.md#segment)**

```rs
BoxRailSegment : Segment {
	Wedge : WedgePart,

	TopLeft : Vector3,
	TopRight : Vector3,
	BottomLeft : Vector3,
	BottomRight : Vector3,

	DrawTop : boolean,
	DrawBottom : boolean,
	DrawLeft : boolean,
	DrawRight : boolean,
}
```

### Properties

**Wedge**

The wedge used to make the box. This will be cloned each time a new segment is created.

**TopLeft**

**TopRight**

**BottomLeft**

**BottomRight**

**DrawTop**

**DrawBottom**

**DrawLeft**

**DrawRight**


### Constructors

#### fromData

```lua
BoxRailSegment.fromData(data: table) -> BoxRailSegment
```

##### data

```rs
{
	Name : string,

	Wedge : WedgePart,

	TopLeft : Vector3,
	TopRight : Vector3,
	BottomLeft : Vector3,
	BottomRight : Vector3,

	DrawTop : ?boolean,
	DrawBottom : ?boolean,
	DrawLeft : ?boolean,
	DrawRight : ?boolean,
}
```

#### fromInstance

```lua
BoxRailSegment.fromInstance(instance: Instance) -> BoxRailSegment
```

##### instance Children

```rs
{
	Wedge : ?WedgePart,

	TopLeft : Vector3OffsetInstance,
	TopRight : Vector3OffsetInstance,
	BottomLeft : Vector3OffsetInstance,
	BottomRight : Vector3OffsetInstance,

	DrawTop : ?BoolValue,
	DrawBottom : ?BoolValue,
	DrawLeft : ?BoolValue,
	DrawRight : ?BoolValue,
}
```

## BoxRailSegmentBuilder

### Constructors

#### new

```rs
BoxRailSegmentBuilder.new() -> BoxRailSegmentBuilder
```

### Methods

#### WithWedge

```rs
BoxRailSegmentBuilder:WithWedge(wedge : WedgePart) -> self
```

#### WithTopLeft

```rs
BoxRailSegmentBuilder:WithTopLeft(offset : Vector3) -> self
```

#### WithTopRight

```rs
BoxRailSegmentBuilder:WithTopRight(offset : Vector3) -> self
```

#### WithBottomLeft

```rs
BoxRailSegmentBuilder:WithBottomLeft(offset : Vector3) -> self
```

#### WithBottomRight

```rs
BoxRailSegmentBuilder:WithBottomRight(offset : Vector3) -> self
```

#### WithDrawTop

```rs
BoxRailSegmentBuilder:WithDrawTop(value : boolean) -> self
```

#### WithDrawBottom

```rs
BoxRailSegmentBuilder:WithDrawBottom(value : boolean) -> self
```

#### WithDrawLeft

```rs
BoxRailSegmentBuilder:WithDrawLeft(value : boolean) -> self
```

#### WithDrawRight

```rs
BoxRailSegmentBuilder:WithDrawRight(value : boolean) -> self
```