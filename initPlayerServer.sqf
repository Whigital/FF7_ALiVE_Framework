private "_player";

_player = (_this select 0);

// Exit if headless ....

if ((typeOf _player) == "HeadlessClient_F") exitWith
{
	["Server", (format ["Headless client detected : %1", (name _player)])] call FF7_fnc_debugLog;
};


// Add player as Zeus editable ....
[_player] call FF7_fnc_addToCurator;
