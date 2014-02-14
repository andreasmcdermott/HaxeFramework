package hxfw;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import flash.ui.Mouse;

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
	private static var leftMouseButtonDown:Bool;
	private static var leftMouseButtonPressed:Bool;
	private static var leftMouseButtonPressedPending:Bool;
	private static var rightMouseButtonDown:Bool;
	private static var rightMouseButtonPressed:Bool;
	private static var rightMouseButtonPressedPending:Bool;
	private static var mouseWheel:Int;
	private static var currentMousePosition:Point;
	private static var lastFrameMousePosition:Point;
	
	private function new() 
	{
	}
	
	private static function setup()
	{
		keysPressedPending = new Map<Int, Int>();
		keysPressed = new Map<Int, Int>();
		keysDown = new Map<Int, Float>();
		currentMousePosition = new Point();
		lastFrameMousePosition = new Point();
		
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
		
		leftMouseButtonPressed = leftMouseButtonPressedPending;
		leftMouseButtonPressedPending = false;
		rightMouseButtonPressed = rightMouseButtonPressedPending;
		rightMouseButtonPressedPending = false;
		
		mouseWheel = 0;
		lastFrameMousePosition = currentMousePosition;
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
		}
		
		keysDown.set(e.keyCode, Game.TotalElapsed);
	}
	
	private static function onKeyUp(e:Dynamic)
	{
		keysDown.remove(e.keyCode);
	}
	
	public static function isLeftMouseButtonDown()
	{
		return leftMouseButtonDown;
	}
	
	public static function isLeftMouseButtonPressed()
	{
		return leftMouseButtonPressed;
	}
	
	public static function isRightMouseButtonDown()
	{
		return rightMouseButtonDown;
	}
	
	public static function isRightMouseButtonPressed()
	{
		return rightMouseButtonPressed;
	}
	
	private static function onLeftMouseDown(e:Dynamic)
	{
		if (!leftMouseButtonDown)
		{
			leftMouseButtonPressedPending = true;
		}
		
		leftMouseButtonDown = true;
	}
	
	private static function onLeftMouseUp(e:Dynamic)
	{
		leftMouseButtonDown = false;
	}
	
	private static function onRightMouseDown(e:Dynamic)
	{
		if (!rightMouseButtonDown)
		{
			rightMouseButtonPressedPending = true;
		}
		
		rightMouseButtonDown = true;
	}
	
	private static function onRightMouseUp(e:Dynamic)
	{
		rightMouseButtonDown = false;
	}
	
	public static function mouseScrolled():Int
	{
		return mouseWheel;
	}
	
	private static function onMouseWheel(e:Dynamic)
	{
		mouseWheel = e.delta;
	}
	
	public static function mousePosition():Point
	{
		return new Point(currentMousePosition.x, currentMousePosition.y);
	}
	
	public static function mouseDelta():Point
	{
		return new Point(currentMousePosition.x - lastFrameMousePosition.x, currentMousePosition.y - lastFrameMousePosition.y);
	}
	
	private static function onMouseMove(e:Dynamic)
	{
		currentMousePosition = Camera.convertToWorldSpace(e.stageX, e.stageY);
	}
}