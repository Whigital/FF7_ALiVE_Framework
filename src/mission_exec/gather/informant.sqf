private ["_posOK", "_marker", "_location", "_gatherPos", "_faction", "_facSide", "_objPos", "_fuzzyPos", "_msg", "_radius", "_mkrRad"];

private ["_informantGrp", "_informant", "_infEH"];

if (FF7_Global_Debug) then
{
	["Gather", "Running mission informant"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Locate informant and receive intel";
_radius	= 300;
_mkrRad = 100;

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersTown);

	if (((getMarkerPos _marker) distance FF7_OP_missionPos) > 2000) then
	{
		_posOK = true;
	};
};

FF7_OP_markersTown = FF7_OP_markersTown - [_marker];

_location = markerText _marker;
_gatherPos = (getMarkerPos _marker);

FF7_OP_gatherPos = _gatherPos;

_objPos = [_gatherPos, (_radius * 1.5)] call OPS_fnc_findBuildingAndPos;

_faction = [_objPos] call OPS_fnc_getFaction;

_informantGrp = createGroup civilian;

_informantGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

_informant = _informantGrp createUnit ["C_journalist_F", _objPos, [], 0, "NONE"];

_informant setVariable ["FF7_OPS_Target", true];

_informant allowDamage false;

waitUntil {alive _informant};

/*
removeAllWeapons _informant;
removeAllItems _informant;
removeAllAssignedItems _informant;
removeUniform _informant;
removeVest _informant;
removeBackpack _informant;
removeHeadgear _informant;
removeGoggles _informant;

_officer forceAddUniform _uniform;
_officer addVest _vest;
_officer addHeadgear _headgear;
_officer addGoggles _goggles;
*/

_informant disableAI "AUTOTARGET";
_informant disableAI "MOVE";
_informant setUnitPos "MIDDLE";

_informantGrp setCombatMode "BLUE";
_informantGrp setBehaviour "CARELESS";

GlobalGatherObj = _informant;

[
	_informant,
	["hand", "11DD11", "Receive Intel"] call FF7_fnc_formatAddAction,
	{[] remoteExec ["OPS_fnc_pickupIntel", 2, false]},
	[],
	100,
	true,
	true,
	"",
	"((_target distance _this) < 3)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

[_informant] call FF7_fnc_addToCurator;

_fuzzyPos = [[[_objPos, _mkrRad]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, _mkrRad, _msg, "ColorCIV", "DiagGrid", "mil_unknown"] call OPS_fnc_createMarker;

["IntelGather", format ["Locate informant in %2 and receive intel from him.", _faction, _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

sleep 5;

_informant allowDamage true;

/*
_infEH = _informant addEventHandler
[
	"Killed",
	{
		params ["_unit", "_killer"];

		private ["_nameKiller"];

		if (isPlayer _killer) then
		{
			_nameKiller = (name _killer);

			//[(format ["<t align='center'><t size='2.0' color='#CC2222'>R.O.E</t><br/><br/><t size='1.3' color='#00B2EE'>Watch your fire <t size='1.3' color='#CC2222'>%1</t>,<br/>you just killed the %2!</t>", _nameKiller, "informant"]), 15] remoteExec ["FF7_fnc_globalHint", 0];
			["ROE", "R.O.E", (format ["Watch your fire <t color='#CC2222'>%1</t>,<br/>you just killed the %2 !</t>", _nameKiller, "informant"])] remoteExec ["FF7_fnc_globalHintStruct", 0];
		};
	}
];
*/

while {(!(FF7_OP_gatherSuccess) && (alive _informant))} do
{
	sleep 1;
};

sleep 1;

if (FF7_OP_gatherSuccess) then
{
	["Completed", format ["Informant in %1 found and intel received.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

	//_informant removeEventHandler ["Killed", _infEH];
};

if !(alive _informant) then
{
	[_informant] remoteExec ["FF7_fnc_remAllActions", 0, true];
	["Failed", format ["The informant in %1 has been killed, mission failed.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];
};

{
	deleteMarker _x;
} foreach _markers;

[[_informant], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
