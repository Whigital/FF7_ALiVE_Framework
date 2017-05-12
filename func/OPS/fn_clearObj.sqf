private ["_cleanArray", "_delay"];

if (FF7_Global_Debug) then
{
	["OPS_fnc_clearObj", "Running function"] call FF7_fnc_debugLog;
};

_cleanArray = param [0];
_delay		= param [1, 1];

sleep _delay;

{
	if (typeName _x == "ARRAY") then
	{
		[_x] call OPS_fnc_clearObj;
	}
	else
	{
		if (typeName _x == "GROUP") then
		{
			{
				if (vehicle _x != _x) then
				{
					deleteVehicle (vehicle _x);
					sleep 0.1;
				};
				
				deleteVehicle _x;
				sleep 0.1;
			} forEach (units _x);
		}
		else
		{
			if (vehicle _x != _x) then
			{
				deleteVehicle (vehicle _x);
				sleep 0.1;
			};

			if !(_x isKindOf "Man") then
			{
				{
					deleteVehicle _x;
					sleep 0.1;
				} forEach (crew _x);
			};
			deleteVehicle _x;
			sleep 0.1;
		};
		sleep 0.5;
	};
} forEach _cleanArray;
