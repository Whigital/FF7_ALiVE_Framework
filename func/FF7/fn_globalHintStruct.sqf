private ["_type", "_title", "_msg", "_icon"];

_type	= (_this select 0);
_title	= (_this select 1);
_msg 	= (_this select 2);
_icon	= "img\icon\hint_default.paa";

switch (_type) do
{
	case "HQ":
	{
		_icon	= "img\icon\icon-hq.paa";
	};

	case "SUPPLY":
	{
		_icon	= "img\icon\icon-supply1.paa";
	};

	case "ARMORY":
	{
		_icon	= "img\icon\icon-arsenal.paa";
	};

	case "ROE":
	{
		_icon	= "img\icon\icon-warning4.paa";
	};
};

hint parseText (format ["<t align='center' font='PuristaMedium' size='1.2'><img size='1.7' image='%1' />&#160;&#160;<t size='1.7' color='#00EEB2'>%2</t><br/>-------------------------------------------------------<br/><t color='#00B2EE'>%3</t></t>", _icon, _title, _msg]);
