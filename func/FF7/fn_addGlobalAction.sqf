private ["_obj", "_title", "_code", "_args", "_prio", "_show", "_hide", "_hotkey", "_cond"];

_obj	= (_this select 0);
_title	= (_this select 1);
_code	= (_this select 2);
_args	= (_this select 3);
_prio	= (_this select 4);
_show	= (_this select 5);
_hide	= (_this select 6);
_hotkey	= (_this select 7);
_cond	= (_this select 8);

if (isNull _obj) exitWith {};

_null = _obj addAction [_title, _code, _args, _prio, _show, _hide, _hotkey, _cond];
