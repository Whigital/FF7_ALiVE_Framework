class CfgGroups
{
	class East
	{
		name = "OPFOR";

		class OPF_F
		{
			name = "CSAT";

			class Armored
			{
				name = "Armor";

				class FF7_OIA_TankTeam1
				{
					name = "FF7 - Tank Team 1";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_MBT_02_cannon_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_APC_Tracked_02_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_OIA_TankTeam2
				{
					name = "FF7 - Tank Team 2";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_MBT_02_cannon_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_APC_Tracked_02_AA_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_OIA_TankTeam_AA1
				{
					name = "FF7 - Anti-Air Team 1";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_T_APC_Tracked_02_AA_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_T_APC_Tracked_02_AA_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_OIA_TankTeam_AA2
				{
					name = "FF7 - Anti-Air Team 2";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_T_APC_Tracked_02_AA_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_APC_Tracked_02_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_OIA_TankTeam_Art1
				{
					name = "FF7 - Artillery Team 1";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_art.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_MBT_02_arty_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_APC_Tracked_02_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_OIA_TankTeam_Art2
				{
					name = "FF7 - Artillery Team 2";
					side = 0;
					faction = "OPF_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_art.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 0;
						vehicle = "O_MBT_02_arty_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 0;
						vehicle = "O_T_APC_Tracked_02_AA_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};
			};
		};
	};
	
	class Indep
	{
		name = "Independent";

		class IND_F
		{
			name = "AAF";

			class Armored
			{
				name = "Armor";

				class FF7_HAF_TankTeam1
				{
					name = "FF7 - Tank Team 1";
					side = 2;
					faction = "IND_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 2;
						vehicle = "I_MBT_03_cannon_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 2;
						vehicle = "I_APC_tracked_03_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_HAF_TankTeam2
				{
					name = "FF7 - Tank Team 2";
					side = 2;
					faction = "IND_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 2;
						vehicle = "I_MBT_03_cannon_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 2;
						vehicle = "I_APC_Wheeled_03_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};

				class FF7_HAF_TankTeam3
				{
					name = "FF7 - Tank Team 3";
					side = 2;
					faction = "IND_F";
					icon = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
					rarityGroup = 0.5;

					class Unit0
					{
						side = 2;
						vehicle = "I_APC_tracked_03_cannon_F";
						rank = "LIEUTENANT";
						position[] = {0, 0, 0};
					};
					class Unit1
					{
						side = 2;
						vehicle = "I_APC_Wheeled_03_cannon_F";
						rank = "SERGEANT";
						position[] = {0, -10, 0};
					};
				};
			};
		};
	};
};
