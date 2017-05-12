///////////////////////////////////////////////////////////
//                =ATM= Airdrop       	 				    //
//         		 =ATM=Pokertour        		       		    //
//				version : 6.0							        //
//				date : 12/02/2014						   //
//                   visit us : atmarma.fr                 //
/////////////////////////////////////////////////////////

fnc_alt_onsliderchange =
{
	private["_dialog","_text","_value"];
	disableSerialization;

	_dialog = findDisplay 2900;
	_text = _dialog displayCtrl 2902;
	_value = _this select 0;

	Altitude = round(_value);
	_text ctrlSetText format["%1", round(_value)];
};

Getloadout =
{
	_gear = [];

	if (isNull unitBackpack player) exitWith {_gear};

	_back_pack			= backpack player;
	_back_pack_items	= getItemCargo (unitBackpack player);
	_back_pack_weap		= getWeaponCargo (unitBackpack player);
	_back_pack_maga		= getMagazineCargo (unitBackpack player);

	_gear =
	[
		_back_pack,
		_back_pack_items,
		_back_pack_weap,
		_back_pack_maga
	];

	_gear;
};

Setloadout =
{
	_unit = _this select 0;
	_gear = _this select 1;

	removeBackPack _unit;

	_unit addBackPack (_gear select 0);
	clearAllItemsFromBackpack _unit;

	_gear_items	= (_gear select 1);
	_gear_weap	= (_gear select 2);
	_gear_mags	= (_gear select 3);

	// Weapon cargo
	if ((count (_gear_weap select 0)) > 0) then
	{
		for "_i" from 0 to ((count (_gear_weap select 0)) - 1) do
		{
			(unitBackpack _unit) addweaponCargoGlobal [((_gear_weap select 0) select _i), ((_gear_weap select 1) select _i)];
		};
	};

	// Magazine cargo
	if ((count (_gear_mags select 0)) > 0) then
	{
		for "_i" from 0 to ((count (_gear_mags select 0)) - 1) do
		{
			(unitBackpack _unit) addMagazineCargoGlobal [((_gear_mags select 0) select _i), ((_gear_mags select 1) select _i)];
		};
	};

	// Item cargo
	if ((count (_gear_items select 0)) > 0) then
	{
		for "_i" from 0 to ((count (_gear_items select 0)) - 1) do
		{
			(unitBackpack _unit) addItemCargoGlobal [((_gear_items select 0) select _i), ((_gear_items select 1) select _i)];
		};
	};
};

Frontpack =
{
	private ["_target", "_pack", "_class"];

	_target = (_this select 0);

	if (isNull unitBackpack _target) exitWith {nil};
	
	_pack = unitBackpack _target;
	
	_class = typeOf _pack;

	[_target, _class] spawn
	{
		private ["_target","_class","_packHolder"];

		_target	= _this select 0;
		_class 	= _this select 1;

		_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"];
		_packHolder addBackpackCargo [_class, 1];
		_packHolder attachTo [_target,[0.1,0.56,-.72],"pelvis"];
		_target setvariable ["frontpack", _packHolder,true];
		_packHolder setVectorDirAndUp [[0,1,0],[0,0,-1]];

		waitUntil {animationState _target == "para_pilot"};
		_packHolder attachTo [vehicle _target,[0.1,0.72,0.52],"pelvis"];
		_packHolder setVectorDirAndUp [[0,0.1,1],[0,1,0.1]];
	};
};
