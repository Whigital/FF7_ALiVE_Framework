params
[
	["_dusk", 18],
	["_dawn", 6],
	["_accel", 4]
];

while {true} do
{
	private ["_currentTime"];	

	_currentTime = daytime;

	if (_currentTime > _dusk) then
	{
		if (timeMultiplier < _accel) then
		{
			if (FF7_Global_Debug) then
			{
				["ff7_timeKeeper", "Speeding up time"] call FF7_fnc_debugLog;
			};

			setTimeMultiplier _accel;
		};
	}
	else
	{
		if (_currentTime > _dawn) then
		{
			if (timeMultiplier > 1) then
			{
				if (FF7_Global_Debug) then
				{
					["ff7_timeKeeper", "Slowing down time"] call FF7_fnc_debugLog;
				};

				setTimeMultiplier 1;
			};
		};
	};

	sleep 60;
};
