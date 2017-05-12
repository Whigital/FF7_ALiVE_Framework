private ["_class", "_role", "_loadouts", "_loadout"];

_class		= (typeOf (vehicle player));
_loadouts	= profileNamespace getVariable ["bis_fnc_saveInventory_data", []];

switch _class do
{
	case "B_Soldier_SL_F":		{ _role = "SL" };		// Squadleader
	case "B_Soldier_TL_F":		{ _role = "TL" };		// Teamleader
	case "B_Soldier_F":			{ _role = "RL" };		// Rifleman
	case "B_soldier_LAT_F":		{ _role = "LAT" };		// Rifleman (Light AT)
	case "B_Soldier_A_F":		{ _role = "RLS" };		// Rifleman (Support)
	case "B_Soldier_GL_F":		{ _role = "GND" };		// Rifleman (Grenadier)
	case "B_soldier_M_F":		{ _role = "RLL" };		// Rifleman (Longrange)
	case "B_soldier_AR_F":		{ _role = "AR" };		// Autorifleman
	case "B_soldier_AAR_F":		{ _role = "AAR" };		// Asst. Autorifleman
	case "B_soldier_AT_F":		{ _role = "AT" };		// Anti Tank
	case "B_soldier_AAT_F":		{ _role = "AAT" };		// Asst. Anti Tank
	case "B_soldier_AA_F":		{ _role = "AA" };		// Anti Air
	case "B_soldier_AAA_F":		{ _role = "AAA" };		// Asst. Anti Air
	case "B_medic_F":			{ _role = "CLS" };		// Combat Life Saver
	case "B_soldier_repair_F":	{ _role = "RP" };		// Repair Specialist
	case "B_soldier_exp_F":		{ _role = "EX" };		// Explosives Expert
	case "B_Sharpshooter_F":	{ _role = "MKN" };		// Marksman

	case "B_spotter_F":			{ _role = "SPT" };		// Spotter
	case "B_sniper_F":			{ _role = "SPR" };		// Sniper
	case "B_recon_medic_F":		{ _role = "RCM" };		// Recon Paramedic
	case "B_recon_JTAC_F":		{ _role = "JTC" };		// Recon JTAC
	case "B_soldier_UAV_F":		{ _role = "UAV" };		// UAV Operator

	case "B_Helipilot_F":		{ _role = "HPL" };		// Pilot
};

_loadout = (format ["FF7-Gear_%1", _role]);

if (_loadout in _loadouts) then
{
	[player, [profileNamespace, _loadout]] call BIS_fnc_loadInventory;
}
else
{
	["ARMORY", "Armory", (format ["Role based loadout not found.<br/><br/>To get your favorite gear for this role at start, save a loadout called <t color='#22CC22'>%1</t> in the arsenal.", _loadout])] call FF7_fnc_globalHintStruct;
};
