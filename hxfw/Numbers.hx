package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */
class Numbers
{
	public static function formatFloat(value:Float, decimals:Int):String
	{
		var str = Std.string(value);
		var period = str.indexOf(".");
		return str.substr(0, period + decimals + (decimals > 0 ? 1 : 0));
	}
}