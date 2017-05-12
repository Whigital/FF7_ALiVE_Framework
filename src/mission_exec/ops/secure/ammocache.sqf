private ["_posOK", "_marker", "_location", "_objPos", "_stuffPos", "_objCache", "_objOrg", "_objThings", "_rndDir", "_objSpawned"];

if (FF7_Global_Debug) then
{
	["OPS/Secure", "Running mission ammocache"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find and secure the ammocache";

_stuffPos =
[
	[[0.299805,-1.0907,0],29.6862],
	[[3.07813,1.94934,0],36.019],
	[[2.45215,-2.9115,0],317.657],
	[[4.77319,-0.642822,0],32.9984],
	[[-3.92212,3.07617,0],29.5971],
	[[-5.12891,-1.19031,0],312.645]
];

_objSpawned = [];

//_objThings	= ["CargoNet_01_box_F", "Land_PaperBox_open_full_F", "Land_Pallet_MilBoxes_F", "Land_CargoBox_V1_F"];

_objThings =
[
	"O_supplyCrate_F",
	"Box_FIA_Support_F",
	"Box_CSAT_Uniforms_F",
	"CargoNet_01_box_F",
	"Box_CSAT_Equip_F",
	"Box_FIA_Wps_F"
];

_objSpawned	= [];

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersTown);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 300, 8, 0.5] call OPS_fnc_getPosFromMarker;

		if !(_objPos isEqualTo [0, 0, 0]) then
		{
			_posOK = true;
		}
	};
};

FF7_OP_itemSecured = false;

FF7_OP_markersTown = FF7_OP_markersTown - [_marker];

_location = markerText _marker;

_rndDir = (random 360);

_spawnRel =
{
	private ["_tmpType", "_tmpOffset", "_tmpDir", "_tmpObj", "_relPos"];

	params ["_struct", "_orgObj", "_rndDir"];

	_tmpOffset	= (_struct select 0);
	_tmpDir		= (_struct select 1);

	_relPos = (_orgObj modelToWorld _tmpOffset);

	_tmpObj = createVehicle [(selectRandom _objThings), [0, 0, 0], [], 0, "NONE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0];
	//_tmpObj setVectorUp [0,0,1];
	//_tmpObj enableSimulation false;
	_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	//[_tmpObj] call FF7_fnc_addToCurator;

	_tmpObj;
};


// ---------- Spawn the origin
_objOrg = createVehicle ["CamoNet_OPFOR_open_F", [0, 0, 0], [], 0, "NONE"];
_objOrg setDir _rndDir;
_objOrg setPos _objPos;
//_objOrg setVectorUp [0,0,1];
//_objOrg enableSimulation false;
_objOrg allowDamage false;
_objOrg setVariable ["gc_persist", true];

_objSpawned = _objSpawned + [_objOrg];

{
	private ["_tmpObj"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;

	_objSpawned = _objSpawned + [_tmpObj];
} forEach _stuffPos;

sleep 1;

_objCache = (selectRandom _objSpawned);

[_objCache] call FF7_fnc_addToCurator;

GlobalSecureObj = _objCache;

[
	_objCache,
	["secure2", "11DD11", "Secure ammocache"] call FF7_fnc_formatAddAction,
	{[] remoteExec ["OPS_fnc_secureItem", 2, false]},
	[],
	100,
	true,
	true,
	"",
	"((_target distance _this) < 3)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

_fuzzyPos = [[[_objPos, (300 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 300, _msg, "ColorCIV", "Border", "mil_pickup"] call OPS_fnc_createMarker;

["Secure", format ["Locate the ammocache in %1 and secure it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

while {!FF7_OP_itemSecured} do
{
	sleep 1;
};

FF7_OP_itemSecured = false;

sleep 5;

FF7_OP_missionSuccess = true;

["Completed", format ["Good job, the ammocache has been secured ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[[_objSpawned], (random [180, 300, 540])] spawn OPS_fnc_clearObj;

[_objPos, 1000, _objSpawned] spawn OPS_fnc_deSpawnObjEnemy;
