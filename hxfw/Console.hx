package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */
class Console extends Group
{
	// Static
	
	private static var instance:Console;
	
	public static function activate()
	{
		instance = new Console();
	}
	
	public static function doFrame()
	{
		if (instance != null)
		{
			instance.update();
			instance.draw();
		}
	}
	
	// End static
	
	private function new() 
	{
		super(0, Game.Height, Game.Width, Std.int(Game.Height / 3));
	}
}