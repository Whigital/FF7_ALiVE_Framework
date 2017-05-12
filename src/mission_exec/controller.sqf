private
[
	"_delay",
	"_completeLimit",
	"_opType",
	"_popType",
	"_actOp",
	"_prevOp",
	"_factions",
	"_gatherOps",
	"_destroyOps",
	"_eliminateOps",
	"_secureOps",
	"_rescueOps"
];


FF7_OP_gatherPos					= [0, 0, 0];
FF7_OP_missionPos					= [0, 0, 0];
FF7_OP_missionsCompleted	= 0;
FF7_OP_gatherSuccess			= false;
FF7_OP_missionSuccess			= false;

FF7_OP_numInfAO						= ["OPSaoInfantry"] call BIS_fnc_getParamValue;
FF7_OP_numSniperAO				= ["OPSaoSniper"] call BIS_fnc_getParamValue;
FF7_OP_numStaticAO				= ["OPSaoSstatic"] call BIS_fnc_getParamValue;
FF7_OP_numMechAO					= ["OPSaoMech"] call BIS_fnc_getParamValue;
FF7_OP_numArmorAO					= ["OPSaoArmor"] call BIS_fnc_getParamValue;
FF7_OP_radiusAO						= ["OPSaoRadius"] call BIS_fnc_getParamValue;

FF7_OP_centerEast	= createCenter east;
FF7_OP_centerInd	= createCenter resistance;

_delay					= 600;
_completeLimit	= ("ObjectiveLimit" call BIS_fnc_getParamValue);


// ---------- Initialize and populate marker arrays
FF7_OP_markersTown	= [];
FF7_OP_markersObj		= [];
FF7_OP_markerTAOR		= [];

{
	if (["mkr_objTown", _x] call BIS_fnc_inString) then
	{
		FF7_OP_markersTown pushBack _x;
	};

	if (["mkr_opLoc", _x] call BIS_fnc_inString) then
	{
		FF7_OP_markersObj pushBack _x;
	};

	if (["mkr_taor_", _x] call BIS_fnc_inString) then
	{
		FF7_OP_markerTAOR pushBack _x;
	};
} forEach allMapMarkers;


// ---------- Types of intel gathering missions
_gatherOps = ["item", "officer", "informant"];

// ---------- Types of operations
_opsList = ["secure", "destroy", "eliminate", "rescue"];

// ---------- Missions per operation type
_destroyOps	=
[
	"druglab",
	"radar",
	//"radiotower",
	"factory"
];

_secureOps =
[
	"blackfoot",
	//"c130",
	"blackhawk"
	//"ammocache"
];

_eliminateOps =
[
	"mortar",
	"anti-air",
	"artillery"
];

_rescueOps =
[
	"pilot",
	"officer"
];

_opType		= "tbd";
_popType	= "tbd";
_actOp		= "tbd";
_prevOp		= "tbd";

waitUntil {time > (_delay + (random (_delay / 2)))};

// ---------- Main mission controller
while {true} do
{
	["HQ", "Headquarters", "Mission incoming, standby for details ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

	sleep 60;

	// Reset status variables
	FF7_OP_gatherSuccess	= false;
	FF7_OP_missionSuccess	= false;

	// Start intel gathering ....
	_gatherHandle = execVM (format ["src\mission_exec\gather\%1.sqf", (selectRandom _gatherOps)]);

	waitUntil
	{
		sleep 5;
		scriptDone _gatherHandle;
	};

	sleep 5;

	// If intel gathering successfull, launch random mission
	if (FF7_OP_gatherSuccess) then
	{
		sleep 30;

		["HQ", "Headquarters", "Intel received, standby while we analyse the data ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

		sleep 60 + (random 60);

		_opOK = false;

		while {!_opOK} do
		{
			_opType = (selectRandom _opsList);

			if !(_opType == _popType) then
			{
				switch (_opType) do
				{
					case "destroy":
					{
						_actOp = (selectRandom _destroyOps);
					};
					case "rescue":
					{
						_actOp = (selectRandom _rescueOps);
					};
					case "secure":
					{
						_actOp = (selectRandom _secureOps);
					};
					case "eliminate":
					{
						_actOp = (selectRandom _eliminateOps);
					};
				};

				_popType	= _opType;
				_prevOp		= _actOp;
				_opOK			= true;
			};
		};

		["HQ", "Headquarters", "Intel analyzed, standby for tasking ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

		sleep 30;

		["OPS", (format ["Starting mission : %1 - %2", _opType, _actOp])] call FF7_fnc_debugLog;

		_opHandle = execVM (format ["src\mission_exec\ops\%1\%2.sqf", _opType, _actOp]);

		waitUntil
		{
			sleep 5;
			scriptDone _opHandle;
		};

		if (FF7_OP_missionSuccess) then
		{
			FF7_OP_missionsCompleted = FF7_OP_missionsCompleted + 1;

			["OPS", (format ["Missions completed: %1/%2", FF7_OP_missionsCompleted, _completeLimit])] call FF7_fnc_debugLog;

			publicVariableServer "FF7_OP_missionsCompleted";
		}
		else
		{
			["OPS", (format ["Mission failed: %1 - %2", _opType, _actOp])] call FF7_fnc_debugLog;
		};
	}
	else
	{
		sleep 15;

		["HQ", "Headquarters", "Too bad the target got killed, be more careful next time ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];
	};

	if (FF7_OP_missionsCompleted == _completeLimit) exitWith {["Won"] call BIS_fnc_endMissionServer};

	sleep 60;

	["HQ", "Headquarters", "Tasking complete, return to base and await further orders ...."] remoteExec ["FF7_fnc_globalHintStruct", 0];

	sleep (_delay + (random (_delay / 2)));
};
