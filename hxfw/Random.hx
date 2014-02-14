package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */
class Random
{
	public static function intBetween(min:Int, max:Int):Int 
	{
		return (Std.random(max - min) + min);
	}
	
	public static function floatBetween(min:Float, max:Float):Float 
	{
		return Math.random() * (max - min) + min;
	}
	
	public static function sign():Int
	{
		return Std.random(100) < 50 ? -1 : 1;
	}
}