
local DEFAULT_WEDGE = Instance.new("WedgePart")
DEFAULT_WEDGE.Anchored = true
DEFAULT_WEDGE.TopSurface = Enum.SurfaceType.Smooth
DEFAULT_WEDGE.BottomSurface = Enum.SurfaceType.Smooth

local specialMesh = Instance.new("SpecialMesh")
specialMesh.MeshType = Enum.MeshType.Wedge
specialMesh.Scale = Vector3.new(0.001, 1, 1)
specialMesh.Parent = DEFAULT_WEDGE

return DEFAULT_WEDGE