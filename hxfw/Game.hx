package com.andreasmcdermott.hxfw;

import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author Andreas McDermott
 */
class Game extends Sprite 
{
	private var ready:Bool;
	
	private static var previousInstance:Game;

	public function new() 
	{
		super();	
		if (previousInstance != null)
			previousInstance.destroy();
		previousInstance = this;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onEnterFrame(e:Event)
	{
		
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

		// (your code here)
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		
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