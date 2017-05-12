private ["_iRespawn"];

// Run only on player ....
if (!hasInterface) exitWith {};

player disableConversation true;
enableSentences false;

_iRespawn = "RespawnTime" call BIS_fnc_getParamValue;
setPlayerRespawnTime _iRespawn;

player setCustomAimCoef 0.5;

call FF7_fnc_getGear;


player switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSlowWrflDnon";

if (!isNil "FF7_Gear") then
{
	call FF7_fnc_getGear;
}
else
{
	call FF7_fnc_getGearRole;
};


["Preload"] call BIS_fnc_arsenal;
