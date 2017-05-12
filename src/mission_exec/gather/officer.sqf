private ["_posOK", "_marker", "_location", "_gatherPos", "_faction", "_factionClasses", "_facSide", "_objPos", "_fuzzyPos", "_msg", "_radius"];

private ["_officerGrp", "_officer", "_officerType", "_uniform", "_vest", "_headgear", "_goggles", "_captured", "_offEH"];

if (FF7_Global_Debug) then
{
	["Gather", "Running mission officer"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Locate officer and extract intel";
_radius	= 300;

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

_factionClasses = [_faction] call OPS_fnc_classesFromFaction;

_facSide			= (_factionClasses select 0);
_officerType	= (_factionClasses select 5);
_uniform			= (_factionClasses select 6);

/*
switch (_faction) do
{
	case "OPF_F":
	{
		_facSide		= east;
		_officerType	= "O_officer_F";
		_uniform		= "U_O_OfficerUniform_ocamo";
	};

	case "OPF_T_F":
	{
		_facSide		= east;
		_officerType	= "O_T_Officer_F";
		_uniform		= "U_O_T_Officer_F";
	};

	case "IND_F":
	{
		_facSide		= resistance;
		_officerType	= "I_officer_F";
		_uniform		= "U_I_OfficerUniform";
	};
};
*/

_vest			= "V_Rangemaster_belt";
_headgear		= "H_Beret_Colonel";
_goggles		= "G_Aviator";

_officerGrp = createGroup _facSide;

_officerGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

_officer = _officerGrp createUnit [_officerType, _objPos, [], 0, "NONE"];

_officer setVariable ["FF7_OPS_Target", true];

_officer allowDamage false;

waitUntil {alive _officer};

removeAllWeapons _officer;
removeAllItems _officer;
removeAllAssignedItems _officer;
removeUniform _officer;
removeVest _officer;
removeBackpack _officer;
removeHeadgear _officer;
removeGoggles _officer;

_officer forceAddUniform _uniform;
_officer addVest _vest;
_officer addHeadgear _headgear;
_officer addGoggles _goggles;
_officer addItemToUniform "ACE_Cellphone";
_officer setRank "MAJOR";

_officer disableAI "AUTOTARGET";
//_officer disableAI "MOVE";
_officer setUnitPos "UP";

_officerGrp setCombatMode "BLUE";
_officerGrp setBehaviour "CARELESS";
_officerGrp setSpeedMode "LIMITED";

_captured = false;

GlobalGatherObj = _officer;

[_officer] call FF7_fnc_addToCurator;

/*
_fuzzyPos = ([_objPos, (_radius / 6), (_radius / 3), 0, 1, -1, 0] call BIS_fnc_findSafePos);

_markers = [_fuzzyPos, (_radius * 0.625), _msg, "ColorOPFOR", "DiagGrid", "mil_warning"] call OPS_fnc_createMarker;
*/

[_gatherPos, (_radius *1.5), 6, _officerGrp] call OPS_fnc_genWaypoints;

_markers = [_gatherPos, _radius, _msg, "ColorOPFOR", "DiagGrid", "mil_warning"] call OPS_fnc_createMarker;

["IntelGather", format ["Locate the enemy officer in %1 and extract intel from him.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

sleep 5;

_officer allowDamage true;

/*
_offEH = _officer addEventHandler
[
	"Killed",
	{
		params ["_unit", "_killer"];

		private ["_nameKiller"];

		if (isPlayer _killer) then
		{
			_nameKiller = (name _killer);

			//[(format ["<t align='center'><t size='2.0' color='#CC2222'>R.O.E</t><br/><br/><t size='1.3' color='#00B2EE'>Watch your fire <t size='1.3' color='#CC2222'>%1</t>,<br/>you just killed the %2!</t>", _nameKiller, "officer"]), 15] remoteExec ["FF7_fnc_globalHint", 0];
			["ROE", "R.O.E", (format ["Watch your fire <t color='#CC2222'>%1</t>,<br/>you just killed the %2 !</t>", _nameKiller, "officer"])] remoteExec ["FF7_fnc_globalHintStruct", 0];
		};
	}
];
*/

// Captured or Killed loop
while {(!(_captured) && (alive _officer))} do
{
	_captured = _officer getVariable ["ace_captives_isHandcuffed", false];
	sleep 1;
};

// If alive, add Intel action
if (alive _officer) then
{
	[
		_officer,
		["interrogate", "11DD11", "Interrogate"] call FF7_fnc_formatAddAction,
		{[] remoteExec ["OPS_fnc_pickupIntel", 2, false]},
		[],
		100,
		true,
		true,
		"",
		"((_target distance _this) < 3)"
	] remoteExec ["FF7_fnc_addGlobalAction", 0, true];
};

while {(!(FF7_OP_gatherSuccess) && (alive _officer))} do
{
	sleep 1;
};

if (FF7_OP_gatherSuccess) then
{
	["Completed", format ["Enemy officer in %1 found and intel successfully extracted.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

	//_officer removeEventHandler ["Killed", _offEH];
};

if !(alive _officer) then
{
	[_officer] remoteExec ["FF7_fnc_remAllActions", 0, true];
	["Failed", format ["Enemy officer in %1 has been killed, mission failed.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];
};

{
	deleteMarker _x;
} foreach _markers;

[[_officer], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
