private ["_hint", "_timeout"];

_hint 		= (_this select 0);
_timeout	= [_this, 1, 5] call BIS_fnc_param;

hint parseText format["%1", _hint];
//sleep _timeout;
//hint "";
