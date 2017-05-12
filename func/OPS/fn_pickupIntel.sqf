private ["_obj"];

_obj = GlobalGatherObj;

[_obj] remoteExec ["FF7_fnc_remAllActions", 0, true];

FF7_OP_gatherSuccess = true;
