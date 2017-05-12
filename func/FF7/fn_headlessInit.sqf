private ["_alive_server_ver", "_alive_client_ver"];

_alive_server_ver = missionNamespace getVariable ["FF7_ALiVE_version", "0"];
_alive_client_ver = ((configfile >> "CfgPatches" >> "ALiVE_main" >> "versionStr") call BIS_fnc_GetCfgData);

if (!isServer) then
{
	if !(_alive_client_ver isEqualTo _alive_server_ver) then
	{
		["alivemismatch", false, 5] call BIS_fnc_endMission;
	};
};

_null = [30] spawn
{
	params ["_delay"];

	while {true} do
	{
		private ["_allUnits", "_hcName", "_hcCount"];

		_allUnits = (allUnits - playableUnits);

		_hcCount = 0;

		{
			if (local _x) then
			{
				_hcCount = _hcCount + 1;
			};
		} forEach _allUnits;
		
		_hcName	= (name player);

		call (compile (format ["FF7_AI_Distributor_%1_data = ['%2','%3']", _hcName, _hcCount, diag_fps]));

		publicVariableServer (format ["FF7_AI_Distributor_%1_data", _hcName]);

		sleep _delay;
	};
};
