private ["_box", "_unit"];

_box	= (_this select 0);
_unit	= (_this select 1);

/*
_unit playMove "AinvPknlMstpSlayWrflDnon_medic";

sleep 1;

waitUntil {((animationState _unit) != "AinvPknlMstpSlayWrflDnon_medic")};

[_box, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
*/

_unit playMove "AinvPknlMstpSlayWrflDnon_medic";

[10, [], {}, {}, "Treating injuries, standby ...."] call ace_common_fnc_progressBar;

[_box, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
