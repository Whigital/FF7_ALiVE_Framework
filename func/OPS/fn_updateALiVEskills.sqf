private ["_skillMod", "_skillFactions", "_max", "_current", "_factor", "_customSkills"];

if (FF7_Global_Debug) then
{
	["OPS_fnc_updateALiVEskills", "Running function"] call FF7_fnc_debugLog;
};

_skillMod	= ((entities "ALiVE_sys_aiskill") select 0);

_max		= ("ObjectiveLimit" call BIS_fnc_getParamValue);
_factor		= ((1 / _max) * FF7_OP_missionsCompleted);

_customSkills = [];

{
	private ["_skillMin", "_skillMax", "_skillDiff", "_skillValue"];

	_skillMin	= (_x select 0);
	_skillMax	= (_x select 1);
	_skillDiff	= (_skillMax - _skillMin);
	_skillValue	= (_skillMin + (_skillDiff * _factor));
	_customSkills pushBack _skillValue;
} forEach FF7_OP_skillArray;

_skillFactions = [] call ALIVE_fnc_hashCreate;

{
	[_skillFactions, _x, _customSkills] call ALIVE_fnc_hashSet;
} forEach FF7_OP_skillFactions;

_skillMod setVariable ["factionSkills", _skillFactions];
