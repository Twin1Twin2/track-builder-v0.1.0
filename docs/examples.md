# Examples

Examples go here!

Assume MainTrack is the Track you want to build on.

## Intamin Flat Track Program

Builds a track similar to Intamin's 2 Rail track

```lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(api)
	local TrackGroup = api.TrackGroup
	local Section = api.Section

	local Segment = api.Segment
	local RailSegment = Segment.Rail
	local TrackObjectSegment = Segment.TrackObject
	local CrossbeamSegment = Segment.Crossbeam

	local CFrameTrack = api.CFrameTrack
	local mainTrack = CFrameTrack.Create(ReplicatedStorage:FindFirstChild("MainTrack"))
	
	local BASE_PART = Instance.new("Part")
	BASE_PART.Anchored = true
	BASE_PART.TopSurface = "Smooth"
	BASE_PART.BottomSurface = "Smooth"
	BASE_PART.FormFactor = "Custom"
	

	local leftRailSection = Section.fromData({
		Segment = RailSegment.fromData({
			Name = "LeftRail",
			BasePart = BASE_PART,

			Offset = Vector3.new(-3,0,0),
			Horizontal = true,
			Size = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
			Rotation = Vector3.new(),
			MeshData = {
				Mesh = "CylinderMesh",
				Scale = Vector3.new(1,1,0.2),--width is X, height is Y, and length is Z ALWAYS
				Offset = Vector3.new(),
			}
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})

	local rightRailSection = Section.fromData({
		Segment = RailSegment.fromData({
			Name = "RightRail",
			BasePart = BASE_PART,

			Offset = Vector3.new(3,0,0),
			Horizontal = true,
			Size = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
			Rotation = Vector3.new(),
			MeshData = {
				Mesh = "CylinderMesh",
				Scale = Vector3.new(1,1,0.2),--width is X, height is Y, and length is Z ALWAYS
				Offset = Vector3.new(),
			}
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})
	
	local crossbeamSection = Section.fromData({
		Segment = CrossbeamSegment.fromData({
			Name = "Crossbeam",
			BasePart = BASE_PART,
			EndOffset = Vector3.new(3,0,0),
			StartOffset = Vector3.new(-3,0,0),
			Horizontal = false,
			Size = Vector3.new(.6,.6,0),--width is X, height is Y, and length is Z ALWAYS
			Rotation = Vector3.new(),
			MeshData = {
				Mesh = "BlockMesh",
				Scale = Vector3.new(1,1,0),--width is X, height is Y, and length is Z ALWAYS
				Offset = Vector3.new(),
			},
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = false,
		BuildEnd = false,
	})

	local TIE_PART = Instance.new("Part")
	TIE_PART.Size = Vector3.new(6, 0.6, 0.6)
	TIE_PART.Anchored = true
	TIE_PART.TopSurface = "Smooth"
	TIE_PART.BottomSurface = "Smooth"
	TIE_PART.FormFactor = "Custom"

	local tieSection = Section.fromData({
		Segment = TrackObjectSegment.fromData({
			Name = "Tie",
			Object = TIE_PART,
			Offset = CFrame.new(),
			UseLookVector = false,
		}),

		Interval = 5,
		StartOffset = 0,
		Optimize = false,
		BuildEnd = true,
	})
	
	local trackGroup = TrackGroup.new()
	trackGroup.Name = "TestingTrack"
	trackGroup:Add(leftRailSection)
	trackGroup:Add(rightRailSection)
	trackGroup:Add(crossbeamSection)
	trackGroup:Add(tieSection)
	
	local model = trackGroup:Create(mainTrack, 0, mainTrack.Length)
	model.Parent = workspace
	
	warn("Finished!")
end
```

## BoxBuilderProgram

Creates a RMC Single Rail Track

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(api)
	local TrackGroup = api.TrackGroup
	local Section = api.Section

	local Segment = api.Segment
	local RailSegment = Segment.Rail
	local TrackObjectSegment = Segment.TrackObject
	local CrossbeamSegment = Segment.Crossbeam
	local BoxRailSegment = Segment.BoxRail
	local RectSegment = Segment.Rect
	local RectRailSegment = Segment.RectRail

	local CFrameTrack = api.CFrameTrack
	local mainTrack = CFrameTrack.Create(ReplicatedStorage:FindFirstChild("MainTrack"))
	
	local BASE_PART = Instance.new("Part")
	BASE_PART.Anchored = true
	BASE_PART.TopSurface = "Smooth"
	BASE_PART.BottomSurface = "Smooth"
	BASE_PART.FormFactor = "Custom"

	local WEDGE = Instance.new("WedgePart")
	WEDGE.Size = Vector3.new(0.2, 1, 1)
	WEDGE.Anchored = true
	WEDGE.Material = Enum.Material.Metal
	WEDGE.BrickColor = BrickColor.Black()
	WEDGE.TopSurface = Enum.SurfaceType.Smooth
	WEDGE.BottomSurface = Enum.SurfaceType.Smooth

	local specialMesh = Instance.new("SpecialMesh")
	specialMesh.MeshType = Enum.MeshType.Wedge
	specialMesh.Scale = Vector3.new(0.001, 1, 1)
	specialMesh.Parent = WEDGE

	local topBuilder = Section.fromData({
		Segment = BoxRailSegment.fromData({
			Name = "Top",

			TopLeft = Vector3.new(1.5, 0.3, 0),
			TopRight = Vector3.new(-1.5, 0.3, 0),
			BottomLeft = Vector3.new(1.5, -0.3, 0),
			BottomRight = Vector3.new(-1.5, -0.3, 0),

			Wedge = WEDGE,
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})

	local spineBuilder = Section.fromData({
		Segment = BoxRailSegment.fromData({
			Name = "Spine",

			TopLeft = Vector3.new(1, -0.2, 0),
			TopRight = Vector3.new(-1, -0.2, 0),
			BottomLeft = Vector3.new(1, -1.5, 0),
			BottomRight = Vector3.new(-1, -1.5, 0),

			DrawTop = false,
			DrawBottom = false,

			Wedge = WEDGE,
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})
	

	local BOTTOM_WEDGE = Instance.new("WedgePart")
	BOTTOM_WEDGE.Size = Vector3.new(0.05, 0, 0)
	BOTTOM_WEDGE.Anchored = true
	BOTTOM_WEDGE.Material = Enum.Material.Metal
	BOTTOM_WEDGE.BrickColor = BrickColor.Black()
	BOTTOM_WEDGE.TopSurface = Enum.SurfaceType.Smooth
	BOTTOM_WEDGE.BottomSurface = Enum.SurfaceType.Smooth	

	local bottomBuilder = Section.fromData({
		Segment = RectRailSegment.fromData({
			StartOffset1 = Vector3.new(1.5, -1.5, 0),
			StartOffset2 = Vector3.new(-1.5, -1.5, 0),
			
			EndOffset1 = Vector3.new(1.5, -1.5, 0),
			EndOffset2 = Vector3.new(-1.5, -1.5, 0),

			UseStart = true,

			Wedge = BOTTOM_WEDGE,
		}),
		
		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})
	
	-- Creates a ChainLift
	local CHAIN_PART = BASE_PART:Clone()
	CHAIN_PART.Size = Vector3.new(1, 0.8, 1)
	CHAIN_PART.BrickColor = BrickColor.new("Dark stone grey")
	CHAIN_PART.CanCollide = false
	CHAIN_PART.Anchored = true

	local CHAIN_IMAGE = Instance.new("Texture")
	CHAIN_IMAGE.StudsPerTileU = 1
	CHAIN_IMAGE.StudsPerTileV = 1
	CHAIN_IMAGE.Texture = "http://www.roblox.com/asset/?id=56334448"
	CHAIN_IMAGE.Face = "Top"
	CHAIN_IMAGE.Parent = CHAIN_PART

	local chainSection = Section.fromData({
		Segment = RailSegment.fromData({
			Name = "Chain",

			BasePart = CHAIN_PART,
			Offset = Vector3.new(0, 0.3, 0),
			Size = Vector3.new(1, 0.2, 0),
			Rotation = Vector3.new(),
			Horizontal = false,
		}),

		Interval = 5,
		StartOffset = 0,
		Optimize = true,
		BuildEnd = false,
	})

	local trackGroup = TrackGroup.new()
	trackGroup.Name = "TestingTrack"
	trackGroup:Add(topBuilder)
	trackGroup:Add(spineBuilder)
	trackGroup:Add(bottomBuilder)
	
	local model = trackGroup:Create(mainTrack, 0, mainTrack.Length)

	local chainModel = chainSection:Create(mainTrack, 410, 670)
	chainModel.Parent = model

	model.Parent = workspace

	warn("Finished!")
end
```