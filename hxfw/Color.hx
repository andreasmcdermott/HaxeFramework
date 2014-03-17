package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */

 typedef RGBA = {
	var r:Float;
	var g:Float;
	var b:Float;
	var a:Float;
}

typedef RGB = {
	var r:Float;
	var g:Float;
	var b:Float;
}
 
class Color
{
	public static var White(default, null):UInt = 0xffffffff;
	public static var Black(default, null):UInt = 0xff000000;
	public static var Red(default, null):UInt = 0xffff0000;
	public static var Green(default, null):UInt = 0xff00ff00;
	public static var Blue(default, null):UInt = 0xff0000ff;
	public static var Purple(default, null):UInt = 0xffff00ff;
	public static var Cyan(default, null):UInt = 0xff00ffff;
	public static var Yellow(default, null):UInt = 0xffffff00;
	
	public static function desaturate(color:UInt, strength:Float):UInt
	{
		var rgb = toRGBFromHex(color);
		var gray:Float = rgb.g * 0.59 + rgb.r * 0.3 + rgb.b * 0.11;
		return toHexFromRGBA( { r: rgb.r * strength + gray * (1 - strength),
			g: rgb.g * strength + gray * (1 - strength),
			b: rgb.b * strength + gray * (1 - strength), a:1 });
	}
	
	public static function random(a:Float = 1.0):UInt
	{
		return toHexFromInt(Std.random(255), Std.random(255), Std.random(255), Std.int(a * 255));
	}
	
	public static function toRGBAFromHex(color:UInt):RGBA
	{
		return {
			r: ((color >> 16) & 0xff) / 255.0,
			g: ((color >> 8) & 0xff) / 255.0,
			b:  (color & 0xff) / 255.0,
			a: ((color >> 24) & 0xff) / 255.0
		};
	}
	
	public static function toRGBFromHex(color:UInt):RGB
	{
		return {
			r: ((color >> 16) & 0xff) / 255.0,
			g: ((color >> 8) & 0xff) / 255.0,
			b:  (color & 0xff) / 255.0
		};
	}
	
	public static function toRGBAFromInt(r:UInt, g:UInt, b:UInt, a:UInt = 255):RGBA
	{
		return {
			r: r / 255,
			g: g / 255,
			b: b / 255,
			a: a / 255
		};
	}
	
	public static function toHexFromRGBA(color:RGBA):UInt
	{
		var a = Std.int(color.a * 255);
		var r = Std.int(color.r * 255);
		var g = Std.int(color.g * 255);
		var b = Std.int(color.b * 255);
		
		var c = (a << 24) + (r << 16) + (g << 8) + b;
		return c;
	}
	
	public static function toHexFromRGB(color:RGB):UInt
	{
		var r = Std.int(color.r * 255);
		var g = Std.int(color.g * 255);
		var b = Std.int(color.b * 255);
		
		return (r << 16) + (g << 8) + b; 
	}
	
	public static function toHexFromInt(r:UInt, g:UInt, b:UInt, a:UInt = 255):UInt
	{
		return (a << 24) + (r << 16) + (g << 8) + b;
	}
}