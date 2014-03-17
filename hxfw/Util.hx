package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */
class Util
{
	public static function isOfClass(d:Dynamic, c:String)
	{
		var fullClassName = Type.getClassName(Type.getClass(d));
		
		var onlyClassName = fullClassName.substring(fullClassName.lastIndexOf(".") + 1);
		
		return onlyClassName.toLowerCase() == c.toLowerCase();
	}
}