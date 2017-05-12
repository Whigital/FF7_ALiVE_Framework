private ["_posOK", "_marker", "_location", "_gatherPos", "_objPos", "_intel", "_items", "_fuzzyPos", "_msg", "_radius", "_mkrRad"];

if (FF7_Global_Debug) then
{
	["Gather", "Running mission item"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Locate item and extract intel";
_items	= ["Land_MetalCase_01_small_F", "Land_PlasticCase_01_medium_F", "Land_DataTerminal_01_F", "Land_MetalCase_01_medium_F", "Land_PlasticCase_01_large_F"];
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

_intel = createVehicle [(selectRandom _items), [0, 0, 0], [], 0, "NONE"];
_intel setDir ((random 45) + 30);
_intel setPos [(_objPos select 0), (_objPos select 1), (_objPos select 2) + 1];
sleep 3;
_intel enableSimulation false;
_intel allowDamage false;
_intel setVariable ["ace_cargo_size", -1];
[_intel, false] call ace_dragging_fnc_setDraggable;
[_intel, false] call ace_dragging_fnc_setCarryable;
_intel setVariable ["ace_cargo_canLoad", 0];
_intel setVariable ["gc_persist", true];

GlobalGatherObj = _intel;

[
	_intel,
	["hand", "11DD11", "Extract Intel"] call FF7_fnc_formatAddAction,
	{[] remoteExec ["OPS_fnc_pickupIntel", 2, false]},
	[],
	100,
	true,
	true,
	"",
	"((_target distance _this) < 3)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

[_intel] call FF7_fnc_addToCurator;

_fuzzyPos = [[[_objPos, _mkrRad]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, _mkrRad, _msg, "ColorCIV", "DiagGrid", "mil_unknown"] call OPS_fnc_createMarker;

["IntelGather", format ["Locate item in %1 and extract intel from it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

while {!FF7_OP_gatherSuccess} do
{
	sleep 1;
};

sleep 1;

["Completed", format ["Item in %1 found and intel successfully extracted.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

[[_intel], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
