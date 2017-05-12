private ["_wp", "_wpp"];

params ["_pos", "_rad", "_cnt", "_grp"];

for "_i" from 1 to _cnt do
{
	private ["_wp", "_wpp"];

	_wpp	= [_pos, _rad] call OPS_fnc_findBuildingAndPos;
	_wp		= _grp addWaypoint [_wpp, 2];

	_wp setWaypointType "MOVE";
	_wp setWaypointTimeout [60, 90, 120];
};

[_grp, _cnt] setWaypointType "CYCLE";
