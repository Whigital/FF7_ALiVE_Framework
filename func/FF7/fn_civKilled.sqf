params ["_unit"];

/*
if ((side _unit) == civilian) then
{
	["FF7_fnc_civKilled", "Adding MPKilled EH to civilian unit"] call FF7_fnc_debugLog;

	_EHidx = _unit addMPEventHandler
	[
		"MPkilled",
		{
/*			params
			[
				"_killed",
				"_killer"
			];
			private
			[
				"_victim",
				"_killer",
				"_nameKiller"
			];

			_victim			= (_this select 0);
			_killer			= (_this select 1);
			_nameKiller	= (name _killer);

			diag_log _this;
			diag_log _victim;
			diag_log _killer;

			if (!(isPlayer _killer)) exitWith {["FF7_fnc_civKilled", (format ["Event fired, but killer not a player (%1 / %2)", _killer, _nameKiller])] call FF7_fnc_debugLog};

			["FF7_fnc_civKilled", (format ["Event fired by killer: %1", (name _killer)])] call FF7_fnc_debugLog;

			if ((isServer) || ((typeOf player) == "HeadlessClient_F")) exitWith {["FF7_fnc_civKilled", "Server or Headless client"] call FF7_fnc_debugLog};

			if (_killer == player) then
			{
				[
					"ROE",
					"R.O.E",
					"<t color='#CC2222'>You just murdered a civilian.</t><br/><br/>This will not be tolerated, your weapons will be confiscated!</t>"
				] call FF7_fnc_globalHintStruct;

				removeAllWeapons player;
			}
			else
			{
				[
					"ROE",
					"R.O.E",
					(format ["<t color='#CC2222'>%1</t> just murdered a civilian.<br/><br/>This will not be tolerated and as a result, his/hers weapons has been confiscated!</t>", _nameKiller])
				] call FF7_fnc_globalHintStruct;
			};
		}
	];
};
*/

if (((side _unit) == civilian) && (local _unit)) then
{
	["FF7_fnc_civKilled", "Adding 'Killed' EH to civilian unit"] call FF7_fnc_debugLog;

	_unit addEventHandler
	[
		"Killed",
		{
			params
			[
				"_victim",
				"_killer"
			];

			private
			[
				"_aceKiller",
				"_nameKiller"
			];

			_aceKiller = (_victim getVariable ["ace_medical_lastDamageSource", objNull]);
		}
	];
};
