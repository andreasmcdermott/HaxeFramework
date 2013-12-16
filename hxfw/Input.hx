package hxfw;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;

/**
 * ...
 * @author Andreas McDermott
 */
 
class Input
{
	private static var isReady:Bool = false;
	private static var keysDown:Map<Int, Float>;
	private static var keysPressed:Map<Int, Int>;
	private static var keysPressedPending:Map<Int, Int>;
	
	private function new() 
	{
	}
	
	private static function setup()
	{
		keysPressedPending = new Map<Int, Int>();
		keysPressed = new Map<Int, Int>();
		keysDown = new Map<Int, Float>();
		
		Game.registerEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Game.registerEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		Game.registerEventListener(MouseEvent.MOUSE_DOWN, onLeftMouseDown);
		Game.registerEventListener(MouseEvent.MOUSE_UP, onLeftMouseUp);
		Game.registerEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
		Game.registerEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
		Game.registerEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		Game.registerEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		isReady = true;
	}
	
	public static function update()
	{
		if (!isReady)
			setup();

		keysPressed = keysPressedPending;
		keysPressedPending = new Map<Int, Int>();
	}
	
	public static function isKeyDown(key:Int)
	{
		return keysDown.exists(key);
	}
	
	public static function isKeyPressed(key:Int)
	{
		return keysPressed.exists(key);
	}
	
	private static function onKeyDown(e:Dynamic)
	{
		if (!keysDown.exists(e.keyCode))
		{
			keysPressedPending.set(e.keyCode, 0);
      keysDown.set(e.keyCode, Game.TotalElapsed);
		}
	}
	
	private static function onKeyUp(e:Dynamic)
	{
		keysDown.remove(e.keyCode);
	}
	
	private static function onLeftMouseDown(e:Dynamic)
	{
		
	}
	
	private static function onLeftMouseUp(e:Dynamic)
	{
		
	}
	
	private static function onRightMouseDown(e:Dynamic)
	{
		
	}
	
	private static function onRightMouseUp(e:Dynamic)
	{
		
	}
	
	private static function onMouseWheel(e:Dynamic)
	{
		
	}
	
	private static function onMouseMove(e:Dynamic)
	{
		
	}
}