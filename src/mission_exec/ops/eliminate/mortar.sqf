private ["_posOK", "_marker", "_location", "_objPos", "_objEmp", "_objOrg", "_hmgs", "_mortars", "_objMortars", "_objMortar1", "_objMortar2", "_objMortar3", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir"];

private ["_faction", "_factionClasses", "_facSide", "_empUnit"];

if (FF7_Global_Debug) then
{
	["OPS/Eliminate", "Running mission mortar"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find and eliminate the enemy mortars";

_objThings	=
[
	//["Box_East_AmmoVeh_F",[0,0,0],0],
	["Box_CSAT_Equip_F",[-1.43896,0.010376,0],337.667],
	["Box_FIA_Wps_F",[0.989258,1.45923,-4.57764e-005],214.305],
	["Box_T_East_Wps_F",[-0.848633,1.75037,0],118.962],
	//["O_Mortar_01_F",[-0.0141602,-3.51611,0],180],
	["Land_BagFence_Short_F",[-2.66602,-3.78711,0],270],
	["Land_BagFence_Short_F",[2.6958,-4.05579,0],90],
	//["O_Mortar_01_F",[-4.25635,3.1571,3.05176e-005],315.041],
	//["O_Mortar_01_F",[4.52881,2.9126,0],45.0137],
	["Land_BagFence_Short_F",[-2.5708,5.22864,3.05176e-005],45.0404],
	["Land_BagFence_Short_F",[2.99658,5.21143,0],315.014],
	//["O_HMG_01_high_F",[5.74902,-2.23596,-6.67572e-005],132.108],
	["Land_BagFence_Round_F",[-2.30713,-6.09338,0],45],
	["Land_BagFence_Round_F",[2.20947,-6.29565,0],315],
	["Land_BagFence_Short_F",[-0.0439453,-6.6554,0],0],
	["Land_BagFence_Short_F",[6.59814,1.22925,0],135.014],
	["Land_BagFence_Short_F",[-6.55615,1.6261,3.05176e-005],225.049],
	//["O_HMG_01_high_F",[-6.56543,-1.91382,5.72205e-005],226.864],
	//["O_HMG_01_high_F",[0.344727,6.97888,-6.10352e-005],0.298082],
	["Land_BagFence_Round_F",[-4.45459,6.60107,3.05176e-005],180.046],
	["Land_BagFence_Round_F",[4.92236,6.45007,0],180.029],
	["Land_BagFence_Round_F",[-7.7915,3.55408,3.05176e-005],90.0557],
	["Land_BagFence_Round_F",[7.97168,3.11304,0],270.015],
	["Land_BagFence_Short_F",[-6.45313,5.39893,3.05176e-005],135.058],
	["Land_BagFence_Short_F",[6.771,5.11096,0],225.03],
	["Land_Razorwire_F",[9.69043,-2.25232,0],135],
	["Land_Razorwire_F",[-7.66064,-4.63428,0],225],
	["Land_Razorwire_F",[-1.73975,10.2667,7.24792e-005],0]
];

_hmgs =
[
	["O_HMG_01_high_F",[-6.56543,-1.91382,5.72205e-005],226.864],
	["O_HMG_01_high_F",[0.344727,6.97888,-6.10352e-005],0.298082],
	["O_HMG_01_high_F",[5.74902,-2.23596,-6.67572e-005],132.108]
];

_mortars =
[
	["O_Mortar_01_F",[-0.0141602,-3.51611,0],180],
	["O_Mortar_01_F",[-4.25635,3.1571,3.05176e-005],315.041],
	["O_Mortar_01_F",[4.52881,2.9126,0],45.0137]
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
	[_tmpObj, false] call ace_dragging_fnc_setDraggable;
	[_tmpObj, false] call ace_dragging_fnc_setCarryable;
	_tmpObj setVariable ["ace_cargo_canLoad", 0];

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
		_objPos = [_marker, 500, 10, 0.5] call OPS_fnc_getPosFromMarker;

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
_objOrg = createVehicle ["Box_East_AmmoVeh_F", [0, 0, 0], [], 0, "NONE"];
_objOrg setDir _rndDir;
_objOrg setPos _objPos;
//_objOrg setVectorUp [0,0,1];
//_objOrg enableSimulation false;
//_objOrg allowDamage false;

[_objOrg, false] call ace_dragging_fnc_setDraggable;
[_objOrg, false] call ace_dragging_fnc_setCarryable;
_objOrg setVariable ["ace_cargo_canLoad", 0];
_objOrg setVariable ["gc_persist", true];

_objSpawned = _objSpawned + [_objOrg];

// Spawn things
{
	private ["_tmpObj"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;

	_objSpawned = _objSpawned + [_tmpObj];
} forEach _objThings;

_objGroup = createGroup _facSide;

// Spawn HMGs
{
	private ["_tmpObj", "_tmpUnit"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;
	_objSpawned = _objSpawned + [_tmpObj];

	waitUntil
	{
		!(isNull _tmpObj);
	};

	_objEmp = _objEmp + [_tmpObj];
	_tmpObj = nil;
	_tmpUnit = nil;
} forEach _hmgs;

// Spawn mortars
_objMortar1 = [(_mortars select 0), _objOrg, _rndDir] call _spawnRel;
_objMortar2 = [(_mortars select 1), _objOrg, _rndDir] call _spawnRel;
_objMortar3 = [(_mortars select 2), _objOrg, _rndDir] call _spawnRel;

_objEmp = _objEmp + [_objMortar1, _objMortar2, _objMortar3];

{
	private ["_tmpUnit", "_tmpDir", "_tmpGrp"];

	_tmpDir = (getDir _x);

	_tmpGrp	= createGroup _facSide;

	_empUnit createUnit [getPos _x, _tmpGrp];
	_tmpGrp setBehaviour "COMBAT";
	_tmpGrp setCombatMode "RED";

	_tmpUnit = ((units _tmpGrp) select 0);
	_tmpGrp setFormDir _tmpDir;
	_tmpUnit setDir _tmpDir;
	_tmpUnit setPos (getPos _x);

	_tmpUnit assignAsGunner _x;
	_tmpUnit moveInGunner _x;

	//[_tmpGrp, 0.3, 0.7, 0.05] call OPS_fnc_setGroupSkill;

	_tmpGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

	_x lock 2;

	[_x] call FF7_fnc_addToCurator;

	{
		[_x] call FF7_fnc_addToCurator;
	} forEach (units _tmpGrp);

	_objEnemy = _objEnemy + [_tmpGrp];

	_tmpUnit = nil;
	_tmpGrp = nil;
} forEach _objEmp;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorOPFOR", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["Eliminate", format ["Locate the mortars near %1 and eliminate them.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		_faction
	] call OPS_fnc_spawnObjEnemy
);

_mortarsUp = true;

while {_mortarsUp} do
{
	private ["_count"];

	_count = 0;

	{
		if !(alive _x) then
		{
			_count = _count + 1;
		};
	} forEach [_objMortar1, _objMortar2, _objMortar3];

	if (_count == 3) then
	{
		_mortarsUp = false;
	};

	sleep 5;
};

FF7_OP_missionSuccess = true;

sleep 1;

["Completed", format ["Good job, the mortars near %1 has been eliminated ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objEmp, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
//[_objSpawned, (random [180, 540, 720])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objEmp, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
