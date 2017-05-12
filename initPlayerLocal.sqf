private ["_player", "_type", "_alive_server_ver", "_alive_client_ver"];

// Run only on player ....
if (!hasInterface) exitWith
{
	call FF7_fnc_headlessInit;
};


// Wait until player is initialized ....
waitUntil {!isNull player};

waitUntil{!(isNil "BIS_fnc_init")};


// Check correct ALiVE version
_alive_server_ver = missionNamespace getVariable ["FF7_ALiVE_version", "0"];
_alive_client_ver = ((configfile >> "CfgPatches" >> "ALiVE_main" >> "versionStr") call BIS_fnc_GetCfgData);

if (!isServer) then
{
	if !(_alive_client_ver isEqualTo _alive_server_ver) then
	{
		["Client", (format ["ALiVE Server version : %1", _alive_server_ver])] call FF7_fnc_debugLog;
		["Client", (format ["ALiVE Client version : %1", _alive_client_ver])] call FF7_fnc_debugLog;

		["Client", "ALiVE version missmatch, sending client back to lobby"] call FF7_fnc_debugLog;

		["alivemismatch", false, 5] call BIS_fnc_endMission;
	};
};

_player	= player;


// Setup TFAR frequencies
if ("task_force_radio" in activatedAddons) then
{
	call FF7_fnc_TFARsetup;
}
else
{
	["initPlayerLocal", "TFAR not active ...."] call FF7_fnc_debugLog;
};


// ACE actions
["initPlayerLocal", "Adding ACE actions ...."] call FF7_fnc_debugLog;

[_player] call FF7_fnc_aceActions;
