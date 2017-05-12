private ["_arr", "_path"];

_arr = toArray str missionConfigFile;
_arr resize (count _arr - 15);

_path = toString _arr;

_path;
