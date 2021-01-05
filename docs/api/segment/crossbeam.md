# Crossbeam Segment

Creates a BasePart that is positioned and sized parallel to the Track.
Similar to Crossbeams in NewSmooth plugins

## CrossbeamSegment

**Extends [Segment](./index.md#segment)**

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

	Offset : Vector3OffsetInstance,
	Size : ?Vector3Value,
	Rotation : ?Vector3Value,
	Horizontal : ?BoolValue,

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