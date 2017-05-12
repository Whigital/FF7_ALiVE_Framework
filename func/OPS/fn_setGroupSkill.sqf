private ["_group", "_acc", "_skill", "_var"];

_group	= (_this select 0);
_acc	= (_this select 1);
_skill	= (_this select 2);
_var	= 0;

// Set default variance
if ((count _this) > 3) then
{
	_var = (_this select 3);
}
else
{
	_var = 0.1;
};

/*
// Loop through units in _group
{
	if (_x isKindOf "Man") then
	{

		// Accuracy
		_x setSkill ["aimingAccuracy", [_acc, _var] call FF7_fnc_genRandom];
		_x setSkill ["aimingShake", [_acc, _var] call FF7_fnc_genRandom];
		_x setSkill ["aimingSpeed", [_acc, _var] call FF7_fnc_genRandom];
		_x setSkill ["reloadSpeed", [_acc, _var] call FF7_fnc_genRandom];

		// Behavior
		_x setSkill ["commanding", [_skill, _var] call FF7_fnc_genRandom];
		_x setSkill ["courage", [_skill, _var] call FF7_fnc_genRandom];
		_x setSkill ["general", [_skill, _var] call FF7_fnc_genRandom];
		_x setSkill ["spotDistance",[_skill, _var] call FF7_fnc_genRandom];
		_x setSkill ["spotTime", [_skill, _var] call FF7_fnc_genRandom];
	};
} foreach units _group;
*/

// Loop through units in _group
{
	if (_x isKindOf "Man") then
	{

		// Accuracy
		_x setSkill ["aimingAccuracy", FF7_OPS_aimingAccuracy];
		_x setSkill ["aimingShake", FF7_OPS_aimingShake];
		_x setSkill ["aimingSpeed", FF7_OPS_aimingSpeed];
		_x setSkill ["reloadSpeed", FF7_OPS_reloadSpeed];

		// Behavior
		_x setSkill ["commanding", FF7_OPS_commanding];
		_x setSkill ["courage", FF7_OPS_courage];
		_x setSkill ["general", FF7_OPS_general];
		_x setSkill ["spotDistance", FF7_OPS_spotDistance];
		_x setSkill ["spotTime", FF7_OPS_spotTime];
	};
} foreach units _group;
