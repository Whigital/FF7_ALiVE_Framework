private ["_faction", "_marker"];

params ["_pos"];

_faction = [FF7_OP_Factions, "opf"] call CBA_fnc_hashGet;

{
	if (_pos inArea _x) then
	{
		if (["opf", _x] call BIS_fnc_inString) then
		{
			_faction = [FF7_OP_Factions, "opf"] call CBA_fnc_hashGet;
		};

		if (["indf", _x] call BIS_fnc_inString) then
		{
			_faction = [FF7_OP_Factions, "indf"] call CBA_fnc_hashGet;
		};
	};
} forEach FF7_OP_markerTAOR;

_faction;
