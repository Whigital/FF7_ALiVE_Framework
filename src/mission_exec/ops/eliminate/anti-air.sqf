private ["_posOK", "_marker", "_location", "_objPos", "_objEmp", "_objOrg", "_statics", "_aas", "_objAA1", "_objAA2", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir"];

private ["_faction", "_factionClasses", "_facSide", "_unitEng", "_unitOff", "_vehAA"];

if (FF7_Global_Debug) then
{
	["OPS/Eliminate", "Running mission anti-air"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find and elimitante the enemy AA units";

_objThings	=
[
	//["Box_East_AmmoVeh_F",[0,0,0],0],
	["CamoNet_OPFOR_open_F",[0.439697,-0.548462,0],0], // CamoNet_BLUFOR_open_F or CamoNet_OPFOR_open_F
	["Box_FIA_Wps_F",[1.43579,-1.10791,0],304.77],
	["Land_PaperBox_open_full_F",[-1.52783,-1.31958,0],344.019],
	["Land_Pallet_MilBoxes_F",[0.768311,1.79224,0],100.897],
	["Box_FIA_Ammo_F",[-1.63232,1.34363,0],19.6129],
	//["O_static_AT_F",[-5.92554,-2.66956,0],240],
	//["O_HMG_01_high_F",[-6.07178,2.52368,0],300],
	//["O_static_AT_F",[6.41943,2.55688,0],60],
	//["O_HMG_01_high_F",[6.57227,-2.85022,0],120.141],
	["Land_HBarrier_Big_F",[4.52295,-10.7817,3.62396e-005],269.991],
	//["O_T_APC_Tracked_02_AA_ghex_F",[0.142578,-11.651,0],179.998],
	["Land_HBarrier_Big_F",[-3.99512,-10.9641,3.62396e-005],269.991],
	["Land_HBarrier_Big_F",[-4.26489,11.1747,0],90],
	//["O_T_APC_Tracked_02_AA_ghex_F",[0.115234,12.0426,-3.62396e-005],0],
	["Land_HBarrier_Big_F",[4.25171,11.3553,0],90],
	["Land_HBarrier_Big_F",[0.456055,-16.2916,3.62396e-005],179.998],
	["Land_HBarrier_Big_F",[-0.197998,16.684,0],0]
];

_statics =
[
	["O_static_AT_F",[-5.92554,-2.66956,0],240],
	["O_HMG_01_high_F",[-6.07178,2.52368,0],300],
	["O_static_AT_F",[6.41943,2.55688,0],60],
	["O_HMG_01_high_F",[6.57227,-2.85022,0],120.141]
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
_vehAA		= (_factionClasses select 7);

_aas =
[
	[_vehAA,[0.142578,-11.651,0],179.998],
	[_vehAA,[0.115234,12.0426,-3.62396e-005],0]
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


// Spawn and crew AAs
_objAA1 = [(_aas select 0), _objOrg, _rndDir] call _spawnRel;
_objAA2 = [(_aas select 1), _objOrg, _rndDir] call _spawnRel;

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
} forEach [_objAA1, _objAA2];

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorOPFOR", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["Eliminate", format ["Locate the AA battery near %1 and eliminate it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		_faction
	] call OPS_fnc_spawnObjEnemy
);

_aasUp = true;

while {_aasUp} do
{
	private ["_count"];

	_count = 0;

	{
		if !(alive _x) then
		{
			_count = _count + 1;
		};
	} forEach [_objAA1, _objAA2];

	if (_count == 2) then
	{
		_aasUp = false;
	};

	sleep 5;
};

FF7_OP_missionSuccess = true;

sleep 1;

["Completed", format ["Good job, the AA battery near %1 has been eliminated ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
