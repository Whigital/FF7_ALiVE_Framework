params ["_faction"];

private ["_returnArray"];

/*
	_facSide,				0
	_side,					1
	_fact,					2
	_teamSnip,			3
	_empUnit,				4
	_officerType,		5
	_uniform,				6
	_vehAA,					7
	_vehArty,				8
	_INF_TEAMS,			9
	_VEH_MECH,			10
	_VEH_ARM,				11
	_EMP_STATIC			12
	_InfPath				13
*/


// ##### Classes by factions #####
_classes_OPF_F =
[
	east,														// facSide
	"East",													// side
	"OPF_F",												// fact
	"OI_SniperTeam",								// teamSnip
	"O_engineer_F",									// empUnit
	"O_officer_F",									// officerType
	"U_O_OfficerUniform_ocamo",			// uniform
	"O_APC_Tracked_02_AA_F",				// vehAA
	"O_MBT_02_arty_F",							// vehArty
	[																// INF_TEAMS
		"OI_reconPatrol",
		"OI_reconSentry",
		"OI_reconTeam",
		"OIA_InfAssault",
		"OIA_InfSentry",
		"OIA_InfSquad",
		"OIA_InfSquad_Weapons",
		"OIA_InfTeam",
		"OIA_InfTeam_AA",
		"OIA_InfTeam_AT",
		"OIA_ReconSquad",
		"OI_ViperTeam"
	],
	[																// VEH_MECH
		"O_APC_Wheeled_02_rcws_F",
		"O_MRAP_02_gmg_F",
		"O_MRAP_02_hmg_F"
	],
	[																// VEH_ARM
		"O_MBT_02_cannon_F",
		"O_APC_Tracked_02_cannon_F",
		"O_APC_Tracked_02_AA_F",
		"O_MBT_02_arty_F"
	],
	[																// EMP_STATIC
		"O_HMG_01_F",
		"O_HMG_01_high_F",
		"O_GMG_01_F",
		"O_GMG_01_high_F",
		"O_Mortar_01_F",
		"O_static_AA_F",
		"O_static_AT_F"
	],
	"Infantry"
];

_classes_OPF_T_F =
[
	east,														// facSide
	"East",													// side
	"OPF_T_F",											// fact
	"O_T_SniperTeam",								// teamSnip
	"O_T_Engineer_F",								// empUnit
	"O_T_Officer_F",								// officerType
	"U_O_T_Officer_F",							// uniform
	"O_T_APC_Tracked_02_AA_ghex_F",	// vehAA
	"O_T_MBT_02_arty_ghex_F",				// vehArty
	[																// INF_TEAMS
		"O_T_InfSentry",
		"O_T_InfSquad",
		"O_T_InfSquad_Weapons",
		"O_T_InfTeam",
		"O_T_InfTeam_AA",
		"O_T_InfTeam_AT",
		"O_T_reconPatrol",
		"O_T_reconSentry",
		"O_T_reconTeam",
		"O_T_ViperTeam"
	],
	[																// VEH_MECH
		"O_T_APC_Wheeled_02_rcws_ghex_F",
		"O_T_MRAP_02_gmg_ghex_F",
		"O_T_MRAP_02_hmg_ghex_F",
		"O_T_LSV_02_armed_F"
	],
	[																// VEH_ARM
		"O_T_MBT_02_cannon_ghex_F",
		"O_T_APC_Tracked_02_cannon_ghex_F",
		"O_T_APC_Tracked_02_AA_ghex_F",
		"O_T_MBT_02_arty_ghex_F"
	],
	[																// EMP_STATIC
		"O_HMG_01_F",
		"O_HMG_01_high_F",
		"O_GMG_01_F",
		"O_GMG_01_high_F",
		"O_Mortar_01_F",
		"O_static_AA_F",
		"O_static_AT_F"
	],
	"Infantry"
];

_classes_IND_F =
[
	resistance,											// facSide
	"Indep",												// side
	"IND_F",												// fact
	"HAF_SniperTeam",								// teamSnip
	"I_engineer_F",									// empUnit
	"I_officer_F",									// officerType
	"U_I_OfficerUniform",						// uniform
	"O_APC_Tracked_02_AA_F",				// vehAA
	"O_MBT_02_arty_F",							// vehArty
	[																// INF_TEAMS
		"HAF_InfTeam",
		"HAF_InfTeam_AA",
		"HAF_InfTeam_AT",
		"HAF_InfSentry",
		"HAF_InfSquad",
		"HAF_InfSquad_Weapons"
	],
	[																// VEH_MECH
		"I_APC_Wheeled_03_cannon_F",
		"I_MRAP_03_gmg_F",
		"I_MRAP_03_hmg_F"
	],
	[																// VEH_ARM
		"I_APC_tracked_03_cannon_F",
		"I_MBT_03_cannon_F"
	],
	[																// EMP_STATIC
		"I_HMG_01_F",
		"I_HMG_01_high_F",
		"I_GMG_01_F",
		"I_GMG_01_high_F",
		"I_Mortar_01_F",
		"I_static_AA_F",
		"I_static_AT_F"
	],
	"Infantry"
];

_classes_IND_G_F =
[
	east,														// facSide
	"West",													// side
	"Guerilla",											// fact
	"IRG_SniperTeam_M",							// teamSnip
	"O_G_engineer_F",								// empUnit
	"I_officer_F",									// officerType
	"U_I_OfficerUniform",						// uniform
	"O_APC_Tracked_02_AA_F",				// vehAA
	"O_MBT_02_arty_F",							// vehArty
	[																// INF_TEAMS
		"IRG_InfAssault",
		"IRG_InfSentry",
		"IRG_InfSquad",
		"IRG_InfSquad_Weapons",
		"IRG_InfTeam",
		"IRG_InfTeam_AT",
		"IRG_ReconSentry"
	],
	[																// VEH_MECH
		"O_G_Offroad_01_armed_F"
	],
	[																// VEH_ARM
		"rhsusf_m113d_usarmy_M240",
		"rhsusf_m113_usarmy_M240"
	],
	[																// EMP_STATIC
		"RHS_M2StaticMG_D"
	],
	"Infantry"
];

_classes_IND_C_F =
[
	resistance,											// facSide
	"Indep",												// side
	"IND_C_F",											// fact
	"IRG_SniperTeam_M",							// teamSnip
	"I_C_Soldier_Para_8_F",					// empUnit
	"I_officer_F",									// officerType
	"U_I_OfficerUniform",						// uniform
	"O_APC_Tracked_02_AA_F",				// vehAA
	"O_MBT_02_arty_F",							// vehArty
	[																// INF_TEAMS
		"BanditCombatGroup",
		"BanditFireTeam",
		"BanditShockTeam",
		"ParaCombatGroup",
		"ParaFireTeam",
		"ParaShockTeam"
	],
	[																// VEH_MECH
		"I_G_Offroad_01_armed_F"
	],
	[																// VEH_ARM
		"rhsusf_m113d_usarmy_M240",
		"rhsusf_m113_usarmy_M240"
	],
	[																// EMP_STATIC
		"RHS_M2StaticMG_D"
	],
	"Infantry"
];

_classes_rhs_faction_vdv =
[
	east,														// facSide
	"East",													// side
	"rhs_faction_vdv",							// fact
	"OI_SniperTeam",								// teamSnip
	"rhs_vdv_engineer",							// empUnit
	"rhs_vdv_officer",							// officerType
	"rhs_uniform_vdv_emr",					// uniform
	"rhs_zsu234_aa",								// vehAA
	"rhs_2s3_tv",										// vehArty
	[																// INF_TEAMS
		"rhs_group_rus_vdv_infantry_fireteam",
		"rhs_group_rus_vdv_infantry_MANEUVER",
		"rhs_group_rus_vdv_infantry_section_AA",
		"rhs_group_rus_vdv_infantry_section_AT",
		"rhs_group_rus_vdv_infantry_section_marksman",
		"rhs_group_rus_vdv_infantry_section_mg",
		"rhs_group_rus_vdv_infantry_squad",
		"rhs_group_rus_vdv_infantry_squad_2mg",
		"rhs_group_rus_vdv_infantry_squad_mg_sniper",
		"rhs_group_rus_vdv_infantry_squad_sniper"
	],
	[																// VEH_MECH
		"rhs_bmp2d_vdv",
		"rhs_btr80_vmf",
		"rhs_bmd1pk",
		"rhs_tigr_sts_vdv",
		"RHS_Ural_Zu23_VDV_01"

	],
	[																// VEH_ARM
		"rhs_zsu234_aa",
		"rhs_t72bd_tv",
		"rhs_2s3_tv",
		"rhs_sprut_vdv"
	],
	[																// EMP_STATIC
		"rhs_KORD_high_VDV",
		"RHS_AGS30_TriPod_VDV",
		"rhs_Kornet_9M133_2_vdv",
		"rhs_SPG9M_VDV",
		"rhs_Igla_AA_pod_msv",
		"rhs_2b14_82mm_msv"
	],
	"rhs_group_rus_vdv_infantry_flora"
];

_classes_rhs_faction_vdv_flora =
[
	east,														// facSide
	"East",													// side
	"rhs_faction_vdv",							// fact
	"OI_SniperTeam",								// teamSnip
	"rhs_vdv_flora_engineer",				// empUnit
	"rhs_vdv_flora_officer",				// officerType
	"rhs_uniform_vdv_flora",				// uniform
	"rhs_zsu234_aa",								// vehAA
	"rhs_2s3_tv",										// vehArty
	[																// INF_TEAMS
		"rhs_group_rus_vdv_infantry_flora_fireteam",
		"rhs_group_rus_vdv_infantry_flora_MANEUVER",
		"rhs_group_rus_vdv_infantry_flora_section_AA",
		"rhs_group_rus_vdv_infantry_flora_section_AT",
		"rhs_group_rus_vdv_infantry_flora_section_marksman",
		"rhs_group_rus_vdv_infantry_flora_section_mg",
		"rhs_group_rus_vdv_infantry_flora_squad",
		"rhs_group_rus_vdv_infantry_flora_squad_2mg",
		"rhs_group_rus_vdv_infantry_flora_squad_mg_sniper",
		"rhs_group_rus_vdv_infantry_flora_squad_sniper"
	],
	[																// VEH_MECH
		"rhs_bmp2d_vdv",
		"rhs_btr80_vmf",
		"rhs_bmd1pk",
		"rhs_tigr_sts_vdv",
		"RHS_Ural_Zu23_VDV_01"

	],
	[																// VEH_ARM
		"rhs_zsu234_aa",
		"rhs_t72bd_tv",
		"rhs_2s3_tv",
		"rhs_sprut_vdv"
	],
	[																// EMP_STATIC
		"rhs_KORD_high_VDV",
		"RHS_AGS30_TriPod_VDV",
		"rhs_Kornet_9M133_2_vdv",
		"rhs_SPG9M_VDV",
		"rhs_Igla_AA_pod_msv",
		"rhs_2b14_82mm_msv"
	],
	"rhs_group_rus_vdv_infantry_flora"
];

_classes_rhs_faction_vdv_des =
[
	east,														// facSide
	"East",													// side
	"rhs_faction_vdv",							// fact
	"OI_SniperTeam",								// teamSnip
	"rhs_vdv_des_engineer",					// empUnit
	"rhs_vdv_des_officer",					// officerType
	"rhs_uniform_vdv_emr_des",			// uniform
	"rhs_zsu234_aa",								// vehAA
	"rhs_2s3_tv",										// vehArty
	[																// INF_TEAMS
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
	],
	[																// VEH_MECH
		"rhs_bmp2d_vdv",
		"rhs_btr80_vmf",
		"rhs_bmd1pk",
		"rhs_tigr_sts_vdv",
		"RHS_Ural_Zu23_VDV_01"

	],
	[																// VEH_ARM
		"rhs_zsu234_aa",
		"rhs_t72bd_tv",
		"rhs_2s3_tv",
		"rhs_sprut_vdv"
	],
	[																// EMP_STATIC
		"rhs_KORD_high_VDV",
		"RHS_AGS30_TriPod_VDV",
		"rhs_Kornet_9M133_2_vdv",
		"rhs_SPG9M_VDV",
		"rhs_Igla_AA_pod_msv",
		"rhs_2b14_82mm_msv"
	],
	"rhs_group_rus_vdv_des_infantry"
];


switch (_faction) do
{
	case "OPF_F":
	{
		_returnArray = _classes_OPF_F;
	};

	case "OPF_T_F":
	{
		_returnArray = _classes_OPF_T_F;
	};

	case "IND_F":
	{
		_returnArray = _classes_IND_F;
	};

	case "IND_G_F":
	{
		_returnArray = _classes_IND_G_F;
	};

	case "IND_C_F":
	{
		_returnArray = _classes_IND_C_F;
	};

	case "rhs_faction_vdv":
	{
		_returnArray = _classes_rhs_faction_vdv;
	};

	case "rhs_faction_vdv_flora":
	{
		_returnArray = _classes_rhs_faction_vdv_flora;
	};

	case "rhs_faction_vdv_des":
	{
		_returnArray = _classes_rhs_faction_vdv_des;
	};

	default
	{
		_returnArray = _classes_OPF_F;
	};
};

_returnArray;
