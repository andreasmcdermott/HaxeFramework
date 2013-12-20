package hxfw;
import flash.ui.Keyboard;

using hxfw.Tween;

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
	
	private var active:Bool = false;
	
	private function new() 
	{
		super(0, Game.Height, Game.Width, Std.int(Game.Height / 3) + 1);
		forceBounds = true;
		addChild(new Entity(0, 0, width, height).assignDrawable(Util.createBitmap(Std.int(width), Std.int(height), 0xaaffffff)));
	}
	
	override private function update()
	{
		if (Input.isKeyPressed(Keyboard.TAB))
		{
			if (!active)
			{
				active = true;
				this.tween(0.5, { y: Game.Height / 3 * 2} ).ease(EaseType.SquaredEaseIn);
			}
			else
				this.tween(0.5, { y: Game.Height } ).ease(EaseType.SquaredEaseOut).then(function (d:Dynamic) { active = false; } );
		}
		
		super.update();
	}
	
	override private function draw()
	{
		if (active)
			super.draw();
	}
}