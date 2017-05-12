/*
["C130J_wreck_EP1",[0,0,0],0,1,0,{}],
["CUP_A2_misc_trunk_torzo",[4.73145,7.20178,0],74.2117,1,0,{}],
["CUP_A2_misc_fallentrunk_pmc",[-9.57178,-0.576294,0],162.738,1,0,{}],
["CargoNet_01_box_F",[-0.82959,10.4233,0],326.435,1,0,{}],
["CUP_A2_misc_fallenspruce_1xtrunk_pmc",[-6.12646,11.8922,0],92.3565,1,0,{}],
["CargoNet_01_box_F",[-0.45166,13.3136,0],14.3457,1,0,{}],
["CUP_A2_misc_stubleafs_pmc",[-11.5205,9.57166,0],238.16,1,0,{}],
["CUP_A2_misc_stub1",[3.98682,14.3422,0],0,1,0,{}],
["CUP_A2_misc_fallentree1",[12.4961,11.6835,0],337.815,1,0,{}],
["CUP_A2_misc_fallentree2",[-13.75,11.4523,0],205.838,1,0,{}],
["CUP_A2_misc_fallenspruce",[4.68604,24.4199,-0.0254054],148.501,1,0,{}],
["CUP_A2_misc_stub2",[-8.12158,21.951,0],319.066,1,0,{}],
*/

private ["_posOK", "_marker", "_location", "_objPos", "_objPlane", "_objCargo", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir", "_faction"];

if (FF7_Global_Debug) then
{
	["OPS/Secure", "Running mission c130"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the downed C130 and secure the cargo";

_objThings	=
[
	//["C130J_wreck_EP1",[0,0,0],0,1,0,{}],											-- Origin
	//["CargoNet_01_box_F",[-0.45166,13.3136,0],14.3457,1,0,{}],					-- Activation
	["CUP_A2_misc_trunk_torzo",[4.73145,7.20178,0],74.2117,1,0,{}],
	["CUP_A2_misc_fallentrunk_pmc",[-9.57178,-0.576294,0],162.738,1,0,{}],
	["CargoNet_01_box_F",[-0.82959,10.4233,0],326.435,1,0,{}],
	["CUP_A2_misc_fallenspruce_1xtrunk_pmc",[-6.12646,11.8922,0],92.3565,1,0,{}],
	["CUP_A2_misc_stubleafs_pmc",[-11.5205,9.57166,0],238.16,1,0,{}],
	["CUP_A2_misc_stub1",[3.98682,14.3422,0],0,1,0,{}],
	["CUP_A2_misc_fallentree1",[12.4961,11.6835,0],337.815,1,0,{}],
	["CUP_A2_misc_fallentree2",[-13.75,11.4523,0],205.838,1,0,{}],
	["CUP_A2_misc_fallenspruce",[4.68604,24.4199,-0.0254054],148.501,1,0,{}],
	["CUP_A2_misc_stub2",[-8.12158,21.951,0],319.066,1,0,{}]
];

_objSpawned	= [];

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersObj);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 250, 25, 0.25] call OPS_fnc_getPosFromMarker;

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
_objPlane = createVehicle ["C130J_wreck_EP1", [0, 0, 0], [], 0, "NONE"];
_objPlane setDir _rndDir;
_objPlane setPos _objPos;
//_objPlane setVectorUp [0,0,1];
//_objPlane enableSimulation false;
_objPlane allowDamage false;
_objPlane setVariable ["gc_persist", true];

sleep 1;

_objSpawned = _objSpawned + [_objPlane];


// ---------- Spawn cargo
_objCargo	= createVehicle ["CargoNet_01_box_F", [0, 0, 0], [], 0, "NONE"];
_relPos		= (_objPlane modelToWorld [-0.45166, 13.3136, 0]);

_objCargo setDir 14.3457 + _rndDir;
_objCargo setPos [(_relPos select 0), (_relPos select 1), 0];
//_objCargo setVectorUp [0,0,1];
//_objCargo enableSimulation false;
_objCargo allowDamage false;
_objCargo setVariable ["gc_persist", true];

[_objCargo] call FF7_fnc_addToCurator;

_objSpawned = _objSpawned + [_objCargo];

GlobalSecureObj = _objCargo;

[
	_objCargo,
	["secure2", "11DD11", "Secure Cargo"] call FF7_fnc_formatAddAction,
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

	_relPos = (_objPlane modelToWorld _tmpOffset);

	_tmpObj = createVehicle [_tmpType, [0, 0, 0], [], 0, "NONE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0 + (_tmpOffset select 2)];
	_tmpObj setVectorUp [0,0,1];
	//_tmpObj enableSimulation false;
	_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	_objSpawned = _objSpawned + [_tmpObj];
} foreach _objThings;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorBLUFOR", "Border", "mil_pickup"] call OPS_fnc_createMarker;

["Secure", format ["Locate the downed C130 near %1 and secure its cargo.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

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

["Completed", format ["Good job, the C130 cargo has been secured ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
