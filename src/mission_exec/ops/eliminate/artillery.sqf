private ["_posOK", "_marker", "_location", "_objPos", "_objEmp", "_objOrg", "_statics", "_artys", "_objArty1", "_objArty2", "_objArty3", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir"];

private ["_faction", "_factionClasses", "_facSide", "_unitEng", "_unitOff", "_vehArty"];

if (FF7_Global_Debug) then
{
	["OPS/Eliminate", "Running mission artillery"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find and elimitnate the enemy artillery units";

_objThings	=
[
	//["Box_East_AmmoVeh_F",[0,0,0],0],
	["Box_FIA_Wps_F",[-1.66797,-0.850952,0],46.4864],
	["Land_PaperBox_open_full_F",[0.119141,1.93396,0],344.019],
	["Land_Pallet_MilBoxes_F",[-1.53516,1.11157,0],17.1691],
	["Box_FIA_Ammo_F",[2.19189,0.878052,0],341.144],
	//["O_static_AA_F",[7.56836,4.29663,1.90735e-006],59.8884],
	//["O_static_AA_F",[-8.30322,4.29639,0],299.92],
	//["O_static_AA_F",[-0.164063,-9.58911,0],179.957],
	//["O_T_MBT_02_arty_ghex_F",[-0.190918,9.50781,-9.53674e-007],0],
	//["O_T_MBT_02_arty_ghex_F",[8.64502,-5.13428,-9.53674e-007],120.035],
	//["O_T_MBT_02_arty_ghex_F",[-9.17041,-5.58728,-9.53674e-007],240.082],
	["Land_HBarrier_Big_F",[-5.3501,9.896,0],90],
	["Land_HBarrier_Big_F",[5.00684,10.0581,0],90],
	["Land_HBarrier_Big_F",[11.563,-0.866577,0],210.047],
	["Land_HBarrier_Big_F",[6.52539,-9.91406,0],210.047],
	["Land_HBarrier_Big_F",[-6.93555,-10.2551,0],330.069],
	["Land_HBarrier_Big_F",[-12.2446,-1.36023,0],330.069],
	["Land_Razorwire_F",[11.7231,4.69287,0],240.079],
	["Land_Razorwire_F",[-12.0093,4.6875,0],300.028],
	["Land_Razorwire_F",[-1.92188,-12.92,0],0],
	["Land_HBarrier_Big_F",[-0.220215,15.1727,0],0],
	["Land_HBarrier_Big_F",[13.5688,-7.94568,0],120.035],
	["Land_HBarrier_Big_F",[-14.0679,-8.44202,0],240.082]
];

_statics =
[
	["O_static_AA_F",[7.56836,4.29663,1.90735e-006],59.8884],
	["O_static_AA_F",[-8.30322,4.29639,0],299.92],
	["O_static_AA_F",[-0.164063,-9.58911,0],179.957]
];

_objSpawned	= [];
_objEmp		= [];
_objEnemy	= [grpNull];

_spawnRel =
{
	private ["_tmpType", "_tmpOffset", "_tmpDir", "_tmpObj", "_relPos"];

	params ["_struct", "_orgObj", "_rndDir"];

	_tmpType	= (_struct select 0);
	_tmpOffset	= (_struct select 1);
	_tmpDir		= (_struct select 2);

	_relPos = (_orgObj modelToWorld _tmpOffset);

	_tmpObj = createVehicle [_tmpType, [0, 0, 0], [], 0, "NONE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0];
	//_tmpObj setVectorUp [0,0,1];
	//_tmpObj enableSimulation false;
	//_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	//[_tmpObj] call FF7_fnc_addToCurator;

	_tmpObj;
};

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersObj);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 500, 20, 0.35] call OPS_fnc_getPosFromMarker;

		if !(_objPos isEqualTo [0, 0, 0]) then
		{
			_posOK = true;
		}
	};
};

FF7_OP_markersObj = FF7_OP_markersObj - [_marker];

FF7_OP_missionPos = _objPos;

_location = markerText _marker;

_faction = [_objPos] call OPS_fnc_getFaction;

_factionClasses = [_faction] call OPS_fnc_classesFromFaction;

_facSide	= (_factionClasses select 0);
_unitEng	= (_factionClasses select 4);
_unitOff	= (_factionClasses select 5);
_vehArty	= (_factionClasses select 8);

_artys =
[
	[_vehArty,[-0.190918,9.50781,-9.53674e-007],0],
	[_vehArty,[8.64502,-5.13428,-9.53674e-007],120.035],
	[_vehArty,[-9.17041,-5.58728,-9.53674e-007],240.082]
];

_rndDir = (random 360);

// ---------- Spawn origin
_objOrg = createVehicle ["Box_East_AmmoVeh_F", [0, 0, 0], [], 0, "NONE"];
_objOrg setDir _rndDir;
_objOrg setPos _objPos;
//_objOrg setVectorUp [0,0,1];
//_objOrg enableSimulation false;
//_objOrg allowDamage false;
_objOrg setVariable ["gc_persist", true];

_objSpawned = _objSpawned + [_objOrg];

// Spawn things
{
	private ["_tmpObj"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;

	_objSpawned = _objSpawned + [_tmpObj];
} forEach _objThings;

_objGroup = createGroup _facSide;

// Spawn and crew statics
{
	private ["_tmpObj", "_tmpUnit", "_tmpDir", "_tmpGrp"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;

	_objSpawned = _objSpawned + [_tmpObj];

	waitUntil
	{
		!(isNull _tmpObj);
	};

	_tmpDir = (getDir _tmpObj);

	_tmpGrp	= createGroup _facSide;

	_unitEng createUnit [getPos _tmpObj, _tmpGrp];
	_tmpGrp setBehaviour "COMBAT";
	_tmpGrp setCombatMode "RED";

	_tmpUnit = ((units _tmpGrp) select 0);
	_tmpGrp setFormDir _tmpDir;
	_tmpUnit setDir _tmpDir;
	_tmpUnit setPos (getPos _tmpObj);

	_tmpUnit assignAsGunner _tmpObj;
	_tmpUnit moveInGunner _tmpObj;

	//[_tmpGrp, 0.3, 0.7, 0.05] call OPS_fnc_setGroupSkill;

	[_tmpObj] call FF7_fnc_addToCurator;

	{
		[_x] call FF7_fnc_addToCurator;
	} forEach (units _tmpGrp);

	_objEnemy = _objEnemy + [_tmpGrp];

	_tmpUnit	= nil;
	_tmpGrp		= nil;
	_tmpObj		= nil;
} forEach _statics;


// Spawn and crew Artys
_objArty1 = [(_artys select 0), _objOrg, _rndDir] call _spawnRel;
_objArty2 = [(_artys select 1), _objOrg, _rndDir] call _spawnRel;
_objArty3 = [(_artys select 2), _objOrg, _rndDir] call _spawnRel;

{
	private ["_tmpUnit", "_tmpGrp", "_tmpCmdr", "_tmpGnr", "tmpDir"];

	_tmpDir = (getDir _x);

	_x allowCrewInImmobile true;

	_tmpGrp	= createGroup _facSide;

	_unitOff createUnit [getPos _x, _tmpGrp];
	_unitEng createUnit [getPos _x, _tmpGrp];

	_tmpGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

	_tmpGrp setFormDir _tmpDir;

	_tmpCmdr	= ((units _tmpGrp) select 0);
	_tmpGnr		= ((units _tmpGrp) select 1);

	_tmpCmdr setDir _tmpDir;
	_tmpGnr setDir _tmpDir;

	_tmpCmdr assignAsCommander _x;
	_tmpCmdr moveInCommander _x;

	_tmpGnr assignAsGunner _x;
	_tmpGnr moveInGunner _x;

	_tmpGrp setBehaviour "COMBAT";
	_tmpGrp setCombatMode "RED";
	_tmpGrp allowFleeing 0;

	_x engineOn true;
	_x lock 2;

	//_x setVariable ["ace_cookoff_enable", false, true];

	[_x] call FF7_fnc_addToCurator;

	{
		[_x] call FF7_fnc_addToCurator;
	} forEach (units _tmpGrp);

	_objEnemy	= _objEnemy + [_tmpGrp];
	_objSpawned	= _objSpawned + [_x];
} forEach [_objArty1, _objArty2, _objArty3];

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorOPFOR", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["Eliminate", format ["Locate artillery near %1 and eliminate it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		_faction
	] call OPS_fnc_spawnObjEnemy
);

_artyUp = true;

while {_artyUp} do
{
	private ["_count"];

	_count = 0;

	{
		if !(alive _x) then
		{
			_count = _count + 1;
		};
	} forEach [_objArty1, _objArty2, _objArty3];

	if (_count == 3) then
	{
		_artyUp = false;
	};

	sleep 5;
};

FF7_OP_missionSuccess = true;

sleep 1;

["Completed", format ["Good job, the artillery near %1 has been eliminated ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
