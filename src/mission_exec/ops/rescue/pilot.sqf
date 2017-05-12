private
[
	"_posOK",
	"_marker",
	"_location",
	"_objPos",
	"_objOrg",
	"_posPilot"
	,"_objPilot",
	"_grpPilot",
	"_hmgs",
	"_objThings",
	"_objSpawned",
	"_objEnemy",
	"_relPos",
	"_rndDir",
	"_pilotEH",
	"_faction",
	"_facSide",
	"_empUnit"
];

if (FF7_Global_Debug) then
{
	["OPS/Rescue", "Running mission pilot"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the pilot and bring him to back to HQ";

_objThings	=
[
	//["Campfire_burning_F",[0,0,0],0],
	["Land_CampingChair_V1_F",[-2.10938,-0.502197,0],232.626],
	["Land_CampingChair_V1_F",[-1.13965,2.53918,0],335.799],
	["Land_WoodenLog_F",[-3.0376,0.589478,4.673e-005],0],
	["MetalBarrel_burning_F",[3.05713,-1.73279,6.67572e-006],0],
	//["O_HMG_01_high_F",[0.262207,-3.8573,0],194.627],
	["Land_TentA_F",[4.06348,0.667847,7.15256e-005],72.2764],
	["Land_WoodPile_F",[-4.14697,0.136108,0],338.986],
	["Camp_EP1",[0.450195,5.66553,0],186.221],
	["Land_TentA_F",[-4.14941,2.8562,6.67572e-005],300.785],
	["Land_WoodPile_large_F",[3.90039,-3.45654,0],220.961],
	//["B_Pilot_F",[1.30957,5.95593,0.00143909],209.792],
	["Land_Bucket_F",[-0.876465,6.50183,0.0577502],0],
	["Land_Razorwire_F",[-7.72266,1.10254,-5.53131e-005],68.7474],
	["Hhedgehog_concrete",[0.793457,-7.21106,0],185.607],
	["Land_Sleeping_bag_brown_F",[-0.553711,7.3833,0.0604043],286.272],
	//["O_HMG_01_high_F",[-5.0874,5.73267,0],303.112],
	//["O_HMG_01_high_F",[7.47656,3.72754,0],65.8859],
	["Land_Razorwire_F",[7.76465,-3.21082,-5.72205e-005],288.738],
	["Land_Razorwire_F",[-4.12256,9.73596,0],142.043],
	["Land_Razorwire_F",[8.73682,6.73303,0],220.984]
];

_hmgs =
[
	["O_HMG_01_high_F",[0.262207,-3.8573,0],194.627],
	["O_HMG_01_high_F",[-5.0874,5.73267,0],303.112],
	["O_HMG_01_high_F",[7.47656,3.72754,0],65.8859]
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
		_objPos = [_marker, 400, 10, 0.35] call OPS_fnc_getPosFromMarker;

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
_empUnit	= (_factionClasses select 4);

_rndDir = (random 360);

// ---------- Spawn origin
_objOrg = createVehicle ["Campfire_burning_F", [0, 0, 0], [], 0, "NONE"];
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


// Spawn Pilot
_posPilot = (_objOrg modelToWorld [1.30957,5.95593,0.00143909]);
_grpPilot = createGroup west;

_grpPilot setVariable ["FF7_AI_Distributor_serverLocal", true];

"B_Pilot_F" createUnit [_posPilot, _grpPilot];

_objPilot = ((units _grpPilot) select 0);

_objPilot setVariable ["FF7_OPS_Target", true];

_grpPilot setFormDir (209.792 + _rndDir);
_objPilot setDir (209.792 + _rndDir);
_objPilot setPos _posPilot;

removeAllWeapons _objPilot;
removeAllItems _objPilot;
removeAllAssignedItems _objPilot;
removeUniform _objPilot;
removeVest _objPilot;
removeBackpack _objPilot;
removeHeadgear _objPilot;
removeGoggles _objPilot;

_objPilot forceAddUniform "U_B_PilotCoveralls";
_objPilot addBackpack "B_Parachute";
_objPilot addHeadgear "H_PilotHelmetFighter_B";
_objPilot addGoggles "G_Aviator";

_objPilot setunitpos "UP";
_objPilot setBehaviour "Careless";

dostop _objPilot;

_objPilot playmove "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon";
_objPilot disableAI "MOVE";

if !(isnil "ACE_captives_fnc_setHandcuffed") then
{
	[_objPilot, true] call ACE_captives_fnc_setHandcuffed;
}
else
{
	_objPilot setCaptive true;
};

[_objPilot] call FF7_fnc_addToCurator;

// Spawn HMGs
{
	private ["_tmpObj", "_tmpUnit", "_tmpDir", "_tmpGrp"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;
	_objSpawned = _objSpawned + [_tmpObj];

	waitUntil
	{
		sleep 1;
		!isNull _tmpObj;
	};

	_tmpGrp	= createGroup _facSide;

	_tmpDir = (getDir _tmpObj);

	_empUnit createUnit [getPos _tmpObj, _tmpGrp];
	_tmpGrp setBehaviour "COMBAT";
	_tmpGrp setCombatMode "RED";

	_tmpUnit = ((units _tmpGrp) select 0);
	_tmpGrp setFormDir _tmpDir;
	_tmpUnit setDir _tmpDir;
	_tmpUnit setPos (getPos _tmpObj);

	_tmpUnit assignAsGunner _tmpObj;
	_tmpUnit moveInGunner _tmpObj;

	_tmpGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

	//_tmpObj lock 2;

	[_tmpObj] call FF7_fnc_addToCurator;

	{
		[_x] call FF7_fnc_addToCurator;
	} forEach (units _tmpGrp);

	_objEnemy = _objEnemy + [_tmpGrp];

	_tmpUnit = nil;
	_tmpGrp = nil;
} forEach _hmgs;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorCIV", "Border", "mil_unknown"] call OPS_fnc_createMarker;

["Rescue", format ["Locate the pilot near %1 and rescue him.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		_faction
	] call OPS_fnc_spawnObjEnemy
);

while {alive _objPilot} do
{
	private ["_dist"];

	_dist = (_objPilot distance (getMarkerPos "mkr_hq"));

	if (_dist < 10) exitWith {FF7_OP_missionSuccess = true;};

	sleep 1;
};

if (FF7_OP_missionSuccess) then
{
	["Completed", "Pilot safely brought back to HQ."] remoteExec ["FF7_fnc_globalNotify", 0, false];

	//_objPilot removeEventHandler ["Killed", _pilotEH];

	if !(isnil "ACE_captives_fnc_setHandcuffed") then
	{
	[_objPilot, false] call ACE_captives_fnc_setHandcuffed;
	}
	else
	{
		_objPilot setCaptive false;
	};
};

if !(alive _objPilot) then
{
	["Failed", "The pilot has been killed, mission failed."] remoteExec ["FF7_fnc_globalNotify", 0, false];
};

{
	deleteMarker _x;
} foreach _markers;

//[[_objSpawned], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
//[[_objEnemy], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
[[_objPilot], (random [180, 300, 540])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
