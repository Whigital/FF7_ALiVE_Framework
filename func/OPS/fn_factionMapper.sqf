// ---------- Initialize faction hash
private ["_factions", "_opf", "_opfFaction", "_ind", "_indFaction"];

_opf = ("OpponentOPF" call BIS_fnc_getParamValue);
_ind = ("OpponentINDF" call BIS_fnc_getParamValue);

switch (_opf) do
{
	case 0:
	{
		_opfFaction = "OPF_F";
	};

	case 1:
	{
		_opfFaction = "OPF_T_F";
	};

	case 2:
	{
		_opfFaction = "rhs_faction_vdv_flora";
	};

	case 3:
	{
		_opfFaction = "rhs_faction_vdv_des";
	};

	default
	{
		_opfFaction = "OPF_F";
	};
};

switch (_ind) do
{
	case 0:
	{
		_indFaction = "IND_F";
	};

	default
	{
		_indFaction = "IND_F";
	};
};

_factions =
[
	["opf", _opfFaction],
	["indf", _indFaction]
];

FF7_OP_Factions = [_factions, 0] call CBA_fnc_hashCreate;
