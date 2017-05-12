private ["_aliveobjs"];

_aliveobjs = [];

{
	_aliveobjs pushBack ([_x,"objectives"] call ALiVE_fnc_hashGet);
} forEach OPCOM_instances;
