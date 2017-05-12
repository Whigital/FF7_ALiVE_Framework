params ["_period", "_fogLimit"];

private ["_terrain", "_altitude"];

_terrain = (toLower worldName);

switch (_terrain) do
{
	case "altis":
	{
		_altitude = 30;
	};

	case "tanoa":
	{
		_altitude = 30;
	};

	case "chernarus":
	{
		_altitude = 50;
	};

	case "chernarus_summer":
	{
		_altitude = 50;
	};

	case "takistan":
	{
		_altitude = 300;
	};

	default
	{
		_altitude = 25;
	};
};

while {true} do
{
	private ["_fog", "_decay", "_base"];

	if (fog > _fogLimit) then
	{
		if (FF7_Global_Debug) then
		{
			["ff7_weatherMan", "Changing foglevels"] call FF7_fnc_debugLog;
		};

		_fog	= (random _fogLimit);
		_base	= (random _altitude);
		_decay	= (random [0.025, 0.05, 0.075]);

		(_period * 2) setFog [_fog, _decay, _base];
	};

	sleep (_period);
};
