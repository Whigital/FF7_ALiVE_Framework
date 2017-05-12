params
[
	"_image",
	"_color",
	"_capition",
	["_font", "PuristaMedium"],
	["_fontSize", "1.1"],
	["_imgSize", "1.8"]
];

private ["_text"];

_text = (format ["<img size='%1' image='img\icon\icon-%2.paa' /><t size='%3' font='%4' color='#%5'>&#160;%6</t>", _imgSize, _image, _fontSize, _font, _color, _capition]);

_text;
