# CFrameTrack

A 3D line that describes the positions of your track in the workspace

## Module

```
CFrameTrack {
	CFrameTrack : CFrameTrack,

	IsType : function,

	PointToPoint : PointToPointCFrameTrack
	PointToPoint2 : PointToPointCFrameTrack2,

	Create : function,
	CreateFromData : function,
	CreateFromInstance : function
}
```

### Create Functions

Factory Pattern

```
{
	PointToPoint = PointToPointCFrameTrack,
	PointToPoint2 = PointToPoint2CFrameTrack,
}
```

#### Create

```
CFrameTrack.Create(value: Instance or table) -> CFrameTrack
```

#### CreateFromData

```
CFrameTrack.CreateFromData(data: table) -> CFrameTrack
```

#### CreateFromInstance

```
CFrameTrack.CreateFromInstance(instance: Instance) -> CFrameTrack
```


## CFrameTrack

### Constructors

#### fromInstance

```
PointToPoint2CFrameTrack.fromInstance(instance: Instance) -> PointToPoint2CFrameTrack
```

## PointToPoint

```
instance: Instance
    +--> TrackClass: StringValue
    |       +-- Value: "PointToPoint"
    +--> IsCircuited: BoolValue
    +--> DistanceBetweenPoints: NumberValue
    +--> Points: Instance
            |--> 1: CFrameInstance
            |--> 2: CFrameInstance
            |--> ...
            |--> N: CFrameInstance
```


## PointToPoint2

### Constructors

#### fromInstance

```
PointToPoint2CFrameTrack.fromInstance(instance: Instance) -> PointToPoint2CFrameTrack
```

##### instance

```
instance: Instance
    +--> TrackClass: StringValue
    |       +-- Value: "PointToPoint2"
    +--> IsCircuited: BoolValue
    +--> HashValue: NumberValue
    +--> Points: Instance
            |--> 1: CFrameInstance
            |--> 2: CFrameInstance
            |--> ...
            |--> N: CFrameInstance
```