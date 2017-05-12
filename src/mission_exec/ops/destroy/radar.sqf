private ["_posOK", "_marker", "_location", "_objPos", "_radars", "_radar", "_faction", "_objEnemy"];

if (FF7_Global_Debug) then
{
	["OPS/Destroy", "Running mission radar"] call FF7_fnc_debugLog;
};

_posOK		= false;
_msg		= "Find and destroy the radar";
_radars		=
[
	"TK_WarfareBArtilleryRadar_Base_EP1",
	//"rhs_prv13",
	"TK_GUE_WarfareBAntiAirRadar_Base_EP1",
	"TK_GUE_WarfareBArtilleryRadar_Base_EP1",
	//"rhs_p37",
	"TK_WarfareBAntiAirRadar_Base_EP1"
];

//diag_log "Starting radar mission";

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersObj);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 500, 20, 0.5] call OPS_fnc_getPosFromMarker;

		if !(_objPos isEqualTo [0, 0, 0]) then
		{
			_posOK = true;
		}
	};
};

FF7_OP_markersObj = FF7_OP_markersObj - [_marker];

_location = markerText _marker;

//diag_log format ["Found new objective: %1", _location];

//_objPos = [_marker, 200, 20] call OPS_fnc_getPosFromMarker;
//diag_log format ["Found position at objective: %1", _objPos];

FF7_OP_missionPos = _objPos;

_radar = createVehicle [(_radars call BIS_fnc_selectRandom), [0, 0, 0], [], 0, "NONE"];
_radar setDir ((random 45) + 30);
_radar setPos _objPos;
_radar setVectorUp [0,0,1];
_radar setVariable ["gc_persist", true];

[_radar] call FF7_fnc_addToCurator;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorOPFOR", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["SeekDestroy", format ["Locate the radar installation near %1 and destroy it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_faction = [_objPos] call OPS_fnc_getFaction;

_objEnemy =
[
	_objPos,
	_faction
] call OPS_fnc_spawnObjEnemy;

while {(alive _radar)} do
{
	sleep 1;
};

FF7_OP_missionSuccess = true;

sleep 1;

["Completed", format ["Good job, the radar installation near %1 has been destroyed ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
[_objPos, 1000, _objEnemy] spawn OPS_fnc_deSpawnObjEnemy;
