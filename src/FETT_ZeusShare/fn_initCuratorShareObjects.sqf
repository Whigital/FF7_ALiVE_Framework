
{
	_x addEventHandler ["CuratorGroupPlaced",{ _this remoteExecCall ["FETT_fnc_grpPlaced",2,false]; }];
	_x addEventHandler ["CuratorObjectPlaced",{ _this remoteExecCall ["FETT_fnc_objPlaced",2,false]; }];
} forEach allCurators;
