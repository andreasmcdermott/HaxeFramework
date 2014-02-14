package hxfw;

import hxfw.scenes.Scene;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.text.TextFormat;

/**
 * ...
 * @author Andreas McDermott
 */
class Game extends Sprite 
{
	// Static
	
	public static var Scale(default, null):Int = 3;
	public static var Dt(default, null):Float;
	public static var Fps(default, null):Float = 0;
	public static var TotalElapsed(default, null):Float = 0.0;
	public static var Width(default, null):Int;
	public static var Height(default, null):Int;
	public static var DefaultFont(default, null):TextFormat;
	
	private static var instance:Game;
	
	public static function addRenderTarget(renderTarget:DisplayObject)
	{
		instance.addChild(renderTarget);
	}
	
	public static function removeRenderTarget(renderTarget:DisplayObject)
	{
		instance.removeChild(renderTarget);
	}
	
	public static function registerEventListener(type:String, listener:Dynamic->Void)
	{
		Lib.current.stage.addEventListener(type, listener);
	}
	
	// End static

	private var ready:Bool;
	private var lastFrameTime:Int = -1;
	private var console:Console;
	private var frameCount:Int = 0;
	private var fpsTimer:Float = 0.0;
	
	public function new() 
	{
		super();	
		if (instance != null)
			instance.destroy();
		instance = this;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onEnterFrame(e:Event)
	{
		if (lastFrameTime < 0)
			lastFrameTime = Lib.getTimer();
			
		var now = Lib.getTimer();
		Dt = (now - lastFrameTime) / 1000.0;
		lastFrameTime = now;
		TotalElapsed += Dt;
		frameCount += 1;
		fpsTimer += Dt;
		
		if (fpsTimer >= 1)
		{
			fpsTimer -= 1.0;
			Fps = frameCount;
			frameCount = 0;
		}
		
		Camera.clearActiveCamera();
		Input.update();
		Tween.update();
		Scene.doFrame();
		Console.doFrame();
	}
	
	private function onResize(e:Event) 
	{
		if (!ready) init();
		// else (resize or orientation change)
	}
	
	private function init() 
	{
		if (ready) return;
		ready = true;

		Width = Std.int(stage.stageWidth / Scale);
		Height = Std.int(stage.stageHeight / Scale);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function destroy()
	{
		stage.removeEventListener(Event.RESIZE, onResize);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onAddedToStage(event) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onResize);
		
		#if ios
	 	haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
}