private ["_obj"];

_obj = GlobalChargeObj;

[_obj] remoteExec ["FF7_fnc_remAllActions", 0];

FF7_OP_chargePlaced = true;
