private "_unit";

_unit = (_this select 0);

{
     _x addCuratorEditableObjects [[_unit], true];
} forEach allCurators;
