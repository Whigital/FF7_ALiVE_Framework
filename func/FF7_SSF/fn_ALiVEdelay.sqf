private ["_alive_mod", "_alive_status"];

if (isNil "SSF_fnc_ServerCommand") exitWith {["ALiVEdelay", "SFF_fnc_ServerCommand not found, skipping server locking ...."] call FF7_fnc_debugLog};


["Server", "Locking server until ALiVE is fully initialized ...."] call FF7_fnc_debugLog;

if (["#lock"] call SSF_fnc_ServerCommand) then
{
	["Server", "Server successfully locked ...."] call FF7_fnc_debugLog;
}
else
{
	["Server", "Server lock failed !"] call FF7_fnc_debugLog;
};

sleep 30;

_alive_main		= ((entities "ALiVE_require") select 0);
_alive_status	= (_alive_main getVariable ["startupComplete", false]);

while {!_alive_status} do
{
	sleep 15;

	_alive_status = (_alive_main getVariable ["startupComplete", false]);
};

sleep 5;

["Server", "ALiVE fully initialized, unlocking server ...."] call FF7_fnc_debugLog;

if (["#unlock"] call SSF_fnc_ServerCommand) then
{
	["Server", "Server successfully unlocked ...."] call FF7_fnc_debugLog;
}
else
{
	["Server", "Server unlock failed !"] call FF7_fnc_debugLog;
};
