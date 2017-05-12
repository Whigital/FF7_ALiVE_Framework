private ["_pos", "_posx", "_posy", "_posz", "_crate", "_crates", "_chute", "_chutes", "_smoke", "_smokes", "_light", "_lights", "_delay", "_content"];

if (FF7_Global_Debug) then
{
	["FF7_fnc_supplyDrop", "Running function"] call FF7_fnc_debugLog;
};

_delay = "SupplyDropPeriod" call BIS_fnc_getParamValue;

FF7_Supplydrop = false;
publicVariable "FF7_Supplydrop";

_pos = (_this select 0);

_posx = (_pos select 0);
_posy = (_pos select 1);
_posz = (_pos select 2);

_chutes	= ["B_Parachute_02_F", "O_Parachute_02_F", "I_Parachute_02_F"];
_crates	= ["Box_IND_AmmoVeh_F", "Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F"];
_smokes	= ["SmokeShellRed", "SmokeShellOrange", "SmokeShellPurple"];
_lights	= ["Chemlight_green", "Chemlight_yellow", "Chemlight_red"];

_smoketype = (selectRandom _smokes);
_lighttype = "Chemlight_yellow";

_content =
[
	// Magazines
	["rhs_mag_30Rnd_556x45_Mk318_Stanag", 44],
	["rhs_200rnd_556x45_M_SAW", 8],
	["rhsusf_100Rnd_762x51", 8],
	["20Rnd_762x51_Mag", 6],
	["ACE_20Rnd_762x51_M118LR_Mag", 6],
	["ACE_20Rnd_762x51_M993_AP_Mag", 6],
	["rhsusf_20Rnd_762x51_m118_special_Mag", 6],
	["rhsusf_20Rnd_762x51_m993_Mag", 6],
	["rhsusf_5Rnd_300winmag_xm2010", 8],
	["rhsusf_5Rnd_762x51_m118_special_Mag", 8],
	["rhsusf_5Rnd_762x51_m993_Mag", 4],
	["rhsusf_10Rnd_762x51_m118_special_Mag", 6],
	["rhsusf_10Rnd_762x51_m993_Mag", 4],
	["10Rnd_338_Mag", 6],
	["7Rnd_408_Mag", 6],
	["rhsusf_mag_10Rnd_STD_50BMG_M33", 4],
	["rhsusf_mag_10Rnd_STD_50BMG_mk211", 2],

	// Launchers
	["rhs_weap_M136", 2],
	["rhs_weap_m72a7", 1],
	["launch_NLAW_F", 1],

	// Rockets
	["tf47_m3maaws_HE", 2],
	["tf47_m3maaws_HEAT", 4],
	["tf47_smaw_HEAA", 4],
	["tf47_smaw_HEDP", 2],
	["tf47_smaw_NE", 2],
	["tf47_smaw_SR", 8],
	["Titan_AA", 2],
	["Titan_AP", 2],
	["Titan_AT", 4],
	["rhs_fgm148_magazine_AT", 2],
	["rhs_mag_smaw_HEAA", 4],
	["rhs_mag_smaw_HEDP", 2],
	["rhs_fim92_mag", 2],

	// Explosives
	["DemoCharge_Remote_Mag", 6],
	["ClaymoreDirectionalMine_Remote_Mag", 8],
	["SLAMDirectionalMine_Wire_Mag", 4],
	["SatchelCharge_Remote_Mag", 2],

	// Grenades
	["HandGrenade", 8],
	["MiniGrenade", 8],
	["B_IR_Grenade", 4],
	["SmokeShell", 12],
	["SmokeShellBlue", 12],
	["SmokeShellGreen", 12],
	["SmokeShellYellow", 12],

	// Throwables
	["Chemlight_blue", 6],
	["Chemlight_green", 6],
	["Chemlight_yellow", 6],

	// 40mm
	["1Rnd_HE_Grenade_shell", 6],
	["rhs_mag_M441_HE", 6],
	["3Rnd_HE_Grenade_shell", 4],
	["1Rnd_Smoke_Grenade_shell", 4],
	["1Rnd_SmokeGreen_Grenade_shell", 4],
	["1Rnd_SmokeBlue_Grenade_shell", 4],
	["1Rnd_SmokeYellow_Grenade_shell", 4],
	["UGL_FlareWhite_F", 2],
	["UGL_FlareGreen_F", 2],
	["UGL_FlareYellow_F", 2],
	["UGL_FlareCIR_F", 4],
	["ACE_HuntIR_M203", 4],

	// Medical
	["ACE_fieldDressing", 60],
	["ACE_morphine", 40],
	["ACE_epinephrine", 16],
	["ACE_bloodIV", 12],
	["ACE_bloodIV_250", 16],
	["ACE_bloodIV_500", 20],

	// Misc.
	["ACE_CableTie", 8],
	["ACE_EarPlugs", 8],
	["Laserbatteries", 2],
	["ACE_IR_Strobe_Item", 8],
	["ACE_UAVBattery", 1],
	["NVGoggles", 1]
];

_chute = createVehicle ["B_Parachute_02_F", [_posx, _posy, _posz + 100], [], 0, "NONE"];

_crate = createVehicle [(selectRandom _crates), position _chute, [], 0, "NONE"];
_crate attachTo [_chute, [0, 0, -0.7]];
_crate allowdamage false;
_crate setVariable ["gc_persist", true];

_smoke = createVehicle [_smoketype, position _chute, [], 0, "NONE"];
_smoke attachTo [_chute, [0, 0, 0.45]];

if ((daytime > 19) || (daytime < 5)) then
{
	_light = createVehicle [_lighttype, position _chute, [], 0, "NONE"];
	_light attachTo [_chute, [0, 0, 0.45]];
};

clearMagazineCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

{
	_crate addItemCargoGlobal _x;
} forEach _content;

// Arsenal action
/*
[
	_crate,
	["arsenal", "DD1111", "Virtual Arsenal"] call FF7_fnc_formatAddAction,
	{["Open", true] spawn BIS_fnc_arsenal},
	[],
	100,
	true,
	true,
	"",
	"((_target distance _this) < 5)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

// Save gear action
[
	_crate,
	["saw", "11DD11", "Quicksave Gear"] call FF7_fnc_formatAddAction,
	{call FF7_fnc_saveGear},
	[],
	99,
	true,
	true,
	"",
	"((_target distance _this) < 5)"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];

[
	_crate,
	["loadgear", "4169E1", "Quickload Gear"] call FF7_fnc_formatAddAction,
	{call FF7_fnc_getGear},
	[],
	98,
	true,
	true,
	"",
	"((_target distance _this) < 5) && (!isNil 'FF7_Gear')"
] remoteExec ["FF7_fnc_addGlobalAction", 0, true];
*/

// Disable ACE cargo
_crate setVariable ["ace_cargo_size", -1];

// Disable ACE dragging
[_crate, false] call ace_dragging_fnc_setDraggable;

// Disable ACE carrying
[_crate, false] call ace_dragging_fnc_setCarryable;

// Disable ACE cargo loading
_crate setVariable ["ace_cargo_canLoad", 0];

_crate setVariable["gc_persist", true];

["SUPPLY", "Supply depot", "Supplycrate is in the air ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

waitUntil {(((position _crate) select 2) < 2) || (isNull _chute)};

detach _crate;

if !(isNil "_light") then
{
	detach _light;
};

detach _smoke;

sleep (_delay/2);

deleteVehicle _crate;

sleep (_delay/2);

//["<t align='center'><t size='2.0' color='#00EEB2'>Supply depot</t><br/>________________________________________<br/><br/><t size='1.3' color='#00B2EE'>Supplydrop is now available ....</t>", 10] remoteExec ["FF7_fnc_globalHint", 0];

["SUPPLY", "Supply depot", "Supplydrop now available ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

FF7_Supplydrop = true;
publicVariable "FF7_Supplydrop";
