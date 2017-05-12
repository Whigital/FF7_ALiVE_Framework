/*
	Author: Whigital

	AI Distribution script, based on ALIVE_fnc_AI_Distributor by Highhead.

	- Added dynamic detection of HCs.
	- Variable to keep groups local on server (FF7_AI_Distributor_serverLocal).

	Usage:

	Run from initServer.sqf eg. '_null = [] execVM "<this-script>";'

*/

if (!isServer) exitWith {["ff7_aiDistributor", "AI distribution script should only run on the server, exiting ...."] call FF7_fnc_debugLog};
//if (!isServer) exitWith {diag_log (text "AI distribution script should only run on the server, exiting ....")};

private ["_alive_mod", "_alive_status"];

_alive_main		= ((entities "ALiVE_require") select 0);
_alive_status	= (_alive_main getVariable ["startupComplete", false]);
_check_interval	= 30;

["ff7_aiDistributor", "Waiting for ALiVE to initialize ...."] call FF7_fnc_debugLog;
//diag_log (text "Waiting for ALiVE to initialize ....");

while {!_alive_status} do
{
	sleep 10;

	_alive_status = (_alive_main getVariable ["startupComplete", false]);
};

sleep 60;

["ff7_aiDistributor", "Starting group distribution"] call FF7_fnc_debugLog;
//diag_log (text "Starting group distribution");

FF7_AI_Distributor = [_check_interval] spawn
{
	params [["_interval", 30]];

	private ["_currHC", "_hcIndex"];

	FF7_AI_Distributor_enabled = true;

	while {FF7_AI_Distributor_enabled} do
	{
		FF7_AI_Distributor_HCList = [];

		_hcIndex = 0;

		{
			if ((typeOf _x) == "HeadlessClient_F") then
			{
				FF7_AI_Distributor_HCList pushBack _x;
			};
		} forEach allPlayers;

		{
			if ((count FF7_AI_Distributor_HCList) == 0) exitWith {};

			if (local _x && {{alive _x && {!((vehicle _x) getVariable ["ALiVE_CombatSupport", false])}} count units _x > 0}) then
			{
				if !(_x getVariable ["FF7_AI_Distributor_serverLocal", false]) then
				{
					if (_hcIndex > ((count FF7_AI_Distributor_HCList) - 1)) then
					{
						_hcIndex = 0;
					};

					_currHC = (FF7_AI_Distributor_HCList select _hcIndex);
					
					_hcIndex = _hcIndex + 1;

					_x setGroupOwner (owner _currHC);

					["ff7_aiDistributor", (format ["Group [%1] with %2 units transferred to %3", _x, (count (units _x)), (name _currHC)])] call FF7_fnc_debugLog;
					//diag_log (text (format ["Group '%1' with %2 units transferred to %3", _x, (count (units _x)), (name _currHC)]));
				};
			};

			sleep 1;

		} foreach allGroups;

		sleep _interval;
	};
};
