private ["_in", "_dec", "_out"];

_in	=	(_this select 0);
_dec =	(_this select 1);

_out = ((round (_in * (10 ^ _dec))) / (10 ^ _dec));

_out
