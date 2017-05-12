private ["_pos", "_radius", "_text", "_circle", "_marker", "_type", "_brush", "_color"];

_pos	= (_this select 0);
_radius	= (_this select 1);
_text	= (_this select 2);
_color	= param [3, "ColorOPFOR"];
_brush	= param [4, "Border"];
_type	= param [5, "mil_dot"];

_circle = createMarker ["FF7_OP_circleTarget", _pos];

_circle setMarkerShape "ELLIPSE";
_circle setMarkerColor _color;
_circle setMarkerBrush _brush;
_circle setMarkerSize [_radius, _radius];
_circle setMarkerText "AO";

_marker = createMarker ["FF7_OP_markerTarget", _pos];

_marker setMarkerType _type;
_marker setMarkerColor _color;
_marker setMarkerText (format [" %1", _text]);

[_marker, _circle];
