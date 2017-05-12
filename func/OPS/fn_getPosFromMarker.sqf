private ["_safePos", "_rndPos", "_marker", "_radius", "_space", "_grad", "_markerPos", "_limit"];

_marker		= (_this select 0);
_radius		= (_this select 1);
_space		= (_this select 2);
_grad		= (_this select 3);

_markerPos	= (getMarkerPos _marker);
_limit		= 0;
_safePos	= [];

while {((count _safePos) == 0)} do
{
	_rndPos = [[[_markerPos, _radius],[]],["water","out"]] call BIS_fnc_randomPos;

	if (!(isOnRoad _rndPos)) then
	{
		_safePos = _rndPos isFlatEmpty [(_space / 2), 1, _grad, _space, 0, false];
	};

	_limit = _limit + 1;

	if (_limit >= 50) then
	{
		diag_log format ["Safepos limit reached: %1", _limit];
		_safePos = [0, 0, 0];
	};
};

_safePos;
