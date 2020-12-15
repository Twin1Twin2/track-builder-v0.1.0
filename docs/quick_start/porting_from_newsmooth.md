# Porting From NewSmooth

!!! warning

	This tutorial is still a work in progress

For this tutorial, we will be referencing the Intamin NewSmooth converter.

Specifically, we will be looking at the `SuperSpine` TrackType.

Additionally, we will be adding our own twist to the crossbeams that you cannot normally do with NewSmooth without switching converters.

!!! warning

	This tutorial will *not* go over setting up physics for physics based coasters.

_____

## Rails

```lua
-- physics rails
local rails = {
	leftrail = {
		current = Vector3.new(-3,0,0),
		previous = Vector3.new(-3,0,0),
		Horizontal = true,
		BrickColor = ba.RailColor,
		Size = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
		Rotation = Vector3.new(),
		Mesh = "CylinderMesh",
		Meshscale = Vector3.new(1,1,0.2),--width is X, height is Y, and length is Z ALWAYS
		Meshoffset = Vector3.new(),
		Properties = {--any properties you want on the bricks like Friction or Material or Transparency
			Friction = 0,
		}
	},
	rightrail = {
		current = Vector3.new(3,0,0),
		previous = Vector3.new(3,0,0),
		Horizontal = true,
		BrickColor = ba.RailColor,
		Size = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
		Rotation = Vector3.new(),
		Mesh = "CylinderMesh",
		Meshoffset = Vector3.new(),
		Meshscale = Vector3.new(1,1,0.2),--width is X, height is Y, and length is Z ALWAYS
		Properties = {
			Friction = 0,
		},
	},
}

--- Super Spine rails
rails = {
	beam1 = {
		current = Vector3.new(0,-1-0.3,0),
		previous = Vector3.new(0,-1-0.3,0),
		Horizontal = false,
		BrickColor = ba.SpineColor,
		Size = Vector3.new(1.8,2,0),--width is X, height is Y, and length is Z ALWAYS
		Rotation = Vector3.new(),
		Mesh = "BlockMesh",
		Meshscale = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
		Meshoffset = Vector3.new(),
		Properties = {
			CanCollide = false,
		},
	},
	beam2 = {
		current = Vector3.new(0,-2.3,0),
		previous = Vector3.new(0,-2.3,0),
		Horizontal = true,
		BrickColor = ba.SpineColor,
		Size = Vector3.new(1.8,1.8,0),--width is X, height is Y, and length is Z ALWAYS
		Rotation = Vector3.new(),
		Mesh = "CylinderMesh",
		Meshscale = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
		Meshoffset = Vector3.new(),
		Properties = {
			CanCollide = false,
		},
	},
},
```

RailSegment

### Misc Part Properties

- BrickColor
- Properties

Works by cloning the given part.

See size for Size property

### Current and Previous

For all rails, the `current` and `previous` are the exact same. Crossbeams have a different `current` and `previous`.

`RailSegment.Offset`

### Horizontal

Horizontal is a value which tells if this rail should be rotated along the _ axis. It is used primarily by CylinderMesh rails.

> In the future, this could be changed to allow all axis.

`RailSegment.Horizontal`

### Size

`RailSegment.Size`

### Rotation

`RailSegment.Rotation`


## Ties

```lua
-- Super Spine ties
ties = {
	tie1 = {
		ClassName = "Part",
		offset = CFrame.new(0,0,0),
		BrickColor = ba.TieColor,
		Mesh = "BlockMesh",
		Meshscale = Vector3.new(1,1,1),--width is X, height is Y, and length is Z ALWAYS
		Meshoffset = Vector3.new(),
		Properties = {
			CanCollide = false,
			Size = Vector3.new(6, .6, .6),
		},
	},
},
```

TrackObject

A TrackObject is an object placed at a given point on the track. It does not require resizing as Rails and Crossbeams stretch to expand to the whole segment.
A TrackObject's object can be either anything that is a BasePart or a Model with it's PrimaryPart set.
It was named `TrackObject` instead of `Tie` to signify the versatility of this `Segment`. You will see in the later section **Brakes, Transport, and MagLaunch/Brakes** how it could it be used for these elements.

### Misc Part Properties

- ClassName
- BrickColor
- Mesh
- MeshScale
- MeshOffset
- Properties

`TrackObject.Object`

### Offset

`TrackObject.Offset`


## Crossbeams

```lua
-- Super Spine Crossbeams
crossbeams = {
	crossbeam = {
		current = Vector3.new(3,0,0),
		previous = Vector3.new(-3,0,0),
		Horizontal = false,
		BrickColor = ba.SpineColor,
		Size = Vector3.new(.6,.6,0),--width is X, height is Y, and length is Z ALWAYS
		Rotation = Vector3.new(),
		Mesh = "BlockMesh",
		Meshscale = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
		Meshoffset = Vector3.new(),
		Properties = {
			CanCollide = false,
		},
	},
},
```

### Misc Part Properties

- BrickColor
- Properties

### Current

`CrossbeamSegment.EndOffset`

### Previous

`CrossbeamSegment.StartOffset`

### Horizontal

`CrossbeamSegment.Horizontal`

### Size

`CrossbeamSegment.Size`

### Rotation

`CrossbeamSegment.Rotation`

### MeshData

`CrossbeamSegment.MeshData`

Similar to RailSegment's MeshData.

## Chainlift

A Chainlift is just a square rail with a chain texture.


## Brakes, Transport, and MagLaunch/Brakes

These elements in NewSmooth are designed to stretch to fit a variety of Segment lengths.

It is recommended you convert these to a model and use them as TrackObjects.


