params
[
	["_period", 60]
];

private ["_alive_mod", "_alive_status"];

_alive_main		= ((entities "ALiVE_require") select 0);
_alive_status	= (_alive_main getVariable ["startupComplete", false]);

["ff7_serverDiag", "Waiting for ALiVE to initialize ...."] call FF7_fnc_debugLog;

while {!_alive_status} do
{
	sleep 10;

	_alive_status = (_alive_main getVariable ["startupComplete", false]);
};

sleep _period;

["ff7_serverDiag", "Starting diag script"] call FF7_fnc_debugLog;

_null = [_period] spawn
{
	params ["_delay"];

	while {true} do
	{
		private ["_allUnits", "_srvCount", "_grpCount", "_unitCount"];

		_allUnits = (allUnits - playableUnits);

		_srvCount = 0;

		{
			if (local _x) then
			{
				_srvCount = _srvCount + 1;
			};
		} forEach _allUnits;

		["Debug", (format ["Server stats: %1 FPS / %2 units", diag_fps, _srvCount])] call FF7_fnc_debugLog;

		if (!isNil "FF7_AI_Distributor_HCList") then
		{
			if ((count FF7_AI_Distributor_HCList) > 0) then
			{
				{
					private ["_hcData", "_hcName", "_hcCount", "_hcFPS"];

					_hcName		= (name _x);
					_hcData		= call (compile (format ["FF7_AI_Distributor_%1_data", _hcName]));
					_hcCount	= (_hcData select 0);
					_hcFPS		= (_hcData select 1);

					["Debug", (format ["%1 stats: %2 FPS / %3 units", _hcName, _hcFPS, _hcCount])] call FF7_fnc_debugLog;

				} forEach FF7_AI_Distributor_HCList;
			};
		};

		_grpCount	= (count allGroups);
		_unitCount	= (count _allUnits);

		["Debug", (format ["Total groups: %1", _grpCount])] call FF7_fnc_debugLog;
		["Debug", (format ["Total units : %1", _unitCount])] call FF7_fnc_debugLog;

		sleep _delay;
	};
};
