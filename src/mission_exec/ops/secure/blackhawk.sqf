/*
["CUP_A1_UH60_Crashed",[0,0,0],0,1,0,{}],
["Land_SatellitePhone_F",[0.975586,-1.90076,0],211.767,1,0,{}],
["CUP_A1_Hromada_kameni",[-2.59766,2.48694,0],78.7599,1,0,{}],
["CUP_A1_oliva",[4.18604,1.37195,0],226.212,1,0,{}],
["01_bushes_01_b_canina2s_summer",[-4.29785,0.677368,0],35.6684,1,0,{}],
["CUP_A1_Hromada_kameni",[0.0268555,-6.43701,0],246.139,1,0,{}],
["CUP_A1_Stone4a",[-4.73877,5.41248,0],104.584,1,0,{}],
["CUP_A1_hrusen2",[-6.74121,-2.72791,0],290.89,1,0,{}],
["01_bushes_01_b_canina2s_summer",[7.58057,-0.81189,0],319.768,1,0,{}],
["01_bushes_01_b_craet1_summer",[-2.43262,-7.84204,0],70.9449,1,0,{}],
["CUP_A1_Stone4a",[6.80957,-4.87891,0],334.531,1,0,{}],
["CUP_A1_str_liskac",[5.27588,6.57349,0],310.972,1,0,{}],
["CUP_A1_oliva",[3.85986,-7.68762,0],308.2,1,0,{}],
["CUP_A1_Hromada_kameni",[0.947266,8.69287,0],30.0447,1,0,{}],
["CUP_A1_str_vrba",[-1.37109,11.5864,0],246.719,1,0,{}],
*/


private ["_posOK", "_marker", "_location", "_objPos", "_objChopper", "_objItem", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir", "_faction"];

if (FF7_Global_Debug) then
{
	["OPS/Secure", "Running mission blackhawk"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the crashed Blackhawk and secure its flightrecorder";

_objThings	=
[
	//["CUP_A1_UH60_Crashed",[0,0,0],0,1,0,{}],									-- Origin
	//["Land_SatellitePhone_F",[0.975586,-1.90076,0],211.767,1,0,{}],			-- Activation
	["CUP_A1_Hromada_kameni",[-2.59766,2.48694,0],78.7599,1,0,{}],
	["CUP_A1_oliva",[4.18604,1.37195,0],226.212,1,0,{}],
	["01_bushes_01_b_canina2s_summer",[-4.29785,0.677368,0],35.6684,1,0,{}],
	["CUP_A1_Hromada_kameni",[0.0268555,-6.43701,0],246.139,1,0,{}],
	["CUP_A1_Stone4a",[-4.73877,5.41248,0],104.584,1,0,{}],
	["CUP_A1_hrusen2",[-6.74121,-2.72791,0],290.89,1,0,{}],
	["01_bushes_01_b_canina2s_summer",[7.58057,-0.81189,0],319.768,1,0,{}],
	["01_bushes_01_b_craet1_summer",[-2.43262,-7.84204,0],70.9449,1,0,{}],
	["CUP_A1_Stone4a",[6.80957,-4.87891,0],334.531,1,0,{}],
	["CUP_A1_str_liskac",[5.27588,6.57349,0],310.972,1,0,{}],
	["CUP_A1_oliva",[3.85986,-7.68762,0],308.2,1,0,{}],
	["CUP_A1_Hromada_kameni",[0.947266,8.69287,0],30.0447,1,0,{}],
	["CUP_A1_str_vrba",[-1.37109,11.5864,0],246.719,1,0,{}]
];

_objSpawned	= [];

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

FF7_OP_itemSecured = false;

FF7_OP_markersObj = FF7_OP_markersObj - [_marker];

_location = markerText _marker;

_rndDir = (random 360);

// ---------- Spawn the plane
_objChopper = createVehicle ["CUP_A1_UH60_Crashed", [0, 0, 0], [], 0, "NONE"];
_objChopper setDir _rndDir;
_objChopper setPos _objPos;
_objChopper setVectorUp [0,0,1];
_objChopper enableSimulation false;
_objChopper allowDamage false;
_objChopper setVariable ["gc_persist", true];

sleep 1;

_objSpawned = _objSpawned + [_objChopper];


// ---------- Spawn cargo
_objItem	= createVehicle ["Land_SatellitePhone_F", [0, 0, 0], [], 0, "NONE"];
_relPos		= (_objChopper modelToWorld [0.975586, -1.90076, 0]);

_objItem setDir 70.6349 + _rndDir;
_objItem setPos [(_relPos select 0), (_relPos select 1), 0];
_objItem setVectorUp [0,0,1];
_objItem enableSimulation false;
_objItem allowDamage false;
_objItem setVariable ["gc_persist", true];

[_objItem] call FF7_fnc_addToCurator;

_objSpawned = _objSpawned + [_objItem];

GlobalSecureObj = _objItem;

[
	_objItem,
	["secure2", "11DD11", "Secure Data"] call FF7_fnc_formatAddAction,
	{[] remoteExec ["OPS_fnc_secureItem", 2, false]},
	[],
	99,
	true,
	true,
	"",
	"((_target distance _this) < 3)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

// ---------- Loop through all others
{
	private ["_tmpObj", "_tmpType", "_tmpOffset", "_tmpDir"];

	_tmpType	= (_x select 0);
	_tmpOffset	= (_x select 1);
	_tmpDir		= (_x select 2);

	_relPos = (_objChopper modelToWorld _tmpOffset);

	_tmpObj = createVehicle [_tmpType, [0, 0, 0], [], 0, "NONE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0 + (_tmpOffset select 2)];
	_tmpObj setVectorUp [0,0,1];
	_tmpObj enableSimulation false;
	_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	_objSpawned = _objSpawned + [_tmpObj];
} foreach _objThings;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorBLUFOR", "Border", "mil_pickup"] call OPS_fnc_createMarker;

["Secure", format ["Locate the Blackhawk near %1 and secure its flightdata.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_faction = [_objPos] call OPS_fnc_getFaction;

_objEnemy =
[
	_objPos,
	_faction
] call OPS_fnc_spawnObjEnemy;

while {!FF7_OP_itemSecured} do
{
	sleep 1;
};

FF7_OP_itemSecured = false;

FF7_OP_missionSuccess = true;

["Completed", format ["Good job, the Blackhawk flightrecorder has been secured ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
