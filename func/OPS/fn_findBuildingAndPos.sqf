params
[
	["_where", [0, 0]],
	["_radius", 400]
];

private ["_buildings", "_building", "_buildpos", "_pos", "_bfound", "_pfound"];

_pos = [];

while {(count _pos) == 0} do
{
	_buildings = (nearestObjects [_where, ["house"], _radius]);

	if ((count _buildings) > 0) then
	{
		_building = (selectRandom _buildings);

		_buildpos = (_building call BIS_fnc_buildingPositions);

		if ((count _buildpos) > 0) then
		{
			_pos = (selectRandom _buildpos);
		};
	};
};

_pos;
