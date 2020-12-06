# TrackGroup

Builds all the Sections it holds along a section of track at once.

```
TrackGroup : BaseSection {
	Name : string,

	Sections : BaseSection[],
}
```

### Methods

#### Create

Creates a Model

```lua
TrackGroup:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Model
```

#### CreateAsync

Like Create, but wraps this call in a Promise and returns it.

```lua
TrackGroup:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Promise -> Model
```

### Constructors

#### fromData

```lua
TrackGroup.fromData(data: table) -> TrackGroup
```

##### data

```rs
{
	Name : ?string,

	Sections : BaseSection[]
}
```

#### fromInstance

```lua
TrackGroup.fromInstance(instance: Instance) -> TrackGroup
```

##### instance Children

```rs
{

}
```