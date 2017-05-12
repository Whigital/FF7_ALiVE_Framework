params ["_unit"];

private ["_action", "_cond", "_type"];

_type = (typeOf _unit);


//----- Role specific actions -----
if (_type in ["B_Soldier_SL_F", "B_Soldier_TL_F", "B_spotter_F", "B_recon_JTAC_F"]) then
{
	_cond = {true};


	// Add "Support" parent
	_action =
	[
		"FF7_Support",
		"Support",
		"img\icon\icon-support.paa",
		{},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;


	// ALiVE Combat Tablet 
	_action =
	[
		"FF7_Support_Tablet",
		"Combat Support",
		"img\icon\icon-combatsupport.paa",
		{["radio"] call ALIVE_fnc_radioAction;},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions", "FF7_Support"], _action] call ace_interact_menu_fnc_addActionToObject;


	// Supply drop
	_action =
	[
		"FF7_Support_Drop",
		"Supply Drop",
		"img\icon\icon-supply.paa",
		{[_player] call FF7_fnc_reqSupplyDrop;},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions", "FF7_Support"], _action] call ace_interact_menu_fnc_addActionToObject;
}
else
{
	_cond = {((leader (group _player)) == _player)};


	// Add "Support" parent
	_action =
	[
		"FF7_Support",
		"Support",
		"img\icon\icon-support.paa",
		{},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;


	// ALiVE Combat Tablet 
	_action =
	[
		"FF7_Support_Tablet",
		"Combat Support",
		"img\icon\icon-combatsupport.paa",
		{["radio"] call ALIVE_fnc_radioAction;},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions", "FF7_Support"], _action] call ace_interact_menu_fnc_addActionToObject;


	// Supply drop
	_action =
	[
		"FF7_Support_Drop",
		"Supply Drop",
		"img\icon\icon-supply.paa",
		{[_player] call FF7_fnc_reqSupplyDrop;},
		_cond
	] call ace_interact_menu_fnc_createAction;

	[_unit, 1, ["ACE_SelfActions", "FF7_Support"], _action] call ace_interact_menu_fnc_addActionToObject;
};


//----- Health check for medics -----
if (_type in ["B_medic_F", "B_recon_medic_F"]) then
{
	_action =
	[
		"FF7_MedicalStatus",
		"Health status",
		"img\icon\icon-health.paa",
		{[_target] spawn FF7_fnc_aceMedicalStatus;},
		{([_player] call ace_medical_fnc_isMedic)}
	] call ace_interact_menu_fnc_createAction;

	["CAManBase", 0, ["ACE_Torso"], _action, true] call ace_interact_menu_fnc_addActionToClass;
};


//----- Common actions -----

_cond = {true};

// Settings parent
_action =
[
	"FF7_Settings",
	"Settings",
	"img\icon\icon-settings.paa",
	{},
	_cond
] call ace_interact_menu_fnc_createAction;

[_unit, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;


// Viewdistance
_action =
[
	"FF7_Settings_View",
	"Viewdistance",
	"img\icon\icon-monitor.paa",
	{call CHVD_fnc_openDialog;},
	_cond
] call ace_interact_menu_fnc_createAction;

[_unit, 1, ["ACE_SelfActions", "FF7_Settings"], _action] call ace_interact_menu_fnc_addActionToObject;
