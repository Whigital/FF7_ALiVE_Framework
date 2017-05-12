params ["_caller"];
private ["_droppos"];

//if !(FF7_Supplydrop) exitWith {hintSilent "Supplydrop is currently unavailable ...."};
if !(FF7_Supplydrop) exitWith {["SUPPLY", "Supply depot", "Supplydrop is currently unavailable ...."] call FF7_fnc_globalHintStruct};

/*
openMap true;

FF7_Supply_click = false;

onMapSingleClick "FF7_Supply_pos = _pos; FF7_Supply_click = true; onMapSingleClick ''; true;";
waitUntil {FF7_Supply_click or !(visiblemap)};

if (!visibleMap) exitwith {["SUPPLY", "Supply depot", "Supplydrop cancelled ...."] call FF7_fnc_globalHintStruct};

_droppos = FF7_Supply_pos;

[_droppos] remoteExec ["FF7_fnc_supplyDrop", 2, false];

openMap false;
*/

_droppos = (getPos _caller);

[_droppos] remoteExec ["FF7_fnc_supplyDrop", 2, false];
