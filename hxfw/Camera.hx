package hxfw;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.IBitmapDrawable;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import hxfw.entities.Entity;

using hxfw.Tween;

/**
 * ...
 * @author Andreas McDermott
 */
class Camera extends Rectangle
{
	// Static
	
	private static var activeCamera:Camera;
	
	public static function clearActiveCamera()
	{
		if (activeCamera == null) return;
		
		activeCamera.clear();
	}
	
	public static function drawToActiveCamera(drawable:IBitmapDrawable, matrix:Matrix, color:ColorTransform, rect:Rectangle, ?blendMode:BlendMode = null)
	{
		if (activeCamera == null) return;
		activeCamera.draw(drawable, matrix, color, rect, blendMode);
	}
	
	public static function convertToWorldSpace(sx:Float, sy:Float):Point
	{
		return new Point(sx + activeCamera.center.x, sy + activeCamera.center.y);
	}
	
	public static function addScreenShake(strength:Float)
	{
		activeCamera.center.offset((Std.random(2) - 1) * strength, (Std.random(2) - 1) * strength);
	}
	
	public static function drawActiveCameraInScreeSpace(ss:Bool)
	{
		activeCamera.drawInScreenSpace(ss);
	}
	
	// End static
	
	private var renderTarget:Bitmap;
	private var clearColor:UInt;
	private var target:Entity;
	private var center:Point;
	private var goto:Point;
	private var lag:Float;
	private var useScreenSpace:Bool;
	
	public function new(w:Int, h:Int, scale:Int) 
	{
		super(0, 0, w, h);
		renderTarget = Factory.createRenderTarget(w, h, scale);
		clearColor = 0xff000000;
		goto = new Point();
		center = new Point();
		setDelay(0.25);
		useScreenSpace = false;
		if (activeCamera == null)
			activate();
	}
	
	public function drawInScreenSpace(ss:Bool)
	{
		useScreenSpace = ss;
	}
	
	public function activate()
	{
		if (Camera.activeCamera != null)
			Camera.activeCamera.deactivate();
			
		Camera.activeCamera = this;
		Game.addRenderTarget(renderTarget);
	}
	
	private function deactivate()
	{
		Game.removeRenderTarget(renderTarget);
	}
	
	public function setTarget(target:Entity, jumpTo:Bool = true)
	{
		this.target = target;
		if (jumpTo)
			this.center = lookAt();
	}
	
	public function setDelay(delay:Float) 
	{
		lag = (delay != 0.0) ? 1.0 / delay : 1.0;
	}
	
	public function setClearColor(color:UInt)
	{
		clearColor = color;
	}
	
	public function clear()
	{
		renderTarget.bitmapData.fillRect(this, 0xff000000 | clearColor);
	}
	
	private function lookAt():Point
	{
		if (target == null) return new Point(center.x, center.y);
		
		var targetRect = target.getRect();
		
		return new Point(
			targetRect.x + targetRect.width / 2 - width / 2,
			targetRect.y + targetRect.height / 2 - height / 2);
	}
	
	public function update()
	{
		if (target == null) return;
		
		goto = lookAt();
		
		center.x += Game.Dt * lag * (goto.x - center.x);
		center.y += Game.Dt * lag * (goto.y - center.y);
	}
	
	public function draw(drawable:IBitmapDrawable, matrix:Matrix, color:ColorTransform, rect:Rectangle, ?blendMode:BlendMode = null)
	{
		if (!useScreenSpace)
		{
			matrix.translate( -center.x, -center.y);
			rect.offset( -center.y, -center.y);
		}
		renderTarget.bitmapData.draw(drawable, matrix, color, blendMode != null ? blendMode : BlendMode.NORMAL);// , rect);
	}
}