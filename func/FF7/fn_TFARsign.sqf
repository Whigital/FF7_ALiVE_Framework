/* ----------------------------------------------------------------------

	Usage :	In object init.
	
	_null = [this] execVM "ff7_tfar_sign.sqf";

---------------------------------------------------------------------- */

params ["_radioSign"];

private ["_texSW", "_texLR", "_dir", "_pos"];

_pos = (getPos _radioSign);
_dir = (getDir _radioSign);

_texSW = "UserTexture1m_F" createVehicle _pos;
_texSW setDir _dir;
_texSW setObjectTextureGlobal [0, "img\tfar_freq_sw_512.paa"];

_texLR = "UserTexture1m_F" createVehicle _pos;
_texLR setDir _dir;
_texLR setObjectTextureGlobal [0, "img\tfar_freq_lr_512.paa"];

_texSW attachTo [_radioSign, [-0.5, -0.02, 0.64]];
_texLR attachTo [_radioSign, [0.5, -0.02, 0.64]];
