/*
	FoxForce AI script

	Use this to modify the skill of ZEUS or MCC spawned AI.

	Param:
		1: Accuracy		(required, 0-1)
		2: Skill		(required, 0-1)
		3: Variance		(optional, default 0.1)

	Usage:
		_nul = [0.6, 0.8] spawn FF7_fnc_setAIskill;
			- Will randomize AI accuracy between 0.55-0.65 and skill between 0.75-0.85

		_nul = [0.55, 0.75, 0.2] spawn FF7_fnc_setAIskill;
			- Will randomize AI accuracy between 0.45-0.65 and skill between 0.65-0.85

	https://community.bistudio.com/wiki/AI_Sub-skills

*/

private ["_acc", "_skill", "_var"];

_acc	= (_this select 0);
_skill	= (_this select 1);

// Set default variance
if ((count _this) > 2) then
{
	_var = (_this select 2);
}
else
{
	_var = 0.1;
};

// Loop through all groups and units
{
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
	} foreach units _x;
} foreach allGroups;
