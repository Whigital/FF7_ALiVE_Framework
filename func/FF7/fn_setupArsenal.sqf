private ["_box"];

_box = (_this select 0);

// Clear inventory
clearMagazineCargoGlobal _box;
clearItemCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearBackpackCargoGlobal _box;

// Remove all actions
removeAllActions _box;

// Add Arsenal and Gear options
_null = _box addAction
[
	["arsenal", "DD1111", "Virtual Arsenal"] call FF7_fnc_formatAddAction,
	{["Open", true] spawn BIS_fnc_arsenal},
	[],
	100,
	true,
	true,
	"",
	"((_target distance _this) < 5)"
];

_null = _box addAction
[
	["saw", "11DD11", "Quicksave Gear"] call FF7_fnc_formatAddAction,
	{call FF7_fnc_saveGear},
	[],
	99,
	true,
	true,
	"",
	"((_target distance _this) < 5)"
];

_null = _box addAction
[
	["loadgear", "4169E1", "Quickload Gear"] call FF7_fnc_formatAddAction,
	{call FF7_fnc_getGear},
	[],
	98,
	true,
	true,
	"",
	"((_target distance _this) < 5) && (!isNil 'FF7_Gear')"
];

//["AmmoboxInit", [_box, true]] spawn BIS_fnc_arsenal;

// Disable ACE cargo
_box setVariable ["ace_cargo_size", -1];

// Disable ACE dragging
[_box, false] call ace_dragging_fnc_setDraggable;

// Disable ACE carrying
[_box, false] call ace_dragging_fnc_setCarryable;

// Disable ACE cargo loading
_box setVariable ["ace_cargo_canLoad", 0];

// Add ACE spare barrels
//_box addMagazineCargoGlobal ["ACE_SpareBarrel", 8];
