# BaseSection

Base class for building a section of track from a CFrameTrack

```
Section : BaseSection {
	Name : string,
}
```

### Methods

#### Create

Creates an Instance created on the given CFrameTrack from startPosition to endPosition

```lua
BaseSection:Create(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Instance
```

#### CreateAsync

Like [Create](#create), but wraps this call in a Promise and returns it.

```lua
BaseSection:CreateAsync(cframeTrack: CFrameTrack, startPosition: number, endPosition: number) -> Promise -> Instance
```

### Constructors

#### fromData

```lua
BaseSection.fromData(data: table) -> BaseSection
```

#### fromInstance

```lua
BaseSection.fromInstance(instance: Instance) -> BaseSection
```
