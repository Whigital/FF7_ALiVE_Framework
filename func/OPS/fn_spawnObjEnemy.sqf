private
[
	"_randomPos",
	"_objEnemies",
	"_infTeam",
	"_rndStatic",
	"_rndVehicle",
	"_rndCrew",
	"_sniperTeam",
	"_facSide",
	"_factionClasses",
	"_side",
	"_fact",
	"_teamSnip",
	"_empUnit",
	"_INF_TEAMS",
	"_VEH_MECH",
	"_VEH_ARM",
	"_EMP_STATIC",
	"_infPath"
];

params
[
	"_posObj",
	"_faction",
	["_numInf",			FF7_OP_numInfAO],
	["_numSnip",		FF7_OP_numSniperAO],
	["_numStatic",	FF7_OP_numStaticAO],
	["_numMech",		FF7_OP_numMechAO],
	["_numArmr",		FF7_OP_numArmorAO],
	["_radius",			FF7_OP_radiusAO]
];

if (FF7_Global_Debug) then
{
	["OPS_fnc_spawnObjEnemy", "Running function"] call FF7_fnc_debugLog;
};

_objEnemies	= [grpNull];

_INF_TEAMS	= [];
_VEH_MECH	= [];
_VEH_ARM	= [];
_EMP_STATIC	= [];

_factionClasses = [_faction] call OPS_fnc_classesFromFaction;

_facSide	= (_factionClasses select 0);
_side			= (_factionClasses select 1);
_fact			= (_factionClasses select 2);
_teamSnip	= (_factionClasses select 3);
_empUnit	= (_factionClasses select 4);

_INF_TEAMS	= (_factionClasses select 9);
_VEH_MECH		= (_factionClasses select 10);
_VEH_ARM		= (_factionClasses select 11);
_EMP_STATIC	= (_factionClasses select 12);
_infPath		= (_factionClasses select 13);


//---------- Infantry
for "_x" from 1 to _numInf do
{
	_infTeam	= createGroup _facSide;
	_randomPos	= [_posObj, 25, (_radius * 0.75), 10, 0, 10, 0] call BIS_fnc_findSafePos;
	_infTeam	= [_randomPos, _facSide, (configfile >> "CfgGroups" >> _side >> _fact >> _infPath >> (selectRandom _INF_TEAMS))] call BIS_fnc_spawnGroup;

	[_infTeam, _randomPos, (_radius * 0.5)] call BIS_fnc_taskPatrol;
	//[_infTeam, _posObj, (_radius * 1.5), 8] call CBA_fnc_taskPatrol;

	//[_infTeam, 0.32, 0.7, 0.08] call OPS_fnc_setGroupSkill;

	_objEnemies = _objEnemies + [_infTeam];

	{
		[_x] call FF7_fnc_addToCurator;
	} foreach units _infTeam;

	_infTeam = nil;
	sleep 1;
};


//---------- Overwatch
if (_numSnip > 0) then
{
	for "_x" from 1 to _numSnip do
	{
		private ["_tmpDir"];

		_tmpDir = (random 360);

		_sniperTeam	= createGroup _facSide;

		//_sniperTeam setVariable ["ALiVE_CombatSupport", true];

		_randomPos	= [_posObj, (_radius * 1.5), (_radius * 0.5)] call BIS_fnc_findOverwatch;

		if (_fact == "rhs_faction_vdv") then
		{
			_sniperTeam	= [_randomPos, _facSide, (configfile >> "CfgGroups" >> _side >> "OPF_F" >> "Infantry" >> "OI_SniperTeam")] call BIS_fnc_spawnGroup;
		}
		else
		{
			_sniperTeam	= [_randomPos, _facSide, (configfile >> "CfgGroups" >> _side >> _fact >> "Infantry" >> _teamSnip)] call BIS_fnc_spawnGroup;
		};

		_sniperTeam setFormDir _tmpDir;

		//[_sniperTeam, 0.7, 0.75, 0.15] call OPS_fnc_setGroupSkill;

		_objEnemies = _objEnemies + [_sniperTeam];

		{
			//[_x] doWatch _posObj;
			_x setDir _tmpDir;
			_x setUnitPos "DOWN";
		} foreach units _sniperTeam;

		_sniperTeam setBehaviour "COMBAT";
		_sniperTeam setCombatMode "RED";

		{
			[_x] call FF7_fnc_addToCurator;
		} foreach units _sniperTeam;

		{
			_x setSkill 1;
		} foreach units _sniperTeam;

		_sniperTeam = nil;
		sleep 1;
	};
};


//---------- Statics
if (_numStatic > 0) then
{
	for "_x" from 1 to _numStatic do
	{
		private ["_tmpDir"];

		_tmpDir = (random 360);

		_rndCrew	= createGroup _facSide;

		//_rndCrew setVariable ["ALiVE_CombatSupport", true];

		//_randomPos	= [_posObj, 250, 100, 5] call BIS_fnc_findOverwatch;
		_randomPos	= [_posObj, 25, _radius, 10, 0, 5, 0] call BIS_fnc_findSafePos;

		_rndStatic	= (selectRandom _EMP_STATIC) createVehicle _randomPos;
		_rndStatic enableSimulationGlobal false;
		_rndStatic setDir _tmpDir;
		_rndStatic setVectorUp (surfaceNormal (getPos _rndStatic));
		//_rndStatic setVectorUp [0, 0, 1];

		waitUntil
		{
			!(isNull _rndStatic);
		};

		_empUnit createUnit [_randomPos, _rndCrew];

		_rndCrew setFormDir _tmpDir;
		((units _rndCrew) select 0) setDir _tmpDir;

		((units _rndCrew) select 0) assignAsGunner _rndStatic;
		((units _rndCrew) select 0) moveInGunner _rndStatic;

		_rndCrew setBehaviour "COMBAT";
		_rndCrew setCombatMode "RED";
		//_rndStatic lock 3;
		_rndStatic enableSimulationGlobal true;

		//[_rndCrew, 0.3, 0.7, 0.05] call OPS_fnc_setGroupSkill;

		_objEnemies = _objEnemies + [_rndStatic];
		_objEnemies = _objEnemies + [_rndCrew];

		[_rndStatic] call FF7_fnc_addToCurator;

		{
			[_x] call FF7_fnc_addToCurator;
		} foreach units _rndCrew;

		_rndStatic = nil;
		sleep 1;
	};
};


//---------- Mechanized
if (_numMech > 0) then
{
	for "_x" from 1 to _numMech do
	{
		_rndCrew	= createGroup _facSide;

		//_rndCrew setVariable ["ALiVE_CombatSupport", true];

		_randomPos	= [_posObj, 25, (_radius * 0.75), 10, 0, 10, 0] call BIS_fnc_findSafePos;
		_rndVehicle	= (selectRandom _VEH_MECH) createVehicle _randomPos;

		waitUntil
		{
			!(isNull _rndVehicle);
		};

		[_rndVehicle, _rndCrew, false, "", _empUnit] call BIS_fnc_spawnCrew;

		[_rndCrew, _randomPos, (_radius * 0.25)] call BIS_fnc_taskPatrol;
		//[_rndCrew, _posObj, (_radius * 1.25), 6] call CBA_fnc_taskPatrol;

		//_rndVehicle lock 3;

		//[_rndCrew, 0.3, 0.75, 0.05] call OPS_fnc_setGroupSkill;

		_objEnemies = _objEnemies + [_rndVehicle];
		_objEnemies = _objEnemies + [_rndCrew];

		[_rndVehicle] call FF7_fnc_addToCurator;

		{
			[_x] call FF7_fnc_addToCurator;
		} foreach units _rndCrew;

		_rndVehicle = nil;
		sleep 1;
	};
};


//---------- Armor
if (_numArmr > 0) then
{
	for "_x" from 1 to _numArmr do
	{
		_rndCrew	= createGroup _facSide;

		//_rndCrew setVariable ["ALiVE_CombatSupport", true];

		_randomPos	= [_posObj, 25, (_radius * 0.5), 10, 0, 10, 0] call BIS_fnc_findSafePos;
		_rndVehicle	= (selectRandom _VEH_ARM) createVehicle _randomPos;

		waitUntil
		{
			!(isNull _rndVehicle);
		};

		[_rndVehicle, _rndCrew] call BIS_fnc_spawnCrew;

		[_rndCrew, _randomPos, (_radius * 0.5)] call BIS_fnc_taskPatrol;
		//[_rndCrew, _posObj, _radius, 6] call CBA_fnc_taskPatrol;

		//_rndVehicle lock 3;

		//[_rndCrew, 0.3, 0.75, 0.05] call OPS_fnc_setGroupSkill;

		_objEnemies = _objEnemies + [_rndVehicle];
		_objEnemies = _objEnemies + [_rndCrew];

		[_rndVehicle] call FF7_fnc_addToCurator;

		{
			[_x] call FF7_fnc_addToCurator;
		} foreach units _rndCrew;

		_rndVehicle = nil;
		sleep 1;
	};
};


//---------- Return array
_objEnemies;
