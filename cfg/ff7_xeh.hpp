class Extended_Init_EventHandlers
{
	class Man
	{
		//init = "if ((side _this) == civilian) then {_this addMPEventHandler ['MPkilled', call FF7_fnc_civKilled]};";
		init = "_this call FF7_fnc_civKilled";
	};
};
