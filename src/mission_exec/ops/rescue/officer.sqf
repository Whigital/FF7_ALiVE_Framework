private
[
	"_posOK",
	"_marker",
	"_location",
	"_objPos",
	"_objOrg",
	"_posOff",
	"_objOff",
	"_grpOff",
	"_hmgs",
	"_objThings",
	"_objSpawned",
	"_objEnemy",
	"_relPos",
	"_rndDir",
	"_offEH",
	"_faction",
	"_factionClasses",
	"_facSide",
	"_empUnit"
];

if (FF7_Global_Debug) then
{
	["OPS/Rescue", "Running mission officer"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the officer and bring him to back to HQ";

_objThings	=
[
	//["CamoNet_BLUFOR_big_F",[0,0,0],0],
	["Land_CampingTable_F",[-0.256836,1.00293,0],140.511],
	["Land_CampingChair_V2_F",[-1.27759,-0.101563,0],206.354],
	["Land_CampingChair_V1_F",[-1.22754,1.44153,0],329.467],
	["Campfire_burning_F",[1.94653,-0.820679,0],0],
	["Land_CampingChair_V2_F",[-0.548584,2.07129,0],304.409],
	["Land_CampingChair_V1_F",[1.2644,2.20483,0],30.5786],
	["Land_Garbage_line_F",[-2.85229,2.10168,0],31.7468],
	["Land_Garbage_line_F",[2.63867,-0.451904,0],337.681],
	["Land_CampingChair_V1_folded_F",[2.67212,2.78845,0],30.0845],
	["Land_Garbage_square5_F",[-0.227539,-3.95508,0],316.204],
	["Land_CampingChair_V1_folded_F",[3.19971,3.5697,0],327.61],
	["Land_Sleeping_bag_F",[-2.98047,4.33643,0],13.3625],
	["Land_Sleeping_bag_brown_F",[-5.34863,1.302,0],301.358],
	["Land_TentDome_F",[4.80273,2.25159,0],328.633],
	//["B_T_Officer_F",[-4.38037,2.73645,0.00143909],117.486],
	["Land_WoodenLog_F",[2.46338,4.76819,0],267.806],
	["Land_WoodPile_large_F",[-0.709717,6.20679,0],277.665],
	["Land_TentA_F",[6.23901,-0.486938,0],70.3927],
	["Land_WaterTank_04_F",[-5.76587,-2.6897,0],254.436],
	["MetalBarrel_burning_F",[-6.37915,0.93103,0],306.396],
	["Land_Bucket_painted_F",[-3.24683,5.6842,0],56.6147],
	["Land_Sacks_heap_F",[-6.53271,-0.521851,0],233.696],
	["Land_WoodPile_F",[2.32642,6.24597,0],239.364],
	["Land_WoodPile_F",[4.08716,5.28662,0],310.177],
	["Land_WoodenBox_F",[-4.64673,4.87195,0],139.992],
	["Land_PortableGenerator_01_F",[-4.91406,-4.70715,0],246.707],
	["Land_WoodenBox_F",[-6.04639,3.59265,0],79.966],
	["Land_PortableLight_single_F",[-4.3855,-6.28662,0],194.083],
	["Land_PortableLight_single_F",[7.66797,-3.0575,0],120.89],
	["Land_Razorwire_F",[-8.90137,5.5907,0],119.909],
	["Land_Razorwire_F",[-4.07324,10.2975,0],352.41],
	//["O_GMG_01_high_F",[1.16797,-10.73,0],170.293],
	//["O_GMG_01_high_F",[7.48096,-7.87219,0],97.5941],
	["Land_Razorwire_F",[6.24585,9.30957,0],40.5073],
	["Land_Razorwire_F",[-10.439,-3.89551,0],64.0221],
	["Land_Razorwire_F",[11.4414,0.660034,0],96.9813],
	//["O_GMG_01_high_F",[-5.02393,-10.4784,0],237.451],
	["Land_BagFence_Long_F",[9.09204,-8.18286,0],278.565], // Land_BagFence_Long_F or Land_BagFence_01_long_green_F
	["Land_BagFence_Long_F",[2.67017,-13.0421,0],26.2014],
	["Land_BagFence_Long_F",[-1.69019,-13.3489,0],350.808],
	["Land_BagFence_Long_F",[6.7749,-11.8256,0],307.044],
	["Land_BagFence_Long_F",[-6.03589,-12.3322,0],52.3778]
];

_hmgs =
[
	["O_HMG_01_high_F",[1.16797,-10.73,0],170.293],
	["O_HMG_01_high_F",[7.48096,-7.87219,0],97.5941],
	["O_HMG_01_high_F",[-5.02393,-10.4784,0],237.451]
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
		_objPos = [_marker, 300, 10, 0.35] call OPS_fnc_getPosFromMarker;

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
_objOrg = createVehicle ["CamoNet_OPFOR_big_F", [0, 0, 0], [], 0, "NONE"]; // CamoNet_BLUFOR_big_F or CamoNet_OPFOR_big_F
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


// Spawn Officer
_posOff = (_objOrg modelToWorld [-4.38037,2.73645,0.00143909]);

_grpOff = createGroup west;

_grpOff setVariable ["FF7_AI_Distributor_serverLocal", true];

"B_T_Officer_F" createUnit [_posOff, _grpOff];

_objOff = ((units _grpOff) select 0);

_objOff setVariable ["FF7_OPS_Target", true];

_grpOff setFormDir (117.486 + _rndDir);
_objOff setDir (117.486 + _rndDir);
_objOff setPos _posOff;

removeAllWeapons _objOff;
removeAllItems _objOff;
removeAllAssignedItems _objOff;
removeUniform _objOff;
removeVest _objOff;
removeBackpack _objOff;
removeHeadgear _objOff;
removeGoggles _objOff;

_objOff forceAddUniform "U_B_CombatUniform_mcam";
_objOff addVest "V_BandollierB_khk";
_objOff addHeadgear "H_Beret_Colonel";
_objOff addGoggles "G_Aviator";

_objOff setunitpos "UP";
_objOff setBehaviour "Careless";

dostop _objOff;

_objOff playmove "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon";
_objOff disableAI "MOVE";

if !(isnil "ACE_captives_fnc_setHandcuffed") then
{
	[_objOff, true] call ACE_captives_fnc_setHandcuffed;
}
else
{
	_objOff setCaptive true;
};

[_objOff] call FF7_fnc_addToCurator;

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

	_empUnit createUnit [(getPos _tmpObj), _tmpGrp];
	_tmpGrp setBehaviour "COMBAT";
	_tmpGrp setCombatMode "RED";

	_tmpUnit = ((units _tmpGrp) select 0);
	_tmpGrp setFormDir _tmpDir;
	_tmpUnit setDir _tmpDir;
	_tmpUnit setPos (getPos _tmpObj);

	_tmpUnit assignAsGunner _tmpObj;
	_tmpUnit moveInGunner _tmpObj;

	//[_tmpGrp, 0.3, 0.7, 0.05] call OPS_fnc_setGroupSkill;

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

["Rescue", format ["Locate the officer near %1 and rescue him.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		_faction
	] call OPS_fnc_spawnObjEnemy
);

while {alive _objOff} do
{
	private ["_dist"];

	_dist = (_objOff distance (getMarkerPos "mkr_hq"));

	if (_dist < 10) exitWith {FF7_OP_missionSuccess = true;};

	sleep 1;
};

if (FF7_OP_missionSuccess) then
{
	["Completed", "Officer safely brought back to HQ."] remoteExec ["FF7_fnc_globalNotify", 0, false];

	//_objOff removeEventHandler ["Killed", _offEH];

	if !(isnil "ACE_captives_fnc_setHandcuffed") then
	{
		[_objOff, false] call ACE_captives_fnc_setHandcuffed;
	}
	else
	{
		_objOff setCaptive false;
	};
};

if !(alive _objOff) then
{
	["Failed", "The officer has been killed, mission failed."] remoteExec ["FF7_fnc_globalNotify", 0, false];
};

{
	deleteMarker _x;
} foreach _markers;

//[[_objSpawned], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
//[[_objEnemy], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
[[_objOff], (random [180, 300, 540])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
