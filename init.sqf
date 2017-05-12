//////////////////////////////////////
// ---------- Begin init ---------- //
//////////////////////////////////////

//  ---------- Disable saving

enableSaving [false, false];
enableTeamswitch false;


//  ---------- Viewdistance parameters

CHVD_allowNoGrass	= false;

CHVD_maxView_foot	= 1500;
CHVD_maxView_land	= 2000;
CHVD_maxView_air	= 3000;

CHVD_maxView		= CHVD_maxView_air;
CHVD_maxObj			= CHVD_maxView_air;


// ---------- Make HQ hangar indestructable

["mkr_hq", 100] call FF7_fnc_hangarProtect;


////////////////////////////////////
// ---------- End init ---------- //
////////////////////////////////////
