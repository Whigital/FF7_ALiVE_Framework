/* ---------------------------------------------------------------------------------------------------

File: vehRespawn.sqf
Author: Iceman77

-- Heavily modified by [FF7] Whigital --

Description:
Respawn destroyed and abandoned vehicles

Parameter(s):
_this select 0: vehicle 
_this select 1: abandoned delay in minute(s) - Required
_this select 2: destroyed delay in minute(s) - Required
_this select 3: Function to call for the newly spawned vehicle (for custom armaments etc) - Optional

How to use - Vehicle Init Line: 
_nul = [this, 2, 1, {[_this] call TAG_FNC_TankInit}] execVM "vehRespawn.sqf"; << 2 minute abandoned delay, 1 minute destroyed delay, call the function that disables the TI
_nul = [this, 2, 1, {}] execVM "vehrespawn.sqf"; << 2 minute abandoned delay, 1 minute destroyed delay, NO function called for the newly respawned vehicle (standard way)

---------------------------------------------------------------------------------------------------- */

private "_veh";

_veh			= (_this select 0);
_abandonDelay	= ((_this select 1) * 60);
_deadDelay		= ((_this select 2) * 60);
_vehInit		= (_this select 3);
_dir			= (getDir _veh);
_pos			= (getPos _veh);
_vehtype		= (typeOf _veh);
_vehName		= (vehicleVarName _veh);
_isBoat			= 0;
_disableSim		= true;

//diag_log format ["Running respawn init on %1", _vehName];

_isUAV = (getNumber (configFile >> "CfgVehicles" >> typeof _veh >> "isUav"));

if (_isUav == 1) then
{
	_disableSim = false;
};

_equipVeh =
{
	params ["_respVeh"];

	if (_isUav == 1) exitWith {};

	clearWeaponCargoGlobal _respVeh;
	clearMagazineCargoGlobal _respVeh;
	clearBackpackCargoGlobal _respVeh;
	clearItemCargoGlobal _respVeh;

	if (_respVeh isKindOf "Car") then
	{
		_respVeh addItemCargoGlobal ["ACE_EarPlugs", 8];
		_respVeh addItemCargoGlobal ["ACE_CableTie", 4];

		_respVeh addItemCargoGlobal ["ACE_fieldDressing", 20];
		_respVeh addItemCargoGlobal ["ACE_morphine", 10];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_250", 8];
	};

	if (_respVeh isKindOf "Tank") then
	{
		_respVeh addItemCargoGlobal ["ACE_EarPlugs", 10];
		_respVeh addItemCargoGlobal ["ACE_CableTie", 8];

		_respVeh addItemCargoGlobal ["ACE_fieldDressing", 40];
		_respVeh addItemCargoGlobal ["ACE_morphine", 20];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_250", 8];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_500", 4];
	};

	if (_respVeh isKindOf "Helicopter") then
	{
		_respVeh addItemCargoGlobal ["ACE_EarPlugs", 12];
		_respVeh addItemCargoGlobal ["ACE_CableTie", 8];

		_respVeh addItemCargoGlobal ["ACE_fieldDressing", 30];
		_respVeh addItemCargoGlobal ["ACE_morphine", 15];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_250", 8];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_500", 4];
	};

	if (_respVeh isKindOf "Ship") then
	{
		_respVeh addItemCargoGlobal ["ACE_EarPlugs", 8];
		_respVeh addItemCargoGlobal ["ACE_CableTie", 4];

		_respVeh addItemCargoGlobal ["ACE_fieldDressing", 20];
		_respVeh addItemCargoGlobal ["ACE_morphine", 10];
		_respVeh addItemCargoGlobal ["ACE_bloodIV_250", 8];
	};
};

_addVehEH =
{
	params ["_respVeh"];

	if (!_disableSim) exitWith {};

	_respVeh addEventHandler
	[
		"GetIn",
		{
			params ["_target"];

			if (((count (crew _target)) == 1) && !(simulationEnabled _target)) then
			{
				//diag_log format ["Crew in, simulation enabled for %1", (vehicleVarName _respVeh)];
				_target enableSimulationGlobal true;
			};
		}
	];

	_respVeh addEventHandler
	[
		"GetOut",
		{
			params ["_target"];

			if (((count (crew _target)) == 0) && (simulationEnabled _target)) then
			{
				//diag_log format ["Crew out of %1, sleeping 60 seconds for disableSimulation", (vehicleVarName _target)];

				_target spawn
				{
					sleep 60;

					if ((count (crew _this)) == 0) then
					{
						_this enableSimulationGlobal false;
						//diag_log format ["Crew still out, Simulation disabled for %1", (vehicleVarName _this)];
					};
				};
			};
		}
	];

/*
	[
		_respVeh,
		"getIn",
		{
			params ["_target"];

			if (((count (crew _target)) == 1) && !(simulationEnabled _target)) then
			{
				_target enableSimulationGlobal true;
			};
		},
		_respVeh
	] call CBA_fnc_addBISEventHandler;

	[
		_respVeh,
		"getOut",
		{
			params ["_target"];

			if (((count (crew _target)) == 0) && (simulationEnabled _target)) then
			{
				[_target] spawn
				{
					params ["_target"];

					sleep 60;

					if ((count (crew _target)) == 0) then
					{
						_target enableSimulationGlobal false;
					};
				};
			};
		},
		_respVeh
	] call CBA_fnc_addBISEventHandler;
*/
};

_lazyEH =
{
	params ["_target"];

	if (!_disableSim) exitWith {};

	[_target] spawn
	{
		params ["_target"];

		while {alive _target} do
		{
			if (({isPlayer _x} count (_target nearEntities ["Man", 15])) > 0) then
			{
				if !(simulationEnabled _target) then
				{
					_target enableSimulationGlobal true;
					//hint "Within range: simulation enabled";
				};
			}
			else
			{
				if (((count (crew _target)) > 0)) then
				{
					if !(simulationEnabled _target) then
					{
						_target enableSimulationGlobal true;
						//hint "Inside: simulation enabled";
					};
				}
				else
				{
					if (simulationEnabled _target) then
					{
						_target enableSimulationGlobal false;
						//hint "Out of range and not inside: simulation disabled";
					};
				};
			};

			sleep 1;
		};
	};
};

_setupVeh =
{
	params ["_respVeh"];

	[_respVeh] call _equipVeh;

	if (_isUav == 1) then
	{
		if ((count (crew _respVeh)) == 0) then
		{
			createVehicleCrew _respVeh;
		};
	};

	if (_disableSim) then
	{
		_respVeh enableSimulationGlobal false;
		//diag_log format ["Simulation disabled for %1", (vehicleVarName _respVeh)];
	};

	[_respVeh] call FF7_fnc_addToCurator;
	_respVeh setVariable ["gc_persist", true];
/*
	if (((typeOf _veh) == "rhsusf_m1025_w") || ((typeOf _veh) == "RHS_UH60M") || ((typeOf _veh) == "RHS_A10")) then
	{
		[_respVeh] call _lazyEH;
	}
	else
	{
		[_respVeh] call _addVehEH;
	};
*/

	[_respVeh] call _lazyEH;

};

sleep 1;

[_veh] call _setupVeh;

if (isServer) then
{
	sleep (random 1);

	while {true} do
	{
		//diag_log format ["Watchdog started for %1", _vehName];

		sleep 10 + (random 10);

		//diag_log format ["Alive: %1 / canMove: %2 / Alive crew: %3 / West units within 1000: %4 || %5", str (alive _veh), str (canMove _veh), str ({alive _x} count crew _veh), str ({isPlayer _x} count (_veh nearEntities ["Man", 1000])), _vehName];

		if ((alive _veh) && {canMove _veh} && {{alive _x} count crew _veh isEqualTo 0} && (({isPlayer _x} count (_veh nearEntities ["Man", 1000])) isEqualTo 0)) then
		{
			_abandoned = true;
			
			//diag_log format ["%1 is abandoned", _vehName];

			for "_i" from 0 to _abandonDelay do
			{
				if (({alive _x} count (crew _veh) > 0) || (!alive _veh) || (!canMove _veh)) exitWith {_abandoned = false;};
				sleep 1;
			};

			//diag_log format ["Abandon timers reached for %1", _vehName];
			
			if ((_abandoned) && {_veh distance _pos > 3}) then
			{
				//diag_log format ["%1 distance from origin: %2", _vehName, str (_veh distance _pos)];
				//diag_log format ["Respawning abandoned vehicle %1", _vehName];

				deleteVehicle _veh;
				sleep 1;
				_veh = createVehicle [_vehtype, _pos, [], 0, "CAN_COLLIDE"];
				_veh setDir _dir;
				_veh setPos [_pos select 0, _pos select 1, 0];
				missionNamespace setVariable [_vehName, _veh];
				publicVariable _vehName;
				_veh call _vehInit;
				[_veh] call _setupVeh;
			};
		};

		if ((!alive _veh) || (!canMove _veh)) then
		{
			//diag_log format ["%1 is dead", _vehName];

			_dead = true;

			for "_i" from 0 to _deadDelay do
			{
				//diag_log format ["Dead timer started for %1", _vehName];

				if (({alive _x} count (crew _veh) > 0) || (canMove _veh)) exitWith {_dead = false;};
				sleep 1;
			};

			if (_dead) then
			{
				//diag_log format ["Respawning dead vehicle %1", _vehName];
				
				deleteVehicle _veh;
				sleep 1;
				_veh = createVehicle [_vehtype, _pos, [], 0, "CAN_COLLIDE"];
				_veh setDir _dir;
				_veh setPos [(_pos select 0), (_pos select 1), 0];
				missionNamespace setVariable [_vehName, _veh];
				publicVariable _vehName;
				_veh call _vehInit;
				[_veh] call _setupVeh;
			};
		};
	};
};
