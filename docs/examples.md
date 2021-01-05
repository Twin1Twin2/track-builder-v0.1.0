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
	BASE_PART.Material = Enum.Material.Metal
	BASE_PART.BrickColor = BrickColor.new("Really black")
	

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
		
		SegmentLength = 5,
		SectionStart = 0,
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
		
		SegmentLength = 5,
		SectionStart = 0,
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
		
		SegmentLength = 5,
		SectionStart = 0,
		Optimize = false,
		BuildEnd = false,
	})

	local TIE_PART = BASE_PART:Clone()
	TIE_PART.Size = Vector3.new(6, 0.6, 0.6)
	TIE_PART.Anchored = true

	local tieSection = Section.fromData({
		Segment = TrackObjectSegment.fromData({
			Name = "Tie",
			Object = TIE_PART,
			Offset = CFrame.new(),
			UseLookVector = false,
		}),

		SegmentLength = 5,
		SectionStart = 0,
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
	local TrackGroupBuilder = api.TrackGroupBuilder
	local SectionBuilder = api.SectionBuilder

	local Segment = api.Segment

	local RailSegmentBuilder = Segment.RailBuilder
	local MidTrackObjectSegmentBuilder = Segment.MidTrackObjectBuilder
	local BoxRailSegmentBuilder = Segment.BoxRailBuilder
	local RectSegmentBuilder = Segment.RectBuilder
	local RectRailSegmentBuilder = Segment.RectRailBuilder

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
	
	local topSection = SectionBuilder.new()
		:WithName("Top")
		:WithSegment(BoxRailSegmentBuilder.new()
			:WithWedge(WEDGE)
			:WithTopLeft(Vector3.new(1.5, 0.3, 0))
			:WithTopRight(Vector3.new(-1.5, 0.3, 0))
			:WithBottomLeft(Vector3.new(1.5, -0.3, 0))
			:WithBottomRight(Vector3.new(-1.5, -0.3, 0))
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()
	
	local spineSection = SectionBuilder.new()
		:WithName("Spine")
		:WithSegment(BoxRailSegmentBuilder.new()
			:WithWedge(WEDGE)
			:WithTopLeft(Vector3.new(1, -0.2, 0))
			:WithTopRight(Vector3.new(-1, -0.2, 0))
			:WithBottomLeft(Vector3.new(1, -1.5, 0))
			:WithBottomRight(Vector3.new(-1, -1.5, 0))
			:WithDrawTop(false)
			:WithDrawBottom(false)
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()
	

	local BOTTOM_WEDGE = Instance.new("WedgePart")
		BOTTOM_WEDGE.Size = Vector3.new(0.05, 0, 0)
		BOTTOM_WEDGE.Anchored = true
		BOTTOM_WEDGE.Material = Enum.Material.Metal
		BOTTOM_WEDGE.BrickColor = BrickColor.Black()
		BOTTOM_WEDGE.TopSurface = Enum.SurfaceType.Smooth
		BOTTOM_WEDGE.BottomSurface = Enum.SurfaceType.Smooth
	
	local bottomSection = SectionBuilder.new()
		:WithName("Bottom")
		:WithSegment(RectRailSegmentBuilder.new()
			:WithWedge(WEDGE)
			:WithUseStart(true)
			:WithStartOffset1(Vector3.new(1.2, -1.5, 0))
			:WithStartOffset2(Vector3.new(-1.2, -1.5, 0))
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()
	
	local CHAIN_PART = BASE_PART:Clone()
		CHAIN_PART.Size = Vector3.new(1, 0.8, 1)
		CHAIN_PART.BrickColor = BrickColor.new("Dark stone grey")
		CHAIN_PART.CanCollide = false

	local CHAIN_IMAGE = Instance.new("Texture")
		CHAIN_IMAGE.StudsPerTileU = 1
		CHAIN_IMAGE.StudsPerTileV = 1
		CHAIN_IMAGE.Texture = "http://www.roblox.com/asset/?id=56334448"
		CHAIN_IMAGE.Face = "Top"
		CHAIN_IMAGE.Parent = CHAIN_PART
	
	local chainSection = SectionBuilder.new()
		:WithName("Chain")
		:WithSegment(RailSegmentBuilder.new()
			:WithBasePart(CHAIN_PART)
			:WithSize(Vector3.new(1, 0.2, 0))
			:WithOffset(Vector3.new(0, 0.3, 0))
			:WithRotation(Vector3.new())
			:WithHorizontal(false)
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()
		
	local trackGroup = TrackGroupBuilder.new()
		:WithName("BoxRailTrack")
		:WithSection(topSection)
		:WithSection(spineSection)
		:WithSection(bottomSection)
		:Finish()
		
	local model = trackGroup:Create(mainTrack, 0, mainTrack.Length)
	local chainModel = chainSection:Create(mainTrack, 410, 670)
		chainModel.Parent = model
	
	model.Parent = workspace
	
	warn("Finished!")
end
```