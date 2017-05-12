/* ----------------------------------------------------------------------

	Usage :	In ALiVE_Require module init.

	_null = [] execVM "ff7_ALiVE_staticData.sqf";

---------------------------------------------------------------------- */

// ---------- CQB unit blacklist ---------- //
call (compile (preprocessFileLineNumbers "inc\ff7_alive_blacklist_cqb.sqf"));

// ---------- Unit placemant blacklist ---------- //
call (compile (preprocessFileLineNumbers "inc\ff7_alive_blacklist_unit.sqf"));

// ---------- Vehicle placemant blacklist ---------- //
call (compile (preprocessFileLineNumbers "inc\ff7_alive_blacklist_vehicle.sqf"));

// ---------- Group placemant blacklist ---------- //
call (compile (preprocessFileLineNumbers "inc\ff7_alive_blacklist_group.sqf"));

// ---------- Custom faction mappings ---------- //
waitUntil {!isnil "ALiVE_factionCustomMappings"};
call (compile (preprocessFileLineNumbers "inc\ff7_alive_factions.sqf"));
