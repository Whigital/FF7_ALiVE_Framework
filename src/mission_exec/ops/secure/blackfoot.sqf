/*
["Land_Wreck_Heli_Attack_01_F",[0,0,0],0,1,0,{}],
["Land_Tablet_02_F",[0.822754,-3.95154,0.503],70.6349,1,0,{}],
["01_bushes_01_b_elderberry2s_pmc",[4.61768,1.10083,0],298.54,1,0,{}],
["CUP_A2_misc_brokenspruce_pmc",[2.82617,3.81323,0],300.746,1,0,{}],
["01_bushes_01_b_elderberry2s_pmc",[-4.75488,3.22803,0],306.126,1,0,{}],
["CUP_A2_misc_trunk_water_ep1",[-5.17334,0.13916,0],121.983,1,0,{}],
["CUP_A2_misc_trunk_water_ep1",[6.58105,-1.15649,0],69.4156,1,0,{}],
["CUP_A2_misc_fallenspruce_1xtrunk_pmc",[1.8501,10.2145,0],62.527,1,0,{}],
["CUP_A1_Akat02S",[4.50244,-6.2207,0],147.331,1,0,{}],
["CUP_A2_misc_fallentree2",[-7.19385,3.90295,0],204.283,1,0,{}],
["01_bushes_01_b_elderberry2s_pmc",[6.4502,6.86841,0],21.9689,1,0,{}],
["CUP_A1_rock",[-2.51855,-10.8019,0],36.6571,1,0,{}],
["CUP_A2_misc_stub2",[-3.11182,11.4547,0],297.155,1,0,{}],
["CUP_A2_t_stub_picea",[-0.36377,14.2434,0],245.724,1,0,{}],
*/

private ["_posOK", "_marker", "_location", "_objPos", "_objChopper", "_objItem", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir", "_faction"];

if (FF7_Global_Debug) then
{
	["OPS/Secure", "Running mission blackfoot"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the crashed Blackfoot and secure its targeting system";

_objThings	=
[
	//["Land_Wreck_Heli_Attack_01_F",[0,0,0],0,1,0,{}],								-- Origin
	//["Land_PCSet_01_case_F",[0.0615234,1.75427,0],237.321,1,0,{}],				-- Activation
	["CUP_b_Elderberry2s_PMC",[4.61768,1.10083,0],298.54,1,0,{}],
	["CUP_A2_misc_brokenspruce_pmc",[2.82617,3.81323,0],300.746,1,0,{}],
	["CUP_b_Elderberry2s_PMC",[-4.75488,3.22803,0],306.126,1,0,{}],
	["CUP_A2_misc_trunk_water_ep1",[-5.17334,0.13916,0],121.983,1,0,{}],
	["CUP_A2_misc_trunk_water_ep1",[6.58105,-1.15649,0],69.4156,1,0,{}],
	["CUP_A2_misc_fallenspruce_1xtrunk_pmc",[1.8501,10.2145,0],62.527,1,0,{}],
	["CUP_A1_Akat02S",[4.50244,-6.2207,0],147.331,1,0,{}],
	["CUP_A2_misc_fallentree2",[-7.19385,3.90295,0],204.283,1,0,{}],
	["CUP_b_Elderberry2s_PMC",[6.4502,6.86841,0],21.9689,1,0,{}],
	["CUP_A1_Akat02S",[-2.51855,-10.8019,0],60.6571,1,0,{}],
	["CUP_A2_misc_stub2",[-3.11182,11.4547,0],297.155,1,0,{}],
	["CUP_A2_t_stub_picea",[-0.36377,14.2434,0],245.724,1,0,{}]
];

_objSpawned	= [];

//diag_log "Starting radar mission";

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersObj);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 500, 15, 0.25] call OPS_fnc_getPosFromMarker;

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

// ---------- Spawn the wreck
_objChopper = createVehicle ["Land_Wreck_Heli_Attack_01_F", [0, 0, 0], [], 0, "NONE"];
_objChopper setDir _rndDir;
_objChopper setPos _objPos;
_objChopper setVectorUp [0,0,1];
_objChopper enableSimulation false;
_objChopper allowDamage false;
_objChopper setVariable ["gc_persist", true];

sleep 1;

_objSpawned = _objSpawned + [_objChopper];


// ---------- Spawn objective
_objItem	= createVehicle ["Land_PCSet_01_case_F", [0, 0, 0], [], 0, "NONE"];
_relPos		= (_objChopper modelToWorld [0.0615234, 1.75427, 0]);

_objItem setDir 237.321 + _rndDir;
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
	["secure2", "11DD11", "Secure Computer"] call FF7_fnc_formatAddAction,
	{[] remoteExec ["OPS_fnc_secureItem", 2, false]},
	[],
	99,
	true,
	true,
	"",
	"((_target distance _this) < 2)"
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

["Secure", format ["Locate the crashed Blackfoot near %1 and secure computer.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

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

["Completed", format ["Good job, the Blackfoot targeting computer has been secured ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
