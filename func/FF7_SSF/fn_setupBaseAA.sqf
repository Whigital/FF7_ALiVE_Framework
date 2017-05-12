params ["_markerName"];

private ["_alive_main", "_alive_status", "_fortObjs"];

FF7_Defence_AA_Markers = [];

_fortObjs =
[
	//["B_APC_Tracked_01_AA_F",[0,0,0],0],
	["Land_HBarrier_Big_F",[-0.0478516,4.21741,0],180],
	["Land_HBarrier_Big_F",[4.07373,-0.955688,0],90],
	["Land_HBarrier_Big_F",[-4.06567,-1.27026,0],270],
	["Land_HBarrier_Big_F",[0.0307617,-6.4834,0],0]
];

{
	if ([_markerName, _x] call BIS_fnc_inString) then
	{
		FF7_Defence_AA_Markers pushBack _x;
	};
} forEach allMapMarkers;


// ---------- Private functions

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
	_tmpObj allowDamage false;
	_tmpObj setVariable ["gc_persist", true];

	//[_tmpObj] call FF7_fnc_addToCurator;
};

_spawnAAunit =
{
	params ["_aaMarker"];

	private ["_aaPos", "_aaDir", "_aaGroup", "_aaCmdr", "_aaGunr"];

	_aaPos = getMarkerPos _aaMarker;
	_aaDir = markerDir _aaMarker;

	_aaUnit = "B_APC_Tracked_01_AA_F" createVehicle _aaPos;

	_aaUnit setDir _aaDir;
	_aaUnit allowDamage false;

	//_aaUnit removeMagazineTurret ["4Rnd_Titan_long_missiles",[0]];
	//_aaUnit removeMagazines "4Rnd_Titan_long_missiles";

	{
		[_x, _aaUnit, _aaDir] call _spawnRel;
	} forEach _fortObjs;

	_aaGroup = createGroup west;

	"B_crew_F" createUnit [_aaPos, _aaGroup];
	"B_crew_F" createUnit [_aaPos, _aaGroup];

	_aaGroup setVariable ["FF7_AI_Distributor_serverLocal", true];

	_aaCmdr = ((units _aaGroup) select 0);
	_aaGunr = ((units _aaGroup) select 1);

	_aaCmdr assignAsCommander _aaUnit;
	_aaCmdr moveInCommander _aaUnit;
	_aaCmdr setRank "CAPTAIN";

	_aaGunr assignAsGunner _aaUnit;
	_aaGunr moveInGunner _aaUnit;
	_aaGunr setRank "SERGEANT";

	_aaGroup setFormDir _aaDir;

	_aaGroup setBehaviour "COMBAT";
	_aaGroup setCombatMode "RED";
	_aaGroup allowFleeing 0;

	_aaUnit lock 2;
	_aaUnit allowCrewInImmobile true;
	_aaUnit setFuel 0;
	_aaUnit engineOn false;

	/*
	_aaUnit addEventHandler
	[
		"Fired",
		{
			params ["_unit"];
			
			_unit setVehicleAmmo 1;
			_unit removeMagazineTurret ["4Rnd_Titan_long_missiles",[0]];
			_unit removeMagazines "4Rnd_Titan_long_missiles";
		}
	];
	*/

	sleep 5;

	{
		_x allowDamage false;
		_x setSkill 1;
		[_x] call FF7_fnc_addToCurator;
	} forEach [_aaCmdr, _aaGunr];

	[_aaUnit] call FF7_fnc_addToCurator;

	_null = [_aaUnit] spawn
	{
		params ["_unit"];

		while {true} do
		{
			/*
			private ["_ammo", "_count"];

			_ammo	= magazinesAllTurrets _unit;
			_count	= ((_ammo select 0) select 2);

			if (_count < 600) then
			{
				_unit setVehicleAmmoDef 1;
				_unit removeMagazineTurret ["4Rnd_Titan_long_missiles",[0]];
				_unit removeMagazines "4Rnd_Titan_long_missiles";
			};
			*/

			_unit setVehicleAmmoDef 1;

			sleep 15;
		};
	};
};


// ---------- Wait for ALiVE to initialize

_alive_main		= ((entities "ALiVE_require") select 0);
_alive_status	= (_alive_main getVariable ["startupComplete", false]);

while {!_alive_status} do
{
	sleep 15;

	_alive_status = (_alive_main getVariable ["startupComplete", false]);
};

sleep 5;

// ---------- If AA markers found, spawn units

if ((count FF7_Defence_AA_Markers) > 0) then
{
	{
		if (FF7_Global_Debug) then
		{
			["ff7_setupBaseAA", "Spawning AA unit"] call FF7_fnc_debugLog;
		};

		[_x] call _spawnAAunit;
	} forEach FF7_Defence_AA_Markers;
};
