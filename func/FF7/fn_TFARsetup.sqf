// TFAR general options

if ((isServer) || (isDedicated)) then
{
	#include "\task_force_radio\functions\common.sqf";

	// TFAR general options
	TF_give_microdagr_to_soldier = false;
	publicVariable "TF_give_microdagr_to_soldier";

	tf_give_personal_radio_to_regular_soldier = false;
	publicVariable "tf_give_personal_radio_to_regular_soldier";

	tf_no_auto_long_range_radio = true;
	publicVariable "tf_no_auto_long_range_radio";

	tf_radio_channel_name = "TaskForceRadio - ALiVE";
	publicVariable "tf_radio_channel_name";


	// TFAR ShortWave frequencies
	tf_same_sw_frequencies_for_side = true;
	publicVariable "tf_same_sw_frequencies_for_side";

	_settingsSwWest = [false] call TFAR_fnc_generateSwSettings;
	_settingsSwWest set [2, ["100","200","300","400","101","201","301","401"]];

	tf_freq_west = _settingsSwWest;
	publicVariable "tf_freq_west";


	// TFAR LongRange frequencies
	tf_same_lr_frequencies_for_side = true;
	publicVariable "tf_same_lr_frequencies_for_side";

	_settingsLrWest = [false] call TFAR_fnc_generateLrSettings;
	_settingsLrWest set [2, ["50","60","70","80","51","61","71","81"]];

	tf_freq_west_lr = _settingsLrWest;
	publicVariable "tf_freq_west_lr";

	// TFAR underwater Transceiver settings
	tf_same_dd_frequencies_for_side = true;
	publicVariable "tf_same_dd_frequencies_for_side";

	tf_freq_west_dd = call TFAR_fnc_generateDDFreq;
	publicVariable "tf_freq_west_dd";
}
else
{
	TF_give_microdagr_to_soldier				= false;
	tf_give_personal_radio_to_regular_soldier	= false;
	tf_no_auto_long_range_radio					= true;
	tf_radio_channel_name						= "TaskForceRadio - ALiVE";
	tf_same_sw_frequencies_for_side				= true;
	tf_same_lr_frequencies_for_side				= true;
	tf_same_dd_frequencies_for_side				= true;
};
