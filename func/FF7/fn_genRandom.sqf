private ["_in", "_var", "_out"];


_in		= (_this select 0);
_var	= (_this select 1);

if (_var == 0) exitWith {_in};

if (_in > 1) exitWith {1};

_out = (_in - (_var / 2)) + (random _var);

if (_out <= 0) exitWith {0};
if (_out > 1) exitWith {1};

_out = [_out, 2] call FF7_fnc_getRoundDec;
_out
