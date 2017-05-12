private ["_type", "_msg"];

_type	= (_this select 0);
_msg	= (_this select 1);

[_type, [_msg]] call BIS_fnc_showNotification;
