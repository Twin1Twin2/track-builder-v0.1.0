# Segment (Module)

Describes how to build a piece of track.

## Module

```rs
Segment {
	Segment : Segment,
	IsType : function(object : any) -> (boolean, ?string),

	MeshData : MeshData,

	Rail : RailSegment,
	RailBuilder : RailSegmentBuilder,

	TrackObject : TrackObjectSegment,
	TrackObjectBuilder : TrackObjectSegmentBuilder,

	MidTrackObject : MidTrackObjectSegment,
	MidTrackObjectBuilder : MidTrackObjectSegmentBuilder,

	Crossbeam : CrossbeamSegment,
	CrossbeamBuilder : CrossbeamSegmentBuilder,

	Rect : RectSegment,
	RectBuilder : RectSegmentBuilder,

	RectRail : RectRailSegment,
	RectRailBuilder : RectRailSegmentBuilder,

	Box : BoxSegment,
	BoxBuilder : BoxSegmentBuilder,

	Create : function(object : table | Instance) -> Segment,
	CreateFromData : function(data : table) -> Segment,
	CreateFromInstance : function(instance : Instance) -> Segment,
}
```

### IsType

```
Segment.IsType(object : any) -> boolean, ?string
```

Type checking function for a Segment. Returns true if a Segment

### Create

```
Segment.Create(object : any) -> boolean, ?string
```

Type checking function for a Segment. Returns true if a Segment

### CreateFromData

```
Segment.CreateFromData(object : any) -> boolean, ?string
```

Factory pattern for creating a Segment.

Table must have a string called `SegmentType` as a value.

### CreateFromInstance

```
Segment.CreateFromInstance(object : any) -> boolean, ?string
```

Factory pattern for creating a Segment. Creates a Segment from an Instance.

Instance must have a `StringValue` named `SegmentType` as one of it's children.

### Factory Pattern

The Segment module provides methods to use a factory pattern.

Here's a list of the names used and their corresponding classes:

```lua
{
	Rail = RailSegment,
    TrackObject = TrackObjectSegment,
	MidTrackObject = MidTrackObjectSegment,
	Crossbeam = CrossbeamSegment,
	Rect = RectSegment,
	RectRail = RectRailSegment,
	BoxRail = BoxRailSegment,
}
```


## Segment

Base Class for all Segments

```
Segment {
	Name : string
}
```

### Methods

#### Create

Produces a new segment instance based off of the two CFrame positions given

```lua
Segment:CreateAsync(startCFrame: CFrame, endCFrame: CFrame) -> Instance
```

#### CreateAsync

Like Create, but wraps this call in a Promise and returns it.

```lua
Segment:CreateAsync(startCFrame: CFrame, endCFrame: CFrame) -> Promise -> Instance
```

## MeshData

```
{
	Mesh : string,
	MeshType : Enum.MeshType,

	Offset : Vector3,
	Scale : Vector3,
}
```

Mesh data struct for the NewSmooth Algorithm.

Used by:

- [RailSegment](#railsegment)
- [CrossbeamSegment](#crossbeamsegment)

### Properties

#### Mesh

### Constructors

#### fromData

```lua
MeshData.fromData(data: table) -> MeshData
```

##### data

```rs
{
	Mesh : string,
	MeshType : Enum.MeshType,

	Offset : Vector3,
	Scale : Vector3,
}
```

#### fromInstance

```lua
MeshData.fromInstance(instance: Instance) -> MeshData
```

##### instance Children

```rs
{
	Mesh : StringValue,
	MeshType : StringValue,

	Offset : Vector3Value,
	Scale : Vector3Value,
}
```

#### fromMesh

```lua
MeshData.fromInstance(instance: Instance) -> MeshData
```

Instance must have a child which is a Mesh.

## MeshDataBuilder

```
MeshDataBuilder {
	Mesh : string,
	MeshType : string,

	Offset : Vector3,
	Scale : Vector3,
}
```

### Methods

#### WithMesh

```rs
MeshDataBuilder:WithMesh(mesh : string) -> self
```

#### WithMeshType

```rs
MeshDataBuilder:WithMeshType(mesh : string) -> self
```

#### WithOffset

```rs
MeshDataBuilder:WithOffset(offset : Vector3) -> self
```

#### WithScale

```rs
MeshDataBuilder:WithScale(scale : Vector3) -> self
```

## RailSegment

**Extends [Segment](#segment)**

Creates a BasePart that is positioned and sized parallel to the Track.
Similar to Rails in NewSmooth plugins

```rs
RailSegment : Segment {
	BasePart : BasePart,

	Offset : Vector3,
	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : MeshData,
}
```

### Properties

**BasePart**

The part used to make the rails. This will be cloned each time a new segment is created.

**Offset**

The offset from the CFrame

**Size**

Z is ignored

**Rotation**

Rotation

**Horizontal**

If this is horizontal. Used by CylinderMesh rails

**MeshData**

Data for a mesh that will be added to the rail on segment creation.

See [MeshData](#meshdata)


### Constructors

#### fromData

```lua
RailSegment.fromData(data: table) -> RailSegment
```

##### data

```rs
{
	Name : string,

	BasePart : BasePart,

	Offset : Vector3,
	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : ?MeshData,
}
```

#### fromInstance

```lua
RailSegment.fromInstance(instance: Instance) -> RailSegment
```

##### instance Children

```rs
{
	BasePart : BasePart,

	Offset : Vector3Value,
	Size : Vector3Value,
	Rotation : Vector3Value,
	Horizontal : BoolValue,

	MeshData : Instance, // see MeshData.fromInstance
}
```

## RailSegmentBuilder

### Constructors

#### new

```rs
RailSegmentBuilder.new() -> RailSegmentBuilder
```

### Methods

#### WithBasePart

```rs
RailSegmentBuilder:WithBasePart(basePart : BasePart) -> self
```

#### WithOffset

```rs
RailSegmentBuilder:WithOffset(offset : Vector3) -> self
```

#### WithSize

```rs
RailSegmentBuilder:WithSize(size : Vector3) -> self
```

#### WithHorizontal

```rs
RailSegmentBuilder:WithHorizontal(horizontal : boolean) -> self
```

#### WithMeshData

```rs
RailSegmentBuilder:WithMeshData(meshData : MeshData) -> self
```

## TrackObjectSegment

**Extends [Segment](#segment)**

Creates an object, either a BasePart or a Model, that is positioned at a given point in the track.

Similar to ties in NewSmooth.

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

	Offset : CFrameValue,

	UseLookVector : BoolValue,
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

## MidTrackObjectSegment

**Extends [Segment](#segment)**

Creates an object, either a BasePart or a Model, that is positioned at a given point in the track.

Compared to TrackObject, will position the object between two TrackPositions.

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

	Offset : CFrameValue,

	UseLookVector : BoolValue,
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

## CrossbeamSegment

**Extends [Segment](#segment)**

Creates a BasePart that is positioned and sized parallel to the Track.
Similar to Crossbeams in NewSmooth plugins

```rs
CrossbeamSegment : Segment {
	BasePart : BasePart,

	StartOffset : Vector3,
	EndOffset : Vector3,

	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : MeshData,
}
```

### Properties

**BasePart**

The part used to make the rails. This will be cloned each time a new segment is created.

**StartOffset**

The offset from the CFrame

**EndOffset**

The offset from the CFrame

**Size**

Z is ignored

**Rotation**

Rotation

**Horizontal**

If this is horizontal. Used by CylinderMesh rails

**MeshData**

Data for a mesh that will be added to the rail on segment creation.

See [MeshData](#meshdata)


### Constructors

#### fromData

```lua
CrossbeamSegment.fromData(data: table) -> CrossbeamSegment
```

##### data

```rs
{
	Name : string,

	BasePart : BasePart,

	Offset : Vector3,
	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : ?MeshData,
}
```

#### fromInstance

```lua
CrossbeamSegment.fromInstance(instance: Instance) -> CrossbeamSegment
```

##### instance Children

```rs
{
	BasePart : BasePart,

	Offset : Vector3Value,
	Size : Vector3Value,
	Rotation : Vector3Value,
	Horizontal : BoolValue,

	MeshData : Instance, // see MeshData.fromInstance
}
```

## CrossbeamSegmentBuilder

### Constructors

#### new

```rs
CrossbeamSegmentBuilder.new() -> CrossbeamSegmentBuilder
```

### Methods

#### WithBasePart

```rs
CrossbeamSegmentBuilder:WithBasePart(basePart : BasePart) -> self
```

#### WithStartOffset

```rs
CrossbeamSegmentBuilder:WithStartOffset(offset : Vector3) -> self
```

#### WithEndOffset

```rs
CrossbeamSegmentBuilder:WithEndOffset(offset : Vector3) -> self
```

#### WithSize

```rs
CrossbeamSegmentBuilder:WithSize(size : Vector3) -> self
```

#### WithHorizontal

```rs
CrossbeamSegmentBuilder:WithHorizontal(horizontal : boolean) -> self
```

#### WithMeshData

```rs
CrossbeamSegmentBuilder:WithMeshData(meshData : MeshData) -> self
```

## RectSegment

**Extends [Segment](#segment)**

Creates a Rectangle made out of 2 triangle/wedges and positioned at a given point in the track.

```rs
RectSegment : Segment {
	Wedge : WedgePart,

	P0 : Vector3,
	P1 : Vector3,
	P2 : Vector3,
	P3 : Vector3,
}
```

### Properties

**Wedge**

The WedgePart used to make the rectangle. This will be cloned each time a new segment is created.

**P0**

Offset 1

**P1**

Offset 2

**P2**

Offset 3

**P3**

Offset 4


### Constructors

#### fromData

```lua
RectSegment.fromData(data: table) -> RectSegment
```

##### data

```rs
{
	Name : string,

	Wedge : WedgePart,

	P0 : Vector3,
	P1 : Vector3,
	P2 : Vector3,
	P3 : Vector3,
}
```

#### fromInstance

```lua
RectSegment.fromInstance(instance: Instance) -> RectSegment
```

##### instance Children

```rs
{
	Wedge : WedgePart,

	P0 : Vector3Value,
	P1 : Vector3Value,
	P2 : Vector3Value,
	P3 : Vector3Value,
}
```

## RectSegmentBuilder

### Constructors

#### new

```rs
RectSegmentBuilder.new() -> RectSegmentBuilder
```

### Methods

#### WithWedge

```rs
RectSegmentBuilder:WithWedge(basePart : BasePart) -> self
```

#### WithP0

```rs
RectSegmentBuilder:WithP0(offset : Vector3) -> self
```

#### WithP1

```rs
RectSegmentBuilder:WithP1(offset : Vector3) -> self
```

#### WithP2

```rs
RectSegmentBuilder:WithP2(offset : Vector3) -> self
```

#### WithP3

```rs
RectSegmentBuilder:WithP3(offset : Vector3) -> self
```

## RectRailSegment

**Extends [Segment](#segment)**

Creates a BasePart that is positioned and sized parallel to the Track.
Similar to Rails in NewSmooth plugins

```rs
RectRailSegment : Segment {
	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

### Properties

**Wedge**

**StartOffset1**

Offset relative to the start position

**StartOffset2**

Offset relative to the start position

**EndOffset1**

Offset relative to the end position

**EndOffset2**

Offset relative to the end position

### Constructors

#### fromData

```lua
RectRailSegment.fromData(data: table) -> RectRailSegment
```

##### data

```rs
{
	Name : string,

	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

#### fromInstance

```lua
RectRailSegment.fromInstance(instance: Instance) -> RectRailSegment
```

##### instance Children

```rs
{
	Wedge : WedgePart,

	StartOffset1 : Vector3Value,
	StartOffset2 : Vector3Value,
	EndOffset1 : Vector3Value,
	EndOffset2 : Vector3Value,
}
```

## RectRailSegmentBuilder

```rs
{
	Name : string,

	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

### Constructors

#### new

```rs
RectRailSegmentBuilder.new() -> RectRailSegmentBuilder
```

### Methods

#### WithWedge

```rs
RectRailSegmentBuilder:WithWedge(wedge : WedgePart) -> self
```

#### WithOffset

```rs
RectRailSegmentBuilder:WithOffset(offset : Vector3) -> self
```

## BoxRailSegment

**Extends [Segment](#segment)**

Creates a BasePart that is positioned and sized parallel to the Track.
Similar to Rails in NewSmooth plugins

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
	Wedge : WedgePart,

	TopLeft : Vector3Value,
	TopRight : Vector3Value,
	BottomLeft : Vector3Value,
	BottomRight : Vector3Value,

	DrawTop : BoolValue,
	DrawBottom : BoolValue,
	DrawLeft : BoolValue,
	DrawRight : BoolValue,
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


