private ["_posOK", "_marker", "_location", "_objPos", "_objTent", "_objGastank", "_objThings", "_objSpawned", "_objEnemy", "_relPos", "_rndDir", "_pufs", "_pufPos"];

if (FF7_Global_Debug) then
{
	["OPS/Destroy", "Running mission druglab"] call FF7_fnc_debugLog;
};

_posOK	= false;
_msg	= "Find the druglab and destroy it";

_objThings	=
[
//	["CamoNet_OPFOR_open_F",[0,0,0],0,1,0,{}],					-- Origin
	["Land_GasTank_01_khaki_F",[-0.97168,2.63403,0],5.2286,1,0,{}],
	["Land_Garbage_line_F",[-0.794434,-0.876221,0],277.137,1,0,{}],
	["Oil_Spill_F",[-0.832031,1.46362,0],243.498,1,0,{}],
	["Land_Sack_F",[0.599121,1.96362,0],357.749,1,0,{}],
	["Land_Sack_F",[1.26416,1.68079,0],267.806,1,0,{}],
	["Land_Sleeping_bag_brown_F",[2.02393,-1.52209,0],68.7584,1,0,{}],
	["Land_ChairPlastic_F",[2.30811,0.660156,0],114.743,1,0,{}],
	["Land_BarrelSand_F",[-0.0131836,2.43665,0],168.996,1,0,{}],
	["Land_FireExtinguisher_F",[-0.461426,2.526,0],99.2469,1,0,{}],
//	["Land_GasCooker_F",[-1.46924,2.44922,0.813],290.376,1,0,{}],
	["Land_Bucket_painted_F",[2.88525,0.180542,0],56.6147,1,0,{}],
	["Land_GasTank_01_blue_F",[-0.975098,2.75037,0],293.472,1,0,{}],
	["Land_GasTank_01_yellow_F",[-1.3999,2.65784,0],331.496,1,0,{}],
	["Land_CanisterPlastic_F",[-0.30957,3.03198,0],33.9282,1,0,{}],
//	["Land_GasCanister_F",[-1.8374,2.4856,0.813],210.805,1,0,{}],
	["Land_CampingTable_F",[-1.68652,2.59277,0],355.097,1,0,{}],
	["Land_Sacks_goods_F",[0.958984,2.9281,0],200.933,1,0,{}],
//	["Land_Matches_F",[-1.97266,2.41772,0.813],193.957,1,0,{}],
//	["Land_ButaneTorch_F",[-1.38379,2.79785,0.813],346.419,1,0,{}],
	["Land_Sacks_heap_F",[2.46533,2.00134,0],286.977,1,0,{}],
//	["Land_Gloves_F",[-2.16797,2.36609,0.813],333.502,1,0,{}],
	["Oil_Spill_F",[-3.19482,1.203,0],137.392,1,0,{}],
//	["Land_ButaneCanister_F",[-1.59814,2.81519,0.813],307.742,1,0,{}],
//	["Land_DisinfectantSpray_F",[-2.03857,2.6001,0.813],31.2342,1,0,{}],
	["Land_GasTank_01_khaki_F",[-1.9292,2.69385,0],40.0543,1,0,{}],
	["Land_CampingChair_V1_F",[3.26855,-0.578735,0],67.4961,1,0,{}],
//	["Land_DuctTape_F",[-1.87305,2.79797,0.813],223.31,1,0,{}],
//	["Land_Gloves_F",[-2.42139,2.38599,0.813],3.78406,1,0,{}],
	["Land_GasTank_01_blue_F",[-2.3252,2.62061,0],355.295,1,0,{}],
//	["Land_Money_F",[-2.31641,2.69995,0.813],318.336,1,0,{}],
	["Land_CanisterFuel_F",[-2.76855,2.39343,0],259.883,1,0,{}],
	["Land_Sleeping_bag_blue_F",[2.76807,-2.65735,0],58.4167,1,0,{}],
	["Land_CanisterFuel_F",[-3.02441,2.45703,0],276.79,1,0,{}],
	["Land_Garbage_square5_F",[-2.41211,-3.15833,0],241.122,1,0,{}],
	["CargoNet_01_barrels_F",[3.83252,0.86853,0],256.244,1,0,{}],
	["Land_Fire_barrel",[-3.57324,2.44714,0],290.527,1,0,{}],
	["CargoNet_01_barrels_F",[-1.30908,4.2019,0],276.171,1,0,{}],
	["Land_Fire_barrel",[-4.11182,2.04199,0],1.33539,1,0,{}],
//	["Land_Camping_Light_F",[-4.08838,2.15625,0.831127],232.833,1,0,{}],
	["Campfire_burning_F",[0.67627,-4.88684,0.0299988],227.264,1,0,{}],
	["Land_TentDome_F",[5.13672,-1.65869,0],336.054,1,0,{}],
	["Land_Sleeping_bag_F",[3.60791,-3.70007,0],44.7801,1,0,{}],
	["Land_Metal_rack_F",[-5.26953,0.484375,0],269.737,1,0,{}],
	["CargoNet_01_barrels_F",[-3.39941,4.07971,0],153.526,1,0,{}],
	["Land_CampingChair_V2_F",[-4.70996,-2.5813,0],235.107,1,0,{}],
	["Land_WoodenBox_F",[-5.94971,0.665039,0],281.902,1,0,{}],
	["Land_Pallets_F",[-4.42188,2.84656,0],248.769,1,0,{}],
	["Land_PortableLight_single_F",[-4.896,-4.23413,0],224.918,1,0,{}],
	["Land_WoodenBox_F",[-5.79199,-2.68628,0],67.3739,1,0,{}],
	["Land_WoodPile_F",[-0.0361328,-6.58948,0],306.926,1,0,{}],
	["MetalBarrel_burning_F",[4.40625,-5.22595,0],53.1406,1,0,{}],
	["Land_WoodenLog_F",[3.55322,-6.55481,0],267.806,1,0,{}],
	["Land_Axe_F",[3.38477,-7.05762,0],183.966,1,0,{}],
	["Land_WoodPile_F",[2.21045,-7.68262,0],261.697,1,0,{}]
];

_objSpawned	= [];

//diag_log "Starting radar mission";

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

FF7_OP_chargeTriggered = false;

FF7_OP_markersObj = FF7_OP_markersObj - [_marker];

_location = markerText _marker;

_rndDir = (random 360);

// ---------- Spawn camonet
_objTent = createVehicle ["CamoNet_OPFOR_open_F", [0, 0, 0], [], 0, "NONE"];
_objTent setDir _rndDir;
_objTent setPos _objPos;
//_objTent setVectorUp [0,0,1];
_objTent enableSimulationGlobal false;
_objTent allowDamage false;
_objTent setVariable ["gc_persist", true];

/*
_objTent addEventHandler
[
	"Explosion",
	{
		params ["_target", "_damage"];

		if (_damage > 1) then
		{
			FF7_OP_chargeTriggered = true;
		};
	}
];
*/

sleep 1;

_objTent addEventHandler
[
	"handleDamage",
	{
		params ["_target", "_part", "_damage", "_inflictor", "_ammo", "_pindex", "_ instigator"];

		private ["_retDamage"];

		if (_damage >= 2) then
		{
			_retDamage = _damage;

			FF7_OP_chargeTriggered = true;
		}
		else
		{
			_retDamage = 0;
		};

		_retDamage;
	}
];

[_objTent] call FF7_fnc_addToCurator;

_objSpawned = _objSpawned + [_objTent];


// ---------- Loop through all others
{
	private ["_tmpObj", "_tmpType", "_tmpOffset", "_tmpDir"];

	_tmpType	= (_x select 0);
	_tmpOffset	= (_x select 1);
	_tmpDir		= (_x select 2);

	_relPos = (_objTent modelToWorld _tmpOffset);

	_tmpObj = createVehicle [_tmpType, [0, 0, 0], [], 0, "NONE"];
	_tmpObj setDir _tmpDir + _rndDir;
	_tmpObj setPos [(_relPos select 0), (_relPos select 1), 0 + (_tmpOffset select 2)];
	//_tmpObj setVectorUp [0,0,1];
	//_tmpObj enableSimulation false;
	_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	_objSpawned = _objSpawned + [_tmpObj];
} foreach _objThings;

_objTent enableSimulationGlobal true;
_objTent allowDamage true;

_fuzzyPos = [[[_objPos, (400 * 0.75)]], ["water", "out"]] call BIS_fnc_randomPos;

_markers = [_fuzzyPos, 400, _msg, "ColorUNKNOWN", "Border", "mil_destroy"] call OPS_fnc_createMarker;

["SeekDestroy", format ["Locate the druglab near %1 and destroy it.", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

_pufs = ["Rocket_03_HE_F", "HelicopterExploBig", "Bo_Mk82", "HelicopterExploSmall", "Bo_Air_LGB", "R_60mm_HE", "R_PG7_F"];

_pufPos = [];

for "_i" from 1 to 6 do
{
	private ["_tmpPos"];

	_tmpPos = [[[_objPos, 6],[]],["water","out"]] call BIS_fnc_randomPos;
	_pufPos pushBack _tmpPos;
};

_objEnemy =
[
	_objPos,
	"IND_C_F"
] call OPS_fnc_spawnObjEnemy;

while {!FF7_OP_chargeTriggered} do
{
	sleep 1;
};

{
	private ["_puf"];

	_puf = (selectRandom _pufs) createVehicle _x;

	sleep (random [0.3, 0.55, 0.8]);
} forEach _pufPos;

_touchOff = "Bo_GBU12_LGB" createVehicle _objPos;

{
	deleteVehicle _x;
} foreach _objSpawned;

FF7_OP_chargeTriggered = false;

sleep 10;

FF7_OP_missionSuccess = true;

["Completed", format ["Good job, the druglab near %1 has been destroyed ....", _location]] remoteExec ["FF7_fnc_globalNotify", 0, false];

{
	deleteMarker _x;
} foreach _markers;

//[_objEnemy, (random [180, 540, 720])] spawn OPS_fnc_clearObj;
[_objPos, 1000, _objEnemy] spawn OPS_fnc_deSpawnObjEnemy;
