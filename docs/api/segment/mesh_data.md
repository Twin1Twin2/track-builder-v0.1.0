# MeshData

This page defines documentation for MeshData and MeshDataBuilder

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
MeshData.fromMesh(meshInstance: MeshInstance) -> MeshData
```

Creates MeshData from a given Mesh.

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