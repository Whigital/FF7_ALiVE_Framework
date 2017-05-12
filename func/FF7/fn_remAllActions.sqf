private ["_obj"];

_obj = (_this select 0);

if (isNull _obj) exitWith {};

removeAllActions _obj;
