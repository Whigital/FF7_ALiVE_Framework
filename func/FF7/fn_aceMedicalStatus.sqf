params ["_unit", "_caller"];

private ["_bloodVolume", "_painLevel", "_bleedingState", "_ivBags", "_bloodLossPct", "_bloodLossVol", "_painPct", "_unconscious"];

private ["_patient", "_text", "_textBlood", "_textBleeding", "_textPain", "_textBags", "_textConscious"];

private _round =
{
	params ["_num", "_n"];

	private ["_ret"];

	_ret = ((round (_num * (10 ^ _n))) / (10 ^ _n));

	_ret;
};

_patient = (name _unit);

if (!alive _unit) then
{
	hintSilent (format ["%1 is dead, beyond all hope", _patient]);
}
else
{
	// Retrieve medical data first
	_bloodVolume	= (_unit getVariable "ace_medical_bloodVolume");
	_painLevel		= (_unit getVariable "ace_medical_pain");
	_bleedingState	= (_unit getVariable "ace_medical_isBleeding");
	_ivBags			= (_unit getVariable ["ace_medical_ivBags", 0]);
	_unconscious	= (_unit getVariable "ACE_isUnconscious");

	// Contious
	if (_unconscious) then
	{
		_textConscious = "Conscious: No";
	}
	else
	{
		_textConscious = "Conscious: Yes";
	};

	// Bleeding
	if (_bleedingState) then
	{
		_bleeding = "Yes";
	}
	else
	{
		_bleeding = "No";
	};

	// Bloodlevel
	if (_bloodVolume < 100) then
	{
		_bloodLossPct = (100 - _bloodVolume);
		_bloodLossVol = (7000 - (7000 * (_bloodVolume / 100)));
		_bloodLossPct = [_bloodLossPct, 1] call _round;
		_bloodLossVol = (round _bloodLossVol);

		_textBlood = (format ["Bloodloss: %1%2 / %3ml", _bloodLossPct, "%", _bloodLossVol]);
	}
	else
	{
		_bloodLossPct = 0;
		_bloodLossVol = 0;

		_textBlood = "Bloodloss: None";
	};

	// Painlevel
	if (_painLevel > 0) then
	{
		_painPct = (100 - ((1 - _painLevel) * 100));
		_painPct = [_painPct, 1] call _round;

		_textPain = (format ["Painlevel: %1%2", _painPct, "%"]);
		//_textPain = (str _painLevel + "/" + str _painPct);
	}
	else
	{
		_painPct = 0;

		_textPain = "Pain: None";
	};

	if (_bleedingState) then
	{
		_textBleeding = "Bleeding: Yes";
	}
	else
	{
		_textBleeding = "Bleeding: No";
	};

	if (typeName _ivBags == "ARRAY") then
	{
		private ["_bagsText", "_bags"];

		_bags = [];

		{
			_bags pushBack (str (_x select 0) + "ml");
		} forEach _ivBags;

		private _bagsText = (_bags joinString " / ");

		_textBags = (format ["IVs: %1", _bagsText]);
	}
	else
	{
		_textBags = "IVs: None";
	};

	_text = (format ["%1's health status<br/><br/>%2<br/>%3<br/>%4<br/>%5<br/>%6<br/>%7", _patient, _textConscious, _textBleeding, _textBlood, _textPain, _textBags]);

	[_text] spawn
	{
		params ["_msg"];

		hintSilent (parseText _msg);
		sleep 5;
		hintSilent "";
	};
};
