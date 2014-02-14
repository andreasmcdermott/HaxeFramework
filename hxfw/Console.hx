package hxfw;

import hxfw.entities.Entity;
import flash.ui.Keyboard;
import hxfw.entities.TextDisplay;

using hxfw.Tween;

/**
 * ...
 * @author Andreas McDermott
 */
class Console extends hxfw.entities.Group
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
	private var fpsDisplay:TextDisplay;
	
	private function new() 
	{
		super(0, Game.Height, Game.Width, Std.int(Game.Height / 3) + 1);
		forceBounds = true;
		addChild(new Entity(0, 0, width, height).assignDrawable(Factory.createSquare(Std.int(width), Std.int(height), 0xcc000000)).inheritFromParent(true));
		fpsDisplay = new TextDisplay(10, 10, 100, 16);
	}
	
	override private function update()
	{
		if (Input.isKeyPressed(Keyboard.TAB))
		{
			if (!active)
			{
				active = true;
				this.tween(0.5, { y: Game.Height / 3 * 2} );
			}
			else
				this.tween(0.5, { y: Game.Height }).then(function (d:Dynamic) { active = false; } );
		}
		
		if (active)
		{
			fpsDisplay.setText(Std.string(Game.Fps));
			super.update();
		}
	}
	
	override private function draw()
	{
		if (active)
		{
			Camera.drawActiveCameraInScreeSpace(true);
			super.draw();
			fpsDisplay.draw();
			Camera.drawActiveCameraInScreeSpace(false);
		}
	}
}