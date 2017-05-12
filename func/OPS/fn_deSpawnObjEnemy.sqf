params
[
	"_pos",
	["_radius", 750],
	"_list"
];

while {true} do
{
	private ["_count"];

	_count = (west countSide (_pos nearEntities _radius));

	if (_count < 1) exitWith {[[_list], 1] spawn OPS_fnc_clearObj};

	sleep 15;
};
