private ["_pos", "_faction"];

_pos = (_this select 0);

if ((_pos select 0) < 16000) then
{
	_faction = "CSAT";
}
else
{
	_faction = "AAF";
};

_faction;
