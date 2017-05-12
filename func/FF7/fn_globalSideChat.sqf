private ["_side", "_msg"];

_side	= (_this select 1);
_msg	= (_this select 1);

[_side,"HQ"] sideChat _msg;
