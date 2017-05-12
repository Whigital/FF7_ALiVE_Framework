/*

	AUTHOR: aeroson
	NAME: repetitive_cleanup.sqf
	VERSION: 2.0

	DESCRIPTION:
	Custom made, used and tested garbage collector.
	Improves performance for everyone by deleting things that are not seen by players.
	Can delete everything that is not really needed.
	By default: dead bodies, dropped items, smokes, chemlights, explosives, times and classes can be specified
	You can add your own classes to delete and or change times.
	Beware: if weapons on ground is intentional e.g. fancy weapons stack, it will delete them too.
	Beware: if dead bodies are intentional it will delete them too.
	Beware: if destroyed vehicles intentional it will delete them too.
	Uses allMissionObjects "" to iterate over all objects, so it is fast.
	Adds objects for deletion only if players are specified distance away from them.
	Never again it will happen that vehicle, item or body is delete in front of players' eyes.
	If you want something to withstand the clean up, paste this into it's init:
	this setVariable ["gc_persist", true];

	USAGE:
	paste into init
	[] execVM 'repetitive_cleanup.sqf';
	then open the script and adjust values in CNFIGURATION section
	You might also need to disable Bohemia's garbage collector, seems it's enabled by default despite wiki saying otherwise.
	Source: https://community.bistudio.com/wiki/Description.ext
	Add the following into your description.ext:
	corpseManagerMode = 0;
	wreckManagerMode = 0;

*/

if (!isServer) exitWith {}; // isn't server

// ---------- Wait for ALiVE to initialize

_alive_main		= ((entities "ALiVE_require") select 0);
_alive_status	= (_alive_main getVariable ["startupComplete", false]);

while {!_alive_status} do
{
	sleep 15;

	_alive_status = (_alive_main getVariable ["startupComplete", false]);
};

sleep 5;


#define COMPONENT repetitiveCleanup
#define DOUBLES(A,B) ##A##_##B
#define TRIPLES(A,B,C) ##A##_##B##_##C
#define QUOTE(A) #A
#define GVAR(A) DOUBLES(COMPONENT,A)
#define QGVAR(A) QUOTE(GVAR(A))


if (!isNil {GVAR(isRunning)} && {GVAR(isRunning)}) then
{
	GVAR(isRunning) = false;
	waitUntil {isNil {GVAR(isRunning)}};
};

GVAR(isRunning) = true;

//==================================================================================//
//=============================== CNFIGURATION start ===============================//
//==================================================================================//

_ttdBodies						= ["CleanupBodies",		(10 * 60)] call BIS_fnc_getParamValue;
_ttdVehiclesDead			= ["CleanupVehicles",	(15 * 60)] call BIS_fnc_getParamValue;
_ttdVehiclesImmobile	= ["CleanupAbandoned",	(15 * 60)] call BIS_fnc_getParamValue;
_ttdWeapon						= ["CleanupWeapons",	(10 * 60)] call BIS_fnc_getParamValue;
_ttdDemo							= ["CleanupDemos",		(60 * 60)] call BIS_fnc_getParamValue;
_ttdOther							= ["CleanupOther",		(15 * 60)] call BIS_fnc_getParamValue;

GVAR(deleteClassesConfig) =
[
	[
		_ttdWeapon,
		[
			"WeaponHolder",
			"GroundWeaponHolder",
			"WeaponHolderSimulated",
			"WeaponHolder_Single_F",
			"WeaponHolder_Single_limited_item_F",
			"WeaponHolder_Single_limited_magazine_F",
			"WeaponHolder_Single_limited_weapon_F"
		]
	],
	[
		_ttdDemo,
		[
			"TimeBombCore"
		]
	],
	[
		_ttdOther,
		[
			"SmokeShell"
		]
	],
	[
		_ttdOther,
		[
			"CraterLong_small",
			"CraterLong"
		]
	],
	[
		_ttdOther,
		[
			"ACE_Track",
			"ACE_Wheel",
			"ACE_SandbagObject",
			"ACE_Tactical_Ladder",
			"ACE_TripodObject",
			"ace_fastroping_helper"
		]
	],
	[
		_ttdOther,
		[
			"#dynamicsound",
			"#destructioneffects",
			"#track",
			"#particlesource"
		]
	]
];


//==================================================================================//
//=============================== CNFIGURATION end =================================//
//==================================================================================//


GVAR(resetTimeIfPlayerIsWithin)	= 100; // how far away from object players needs to be so it can delete
GVAR(checkNearbyPlayers)				= false;

GVAR(objectsToCleanup)				= [];
GVAR(timesWhenToCleanup)			= [];
GVAR(originalCleanupDelays)		= [];
GVAR(resetTimeIfPlayerNearby)	= []; // might want to do it on my own in more effective way

GVAR(deleteThoseIndexes) = [];

private ["_markArraysForCleanupAt", "_cleanupArrays"];

private _excludedMissionObjects = allMissionObjects "";

//#define IS_SANE(OBJECT) !isNil{OBJECT} && {!isNull(OBJECT)}
#define IS_SANE(OBJECT) ((!isNil{OBJECT}) && ({!isNull(OBJECT)}))

_markArraysForCleanupAt =
{
	params
	[
		"_index"
	];

	GVAR(deleteThoseIndexes) pushBack _index;
};

//_cleanupArrays =
_deleteMarkedIndexes =
{
	GVAR(deleteThoseIndexes) sort false;

	{
		GVAR(objectsToCleanup) deleteAt _x;
		GVAR(timesWhenToCleanup) deleteAt _x;
		GVAR(originalCleanupDelays) deleteAt _x;
		GVAR(resetTimeIfPlayerNearby) deleteAt _x;
	} forEach GVAR(deleteThoseIndexes);

	GVAR(deleteThoseIndexes) = [];
};



GVAR(addToCleanup) =
{
	params
	[
		"_object",
		[
			"_delay",
			60,
			[0]
		],
		[
			"_resetTimerIfPlayerNearby",
			true,
			[true, false]
		],
		[
			"_resetValuesIfObjectAlreadyPresent",
			false,
			[true, false]
		]
	];

	private ["_newTime", "_index", "_currentTime"];

	if (IS_SANE(_object) && {!(_object getVariable["gc_persist", false])}) then
	{
		_newTime = _delay + time;
		_index = GVAR(objectsToCleanup) find _object;

		if (_index == -1) then
		{
			GVAR(objectsToCleanup) pushBack _object;
			GVAR(timesWhenToCleanup) pushBack _newTime;
			GVAR(originalCleanupDelays) pushBack _delay;
			GVAR(resetTimeIfPlayerNearby) pushBack _resetTimerIfPlayerNearby;
		}
		else
		{
			if (_resetValuesIfObjectAlreadyPresent) then
			{
				GVAR(timesWhenToCleanup) set [_index, _newTime];
				GVAR(originalCleanupDelays) set [_index, _delay];
				GVAR(resetTimeIfPlayerNearby) set [_index, _resetTimerIfPlayerNearby];
			};
		};
	};
};

GVAR(removeFromCleanup) =
{
	params
	[
		"_object"
	];

	if (IS_SANE(_object)) then
	{
		_index = GVAR(objectsToCleanup) find _object;

		if (_index != -1) then
		{
			[_index] call _markArraysForCleanupAt;
		};
	};
};


private ["_playerPositions", "_unit", "_myPos", "_delay", "_newTime", "_object", "_objectIndex"];

while {GVAR(isRunning)} do
{
    sleep (45 + (random 15));

	if (FF7_Global_Debug) then
	{
		["repetetive_cleanup", (format ["Running script on %1 objects", count(GVAR(objectsToCleanup))])] call FF7_fnc_debugLog;
	};

  if (count(GVAR(objectsToCleanup)) > 200) then
	{
  	GVAR(resetTimeIfPlayerIsWithin_multiplicator) = GVAR(resetTimeIfPlayerIsWithin_multiplicator) - 0.01;

		if (GVAR(resetTimeIfPlayerIsWithin_multiplicator) < 0.1) then
		{
  		GVAR(resetTimeIfPlayerIsWithin_multiplicator) = 0.1;
  	};
  }
	else
	{
		GVAR(resetTimeIfPlayerIsWithin_multiplicator) = 1;
	};

    {
    	_object = _x;
			{
	    	_timeToDelete	= _x select 0;
	    	_classesToDelete	= _x select 1;

	    	if (_timeToDelete > 0) then
				{
		    	{
						if (((typeOf _object) == _x) || {(_object isKindOf _x)}) then
						{
							[_object, _timeToDelete, GVAR(checkNearbyPlayers), false] call GVAR(addToCleanup);
						};
					} forEach _classesToDelete;
				};
	    } forEach GVAR(deleteClassesConfig);
	} forEach (allMissionObjects "" - _excludedMissionObjects);

	{
		if ((count (units _x)) == 0) then
		{
			if (local _x) then
			{
				deleteGroup _x;
			}
			else
			{
				_x remoteExec ["deleteGroup", (groupOwner _x)];
			};
		};
	} forEach allGroups;

	if (_ttdBodies > 0) then
	{
		{
			[_x, _ttdBodies, GVAR(checkNearbyPlayers), false] call GVAR(addToCleanup);
		} forEach allDeadMen;
	};

	if (_ttdVehiclesDead > 0) then
	{
		{
			if (_x == vehicle _x) then // make sure its vehicle
			{
				[_x, _ttdVehiclesDead, GVAR(checkNearbyPlayers), false] call GVAR(addToCleanup);
			};
		} forEach (allDead - allDeadMen - _excludedMissionObjects); // all dead without dead men == mostly dead vehicles
	};

	if (_ttdVehiclesImmobile > 0) then
	{
		{
			if (!canMove _x && {alive _x} count crew _x == 0) then
			{
				[_x, _ttdVehiclesImmobile, GVAR(checkNearbyPlayers), false] call GVAR(addToCleanup);
			}
			else
			{
				[_x] call GVAR(removeFromCleanup);
			};
		} forEach (vehicles - _excludedMissionObjects);
	};

	_playerPositions = [];
	{
		_playerPositions pushBack (getPosATL _x);
	} forEach allPlayers;

	//GVAR(resetTimeIfPlayerIsWithin)Sqr = GVAR(resetTimeIfPlayerIsWithin) * GVAR(resetTimeIfPlayerIsWithin);
	GVAR(resetTimeIfPlayerIsWithin)Sqr = GVAR(resetTimeIfPlayerIsWithin) * GVAR(resetTimeIfPlayerIsWithin) * GVAR(resetTimeIfPlayerIsWithin_multiplicator);

	call _deleteMarkedIndexes;

	{
		_object = _x;
		_objectIndex = _forEachIndex;

		if (IS_SANE(_object)) then
		{
			if (GVAR(resetTimeIfPlayerNearby) select _objectIndex) then
			{
				_myPos = getPosATL _object;

				{
					if (GVAR(resetTimeIfPlayerIsWithin)Sqr == 0 || {(_myPos distanceSqr _x) < GVAR(resetTimeIfPlayerIsWithin)Sqr}) exitWith
					{
						_delay = GVAR(originalCleanupDelays) select _objectIndex;
						_newTime = _delay + time;
						GVAR(timesWhenToCleanup) set [_objectIndex, _newTime];
					};
				} forEach _playerPositions;
			};

			if ((GVAR(timesWhenToCleanup) select _objectIndex) < time) then
			{
				[_objectIndex] call _markArraysForCleanupAt;
				deleteVehicle _object;
			};
		}
		else
		{
			[_objectIndex] call _markArraysForCleanupAt;
		};

	} forEach GVAR(objectsToCleanup);

	call _deleteMarkedIndexes;
};

GVAR(isRunning) = nil;
