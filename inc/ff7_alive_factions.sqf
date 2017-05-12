/* ----------------------------------------------------------------------

		Custom faction mappings for ALiVE

---------------------------------------------------------------------- */

["Server", "Loading ALiVE factions ...."] call FF7_fnc_debugLog;

// ----------------------------------------------- //
// ---------- Begin rhs_faction_vdv_des ---------- //
// ----------------------------------------------- //

rhs_faction_vdv_des_map = [] call ALIVE_fnc_hashCreate;

[rhs_faction_vdv_des_map,	"Side",	"EAST"] call ALIVE_fnc_hashSet;
[rhs_faction_vdv_des_map, "GroupSideName", "EAST"] call ALIVE_fnc_hashSet;
[rhs_faction_vdv_des_map,	"FactionName", "rhs_faction_vdv_des"] call ALIVE_fnc_hashSet;
[rhs_faction_vdv_des_map,	"GroupFactionName",	"rhs_faction_vdv"] call ALIVE_fnc_hashSet;

rhs_faction_vdv_des_typemap = [] call ALIVE_fnc_hashCreate;

[rhs_faction_vdv_des_map,	"GroupFactionTypes", rhs_faction_vdv_des_typemap] call ALIVE_fnc_hashSet;


// ----- Group mappings ----- //

rhs_faction_vdv_des_groups = [] call ALIVE_fnc_hashCreate;

[
	rhs_faction_vdv_des_groups,
	"Infantry",
	[
		"rhs_group_rus_vdv_des_infantry_chq",
		"rhs_group_rus_vdv_des_infantry_fireteam",
		"rhs_group_rus_vdv_des_infantry_MANEUVER",
		"rhs_group_rus_vdv_des_infantry_section_AA",
		"rhs_group_rus_vdv_des_infantry_section_AT",
		"rhs_group_rus_vdv_des_infantry_section_marksman",
		"rhs_group_rus_vdv_des_infantry_section_mg",
		"rhs_group_rus_vdv_des_infantry_squad",
		"rhs_group_rus_vdv_des_infantry_squad_2mg",
		"rhs_group_rus_vdv_des_infantry_squad_mg_sniper",
		"rhs_group_rus_vdv_des_infantry_squad_sniper"
	]
] call ALIVE_fnc_hashSet;

[
	rhs_faction_vdv_des_groups,
	"Motorized",
	[
		"rhs_group_rus_vdv_gaz66_squad_2mg",
		"rhs_group_rus_vdv_gaz66_squad_sniper",
		"rhs_group_rus_vdv_gaz66_squad_mg_sniper",
		"rhs_group_rus_vdv_gaz66_squad_aa",
		"rhs_group_rus_vdv_Ural_squad_2mg",
		"rhs_group_rus_vdv_Ural_squad_sniper",
		"rhs_group_rus_vdv_Ural_squad_mg_sniper",
		"rhs_group_rus_vdv_Ural_squad_aa"
	]
] call ALIVE_fnc_hashSet;

[
	rhs_faction_vdv_des_groups,
	"Mechanized",
	[
		"rhs_group_rus_vdv_bmd4ma_squad",
		"rhs_group_rus_vdv_bmd4ma_squad_2mg",
		"rhs_group_rus_vdv_bmd4ma_squad_sniper",
		"rhs_group_rus_vdv_bmd4ma_squad_mg_sniper",
		"rhs_group_rus_vdv_bmd4ma_squad_aa",
		"rhs_group_rus_vdv_bmd4m_squad",
		"rhs_group_rus_vdv_bmd4m_squad_2mg",
		"rhs_group_rus_vdv_bmd4m_squad_sniper",
		"rhs_group_rus_vdv_bmd4m_squad_mg_sniper",
		"rhs_group_rus_vdv_bmd4m_squad_aa",
		"rhs_group_rus_vdv_bmd4_squad",
		"rhs_group_rus_vdv_bmd4_squad_2mg",
		"rhs_group_rus_vdv_bmd4_squad_sniper",
		"rhs_group_rus_vdv_bmd4_squad_mg_sniper",
		"rhs_group_rus_vdv_bmd4_squad_aa",
		"rhs_group_rus_vdv_bmd2_squad",
		"rhs_group_rus_vdv_bmd2_squad_2mg",
		"rhs_group_rus_vdv_bmd2_squad_sniper",
		"rhs_group_rus_vdv_bmd2_squad_mg_sniper",
		"rhs_group_rus_vdv_bmd2_squad_aa",
		"rhs_group_rus_vdv_bmd1_squad",
		"rhs_group_rus_vdv_bmd1_squad_2mg",
		"rhs_group_rus_vdv_bmd1_squad_sniper",
		"rhs_group_rus_vdv_bmd1_squad_mg_sniper",
		"rhs_group_rus_vdv_bmd1_squad_aa",
		"rhs_group_rus_vdv_bmp2_squad",
		"rhs_group_rus_vdv_bmp2_squad_2mg",
		"rhs_group_rus_vdv_bmp2_squad_sniper",
		"rhs_group_rus_vdv_bmp2_squad_mg_sniper",
		"rhs_group_rus_vdv_bmp2_squad_aa",
		"rhs_group_rus_vdv_bmp1_squad",
		"rhs_group_rus_vdv_bmp1_squad_2mg",
		"rhs_group_rus_vdv_bmp1_squad_sniper",
		"rhs_group_rus_vdv_bmp1_squad_mg_sniper",
		"rhs_group_rus_vdv_bmp1_squad_aa",
		"rhs_group_rus_vdv_BTR80a_squad",
		"rhs_group_rus_vdv_BTR80a_squad_2mg",
		"rhs_group_rus_vdv_BTR80a_squad_sniper",
		"rhs_group_rus_vdv_BTR80a_squad_mg_sniper",
		"rhs_group_rus_vdv_BTR80a_squad_aa",
		"rhs_group_rus_vdv_BTR80_squad",
		"rhs_group_rus_vdv_BTR80_squad_2mg",
		"rhs_group_rus_vdv_BTR80_squad_sniper",
		"rhs_group_rus_vdv_BTR80_squad_mg_sniper",
		"rhs_group_rus_vdv_BTR80_squad_aa",
		"rhs_group_rus_vdv_btr70_squad",
		"rhs_group_rus_vdv_btr70_squad_2mg",
		"rhs_group_rus_vdv_btr70_squad_sniper",
		"rhs_group_rus_vdv_btr70_squad_mg_sniper",
		"rhs_group_rus_vdv_btr70_squad_aa",
		"rhs_group_rus_vdv_btr60_squad",
		"rhs_group_rus_vdv_btr60_squad_2mg",
		"rhs_group_rus_vdv_btr60_squad_sniper",
		"rhs_group_rus_vdv_btr60_squad_mg_sniper",
		"rhs_group_rus_vdv_btr60_squad_aa"
	]
] call ALIVE_fnc_hashSet;

[
	rhs_faction_vdv_des_groups,
	"Airborne",
	[
		"rhs_group_rus_vdv_mi24_squad",
		"rhs_group_rus_vdv_mi24_squad_2mg",
		"rhs_group_rus_vdv_mi24_squad_sniper",
		"rhs_group_rus_vdv_mi24_squad_mg_sniper",
		"rhs_group_rus_vdv_mi8_squad",
		"rhs_group_rus_vdv_mi8_squad_2mg",
		"rhs_group_rus_vdv_mi8_squad_sniper",
		"rhs_group_rus_vdv_mi8_squad_mg_sniper"
	]
] call ALIVE_fnc_hashSet;

[
	rhs_faction_vdv_des_groups,
	"Artillery",
	[
		"RHS_SPGPlatoon_vdv_bm21",
		"RHS_SPGSection_vdv_bm21",
		"RHS_SPGPlatoon_tv_2s3",
		"RHS_SPGSection_tv_2s3"
	]
] call ALIVE_fnc_hashSet;

[
	rhs_faction_vdv_des_groups,
	"Armored",
	[
		"RHS_2S25Platoon",
		"RHS_2S25Platoon_AA",
		"RHS_2S25Section",
		"RHS_T80Platoon",
		"RHS_T80Platoon_AA",
		"RHS_T80Section",
		"RHS_T80BPlatoon",
		"RHS_T80BPlatoon_AA",
		"RHS_T80BSection",
		"RHS_T80BVPlatoon",
		"RHS_T80BVPlatoon_AA",
		"RHS_T80BVSection",
		"RHS_T80APlatoon",
		"RHS_T80APlatoon_AA",
		"RHS_T80ASection",
		"RHS_T80UPlatoon",
		"RHS_T80UPlatoon_AA",
		"RHS_T80USection",
		"RHS_T72BAPlatoon",
		"RHS_T72BAPlatoon_AA",
		"RHS_T72BASection",
		"RHS_T72BBPlatoon",
		"RHS_T72BBPlatoon_AA",
		"RHS_T72BBSection",
		"RHS_T72BCPlatoon",
		"RHS_T72BCPlatoon_AA",
		"RHS_T72BCSection",
		"RHS_T72BDPlatoon",
		"RHS_T72BDPlatoon_AA",
		"RHS_T72BDSection"
	]
] call ALIVE_fnc_hashSet;


[
	rhs_faction_vdv_des_map,
	"Groups",	
	rhs_faction_vdv_des_groups
] call ALIVE_fnc_hashSet;

[
	ALIVE_factionCustomMappings,
	"rhs_faction_vdv_des",
	rhs_faction_vdv_des_map
] call ALIVE_fnc_hashSet;


// ----- Support mappings ----- //

[
	ALIVE_factionDefaultSupports,
	"rhs_faction_vdv_des",
	[
		"rhs_p37",
		"rhs_prv13",
		"rhs_2P3_1",
		"rhs_2P3_2",
		"rhs_v2",
		"rhs_v3",
		"rhs_9k79",
		"rhs_9k79_K",
		"rhs_9k79_B",
		"rhs_2s3_tv",
		"rhs_zsu234_aa",
		"RHS_Ural_VMF_01",
		"RHS_Ural_Open_VMF_01",
		"RHS_Ural_Fuel_VMF_01",
		"RHS_BM21_VMF_01",
		"rhs_gaz66_vmf",
		"rhs_gaz66o_vmf",
		"rhs_gaz66_r142_vmf",
		"rhs_gaz66_repair_vmf",
		"rhs_gaz66_ap2_vmf",
		"rhs_gaz66_ammo_vmf",
		"rhs_tigr_vmf",
		"rhs_tigr_3camo_vmf",
		"rhs_tigr_ffv_vmf",
		"rhs_tigr_ffv_3camo_vmf",
		"rhs_uaz_vmf",
		"rhs_uaz_open_vmf",
		"rhs_tigr_vdv",
		"rhs_tigr_3camo_vdv",
		"rhs_tigr_ffv_vdv",
		"rhs_tigr_ffv_3camo_vdv",
		"rhs_tigr_sts_vdv",
		"rhs_tigr_sts_3camo_vdv",
		"rhs_tigr_m_vdv",
		"rhs_tigr_m_3camo_vdv",
		"rhs_uaz_vdv",
		"rhs_uaz_open_vdv"
	]
] call ALIVE_fnc_hashSet;

[
	ALIVE_factionDefaultTransport,
	"rhs_faction_vdv_des",
	[
		"RHS_Ural_VDV_01",
		"RHS_Ural_Open_VDV_01",
		"rhs_gaz66_vdv",
		"rhs_gaz66o_vdv",
		"rhs_gaz66_ap2_vdv"
	]
] call ALIVE_fnc_hashSet;

[
	ALIVE_factionDefaultAirTransport,
	"rhs_faction_vdv_des",
	[
		"RHS_Mi24P_CAS_vdv",
		"RHS_Mi24P_AT_vdv",
		"RHS_Mi24P_vdv",
		"RHS_Mi24V_FAB_vdv",
		"RHS_Mi24V_UPK23_vdv",
		"RHS_Mi24V_AT_vdv",
		"RHS_Mi24V_vdv",
		"RHS_Mi8mt_vdv",
		"RHS_Mi8mt_Cargo_vdv",
		"RHS_Mi8MTV3_vdv",
		"RHS_Mi8MTV3_UPK23_vdv",
		"RHS_Mi8MTV3_FAB_vdv",
		"RHS_Mi8AMT_vdv"
	]
] call ALIVE_fnc_hashSet;

// --------------------------------------------- //
// ---------- End rhs_faction_vdv_des ---------- //
// --------------------------------------------- //
