if (!isNil "FF7_Gear") then
{
	[player, [missionNamespace, "FF7_Gear"]] call BIS_fnc_loadInventory;
	["ARMORY", "Armory", "Gear loaded"] call FF7_fnc_globalHintStruct;
};
