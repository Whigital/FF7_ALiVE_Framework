/*
	Author: Demon Cleaner

	Description:
	Creates a number of aircraft autonomously patrolling a specified area

	Heavily modified by [FF7]Whigital
*/

params
[
	"_action"
];

if (isNil "FF7_airPatInitialized") then
{
	FF7_airPatInitialized	= false;
};

switch (_action) do
{
	case "init":
	{
		if (FF7_airPatInitialized) exitWith {["OPS_fnc_airPatrol", "'init' called when already initialized !"] call FF7_fnc_debugLog};

		if (FF7_Global_Debug) then
		{
			["OPS_fnc_airPatrol", "Running init"] call FF7_fnc_debugLog;
		};

		FF7_airPatCount = ["AirPatrolCount", 6] call BIS_fnc_getParamValue;

		FF7_airPatSpawns	= [];
		FF7_airPatLocs		= [];
		FF7_airPatrols		= [];

		FF7_airPatSkill		= 0.5;
		FF7_airPatDelay		= 1200;

		_blacklist_markers	= ["mkr_taor_black1"];

		_blacklist_locations =
		[
			// Tanoa
			"Ile Sainte-Marie",
			"Imuri Island",
			"Tuadua Island",
			"Ipota",
			"Ravi-ta Island",
			"Momea",
			"Tanoa Sugar Company",
			"diesel power plant",
			"banana plantations",
			"Yani Islets",
			"Yasa Island",
			"Ile Saint-George",
			"Sosovu Island",
			"ferry",
			"fortress ruins",
			"Saioko",
			"port",
			"temple ruins",
			"lumberyard",

			// Altis
			"Makrynisi",
			"Sagonisi",
			"Fournos",
			"Bomos",
			"Atsalis",
			"Pyrgi",
			"Cap Makrinos",
			"Polemistia",
			"Savri",
			"Cap Drakontas",
			"Chelonisi"
		];

		FF7_airPatVehicles =
		[
		/*
			//"O_Heli_Light_02_F",
			//"I_Heli_light_03_F",
			"O_Heli_Attack_02_F",
			"O_Heli_Attack_02_black_F",
			"RHS_Mi24V_vvs",
			"RHS_Ka52_vvsc",
			"rhs_mi28n_vvsc",
			"RHS_Ka52_vvs",
			"RHS_Mi24V_AT_vvs"
		*/
			"RHS_Mi24V_vvsc",
			"O_Heli_Light_02_F",
			"rhs_mi28n_vvsc",
			"I_Heli_light_03_F",
			"RHS_Ka52_vvsc",
			"O_Heli_Attack_02_black_F"
		];

		{
			if (["mrk_air_pat_spn_", _x] call BIS_fnc_inString) then
			{
				FF7_airPatSpawns pushBack _x;
			};
		} forEach allMapMarkers;

		if ((count FF7_airPatSpawns) < 1) exitWith {["OPS_fnc_airPatrol", "No Airpatrol spawnmarkers found, exiting ...."] call FF7_fnc_debugLog};

		_mapSize	= getNumber (configFile >> "CfgWorlds" >> worldName >> "MapSize");
		_mapCenter	= [(_mapSize / 2), (_mapSize / 2), 0];
		_mapRadius	= ((_mapSize / 2) * 1.25);

		//_mapLocs = nearestLocations [_mapCenter, ["NameCityCapital", "NameCity", "NameVillage", "NameLocal", "Hill", "Airport"], _mapRadius];
/*
		{
			private ["_loc"];

			_loc = _x;

			{
				if !((getPos _loc) inArea _x) then
				{
					if !((text _loc) in _blacklist_locations) then
					{
						FF7_airPatLocs pushBack _loc;
					};
				};
			} forEach _blacklist_markers;
		} forEach _mapLocs;
*/
		FF7_airPatLocs = (nearestLocations [_mapCenter, ["NameCityCapital", "NameCity", "NameVillage", "Airport"], _mapRadius]);

		FF7_airPatInitialized = true;

		// ---------- Wait for ALiVE CS module to initialize

		/*
		waitUntil {!isNil "NEO_radioLogic"};
		waitUntil {NEO_radioLogic getVariable ["init", false]};
		*/

		private ["_alive_main", "_alive_status"];

		_alive_main		= ((entities "ALiVE_require") select 0);
		_alive_status	= (_alive_main getVariable ["startupComplete", false]);

		while {!_alive_status} do
		{
			sleep 15;

			_alive_status = (_alive_main getVariable ["startupComplete", false]);
		};

		sleep 5;

		// ---------- Spawn air units

		for "_i" from 1 to FF7_airPatCount do
		{
			["spawn"] call OPS_fnc_airPatrol;
		};
	};

	case "spawn":
	{
		if !(FF7_airPatInitialized) exitWith {["OPS_fnc_airPatrol", "'spawn' called before initialization !"] call FF7_fnc_debugLog};

		private ["_mkr", "_pos", "_dir", "_veh", "_patGrp"];

		if (FF7_Global_Debug) then
		{
			["OPS_fnc_airPatrol", "Running spawn"] call FF7_fnc_debugLog;
		};

		_mkr = (selectRandom FF7_airPatSpawns);
		_dir = markerDir _mkr;
		_veh = (selectRandom FF7_airPatVehicles);
		_pos = [(getMarkerPos _mkr), 25, 500, 25, 1, -1, 0] call BIS_fnc_findSafePos;

		_spwVeh = [_pos, _dir, _veh, EAST] call BIS_fnc_spawnVehicle;

		_patGrp	= (_spwVeh select 2);

		_patGrp setVariable ["FF7_AI_Distributor_serverLocal", true];

		sleep (5 + (random 5));

		_airPat = [_spwVeh] spawn
		{
			params ["_airPat"];

			private ["_patVeh", "_patUnits", "_patGrp", "_patLocs", "_patWPcnt", "_patWPcompRad", "_cbtModes", "_spdModes", "_patBehave"];

			_patVeh			= (_airPat select 0); // Vehicle
			_patUnits		= (_airPat select 1); // Units
			_patGrp			= (_airPat select 2); // Group
			_patWPcnt		= (6 + (random 3));
			_patLocs		= FF7_airPatLocs call BIS_fnc_arrayShuffle;
			_patLocs		= _patLocs call BIS_fnc_arrayShuffle;
			_patWPcompRad	= 250;

			[_patVeh] call FF7_fnc_addToCurator;
			_patVeh setVariable ["ace_cargo_size", -1];

			_cbtModes		= ["WHITE", "YELLOW", "RED"];
			_spdModes		= ["LIMITED", "NORMAL", "FULL"];
			_patBehave		= ["SAFE", "AWARE", "COMBAT"];

			_patVeh lock 2;
			_patVeh allowCrewInImmobile true;
			_patVeh setVariable ["ace_cookoff_enable", false, true];
			//_patVeh flyInHeight (selectRandom [50, 75, 100, 125]);
			_patVeh flyInHeight (50 + (random 50));

			_patGrp setCombatMode "YELLOW";
			_patGrp setBehaviour "SAFE";
			_patGrp setSpeedMode "NORMAL";
/*
			{
				_x setSkill FF7_airPatSkill;
			} forEach _patUnits;
*/
			// Add waypoints on locations
			for "_i" from 1 to _patWPcnt do
			{
				private ["_wp"];

				_wp = _patGrp addWaypoint [(getPos (selectRandom _patLocs)), 300];
				_wp setWaypointType "MOVE";
			};

			// Add final cycle waypoint
			_wp = _patGrp addWaypoint [(getPos (selectRandom _patLocs)), 300];
			_wp setWaypointType "CYCLE";

			{
				private ["_grp", "_idx"];

				_grp = (_x select 0);
				_idx = (_x select 1);

				[_grp, _idx] setWaypointTimeout [15, 30, 45];

				[_grp, _idx] setWaypointCombatMode (selectRandom ["WHITE", "YELLOW"]);
				[_grp, _idx] setWaypointBehaviour "AWARE";
				[_grp, _idx] setWaypointSpeed (selectRandom ["LIMITED", "NORMAL"]);

				/*
				if (_idx != 0) then
				{
					[_grp, _idx] setWaypointSpeed (selectRandom _spdModes);
				};

				[_grp, _idx] setWaypointBehaviour (selectRandom _patBehave);
				[_grp, _idx] setWaypointCombatMode (selectRandom _cbtModes);
				[_grp, _idx] setWaypointCompletionRadius _patWPcompRad;
				*/
			} forEach (waypoints _patGrp);

			//waitUntil {((!(alive _patVeh)) || (!(canMove _patVeh)))};

			while {((alive _patVeh) || (canMove _patVeh))} do
			{
				_patVeh setFuel 1;

				//_patVeh setVehicleAmmoDef 1;

				sleep 60;
			};

			sleep 5;

			{
				if (alive _x) then
				{
					_x setDamage 1;
				};
			} forEach _patUnits;

			sleep (FF7_airPatDelay + (random (FF7_airPatDelay / 2)));

			["spawn"] call OPS_fnc_airPatrol;
		};
	};
};
