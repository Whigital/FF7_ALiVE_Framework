private ["_nextAvail"];

_nextAvail = player getVariable ["FF7_NextAvailHalo", nil];

if (isNil "_nextAvail") then
{
	player setVariable ["FF7_NextAvailHalo", 0];
	_null = [] execVM "src\ATM_airdrop\atm_airdrop.sqf";
}
else
{
	if (time > _nextAvail) then
	{
		_null = [] execVM "src\ATM_airdrop\atm_airdrop.sqf";
	}
	else
	{
		["HQ", "Logistics", format ["Unavailable for another %1 seconds ....", (ceil (_nextAvail - time))]] call FF7_fnc_globalHintStruct;
	};
};
