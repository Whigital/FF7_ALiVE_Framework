private ["_posOK", "_marker", "_location", "_objPos", "_objOrg", "_posHost", "_objHost", "_grpHost", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir", "_houses", "_hostEH"];

private ["_house1", "_house2", "_house3", "_posHouse1", "_posHouse2", "_posHouse3", "_banditGrp1", "_banditGrp2", "_banditGrp3", "_banditGrp4", "_civs"];

if (FF7_Global_Debug) then
{
	["OPS/Rescue", "Running mission hostage"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the hostage and bring him to back to HQ";

_objThings	=
[
	//["Land_StoneTanoa_01_F",[0,0,0],0],
	//["Land_House_Native_02_F",[7.85132,-4.40942,0],154.831],
	["Land_AncientStatue_01_F",[6.91187,6.42151,0],317.361],
	["Land_AncientStatue_02_F",[-9.59863,2.66309,0],45.5961],
	//["Land_Temple_Native_01_F",[-3.43579,10.9423,0],340.343],
	["Land_AncientHead_01_F",[0.905518,-11.7968,0],343.696]
	//["Land_House_Native_01_F",[-11.0935,-6.27661,4.76837e-007],19.5858]
];

_INF_TEAMS	= ["BanditFireTeam", "ParaFireTeam"];

_bandits =
[
	"I_C_Soldier_Para_7_F",
	"I_C_Soldier_Para_4_F",
	"I_C_Soldier_Para_5_F",
	"I_C_Soldier_Bandit_7_F",
	"I_C_Soldier_Bandit_5_F",
	"I_C_Soldier_Para_6_F",
	"I_C_Soldier_Bandit_6_F",
	"I_C_Soldier_Bandit_2_F"
];

_objSpawned	= [];
_objEnemy	= [grpNull];

_spawnRel =
{
	private ["_tmpType", "_tmpOffset", "_tmpDir", "_tmpObj", "_relPos"];

	params ["_struct", "_orgObj", "_rndDir"];

	_tmpType	= (_struct select 0);
	_tmpOffset	= (_struct select 1);
	_tmpDir		= (_struct select 2);

	_relPos = (_orgObj modelToWorld _tmpOffset);

	_tmpObj = createVehicle [_tmpType, [0, 0, 0], [], 0, "CAN_COLLIDE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0.25];
	//_tmpObj setVectorUp [0,0,1];
	//_tmpObj enableSimulation false;
	//_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	//[_tmpObj] call FF7_fnc_addToCurator;

	_tmpObj;
};

_genWPs =
{
	private ["_wp", "_wpp"];

	params ["_pos", "_cnt", "_grp"];

	for "_i" from 1 to _cnt do
	{
		private ["_wp", "_wpp"];

		_wpp	= (selectRandom (selectRandom _pos));
		_wp		= _grp addWaypoint [_wpp, 2];

		_wp setWaypointType "MOVE";
		_wp setWaypointTimeout [15, 30, 45];
	};

	[_grp, _cnt] setWaypointType "CYCLE";
};

_houses =
[
	["Land_House_Native_02_F",[7.85132,-4.40942,0],154.831],
	//["Land_Temple_Native_01_F",[-3.43579,10.9423,0],340.343],
	["Land_House_Native_01_F",[-3.43579,10.9423,0],340.343],
	["Land_House_Native_01_F",[-11.0935,-6.27661,4.76837e-007],19.5858]
];

_civs =
[
	"C_man_sport_1_F",
	"C_man_polo_5_F",
	"C_man_polo_4_F",
	"C_Man_casual_5_F",
	"C_Man_casual_4_F"
];

while {!_posOK} do
{
	_marker = (selectRandom FF7_OP_markersObj);

	//diag_log format ["Try position in: %1", (markerText _marker)];

	if (((getMarkerPos _marker) distance FF7_OP_gatherPos) > 2000) then
	{
		_objPos = [_marker, 400, 25, 0.3] call OPS_fnc_getPosFromMarker;

		if !(_objPos isEqualTo [0, 0, 0]) then
		{
			_posOK = true;
		}
	};
};

FF7_OP_markersObj = FF7_OP_markersObj - [_marker];

FF7_OP_missionPos = _objPos;

_location = markerText _marker;

_rndDir = (random 360);

// ---------- Spawn origin
_objOrg = createVehicle ["Land_StoneTanoa_01_F", [0, 0, 0], [], 0, "NONE"];
_objOrg setDir _rndDir;
_objOrg setPos _objPos;
//_objOrg setVectorUp [0,0,1];
//_objOrg enableSimulation false;
//_objOrg allowDamage false;
_objOrg setVariable ["gc_persist", true];

_objSpawned = _objSpawned + [_objOrg];

// Spawn houses
_house1 = [(_houses select 0), _objOrg, _rndDir] call _spawnRel;
_house1 setVectorUp [0,0,1];
_posHouse1 = _house1 buildingPos -1;

_house2 = [(_houses select 1), _objOrg, _rndDir] call _spawnRel;
_house2 setVectorUp [0,0,1];
_posHouse2 = _house2 buildingPos -1;

_house3 = [(_houses select 2), _objOrg, _rndDir] call _spawnRel;
_house3 setVectorUp [0,0,1];
_posHouse3 = _house3 buildingPos -1;

// Spawn things
{
	private ["_tmpObj"];

	_tmpObj = [_x, _objOrg, _rndDir] call _spawnRel;

	_objSpawned = _objSpawned + [_tmpObj];
} forEach _objThings;

// Spawn hostage
_grpHost = createGroup civilian;

_grpHost setVariable ["FF7_AI_Distributor_serverLocal", true];

_posHost = (selectRandom (selectRandom [_posHouse1, _posHouse2, _posHouse3]));

_objHost = _grpHost createUnit [selectRandom _civs, _posHost, [], 0, "NONE"];

_objHost setVariable ["FF7_OPS_Target", true];

_grpHost setFormDir _rndDir;
_objHost setDir _rndDir;
_objHost setPos _posHost;

_objHost setunitpos "UP";
_objHost disableAI "AUTOTARGET";
_objHost disableAI "MOVE";

dostop _objHost;

_objHost playmove "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon";

_grpHost setCombatMode "BLUE";
_grpHost setBehaviour "CARELESS";

if !(isnil "ACE_captives_fnc_setHandcuffed") then
{
	[_objHost, true] call ACE_captives_fnc_setHandcuffed;
}
else
{
	_objHost setCaptive true;
};

[_objHost] call FF7_fnc_addToCurator;

for "_x" from 1 to 9 do
{
	private ["_infTeam", "_infUnit", "_rndPos", "_rndDir"];

	_rndPos = (selectRandom (selectRandom [_posHouse1, _posHouse2, _posHouse3]));
	_rndDir = (random 360);

	_infTeam = createGroup resistance;

	(selectRandom _bandits) createUnit [_rndPos, _infTeam];

	_infTeam setFormDir _rndDir;

	_infUnit = ((units _infTeam) select 0);
	_infUnit setDir _rndDir;

	_infTeam setCombatMode "GREEN";
	_infTeam setBehaviour "SAFE";
	_infTeam setSpeedMode "LIMITED";

	[[_posHouse1, _posHouse2, _posHouse3], 4, _infTeam] call _genWPs;

	//[_infTeam, 0.32, 0.7, 0.08] call OPS_fnc_setGroupSkill;

	_objEnemy = _objEnemy + [_infTeam];

	{
		[_x] call FF7_fnc_addToCurator;
	} foreach units _infTeam;

	_infTeam = nil;
	sleep 0.2;
};

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorCIV", "Border", "mil_unknown"] call OPS_fnc_createMarker;

_hostEH = _objHost addEventHandler
[
	"Killed",
	{
		params ["_unit", "_killer"];

		private ["_nameKiller"];

		if (isPlayer _killer) then
		{
			_nameKiller = (name _killer);

			//[(format ["<t align='center'><t size='2.0' color='#CC2222'>R.O.E</t><br/><br/><t size='1.3' color='#00B2EE'>Watch your fire <t size='1.3' color='#CC2222'>%1</t>,<br/>you just killed the %2!</t>", _nameKiller, "hostage"]), 15] remoteExec ["FF7_fnc_globalHint", 0];
			["ROE", "R.O.E", (format ["Watch your fire <t color='#CC2222'>%1</t>,<br/>you just killed the %2 !</t>", _nameKiller, "hostage"])] remoteExec ["FF7_fnc_globalHintStruct", 0];
		};
	}
];

["Rescue", format ["Locate the hostage near %1 and rescue him.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_objEnemy = _objEnemy +
(
	[
		_objPos,
		"IND_C_F"
	] call OPS_fnc_spawnObjEnemy
);

while {alive _objHost} do
{
	private ["_dist"];

	_dist = (_objHost distance (getMarkerPos "mkr_hq"));

	if (_dist < 10) exitWith {FF7_OP_missionSuccess = true;};

	sleep 1;
};

if (FF7_OP_missionSuccess) then
{
	["Completed", "Hostage safely brought back to HQ."] remoteExec ["FF7_fnc_globalNotify", 0, false];

	_objHost removeEventHandler ["Killed", _hostEH];

	if !(isnil "ACE_captives_fnc_setHandcuffed") then
	{
		[_objHost, false] call ACE_captives_fnc_setHandcuffed;
	}
	else
	{
		_objHost setCaptive false;
	};
};

if !(alive _objHost) then
{
	["Failed", "The hostage has been killed, mission failed."] remoteExec ["FF7_fnc_globalNotify", 0, false];
};

{
	deleteMarker _x;
} foreach _markers;

//[[_objSpawned], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
//[[_objEnemy], (random [180, 300, 540])] spawn OPS_fnc_clearObj;
[[_objHost], (random [180, 300, 540])] spawn OPS_fnc_clearObj;

[_objPos, 1000, [_objEnemy, _objSpawned]] spawn OPS_fnc_deSpawnObjEnemy;
