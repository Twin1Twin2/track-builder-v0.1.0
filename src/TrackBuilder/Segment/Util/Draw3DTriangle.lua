-- Thanks to EgoMoose!
-- https://github.com/EgoMoose/Articles/blob/master/3d%20triangles/3D%20triangles.md

local function Draw3DTriangle(a, b, c, wedge, parent)
	local edges = {
		{longest = (c - a), other = (b - a), origin = a},
		{longest = (a - b), other = (c - b), origin = b},
		{longest = (b - c), other = (a - c), origin = c}
	};

	local edge = edges[1];
	for i = 2, #edges do
		if edges[i].longest.magnitude > edge.longest.magnitude then
			edge = edges[i];
		end
	end

	local theta = math.acos(edge.longest.unit:Dot(edge.other.unit));
	local w1 = math.cos(theta) * edge.other.magnitude;
	local w2 = edge.longest.magnitude - w1;
	local h = math.sin(theta) * edge.other.magnitude;

	local p1 = edge.origin + edge.other * 0.5;
	local p2 = edge.origin + edge.longest + (edge.other - edge.longest) * 0.5;

	local right = edge.longest:Cross(edge.other).unit;
	local up = right:Cross(edge.longest).unit;
	local back = edge.longest.unit;

	local cf1 = CFrame.new(
		p1.x, p1.y, p1.z,
		-right.x, up.x, back.x,
		-right.y, up.y, back.y,
		-right.z, up.z, back.z
	);

	local cf2 = CFrame.new(
		p2.x, p2.y, p2.z,
		right.x, up.x, -back.x,
		right.y, up.y, -back.y,
		right.z, up.z, -back.z
	);

	local sizeX = wedge.Size.X	-- reuse the wedge's size

	-- put it all together by creating the wedges
	local wedge1 = wedge:Clone();
	wedge1.Size = Vector3.new(sizeX, h, w1);
	wedge1.CFrame = cf1;
	wedge1.Parent = parent;

	local wedge2 = wedge:Clone();
	wedge2.Size = Vector3.new(sizeX, h, w2);
	wedge2.CFrame = cf2;
	wedge2.Parent = parent;
end


return Draw3DTriangle