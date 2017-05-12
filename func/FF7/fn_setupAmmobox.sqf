private ["_box"];

_box = _this select 0;

// Clear inventory
clearMagazineCargoGlobal _box;
clearItemCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearBackpackCargoGlobal _box;

// Remove all actions
removeAllActions _box;

// Disable ACE cargo
_box setVariable ["ace_cargo_size", -1];

// Disable ACE dragging
[_box, false] call ace_dragging_fnc_setDraggable;

// Disable ACE carrying
[_box, false] call ace_dragging_fnc_setCarryable;

// Disable ACE cargo loading
_box setVariable ["ace_cargo_canLoad", 0];
