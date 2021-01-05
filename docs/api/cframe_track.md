# CFrameTrack Module

A 3D line that describes the positions of your track in the workspace

## Module

```rs
CFrameTrack {
	CFrameTrack : CFrameTrack,

	IsType : function,

	PointToPoint : PointToPointCFrameTrack,
	PointToPointBuilder : PointToPointCFrameTrackBuilder,

	PointToPoint2 : PointToPointCFrameTrack2,
	PointToPoint2Builder : PointToPointCFrameTrack2Builder,

	Create : function,
	CreateFromData : function,
	CreateFromInstance : function

    IsPoints: function,
    GetPointsFromInstance : function
}
```

### Factory Pattern

The CFrameTrack module provides methods to use a factory pattern for the following functions.

Here's a list of the names used and their corresponding classes:

```rs
{
	PointToPoint = PointToPointCFrameTrack,
	PointToPoint2 = PointToPoint2CFrameTrack,
}
```

#### Create

```rs
CFrameTrack.Create(value: Instance or table) -> CFrameTrack
```

#### CreateFromData

```rs
CFrameTrack.CreateFromData(data: table) -> CFrameTrack
```

#### CreateFromInstance

```rs
CFrameTrack.CreateFromInstance(instance: Instance) -> CFrameTrack
```


## CFrameTrack

Base class for all CFrameTrack

```rs
{
    Name: string,
    Length: number,
}
```

### Constructors

#### fromData

```rs
CFrameTrack.fromData(data: table) -> CFrameTrack
```

#### fromInstance

```rs
CFrameTrack.fromInstance(instance: Instance) -> CFrameTrack
```

## PointToPoint

**Extends [CFrameTrack](#cframetrack)**

```rs
{
    IsCircuited: boolean,
    CircuitRemainder: number,
    LengthWithoutCircuitRemainder: number,

    DistanceBetweenPoints: number,

    Points: CFrame[]
}
```

### Constructors

#### fromData

```rs
PointToPointCFrameTrack.fromData(data: table) -> PointToPointCFrameTrack
```

##### data

```rs
{
    IsCircuited: boolean,
    DistanceBetweenPoints: number,

    Points: CFrame[]
}
```

#### fromInstance

```rs
PointToPointCFrameTrack.fromInstance(instance: Instance) -> PointToPointCFrameTrack
```

##### instance

```rs
{
    TrackClass: StringValue,
        // Value = "PointToPoint"

    IsCircuited: BoolValue,
    DistanceBetweenPoints: NumberValue,

    Points: PointsInstance
}
```

## PointToPointBuilder

### Constructors

#### new

```rs
PointToPointBuilder.new() -> PointToPointBuilder
```

### Methods

#### Build

```rs
PointToPointBuilder:Build() -> PointToPointCFrameTrack2
```

#### Finish

```rs
PointToPointBuilder:Build() -> PointToPointCFrameTrack2
```

#### WithPoints

```rs
PointToPointBuilder:WithPoints(points: CFrame[]) -> Self
```

#### WithPointsInstance

```rs
PointToPointBuilder:WithPointsInstance(pointsInstance: Instance) -> Self
```

#### WithIsCircuited

```rs
PointToPointBuilder:WithIsCircuited(value: boolean) -> Self
```

#### WithDistanceBetweenPoints

```rs
PointToPointBuilder:WithDistanceBetweenPoints(value: number) -> Self
```

## PointToPoint2

**Extends [CFrameTrack](#cframetrack)**

```rs
{
    IsCircuited: boolean,
    CircuitRemainder: number,
    LengthWithoutCircuitRemainder: number,

    Hasher: Hasher<CFrame>,
}
```

### Constructors

#### fromData

```rs
PointToPointCFrameTrack2.fromData(data: table) -> PointToPointCFrameTrack
```

##### data

```rs
{
    IsCircuited: boolean,
    HashInterval: number,

    Points: CFrame[]
}
```

#### fromInstance

```rs
PointToPointCFrameTrack2.fromInstance(instance: Instance) -> PointToPointCFrameTrack2
```

##### instance

```rs
{
    TrackClass: StringValue,
        // Value = "PointToPoint2"

    IsCircuited: BoolValue,
    HashInterval: ?NumberValue,

    Points: PointsInstance,
}
```

## PointToPoint2Builder

### Constructors

#### new

```rs
PointToPoint2Builder.new() -> PointToPoint2Builder
```

### Methods

#### Build

```rs
PointToPoint2Builder:Build() -> PointToPointCFrameTrack2
```

#### Finish

```rs
PointToPoint2Builder:Build() -> PointToPointCFrameTrack2
```

#### WithPoints

```rs
PointToPoint2Builder:WithPoints(points: CFrame[]) -> Self
```

#### WithPointsInstance

```rs
PointToPoint2Builder:WithPointsInstance(pointsInstance: Instance) -> Self
```

#### WithIsCircuited

```rs
PointToPoint2Builder:WithIsCircuited(value: boolean) -> Self
```

#### WithHashInterval

```rs
PointToPoint2Builder:WithHashInterval(interval: number) -> Self
```
