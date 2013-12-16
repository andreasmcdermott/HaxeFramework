package hxfw;

import flash.display.Bitmap;
import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas McDermott
 */
class Camera extends Rectangle
{
	// Static
	
	private static var activeCamera:Camera;
	
	public static function clearToActiveCamera()
	{
		if (activeCamera == null) return;
		
		activeCamera.clear();
	}
	
	public static function drawToActiveCamera(drawable:IBitmapDrawable, matrix:Matrix)
	{
		if (activeCamera == null) return;
		
		activeCamera.draw(drawable, matrix);
	}
	
	// End static
	
	private var renderTarget:Bitmap;
	private var clearColor:UInt;
	
	public function new(w:Int, h:Int, scale:Int) 
	{
		super(0, 0, w, h);
		renderTarget = Util.createRenderTarget(w, h, scale);
		clearColor = 0xff000000;
		if (activeCamera == null)
			activate();
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
	
	public function setClearColor(color:UInt)
	{
		clearColor = color;
	}
	
	public function clear()
	{
		renderTarget.bitmapData.fillRect(this, 0xff000000 | clearColor);
	}
	
	public function draw(drawable:IBitmapDrawable, matrix:Matrix)
	{
		renderTarget.bitmapData.draw(drawable, matrix);
	}
}