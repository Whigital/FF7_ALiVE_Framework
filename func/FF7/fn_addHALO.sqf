private ["_obj"];

_obj = (_this select 0);

_null = _obj addAction [["para", "FF9900", "HALO drop"] call FF7_fnc_formatAddAction, {call FF7_fnc_reqHALO}, [], 99, true, true, "", "((_target distance _this) < 4)"];
