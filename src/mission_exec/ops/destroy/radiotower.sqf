private ["_posOK", "_marker", "_location", "_objPos", "_tower", "_faction", "_objEnemy"];

if (FF7_Global_Debug) then
{
	["OPS/Destroy", "Running mission radiotower"] call FF7_fnc_debugLog;
};

_posOK		= false;
_msg		= "Destroy radiotower";

//diag_log "Starting radar mission";

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersTown);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 400, 14, 0.5] call OPS_fnc_getPosFromMarker;

		if !(_objPos isEqualTo [0, 0, 0]) then
		{
			_posOK = true;
		}
	};
};

FF7_OP_markersTown = FF7_OP_markersTown - [_marker];

_location = markerText _marker;

//diag_log format ["Found new objective: %1", _location];

//_objPos = [_marker, 200, 20] call OPS_fnc_getPosFromMarker;
//diag_log format ["Found position at objective: %1", _objPos];

FF7_OP_missionPos = _objPos;

_tower = createVehicle ["Land_TTowerBig_2_F", [0, 0, 0], [], 0, "NONE"];
_tower setDir ((random 45) + 30);
_tower setPos _objPos;
_tower setVectorUp [0,0,1];
_tower setVariable ["gc_persist", true];

[_tower] call FF7_fnc_addToCurator;

_fuzzyPos = [[[_objPos, (200 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 200, _msg, "ColorOPFOR", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["SeekDestroy", format ["Destroy radiotower in %1 to disrupt enemy communications.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

while {(alive _tower)} do
{
	sleep 1;
};

FF7_OP_missionSuccess = true;

sleep 1;

["Completed", format ["Good job, the radiotower in %1 has been destroyed ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;
