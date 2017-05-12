params ["_marker", "_radius"];

private ["_pos", "_objs", "_hangars"];

_pos = getMarkerPos _marker;

_objs = [];

_hangars =
[
	"Land_Mil_hangar_EP1",
	"Land_Hangar_F",
	"Land_Ss_hangard",
	"Land_Ss_hangar"
];

{
	{
		_objs pushBack _x;
	} forEach (_pos nearObjects [_x, _radius]);
} forEach _hangars;

{
	_x allowDamage false;
} forEach _objs;
