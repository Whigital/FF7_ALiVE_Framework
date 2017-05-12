private ["_obj"];

_obj = _this select 0;

// Disable ACE dragging
[_obj, false] call ace_dragging_fnc_setDraggable;

// Disable ACE carrying
[_obj, false] call ace_dragging_fnc_setCarryable;

// Disable ACE cargo loading
_obj setVariable ["ace_cargo_canLoad", 0];
